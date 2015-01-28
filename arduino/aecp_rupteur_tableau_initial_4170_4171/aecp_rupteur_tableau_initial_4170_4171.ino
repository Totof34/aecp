// Version pour moteur Panhard, 2 cylindre avec emploi de la tete de delco d'origine
// vidée des masselotes de l'avance centrifuge et la capsule de dépression déconnectée
//
// 25/10/2014
// Test de la vitesse de rotation et capture de la valeur de dépression issu du capteur
// vérifié avec un banc Souriau
// 
// 10/01/2015
// Test de conformité des calculs des délais
// et rectification des formules du tableau initial précédement erronné
// Ok à la date du 11/01/2015
// 
// 13/10/2015
// Tet de conformité de la vitese décodée et du bon délai d'avance en fonction
// du meme tableau 
// Calibration de la plage du capteur de dépreion 
// Ok à la date du 13/01/2015

// Ok à la date du 24/01/2015
// Test affichage sous Processing OK et Validation des délais ainsi que le taux d'erreur global
// qui est générer par le µc pour tout les calculs
// validation aussi du transfert des données vers Processing et l'IHM

// Ci-desous le deux principales lignes de code qui détermine l'allure des courbes destinées aux moteur Panhard
// celle-ci est pour un allumeur AC4114A pour moteur M8N qui équipe les 24 et 17 de la marque
// les deux tableaux sont remplis au départ d'un relevé manuel des courbes construxteur
// le premier est constitué par les degrés d'avance centrifuge additionné de l'avance statique

// L'avance statique est de 4.5 dents d'avance statique côté volant moteur à partir de 0 T/min X10 pour avoir un entier
// Degrés à convertir en degrés allumeur ( 104 dents pour 360°), (360/104)*4.5, ce qui donne ici 156

// Le second comprend les vitesses en tours allumeur soit tours moteur divisé par 2

volatile int Advance[11]= {156,156,166,181,196,201,206,206,206,206,206  }; // en 1/10 de degrés d'avance allumeur à partir de 0 T/min,soit avec l'avance statique];
volatile int Speed[11] = {0,540,1000,1400,1800,1900,2000,2080,2100,3000,3500  }; // Vitesse de rotation en tour allumeur;

// Début du code source

const int MIN_RPM = 0; // La vitesse de départ soit 0 tour par min
const int MAX_RPM = 3500; // La vitesse maximum ou ligne rouge
const int STEP_RPM = 20; // Le pas pour faire croitre la vitesse dans le tableau
const int MAX_INDEX = 175; // L'index maximum sert à calculer la taille du tableau, 3500/20
const int DWELL = 3000;
const int COIL1 = 8;
const int LED1 = 6;
const int LED2 = 10;
const int COIL2 = 9;
const int PROTECT = 5; // Sortie pour bloquer les grilles des IGBT
const int SENSOR1 = 3; // Capteur de PMH
//const int SENSOR2 = 4; // Capteur de vitesse lente

// Définition de constante pour différentes vitesses de conversion Analogique => Numérique
const unsigned char PS_16 = (1 << ADPS2);
const unsigned char PS_32 = (1 << ADPS2) | (1 << ADPS0);
const unsigned char PS_64 = (1 << ADPS2) | (1 << ADPS1);
const unsigned char PS_128 = (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0); 

bool triggered = false;
volatile unsigned long elapsedtime = 0;
volatile unsigned long conversiontime = 0;
volatile unsigned long conversiontime_global = 0;
volatile unsigned long lastDuration = 0;
volatile unsigned long finaldelay = 0;
volatile unsigned long engine_rpm;            // Vitesse courante
volatile long lastDelay = 0;
volatile int Depvalue = 0; // Lecture du capteur de depression
int Depvaluemaped = 0 ; // Transformation des unités
volatile unsigned short currentIndex = 0;
volatile unsigned long delaytime = 0;

volatile float slope[11];
volatile float intercept[11];

volatile unsigned long RPMS[MAX_INDEX];
volatile unsigned long DELAYDEP[MAX_INDEX];
volatile unsigned long DELAYS[MAX_INDEX];

volatile long map_rpm = 1;
volatile int milli_delay = 0;
volatile int micro_delay = 0;
volatile int map_pressure = 0;
volatile int cmap_pressure = 0; // Cmap pour avoir une échelle qui va de 0 à 15 degrés

volatile int pressure_axis[15] = {70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210};  // 15

// manifold pressure averaging array
const int numReadings = 5;                    // Taille du tableeau pour moyenner la pression
volatile int readings[numReadings];                     // Tableau de vitesses lues
volatile int current_index = 0;                         // Index de la vitesse courante lue
volatile unsigned long total = 0;                       // La somme des vitesses lues
volatile unsigned int manifold_pressure = 0;            // Moyenne de départ des pressions
volatile int map_pressure_kpa;

