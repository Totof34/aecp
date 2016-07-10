//**************************************************************
//Aecp-Duino    Allumage electronique programmable - Arduino
char ver[] = " version du 24_03_2016";
#include "TimerOne.h" //Génère une interruption toutes les  1 seconde

//pour la coupure du courant dans la bobine quand le moteur ne tourne pas.

//Macro  ps(v) de debug pour imprimer le numero de ligne, le nom d'une variable, sa valeur
//puis s'arreter definitivement .
#define ps(v) Serial.print("Ligne_") ; Serial.print(__LINE__) ; Serial.print(#v) ; Serial.print(" = ") ;Serial.println((v)) ; Serial.println("  Sketch stop"); while (1);
//Exemple, à la ligne 140, l'instruction     ps(var1);
//inprimera  "Ligne_140var1 = 18  Sketch stop"

//Macro  pc(v)de debug pour imprimer le numero de ligne, le nom d'une variable, sa valeur,
//puis s'arreter et attendre un clic de souris  sur le bouton 'Envoyer'en haut de l'ecran seriel pour continuer.
#define pc(v) Serial.print("Ligne_") ; Serial.print(__LINE__) ; Serial.print(#v) ;Serial.print(" = ") ; Serial.println((v)) ; Serial.println(" Clic bouton 'Envoyer' pour continuer") ;while (Serial.available()==0);{ int k_ = Serial.parseInt() ;}
//Exemple, à la ligne 145, l'instruction    pc(var2);
// inprimera   "Ligne_145var2 = 25.3   Clic bouton 'Envoyer' pour continuer"

int deb = 0; //0 sinon 1 ou 2 pour le debugging,et executer les impressions pc() ou pc(). Voir Setup()

//**************  Ces 5 lignes sont à renseigner obligatoirement.****************

//Les tableau N[] et Ang[] doivent obligatoirement débuter et se terminer par  0
//Le nombre de points est libre
//Le dernier N fixe la ligne rouge, c'est à dire la coupure de l'allumage
//Au régime moteur de:
const int N[] = {0,1240,2000,2500,3400,4100,4200,7000, 0};
//degrés d'avance vilebrequin correspondant:
const int Ang[] = {0,0,0,0,0,0,0,0, 0};
//Pour un moteur Alpine Cléon alu, 1796cc, arbre à cames Savoye S11
//const int N[] = {0, 2000, 3000, 6000, 9000, 0, 0}; //Pour test
//const int Ang[] = {0, 10,  25,   35, 40, 0, 0};
int Ncyl = 2;           //Nombre de cylindres, moteur Panhard
const int AngleCapteur = 90; //le capteur(Hall) est 45° avant le PMH habituellement
const int Avancestatique = 32;
const int CaptOn = 0;  //CapteurOn = 1 déclenche sur front montant (capteur saturé)
//CapteurOn = 0 déclenche sur front descendant (capteur non saturé).Voir fin du listing
//**********************************************************************************
//
const int Bob = 4;    //Sortie D4 vers bobine
const int TstI = 5;    //Sortie D4 vers bobine
const int Cible = 2;  //Entrée sur D2 du capteur, R PullUp et interrupt
int unsigned long D = 0;  //Delai en µs à attendre après la cible pour l'étincelle
const int tcor  = 120; //correction en µs  du temps de calcul pour D
int unsigned long prec_H  = 0;  //Heure du front precedent en µs
int unsigned long T  = 0;  //Periode en cours
int N1  = 0;  //Couple N,A de debut d'un segment
int Ang1  = 0; // Car A1 reservé pour entrée analogique!
int N2  = 0; //Couple N,A de fin de segment
int Ang2  = 0;
float gf = 0;//pour boucle d'attente,gf  GLOBALE et FLOAT indispensable
//  gf = 1; while (gf < 2000)gf++;//10= 100µs,100=1.1ms,2000=21.8ms
float k = 0;//Constante pour calcul de l'avance courante
float C1[20]; //Tableaux des constantes de calcul de l'avance courante
float C2[20]; //Tableaux des constantes de calcul de l'avance courante
float Tc[20]; //Tableau des Ti correspondants au Ni
//Si necessaire, augmenter ces 3 valeurs:Ex C1[30],C2[30],Tc[30]
int Tlim  = 0;  //Période minimale, limite, pour la ligne rouge
int j_lim = 0;  //index maxi des N , donc aussi  Ang
int unsigned long NT  = 0;//Facteur de conversion entre N et T à Ncyl donné
int AngleCibles = 0;//Angle entre 2 cibles, 180° pour 4 cyl, 120° pour 6 cyl, par exemple
int UneEtin = 1; //=1 pour chaque étincelle, testé par isr_CoupeI et remis à zero

