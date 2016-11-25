// Need G4P library
import g4p_controls.*;
// On importe la librairie qui permet de communiquer en série
import processing.serial.*;

Serial myPort; // On créé une instance de la classe Serial
short LF = 10; // "Fin de ligne"

char HEADERSPEED = 'S'; // C'est le caractère que l'on a inséré avant la valeur de vitesse

int speedValue; // Une variable pour stocker la valeur de vitesse
float pressionValue; // Une variable qui stocke le nombre de degré de dépression
int pressionadcValue; // Une variable qui stocke la valeur brute de conversion ADC du capteur
int mmhgValue; // Pour convertir pressionadcValue en mm de mercure mmHg
String spressionValue;
int delayValue; // Une variable pour stocker la valeur du délai
int delaydegValue; // Une variable pour stocker la valeur du délai d'un degré
float errordelay; // Une variable pour stocker la valeur d'erreur du délai
float correctederrordelay; // Corrigé pour anihiler l'action de la dépression dans le calcul de l'erreur
float errordelaypercent;

int topSignal = 90; // Une variable pour stocker la position du capteur
int NT = 60000000; // NT = 120000000/nombre de cylindres
int Ncyl = 360; // Ncyl = 720/nombre de cylindres 360° pour 2 et 180° pour 4 cylindres , temps entre 2 tops
int dwellandcodetime = 0;
int dwellandcodetime2 = 0;
float usPerDegree;
float delayDegree;
float advanceStatic;
float correcteddelayDegree;
String scorrecteddelayDegree;
float delayAvanceDegree;
String sdelayAvanceDegree;
float delaySpark;
String sdelaySpark;
int indexCurve; // Pour sélectionner une courbe allumeur
String nameCurve; // Le nom de la courbes
String titleCurve; // Le titre du graphique
String titleCurve2;// deuxième ligne de titre du graphique

PImage img;
PImage img2;

PFont ft;
PFont ft2;
PFont ft3;
PFont fg;
PFont fg2;
PFont fg3;
PFont fe;
PFont fe2;
PFont fe3;
PFont f;
String[] advanceCurve = new String[176];
String[] depressionCurve = new String[16];
int[][] mydepressionx = new int[12][1];
int[][] mydepressiony = new int[12][1]; 

int myspeedRaw;
float[] myspeed = new float[176];
float mydepressionRaw;
float[] mydepression = new float[500];

int q;
int xcentOrigin = 390;
int xdepOrigin = 960;
int ycentOrigin = 650;
int ydepOrigin = 650;
Boolean stateCent = true;


Table table;

Boolean stateCheck1 = true;
Boolean stateCheck2 = false;
Boolean stateCheck3 = false;
Boolean stateCheck4 = false;
String stringList = "Dyna Z";
String stringList2;
String stringList3;
String stringList4;
String stringList5;
String stringName = "Types mines";
String stringName1;
String stringName2;
String stringName3;
String stringName4;

int time;
int day;int month;int year;
int hour;int minute;int second;
int timestart;
int timestop;
int elapsedtime;
int elapsedtimesec;
int elapsedtimemsec;
Boolean stateCheckbtnrun = true;
Boolean stateCheckbtnrunfree = true;
Boolean stateCheckbtnpause = true;
Boolean stateCheck5 = true;
Boolean stateCheck6 = false;
String stringrpmmin;
int Irpmmin;
Boolean rpmmin = false;
int runrpmmin = 0;
Boolean Brpmmin = true;
String stringrpmmax;
int Irpmmax;
Boolean rpmmax = false;
int runrpmmax = 0;
Boolean Brpmmax = true;

float[] myrpmy = new float[1241];
float[] mycenty = new float[1241];
float[] mydepy = new float[1241];

int xrpmPos = 0;         // variable abscisse  - x
float yrpmPos=0;  // variable yPos - ordonnée
int xcentPos = 0;         // variable abscisse  - x
float ycentPos=0;  // variable yPos - ordonnée
int xdepPos = 0;         // variable abscisse  - x
float ydepPos=0;  // variable yPos - ordonnée
int xrorpm = 40; // Origin x du cardre de l'historique rpm voir coordonnée du cadre dans gui.pde
int yrorpm = 330; // Origin y du cardre de l'historique rpm voir coordonnée du cadre dans gui.pde
int xrocent = 40; // Origin x du cardre de l'historique cent voir coordonnée du cadre dans gui.pde
int yrocent = 500; // Origin y du cardre de l'historique cent voir coordonnée du cadre dans gui.pde
int xrodep = 40; // Origin x du cardre de l'historique dep voir coordonnée du cadre dans gui.pde
int yrodep = 650; // Origin y du cardre de l'historique dep voir coordonnée du cadre dans gui.pde