//rpm averaging array
const int num_rpm_readings = 10;               // Taille du tableeau pour moyenner la vitesse courante
volatile int rpm_readings[num_rpm_readings];   // Tableau de vitesses lues
volatile int current_index_rpm = 0;            // Index de la vitesse courante lue
volatile unsigned long rpm_total = 0;          // La somme des vitesses lues
volatile unsigned int engine_rpm_average = 0;  // Moyenne de départ des vitesses

// Tableau pour sauver des données temporelles
unsigned long start_times;
unsigned long start_times_global;
unsigned long stop_times;
unsigned long stop_times_global;
int code_delay = 100; // cette valeur doit correspondre au temps que prend la routine d'interrution du capteur de rotation

/// Construction du tableau des délais au départ de la vitesse de rotation et des valeurs d'avance
/// La ligne rouge est MAX_RPM
void calculateArrayValues()
{
  float startRPM = MIN_RPM; // Usage d'un double pour accroitre la précision des calculs
  
  int CALC_RPM = 0; // Pour créer le tableau
  int hallAdvance = 180; // On assimile le position du capteur de rotation à 180° du point mort haut

  for(int x = 1; x <=11; x++)
  {
        
    slope[x] = abs(Advance[x] - Advance[x-1])/float((Speed[x] - Speed[x-1])*10); // La fonction pour calculer l'avance linéaire est y = mx+b ou m = (y2-y1)/(x2-x1)
        
    intercept[x] = (Advance[x-1]*0.1)-((Speed[x-1]*slope[x]));  // Calcule la valeur de b d'après la formule précédente
    
    CALC_RPM = Speed[x-1];
    // Construis le tableau avec un pas de 20 T/min 
    for(int i = (Speed[x-1]/STEP_RPM); i < (Speed[x]/STEP_RPM); i++)
    {

      float usPerDegree = 60000000 / CALC_RPM / 360;  // 60000000 car tour allumeur
      float advance = 0;
      advance = (CALC_RPM * slope[x]) + intercept[x]; // Utilise notre fonction pour calculer l'avance

      unsigned long advanceDelay;


      advanceDelay = ((hallAdvance - advance) * usPerDegree) - DWELL - code_delay ; //calcule le temps a appliquer (delai) entre le signal et l'étincelle


      RPMS[i] = usPerDegree * 180;// * 180 car essai avec tete de delco
      
      DELAYS[i] = advanceDelay;
      
      DELAYDEP[i] = usPerDegree; // Lorsqu'on est sur une vitesse de rotation, on multiplie le délai par degré par le "mappage" de la valeur du capteur

      CALC_RPM += STEP_RPM; // Incrémente de 10 T/min à chaque itération


    }
  }
}



/// Applique les propriétés au départ (1 seule fois) puis attache les interruptions
void setup()
{
  pinMode(COIL1, OUTPUT); // initialise en sortie la patte qui alimente la bobine 1
  pinMode(LED1, OUTPUT);  // initialise en sortie la patte qui alimente la Led 1
  pinMode(COIL2, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(PROTECT, OUTPUT);
  pinMode(SENSOR1, INPUT);
  //pinMode(SENSOR2, INPUT);
  Serial.begin(115200);

  digitalWrite(COIL1, HIGH);
  digitalWrite(COIL2, HIGH);
  digitalWrite(PROTECT, HIGH); // Débloque la grille de l'IGBT

  calculateArrayValues();
  
  // Initialise les conversions A=>N
  ADCSRA &= ~PS_128;  // Enlève le bits mis d'originr par Arduino
  
  // On peut ici choisir son diviseur d'horloge.
  // PS_16, PS_32, PS_64 or PS_128
  ADCSRA |= PS_16;    
  // Choisir votre diviseur à PS_16 est la vitesse la plus rapide 

 

}

void editcourbe(){
  for(int i = 0; i < 175; i++)
    {    
    Serial.print(i*20);
    Serial.print(",");
    Serial.print(DELAYS[i]);
    Serial.print(",");
    Serial.println(DELAYDEP[i]);
    }
}

void demo(){
  for(int i = 1; i < 175; i++){
    Serial.print("V");
    Serial.print(",");
    Serial.print(i*20);
    Serial.print(",");
    Serial.print("0");
    Serial.print(",");
    Serial.print(DELAYS[i]);
    Serial.print(",");
    Serial.print(DELAYDEP[i]);
    Serial.print(",");
    Serial.print("0");
    Serial.println(",");
    delay(100);
  }
}


/// Si on capte un signal sur l'entrée on récupère le délai et on actionne la bobine.
void loop()
{
 
   //editcourbe();
       
   demo();

}