float uspardegre = 0;
int Dep = 0;

//********************LES FONCTIONS*************************
// Redémarre le programme depuis le début mais ne
// réinitialiser pas les périphériques et les registres
//void software_Reset()
//{
//  asm volatile ("  jmp 0");
//}
void  CalcD ()////////////////////while (1); delay(1000);/////////////////////////////
// Noter que T1>T2>T3...
{ for (int j = 1; j <= j_lim; j++)//On commence par T la plus longue et on remonte
  { //Serial.print("Tc = "); Serial.println(Tc[j]);delay(1000);
    if  (T >=  Tc[j]) {     //on a trouvé le bon segment de la courbe d'avance
      D =  float(T * C1[j]  + C2[j]) ;//D en µs, C2 est déjà diminué du temps de calcul~50mus
      // if (deb > 1) {  pc(C1[j] );  pc(C2[j] );pc(D);}
      //Serial.println(D);
      break;
    }
  }
}
void  Etincelle ()//////////while (1); delay(1000);/////////////////////////////
//{gf = 1; while (gf < D/14)gf++;//10= 100µs,100=1.1ms,2000=21.8ms//attente possible
{ if (D < 10000) delayMicroseconds(D); //Attendre D
  else delay(D / 1000);  //Quand D >10ms car problèmes avec delayMicroseconds(D) si D>14ms!
  digitalWrite(Bob, 0); //Couper le courant, donc étincelle
  delay(1); //1ms courant off
  digitalWrite(Bob, 1); //Retablire le courant
  UneEtin = 1; //Signaler une étincelle à l'isr_CoupeI
}
void  Init ()////////////////////while (1); delay(1000);/////////////////////////////
{ AngleCibles = 720 / Ncyl; //Ex pour 4 cylindres 180°, et 120° pour 6 cylindres
  NT  = 120000000 / Ncyl; //Facteur de conversion Nt/mn en Tµs
  N1  = 0; Ang1 = 0; //Toutes les courbes partent de 0
  int i = 0;    //locale mais valable hors du FOR
  for (i  = 1; N[i] != 0; i++)
  { N2 = N[i]; Ang2 = Ang[i];
    k = float(Ang2 - Ang1) / float(N2  - N1);
    C1[i] = float(AngleCapteur - Avancestatique - Ang1 + k * N1) / float(AngleCibles);
    C2[i] = -  float(NT * k) / float(AngleCibles) - tcor; //Compense la durée de calcul de D
    Tc[i] = float(NT / N[i]);
    N1 = N2; Ang1 = Ang2; //fin de ce segment, début du suivant
  }
  j_lim = i - 1; //Revenir au dernier couple entré
  Tlim  = Tc[j_lim]; //Ligne rouge
  Serial.print("Ligne_"); Serial.println(__LINE__);
  Serial.print("Tc = "); for (i = 1 ; i < 12; i++)Serial.println(Tc[i]);
  Serial.print("Tlim = "); Serial.println(Tlim);
  Serial.print("C1 = "); for (i = 1 ; i < 12; i++)Serial.println(C1[i]);
  Serial.print("C2 = "); for (i = 1 ; i < 12; i++)Serial.println(C2[i]);

  //  Le courant dans la bobine est coupé si aucune etincelle durant 1 seconde
  Timer1.initialize(1000000); //Toutes les secondes génére IT pour lancer isr_CoupeI
  Timer1.attachInterrupt(isr_CoupeI); //On toggle la Led en cours.
  interrupts();   //Toutes les 1 seconde lancer l'isr_CoupeI
}
void  isr_CoupeI()////////////////////while (1); delay(1000);/////////////////////////////
{ if (UneEtin == 0)digitalWrite(Bob, 0); //pas eu d'étincelle, on coupe I dans bob
  UneEtin = 0;  //Remet  le detecteur d'étincelle à 0
}
void  Top()////////////////////while (1); delay(1000);/////////////////////////////
{ digitalWrite(Bob, 1); //Crée un top sur l'oscillo
  gf = 1; while (gf < 10)gf++;//gf DOIT être Globale et Float 10=100µs,2000=21.8ms, retard/Cible=50µs
  digitalWrite(Bob, 0); //
}
////////////////////////////////////////////////////////////////////////
void setup()//////////////////while (1); delay(1000);//////////////////////////
/////////////////////////////////////////////////////////////////////////
{ deb = 0; //pour debugging, 1 ou 2 sinon 0
  Serial.begin(115200);//Ligne suivante, 3 Macros du langage C
  Serial.println(__FILE__); Serial.println(__DATE__); Serial.println(__TIME__);
  Serial.println(ver);
  if (Ncyl < 2)Ncyl = 2; //On assimile le mono cylindre au bi, avec une étincelle perdue
  pinMode(Cible, INPUT_PULLUP); //Entrée interruption sur D2, front descendant
  pinMode(Bob, OUTPUT); //Sortie sur D4 controle du courant dans la bobine
  pinMode(5, OUTPUT); //Sortie sur D5 inverse de D4, test I
  Init();
  //  T = 142000;// Debug
  //  if (T > Tlim)     //Sous la ligne rouge?
  //  { CalcD(); // Top();  //Oui
  //    ps(D);    //D environ 500000 mus pour 45° delai, 0° d'avance
  //    Etincelle();
  //  }
}