String sName = "mesure";
String sExportdata;
String[] sData = new String[1241];

Boolean stateCheckbtnsave = true;
Boolean stateCheckbtnload = true;

Plot p;  //Globals
Aef aef;
String cFN = "Aecp.conf";
StringDict config;

float[][] records1 = new float [1241][3];
float[][] records2 = new float [1241][3];
float[][] records3 = new float [1241][3];
float[][] records4 = new float [1241][3];
float[] yrsave = new float[1241];
float[] ycsave = new float[1241];
float[] ydsave = new float[1241];

Boolean stateC1 = false;Boolean stateC2 = false;Boolean stateC3 = false;Boolean stateC4 = false;
Boolean stateC5 = false;Boolean stateC6 = false;Boolean stateC7 = false;
color oraC = color(245,110,5); // orange
color blC = color(10,10,255); // bleu
color reC = color(255,10,10);// rouge
color veC = color(10,255,10); // vert
color jaC = color(252,252,41); // jaune
color orC = color(175,152,18); // or

public void setup(){
  size(1350, 690, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  smooth();
  // A vous de trouver quel port série est utilisé à l'aide de print(Serial.list())
 String portName = Serial.list()[32];
 //print(Serial.list());
 // On initialise la communication série, à la même vitesse qu'Arduino
 myPort = new Serial(this, portName, 115200);
 
 myPort.bufferUntil('\n');
 
 // Make a new instance of the file dataCurve for loading some data

 nameCurve = ("a4114a.txt");
 advanceCurve = loadStrings(nameCurve);
 depressionCurve = loadStrings("depressionCurve.txt");
 

 
 
 // Make a new instance of a PImage by loading an image file
  img = loadImage("panhard242.png");                // Using a String for a file name
  
 // Loading a font for displaying text for title
  ft = loadFont("Courier10PitchBT-Bold-32.vlw"); 
 
 // Loading a font for displaying text for title
  fg = loadFont("Courier-Bold-18.vlw"); 
 
 // Loading a font for displaying text for title
  fe = loadFont("Courier-Bold-12.vlw"); 
   
 // Loading a font for displaying text 
  f = loadFont("Courier-Bold-22.vlw"); 
  
  aef = new Aef();
  p = new Plot();
  config = new StringDict();
  loadConfig(cFN);  //Path to the config file should be "argv" or so !

  for (int q = 0; q<175; q++){
    myspeed [q] = 0; // initialise le tableau d'avance centrifuge pour éliminer les "scories" !!!
  }
}
// Un message est reçu depuis l'Arduino
void serialEvent(Serial p) {
 String message = myPort.readStringUntil(LF); // On lit le message reçu, jusqu'au saut de ligne
 if (message == null){
  
 }
 
 if (message != null)
 {
 print("Message " + message);
 // On découpe le message à chaque virgule, on le stocke dans un tableau
 String [] data = message.split(",");

//Message reçu pour la vitesse
 if (data[0].charAt(0) == HEADERSPEED)
 {
 // On convertit la valeur (String -> Int)
 int speedRaw = Integer.parseInt(data[1]);
 speedValue = speedRaw;
 myspeedRaw = speedRaw; 
 knob1.setValue(speedValue);
 // On convertit la valeur (String -> Int)
 float pressionRaw = Float.parseFloat(data[2]);
 // On convertit la valeur (String -> Int)
 pressionValue = pressionRaw;
 mydepressionRaw = pressionRaw;
 knob4.setValue(pressionValue);
 
 // On convertit la valeur (String -> Int)
 int delayRaw = Integer.parseInt(data[3]);
 // On convertit la valeur (String -> Int)
 delayValue = delayRaw;
 
 // On convertit la valeur (String -> Int)
 int delaydegRaw = Integer.parseInt(data[4]);
 // On convertit la valeur (String -> Int)
 delaydegValue = delaydegRaw;
 
 int errorRaw = Integer.parseInt(data[5]);
 // On convertit la valeur (String -> Int)
 errordelay = errorRaw;
 
 // On convertit la valeur (String -> Int)
 int depRaw = Integer.parseInt(data[6]);
 pressionadcValue = depRaw;
 mmhgValue = int((707 - pressionadcValue)/1.78); 
 //println(mmhgValue);
 
 
 calculdegres();
 calculdegresavance();
 calculerreurdelai();
 //storeavance();
 knob2.setValue(topSignal - delayDegree);
 knob3.setValue(delaySpark);
 knob5.setValue(errordelaypercent);
 String scorrecteddelayDegree = nf(correcteddelayDegree, 2, 2);
 String sdelaySpark = nf(delaySpark, 2, 2);
 //print(scorrecteddelayDegree);print(",");
 //println(sdelaySpark);
 textfield1.setText(str(speedValue));
 textfield2.setText(str(pressionValue)); // affiche le nombre de degrés de dépression
 textfield3.setText(str(delayValue));
 textfield5.setText(str(pressionValue));
 if (stateCent == false ){
   textfield6.setText(sdelaySpark);
 }
 else {
   textfield6.setText(str(advanceStatic));
 }
 //textfield6.setText(str(advanceStatic));
 textfield4.setText(scorrecteddelayDegree);
 textfield7.setText(sdelaySpark); // affiche le nombre de degrés résultants
 textfield8.setText(scorrecteddelayDegree); // affiche le nombre de degrés centrifuges
 textfield9.setText(sdelaySpark); // affiche le nombre de degrés résultants
 //println(sdelaySpark);
 String serrordelaypercent = nf(errordelaypercent, 1, 4);
 textfield10.setText(serrordelaypercent); // affiche le pourcentage d'erreur
 storeavance();
 storedepression();
 
 }


 
 
 }
}

public void calculdegres(){
   usPerDegree = (NT / speedValue / float(Ncyl));  // 30000000 car tour allumeur et tour moteur = tour allumeur * 2
   //delayDegree = ((delayValue+dwellandcodetime) / float(delaydegValue))+advanceStatic ; // calcule le nombre de degrés d'avance finale 
   if (stateCent == false ){
   delayDegree = ((delayValue+dwellandcodetime) / usPerDegree)+advanceStatic ; // calcule le nombre de degrés d'avance finale
   }
  else{
   delayDegree = ((delayValue+dwellandcodetime) / usPerDegree)+advanceStatic ; // calcule le nombre de degrés d'avance finale
  } 
   correcteddelayDegree = topSignal - delayDegree;
   //println(correcteddelayDegree);
   //println(usPerDegree);
}

public void calculdegresavance(){
   
   
   delayAvanceDegree = delayDegree - pressionValue; // Soustrait du délai final le nombre de degrés d'avance dépression
   delaySpark = topSignal - delayAvanceDegree+advanceStatic;  // Calcule le délai qui sépare l'étincelle du PMH
   
}

public void calculerreurdelai(){
   
   correctederrordelay = errordelay+(delaydegValue*pressionValue);
   errordelaypercent = (abs(delayValue - correctederrordelay)/float(delayValue))*100; // Calcule le pourcentage d'erreur
   //println(errordelaypercent);
}


public void storeavance(){
  int s = myspeedRaw/40;
  float av = 0;
  if (stateCent == false){
  av = map(correcteddelayDegree, 0, 20, 0, 200);
  }
  else {
  av = map(correcteddelayDegree, 0, 20, 0, 200);  
  }
  //print(s);print(",");
  //println(av);
  myspeed [s] = av;
  //println(myspeed [s]); 
   
}

public void drawmycentrifugalcurve(){
  for (int q = 1; q<175; q++){
    //println(myspeed [q]);
    int lastxr = (q - 1)*2;
    float lastyr = myspeed [q - 1];
    int xr = q*2;
    float yr = myspeed [q];    
    if (stateCent == false ){
    line(xcentOrigin+lastxr,ycentOrigin-160-lastyr,xcentOrigin+xr,ycentOrigin-160-yr); 
    }
    else {
    fill(0);
    line(xcentOrigin+lastxr,ycentOrigin-lastyr,xcentOrigin+xr,ycentOrigin-yr);
    }
  }
}

public void storedepression(){
  int s = mmhgValue;
  float dep = mydepressionRaw;
  //print(s);print(",");
  //println(dep);
  mydepression [s] = dep;
  //print(mydepression [s]);println(","); 
   
}

public void drawmydepressioncurve(){
  for (int g = 1; g<300; g++){
    int xdep = g;
    int lastxdep = g-1;
    int xdepc = xdepOrigin + g; // Origine du tableau en  = 960
    int lastxdepc = xdepOrigin + (g-1); // Origine du tableau en  = 960
    float ydep = mydepression [g];
    float lastydep = mydepression [g-1];
    float ydepc = ydepOrigin - (ydep*10);
    float lastydepc = ydepOrigin - (lastydep*10);
    //println(myspeed [q]);
    fill(0);
    line(lastxdepc,lastydepc,xdepc,ydepc);
    //line(xavc-1,yavc-1,xavc,yavc);
    //print(xavc);print(",");
    //println(yavc);
    //line(480,680,750,525);
  }
}

public void selectcentrifugalcurve(){
  indexCurve = dropList1.getSelectedIndex();
  //println(indexCurve);
  
  switch(indexCurve) {
   case 0: 
     advanceStatic = 17.0;
     nameCurve = "a4114a.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "Allumeur A4114A-SEV TC/TG"; 
     titleCurve2 = "    (M8N - N2 & N5)";
     dwellandcodetime2 = 0;
     stateCent = true;
     break;
   case 1: 
     advanceStatic = 32.0; 
     nameCurve = "M8S.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "Allumeur SEV pour M8S";
     titleCurve2 = "    (     24CT     )";
     dwellandcodetime2 = 120;
     stateCent = false;
     break;
   case 2: 
     advanceStatic = 17.0;
     nameCurve = "a132.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "    Allumeur A132-SEV"; 
     titleCurve2 = "    (M10S - N1 1965)";
     stateCent = true;
     break;
   case 3: 
     advanceStatic = 17.0;
     nameCurve = "525292.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "  Allumeur 525292 - SCD"; 
     titleCurve2 = "                   ";
     stateCent = true;
     break;  
   }
  
  
  drawcentrifugalcurve();
}


public void drawcentrifugalcurve(){
  fill(0,0,0);
  rect(360,xcentOrigin,410,300); // Cadre noir du graphique d'avance centrifuge
  fill(255,255,204);
  rect(370,400,xcentOrigin,280);  // Cadre beige du graphique d'avance centrifuge
  fill(0);
  // Trace le cadrillage de l'avance centrifuge
  for (int i = xcentOrigin; i < 741; i = i+50) 
  {
  line(i, 450, i, ycentOrigin); // ligne verticale
  
  }
  for (int i = ycentOrigin; i > 449; i = i-40) 
  {
  line(xcentOrigin, i, 741, i); // ligne horizontale
  }
  
  textFont(f);
  text(titleCurve,410,420);
  text(titleCurve2,410,440);
  
  textFont(fg);
  text(0,xcentOrigin-5,700);
  text(500,xcentOrigin+30,ycentOrigin+20);
  text(1000,xcentOrigin+80,ycentOrigin+20);
  text(1500,xcentOrigin+130,ycentOrigin+20);
  text(2000,xcentOrigin+180,ycentOrigin+20);
  text(2500,xcentOrigin+230,ycentOrigin+20);
  text(3000,xcentOrigin+280,ycentOrigin+20);
  
  if (stateCent == false){
  text(20,xcentOrigin-20,615);
  text(24,xcentOrigin-20,575);
  text(28,xcentOrigin-20,535);
  text(32,xcentOrigin-20,495);
  }
  else{
  text(4,xcentOrigin-15,615);
  text(8,xcentOrigin-15,575);
  text(12,xcentOrigin-20,535);
  text(16,xcentOrigin-20,495);
  }
  
  textFont(fe);
  text("T/min",xcentOrigin+330,ycentOrigin+20);
  text("d°",xcentOrigin-15,450);
  
  // Trace les bornes de l'avance centrifuge
  for (int i = 2; i<=175; i++){
  String ligne = advanceCurve[i];
  
  String[] cells = split(advanceCurve[i], ",");
  int speedData = Integer.parseInt(cells[0]);
  int timeDelay = Integer.parseInt(cells[1]);
  
  String[] lastcells = split(advanceCurve[i-1], ",");
  int lastspeedData = Integer.parseInt(lastcells[0]);
  int lasttimeDelay = Integer.parseInt(lastcells[1]);
  //int timeDegree = Integer.parseInt(cells[2]);
  float timeDegree = NT / speedData /float(Ncyl);
  float degreeData = (topSignal)-((timeDelay + dwellandcodetime2)/timeDegree)-advanceStatic;
  float lasttimeDegree = NT / lastspeedData /float(Ncyl);
  float lastdegreeData = (topSignal)-((lasttimeDelay + dwellandcodetime2)/lasttimeDegree)-advanceStatic;
  //print(speedData);
  //print(":");
  //println(lastspeedData);
  // Point d'origine pour les courbe (480,680)
  
   int xs = xcentOrigin + (speedData/20);
   float yd = ycentOrigin - (degreeData*10);
   int ydInt = int(yd);
   
   int lastxs = xcentOrigin + (lastspeedData/20);
   float lastyd = ycentOrigin - (lastdegreeData*10);
   int lastydInt = int(lastyd);
   fill(0,255,0);
   //line(xs,ydInt,xs+1,ydInt-1); // courbe cible d'origine
   if (stateCent == false ){
   line((xs),(ydInt-170),(lastxs),(lastydInt-170));
   if (ydInt<650){
   line((xs),(ydInt-150),(lastxs),(lastydInt-150));
   }
   }
   else
   {
   line((xs-10),(ydInt-10),(lastxs-10),(lastydInt-10));
   if (ydInt<638){
   line((xs+10),(ydInt+10),(lastxs+10),(lastydInt+10));
   } 
   }
  }
  
}

public void drawdepressioncurve(){
  
  fill(0,0,0);
  rect(930,390,410,300); // Cadre noir du graphique d'avance dépression
  fill(255,255,204);
  rect(940,400,390,280); // Cadre beige du graphique d'avance dépression
  fill(0);
  // Trace le cadrillage de l'avance dépression
  for (int i = xdepOrigin; i < 1311; i = i+50) 
  {
  line(i, 450, i, ydepOrigin);// ligne verticale
  }
  for (int i = ydepOrigin; i > 424; i = i-50) 
  {
  line(xdepOrigin, i, 1310, i); // ligne horizontale
  }
  
  textFont(f);
  fill(0,0,0);
  text("Capteur de dépression",990,430);
  
  textFont(fg);
  text(0,xdepOrigin-5,ydepOrigin+20);
  text(50,xdepOrigin+40,ydepOrigin+20);
  text(100,xdepOrigin+85,ydepOrigin+20);
  text(150,xdepOrigin+135,ydepOrigin+20);
  text(200,xdepOrigin+185,ydepOrigin+20);
  text(250,xdepOrigin+235,ydepOrigin+20);
  text(300,xdepOrigin+285,ydepOrigin+20);
  
  text(5,xdepOrigin-15,605);
  text(10,xdepOrigin-20,555);
  text(15,xdepOrigin-20,505);
 
  textFont(fe);
  text("mmHg",xdepOrigin+330,ydepOrigin+20);
  text("d°",xdepOrigin-15,450); 
  
  // Trace les bornes de l'avance dépression
  for (int i = 0; i<12; i++){
  String ligne = depressionCurve[i];
  String[] cells = split(depressionCurve[i], ",");
  int depressionx = Integer.parseInt(cells[0]);
  int depressiony = Integer.parseInt(cells[1]);
    
  mydepressionx[i][0] = xdepOrigin + depressionx;
  mydepressiony[i][0] = ydepOrigin - depressiony;
  
  //print(mydepressionx[i][0]);
  //print(":");
  //println(mydepressiony[i][0]); 
  
  }
  
  // Trace les bornes de l'avance dépression
  for (int i = 1; i<12; i++){
    int lastxd = mydepressionx[i-1][0];
    int lastyd = mydepressiony[i-1][0];
    int xd = mydepressionx[i][0];
    int yd = mydepressiony[i][0];
    
    //print(xd);
    //print(":");
    //println(yd);
    
    fill(255,0,0);
    
    //line(lastxd,lastyd,xd,yd); // courbe cible d'origine
    line(lastxd-10,lastyd-10,xd-10,yd-10);
    line(lastxd+10,lastyd+10,xd+10,yd+10);
    
    
  }
  
}


void loadConfig(String file){  
    InputStream input;
    
  if (createInput(file) == null){  // If file not found, set some default values to start up
    config.set("aefmespath","/home/dedessus/sketchbook/myproject/aecp_Duino_Nano/aef/");
    saveConfig(file);  // create the file
    return;            // that's all
  }
//  println("loadConfig");
// populate the config dictionary
  int i;
  String items[];
  String lines[] = loadStrings(file);  //Get all the lines of the file
  items = new String[2];  // Two items per line: key and value
  for (i = 0; i < lines.length; i++){  // for each line in lines
    items = split(lines[i]," ");
    if (items.length == 2) config.set(items[0],items[1]);  // else line is not interpretable
  }
/*  debug: show the content of config  
  String[] k = config.keyArray();
  for (i = 0; i < config.size(); i++){
    println(k[i],config.get(k[i]));
  } 
*/  
}

void saveConfig(String file){
//  println ("saveConfig");
  int i;
  String[] keyval;    // A key/value pair from the config dictionary
  String[] k = config.keyArray();  // The keys
//  println (k);
  keyval = new String[config.size()];
  for (i = 0; i < config.size(); i++) keyval[i] = k[i] + " " + config.get(k[i]);
  saveStrings(file,keyval);
}

// G4P code for folder and file dialogs
public void handleFileDialog() {
  String fname;
  boolean b;
  
    // Use file filter if possible
  fname = G4P.selectInput("Select AEF");
 // println(fname);
  if (fname != null) {
    aef.setPath(fname);
    //aef.loadMesure0();
  }
}

public void openhelpwindow(){
  window1 = GWindow.getWindow(this, "Aide à la sélection", 0, 0, 1350, 690, JAVA2D);
  window1.loop();
  window1.setActionOnClose(G4P.CLOSE_WINDOW);
  window1.addDrawHandler(this, "win_draw2");
  window1.loop();
  togGroup1 = new GToggleGroup();
  option1 = new GOption(window1, 110, 90, 160, 20);
  option1.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option1.setText("Type mines");
  option1.setTextBold();
  option1.setOpaque(false);
  option1.addEventHandler(this, "option1_clicked1");
  option2 = new GOption(window1, 410, 90, 160, 20);
  option2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option2.setText("Type moteur");
  option2.setTextBold();
  option2.setOpaque(false);
  option2.addEventHandler(this, "option2_clicked1");
  option3 = new GOption(window1, 710, 90, 160, 20);
  option3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option3.setText("Marque allumeur");
  option3.setTextBold();
  option3.setOpaque(false);
  option3.addEventHandler(this, "option3_clicked1");
  option4 = new GOption(window1, 1010, 90, 160, 20);
  option4.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option4.setText("Référence Allumeur");
  option4.setTextBold();
  option4.setOpaque(false);
  option4.addEventHandler(this, "option4_clicked1");
  togGroup1.addControl(option1);
  option1.setSelected(true);
  togGroup1.addControl(option2);
  togGroup1.addControl(option3);
  togGroup1.addControl(option4);
  dropList2 = new GDropList(window1, 110, 140, 160, 220, 10);
  dropList2.setItems(loadStrings("list_988723"), 0);
  dropList2.addEventHandler(this, "dropList2_click1");
  dropList3 = new GDropList(window1, 410, 140, 160, 140, 6);
  dropList3.setItems(loadStrings("list_846523"), 0);
  dropList3.addEventHandler(this, "dropList3_click1");
  dropList4 = new GDropList(window1, 710, 140, 160, 80, 3);
  dropList4.setItems(loadStrings("list_362785"), 0);
  dropList4.addEventHandler(this, "dropList4_click1");
  dropList5 = new GDropList(window1, 1010, 140, 170, 220, 10);
  dropList5.setItems(loadStrings("list_999683"), 0);
  dropList5.addEventHandler(this, "dropList5_click1");
}
 
public void recordwindow(){ 
   window2 = GWindow.getWindow(this, "Aide à la sélection pour paramétrer sa courbe", 0, 0, 1350, 690, JAVA2D);
  window2.setActionOnClose(G4P.CLOSE_WINDOW);
  window2.addDrawHandler(this, "win_draw1");
  textfieldrpmmin = new GTextField(window2, 1020, 50, 110, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmin.setText(" ");
  textfieldrpmmin.setOpaque(true);
  textfieldrpmmin.addEventHandler(this, "textfieldrpmmin_change1");
  label43 = new GLabel(window2, 920, 50, 80, 20);
  label43.setText("RPM min");
  label43.setTextBold();
  label43.setOpaque(false);
  label44 = new GLabel(window2, 920, 80, 80, 20);
  label44.setText("RPM max");
  label44.setTextBold();
  label44.setOpaque(false);
  textfieldrpmmax = new GTextField(window2, 1020, 80, 110, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmax.setText(" ");
  textfieldrpmmax.setOpaque(true);
  textfieldrpmmax.addEventHandler(this, "textfieldrpmmax_change1");
  buttonrun = new GButton(window2, 50, 50, 90, 50);
  buttonrun.setText("Départ prédéfinis");
  buttonrun.setTextBold();
  buttonrun.addEventHandler(this, "buttonrun_click1");
  togGroup2 = new GToggleGroup();
  textfieldrpmactual = new GTextField(window2, 740, 50, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmactual.setOpaque(true);
  textfieldrpmactual.addEventHandler(this, "textfieldrpmactual_change1");
  textfieldtimeactual = new GTextField(window2, 740, 80, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldtimeactual.setOpaque(true);
  textfieldtimeactual.addEventHandler(this, "textfieldtimeactual_change1");
  label45 = new GLabel(window2, 600, 50, 120, 20);
  label45.setText("RPM actuel");
  label45.setTextBold();
  label45.setOpaque(false);
  label46 = new GLabel(window2, 600, 80, 120, 20);
  label46.setText("Temps interne");
  label46.setTextBold();
  label46.setOpaque(false);
  label47 = new GLabel(window2, 600, 110, 120, 20);
  label47.setText("Temps écoulé");
  label47.setTextBold();
  label47.setOpaque(false);
  textfieldelapsedtime1 = new GTextField(window2, 740, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime1.setText("0");
  textfieldelapsedtime1.setOpaque(true);
  textfieldelapsedtime1.addEventHandler(this, "textfieldelapsedtime1_change1");
  buttonrunfree = new GButton(window2, 490, 50, 90, 50);
  buttonrunfree.setText("Départ libre");
  buttonrunfree.setTextBold();
  buttonrunfree.addEventHandler(this, "buttonrunfree_click1");
  label48 = new GLabel(window2, 160, 50, 80, 20);
  label48.setText("RPM min");
  label48.setTextBold();
  label48.setOpaque(false);
  label49 = new GLabel(window2, 160, 80, 80, 20);
  label49.setText("RPM max");
  label49.setTextBold();
  label49.setOpaque(false);
  textfieldrpmmin2 = new GTextField(window2, 260, 50, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmin2.setText("1000");
  textfieldrpmmin2.setOpaque(true);
  textfieldrpmmin2.addEventHandler(this, "textfieldrpmmin2_change1");
  textfieldrpmmax2 = new GTextField(window2, 260, 80, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmax2.setText("4000");
  textfieldrpmmax2.setOpaque(true);
  textfieldrpmmax2.addEventHandler(this, "textfieldrpmmax2_change1");
  label50 = new GLabel(window2, 120, 110, 120, 20);
  label50.setText("Temps écoulé");
  label50.setTextBold();
  label50.setOpaque(false);
  textfieldelapsedtime3 = new GTextField(window2, 260, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime3.setOpaque(true);
  textfieldelapsedtime3.addEventHandler(this, "textfieldelapsedtime3_change1");
  textfieldelapsedtime4 = new GTextField(window2, 350, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime4.setOpaque(true);
  textfieldelapsedtime4.addEventHandler(this, "textfieldelapsedtime4_change1");
  label51 = new GLabel(window2, 300, 110, 40, 20);
  label51.setText("Sec");
  label51.setTextBold();
  label51.setOpaque(false);
  textfieldelapsedtime2 = new GTextField(window2, 830, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime2.setOpaque(true);
  textfieldelapsedtime2.addEventHandler(this, "textfieldelapsedtime2change1");
  label53 = new GLabel(window2, 780, 110, 40, 20);
  label53.setText("Sec");
  label53.setTextBold();
  label53.setOpaque(false);
  label52 = new GLabel(window2, 390, 110, 30, 20);
  label52.setText("ms");
  label52.setTextBold();
  label52.setOpaque(false);
  label54 = new GLabel(window2, 870, 110, 30, 20);
  label54.setText("ms");
  label54.setTextBold();
  label54.setOpaque(false);
  buttonsave = new GButton(window2, 1170, 50, 100, 20);
  buttonsave.setText("Sauvegarder");
  buttonsave.setTextBold();
  buttonsave.addEventHandler(this, "buttonsave_click1");
  buttonload = new GButton(window2, 1170, 80, 100, 20);
  buttonload.setText("Historique");
  buttonload.setTextBold();
  buttonload.addEventHandler(this, "buttonload_click1");
  label55 = new GLabel(window2, 920, 110, 100, 20);
  label55.setText("Date & heure");
  label55.setTextBold();
  label55.setOpaque(false);
  tfd = new GTextField(window2, 1030, 110, 20, 20, G4P.SCROLLBARS_NONE);
  tfd.setOpaque(true);
  tfd.addEventHandler(this, "tfd_change1");
  tfm = new GTextField(window2, 1060, 110, 20, 20, G4P.SCROLLBARS_NONE);
  tfm.setOpaque(true);
  tfm.addEventHandler(this, "tfm_change1");
  tfy = new GTextField(window2, 1090, 110, 40, 20, G4P.SCROLLBARS_NONE);
  tfy.setOpaque(true);
  tfy.addEventHandler(this, "tfy_change1");
  tfh = new GTextField(window2, 1160, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfh.setOpaque(true);
  tfh.addEventHandler(this, "tfh_change1");
  tfmin = new GTextField(window2, 1200, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfmin.setOpaque(true);
  tfmin.addEventHandler(this, "tfmin_change1");
  tfs = new GTextField(window2, 1240, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfs.setOpaque(true);
  tfs.addEventHandler(this, "tfs_change1");
  buttonpause = new GButton(window2, 1170, 20, 100, 20);
  buttonpause.setText("Pause");
  buttonpause.setTextBold();
  buttonpause.addEventHandler(this, "buttonpause_click1");
  buttonc1 = new GButton(window2, 1300, 180, 30, 30);
  buttonc1.setText("+");
  buttonc1.setTextBold();
  buttonc1.addEventHandler(this, "buttonc1_click1");
  buttonc2 = new GButton(window2, 1300, 220, 30, 30);
  buttonc2.setText("+");
  buttonc2.setTextBold();
  buttonc2.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  buttonc2.addEventHandler(this, "buttonc2_click1");
  buttonc3 = new GButton(window2, 1300, 260, 30, 30);
  buttonc3.setText("+");
  buttonc3.setTextBold();
  buttonc3.setLocalColorScheme(GCScheme.RED_SCHEME);
  buttonc3.addEventHandler(this, "buttonc3_click1");
  buttonc4 = new GButton(window2, 1300, 300, 30, 30);
  buttonc4.setText("+");
  buttonc4.setTextBold();
  buttonc4.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  buttonc4.addEventHandler(this, "buttonc4_click1");
  
}

public void saveorselectwindow(){ 
  window3 = GWindow.getWindow(this, "Sauvegarde et historique", 0, 0, 370, 150, JAVA2D);
  window3.setActionOnClose(G4P.CLOSE_WINDOW);
  window3.addDrawHandler(this, "win_draw3");
  label56 = new GLabel(window3, 10, 30, 140, 20);
  label56.setText("Nom de la courbe");
  label56.setTextBold();
  label56.setOpaque(false);
  tfsname = new GTextField(window3, 160, 30, 200, 20, G4P.SCROLLBARS_NONE);
  tfsname.setPromptText("Nom de votre courbe");
  tfsname.setOpaque(true);
  tfsname.addEventHandler(this, "tfsname_change1");
  label57 = new GLabel(window3, 10, 60, 140, 20);
  label57.setText("Date & heure");
  label57.setTextBold();
  label57.setOpaque(false);
  tfd2 = new GTextField(window3, 160, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfd2.setOpaque(true);
  tfd2.addEventHandler(this, "tfd2_change1");
  tfm2 = new GTextField(window3, 190, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfm2.setOpaque(true);
  tfm2.addEventHandler(this, "tfm2_change1");
  tfy2 = new GTextField(window3, 220, 60, 40, 20, G4P.SCROLLBARS_NONE);
  tfy2.setOpaque(true);
  tfy2.addEventHandler(this, "tfy2_change1");
  tfh2 = new GTextField(window3, 280, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfh2.setOpaque(true);
  tfh2.addEventHandler(this, "tfh2_change1");
  tfmin2 = new GTextField(window3, 310, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfmin2.setOpaque(true);
  tfmin2.addEventHandler(this, "tfmin2_change1");
  tfs2 = new GTextField(window3, 340, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfs2.setOpaque(true);
  tfs2.addEventHandler(this, "tfs2_change1");
  buttonok = new GButton(window3, 135, 101, 100, 30);
  buttonok.setText("Enregistrer");
  buttonok.setTextBold();
  buttonok.addEventHandler(this, "buttonok_click1");
  label58 = new GLabel(window3, 300, 60, 10, 20);
  label58.setText(":");
  label58.setTextBold();
  label58.setOpaque(false);
  label59 = new GLabel(window3, 330, 60, 10, 20);
  label59.setText(":");
  label59.setTextBold();
  label59.setOpaque(false);
}
 
public void draw(){
  background(255);
  // Draw the image to the screen at coordinate (0,0)
  image(img,140,130);
  
  textFont(ft);
  fill(0,51,0);
  text("Allumage Electronique Cartographique pour Panhard",370,40); // Affichage du titre
  
  ellipseMode(CENTER);
  fill(20);
  ellipse(210,220,405,405);
  ellipse(580,200,270,270); // Premier cercle noir avance centrifuge
  ellipse(890,200,270,270); // second cercle noir avance résultante
  ellipse(1200,200,270,270); // troisième cercle noir avance dépression
  ellipse(850,520,150,150); // quatrième cercle noir erreur délai
  rect(490,340,180,40); // premier cadre noir avance centrifuge
  rect(810,340,180,40); // second cadre noir avance résultante
  rect(1110,340,180,40); // troisième cadre noir avance dépression
  rect(110,440,170,40); // quatrième cadre noir T/min
  rect(40,490,300,180); // Cadre noir qui sert de tableau récapitulatif en bas à gauche
  
  fill(150);
  rect(800,610,100,60); // Cadre noir qui sert de bordure au bouton "aide à la sélection"
  
  fill(255);
  
  ellipse(210,220,340,340);
  
  fill(255,0,0);
  arc(210, 220, 339, 339, -PI/4.6, 0);  // Zone rouge du compteur T/min
  arc(890, 200, 240, 240, -1.58, -1.53);  // Repère rouge qui marque les 33° de l'avance centrifuge et statique soit 17 + 16
  
  textFont(f);
  fill(255,0,0);
  text("6",350,110); // Affichage des chiffres en rouge car régime moteur en zone rouge
  text("7",390,220);
  
  selectcentrifugalcurve(); 
  
  //drawcentrifugalcurve();
  drawdepressioncurve();
  drawmycentrifugalcurve();
  drawmydepressioncurve();
    
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}