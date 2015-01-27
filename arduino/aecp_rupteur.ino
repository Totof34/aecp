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

volatile int Advance[11]= {156,156,205,210,216,223,226,231,233,234,234  }; // en 1/10 de degrés d'avance allumeur à partir de 0 T/min,soit avec l'avance statique];
volatile int Speed[11] = {0,540,1700,1800,1900,2000,2040,2080,2100,3000,3500  }; // Vitesse de rotation en tour allumeur;

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

/// Charge la bobine par mise à la masse, attente du délai "DWELL", et reconnexion à la masse pour créer l'étincelle
void dwellAndFire(int pin)
{
  digitalWrite(LED1, HIGH); // Allume la Led de controle
  digitalWrite(pin, LOW);   // Met la bobine à la masse (charge)
  delayMicroseconds(DWELL);
  digitalWrite(pin, HIGH);  // Déclenche la bobine, émission de l'étincelle
  digitalWrite(LED1, LOW);  // Eteint la Led de controle
  
}

/// Interruption pour le capteur principal
void camSensor()
{
  if ( digitalRead(SENSOR1) == LOW ){                   // Continue seulement si l'état de la broche d'interruption est basse, évite les rebonds du signal
    //start_times_global = micros();               
    elapsedtime = micros() - lastDuration; 
    //Serial.println(elapsedtime);     
    engine_rpm = 30000000/elapsedtime;                      // Lis le temps écoulé pour determiner la vitesse. Note: 30000ms
    // Car 2 rotation par tour volant moteur

    lastDuration = micros();
    rpm_total= rpm_total - rpm_readings[current_index_rpm]; // Soustrait la lecture précédente du total    
                                                            // Remplace le temps courants comme nouveau temps 
    rpm_readings[current_index_rpm] = engine_rpm;           // Place ce temps courant dans l'élémnent en cours
    rpm_total= rpm_total + rpm_readings[current_index_rpm]; // Ajoute le temps lu au total    
    current_index_rpm++;                                    // Avance au prochain élémnet du tableau
    if (current_index_rpm >= (num_rpm_readings - 1))   {    // Si on a atteint la fin du tableau faire .....
      current_index_rpm = 0;                               // ...Une boucle et recommencer au début        
    }
    engine_rpm_average = rpm_total / num_rpm_readings;      // Calcule la moyenne
        
    triggered = true;
    
    //stop_times_global = micros();
    //conversiontime_global = stop_times_global - start_times_global;             // Temps moyen 92 µs par appel de l'interruption
    //Serial.println(conversiontime_global);

  }        
}

//-------------------------------------------- Function to map the engine rpm to value for the array element --------------------------------------------// 
int decode_rpm(int rpm_){

  //map_rpm = 1;
  if(elapsedtime > RPMS[MAX_INDEX]) // On ne dépasse pas la ligne rouge, on peut émettre une étincelle
  {
    if(elapsedtime < RPMS[1]) // Le délai est plus petit que le premier délai du tableau, donc vitesse supérieure à "startRPM"
    {
      if((elapsedtime*1.1) < RPMS[map_rpm]) // Incrémentation de la vitesse, avec un coefficient pour tomber bon dans le tableau
      {
        map_rpm++; // Saute au prochain index dans le tableaau
      }
      else if((elapsedtime*1.1) > RPMS[map_rpm]) // Décrémentation de la vitesse
      {
        map_rpm--; // Saute au prochain index dans le tableaau
      }
    }
  }        
  //Serial.println(map_rpm);
  return map_rpm;
}

//-------------------------------------------- Fonction pour "mapper" la valeur lue du capteur de dépression --------------------------------------------//
int decode_pressure(int pressure_) {

  map_pressure = 0;
  if(pressure_ < 70){
    map_pressure = 0;
  }
  else if (pressure_ > 210){
    map_pressure = 15;
  }
  else{
    while(pressure_ > pressure_axis[map_pressure]){
      map_pressure++;
    }
  }
  cmap_pressure = 15 - map_pressure;
  //Serial.println(map_pressure);
  return cmap_pressure;
}
//-------------------------------------------- Fonction pour lire le capteur de dépression --------------------------------------------//
int read_pressure (){
  //start_times = micros();
  // Fonction pour moyenner la lecture du capteur de pression
  total = total - readings[current_index];        //Soustrait la lecture précédente du total enregistré dans l'index actuel
  readings[current_index] = analogRead(A6);       //Place ce temps courant dans l'élémnent en cours
  total = total + readings[current_index];        //Ajoute le temps lu au total 
  current_index++;                                //Avance au prochain élémnet du tableau     
  if (current_index >= numReadings - 1){          //Si on a atteint la fin du tableau faire .....
    current_index = 0;                            //...Une boucle et recommencer au début 
  }  
  manifold_pressure = total / numReadings;        //Calcule la moyenne
  map_pressure_kpa = map(manifold_pressure,220,400,70,210);  
  delay(1);                                       // délai entre chaque lecture pour stabiliser de 1 ms, en tenir compte pour le temps final
  //stop_times = micros();
  //conversiontime = stop_times - start_times;      // temps moyen de 1124 µs dont un délai de 1ms à la ligne précédente

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

  for (int thisReading = 0; thisReading < numReadings; thisReading++)       // Peuple le tableau de pression avec des zéro
    readings[thisReading] = 0;  

  for (int thisReading = 0; thisReading < num_rpm_readings; thisReading++)   // Peuple le tableau de vitesse avec des zéro
    rpm_readings[thisReading] = 0;

  //attachInterrupt(1, idleSensor, RISING); // Interruption du capteur de proximité
  attachInterrupt(0, camSensor, FALLING); // Interruption du capteur principal



}
/// Si on capte un signal sur l'entrée on récupère le délai et on actionne la bobine.
void loop()
{
 

    if (triggered){
    start_times = micros();
    start_times_global = micros();
    triggered = false;  
    
    decode_rpm(elapsedtime);
    //stop_times = micros();
    finaldelay = (DELAYS[map_rpm]) - (cmap_pressure * (DELAYDEP[map_rpm])); // cmap_pressure correspond à la valeur de dépression en degré lue au tour précédent
    stop_times = micros(); 
    conversiontime = (stop_times - start_times);        // temps moyen d'écart avec la consigne "DELAYS[map_rpm]" de 50 µs
    //start_times_global = micros();
    milli_delay = ((finaldelay/1000)-2);
    micro_delay = (finaldelay-(milli_delay*1000))-conversiontime-80; // -conversiontime pour corriger les erreurs de sommations du temps des différentes lecture et calculs
    //start_times = micros();
    
    delay(milli_delay); // Currently, the largest value that will produce an accurate delay is 16383 µs
    delayMicroseconds(micro_delay); // Currently, the largest value that will produce an accurate delay is 16383 µs
    stop_times_global = micros();
    //stop_times = micros();
    //conversiontime = stop_times - start_times;        // temps moyen d'écart avec la consigne "DELAYS[map_rpm]" de 20 µs
    conversiontime_global = stop_times_global - start_times_global; 
    dwellAndFire(COIL1);
    //delayMicroseconds(DWELL);
    
    read_pressure ();
    decode_pressure(map_pressure_kpa);
    
    Serial.print("V");
    Serial.print(",");
    Serial.print(engine_rpm_average);
    Serial.print(",");
    Serial.print(cmap_pressure);
    Serial.print(",");
    Serial.print(DELAYS[map_rpm]);
    Serial.print(",");
    Serial.print(DELAYDEP[map_rpm]);
    Serial.print(",");
    Serial.print(conversiontime_global);
    Serial.println(",");
     
  }
  

}