void editcourbe(){
  for(int i = 0; i < 176; i++)
    {
    T = NT/(i*40) ;
    uspardegre = (T/float(AngleCibles));
    CalcD();
            
    Serial.print(i*40);
    Serial.print(",");
    Serial.print(D);
    Serial.print(",");
    Serial.println(uspardegre,0);
    }
}

void demo(){
  for(int i = 1; i < 176; i++){
    T = NT/(i*40) ;
    uspardegre = (T/float(AngleCibles));
    CalcD();
    Dep = map((analogRead(A1)),275,495,15,0);  //Mesure la dépression
    if (Dep < 0){ Dep = 0; }
    else if (Dep > 15){ Dep = 15; }
    else ;
    
    Serial.print("S");
    Serial.print(",");
    Serial.print(i*40);
    Serial.print(",");
    Serial.print(Dep,1);
    Serial.print(",");
    Serial.print(D);
    Serial.print(",");
    Serial.print(uspardegre,0);
    Serial.print(",");
    Serial.print("0");
    Serial.print(",");
    Serial.print("0");
    Serial.println(",");
    delay(100);
  }
  for(int i = 174; i > 0; i--){
    T = NT/(i*40) ;
    uspardegre = (T/float(AngleCibles));
    CalcD();
    Dep = map((analogRead(A1)),275,495,15,0);  //Mesure la dépression
    if (Dep < 0){ Dep = 0; }
    else if (Dep > 15){ Dep = 15; }
    else ;
    
    Serial.print("S");
    Serial.print(",");
    Serial.print(i*40);
    Serial.print(",");
    Serial.print(Dep,1);
    Serial.print(",");
    Serial.print(D);
    Serial.print(",");
    Serial.print(uspardegre,0);
    Serial.print(",");
    Serial.print("0");
    Serial.print(",");
    Serial.print("0");
    Serial.println(",");
    delay(100);
  }
}
///////////////////////////////////////////////////////////////////////////
void loop()   /////////////////////while (1); delay(1000);/////////////////
////////////////////////////////////////////////////////////////////////////
{ 

   //editcourbe();
       
   demo();
}
////////////////DEBUGGING////////////////////////
//Voir les macros ps ()à et pc() en début de listing

//Une autre possibilité est de générer ou non du code de debug à la compilation.
//#define DEBUG    // #if defined DEBUG #endif

//Hertz = Nt/mn / 30
//N 1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000
//Hz  33, 50,   66,  83  100  117   133 150   166 183 200    216  233 250   266 283   300 316 333
//Capteur Honeywell 1GT101DC,contient un aimant sur le coté,type non saturé, sortie haute à vide,
//et basse avec une cible en métal. Il faut  CapteurOn = 0, declenche sur front descendant.
//Le capteur à fourche SR 17-J6 contient un aimant en face,type saturé, sortie basse à vide,
//et haute avec une cible métallique. Il faut  CapteurOn = 1, declenche sur front montant.
