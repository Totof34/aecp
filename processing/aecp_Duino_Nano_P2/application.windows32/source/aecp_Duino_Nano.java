import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import g4p_controls.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class aecp_Duino_Nano extends PApplet {

// Need G4P library

// On importe la librairie qui permet de communiquer en s\u00e9rie


Serial myPort; // On cr\u00e9\u00e9 une instance de la classe Serial
short LF = 10; // "Fin de ligne"

char HEADERSPEED = 'S'; // C'est le caract\u00e8re que l'on a ins\u00e9r\u00e9 avant la valeur de vitesse

int speedValue; // Une variable pour stocker la valeur de vitesse
float pressionValue; // Une variable qui stocke le nombre de degr\u00e9 de d\u00e9pression
int pressionadcValue; // Une variable qui stocke la valeur brute de conversion ADC du capteur
int mmhgValue; // Pour convertir pressionadcValue en mm de mercure mmHg
String spressionValue;
int delayValue; // Une variable pour stocker la valeur du d\u00e9lai
int delaydegValue; // Une variable pour stocker la valeur du d\u00e9lai d'un degr\u00e9
float errordelay; // Une variable pour stocker la valeur d'erreur du d\u00e9lai
float correctederrordelay; // Corrig\u00e9 pour anihiler l'action de la d\u00e9pression dans le calcul de l'erreur
float errordelaypercent;

int topSignal = 90; // Une variable pour stocker la position du capteur
int NT = 60000000; // NT = 120000000/nombre de cylindres
int Ncyl = 360; // Ncyl = 720/nombre de cylindres 360\u00b0 pour 2 et 180\u00b0 pour 4 cylindres , temps entre 2 tops
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
int indexCurve; // Pour s\u00e9lectionner une courbe allumeur
String nameCurve; // Le nom de la courbes
String titleCurve; // Le titre du graphique
String titleCurve2;// deuxi\u00e8me ligne de titre du graphique

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
float[] mydepression = new float[300];

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
float yrpmPos=0;  // variable yPos - ordonn\u00e9e
int xcentPos = 0;         // variable abscisse  - x
float ycentPos=0;  // variable yPos - ordonn\u00e9e
int xdepPos = 0;         // variable abscisse  - x
float ydepPos=0;  // variable yPos - ordonn\u00e9e
int xrorpm = 40; // Origin x du cardre de l'historique rpm voir coordonn\u00e9e du cadre dans gui.pde
int yrorpm = 330; // Origin y du cardre de l'historique rpm voir coordonn\u00e9e du cadre dans gui.pde
int xrocent = 40; // Origin x du cardre de l'historique cent voir coordonn\u00e9e du cadre dans gui.pde
int yrocent = 500; // Origin y du cardre de l'historique cent voir coordonn\u00e9e du cadre dans gui.pde
int xrodep = 40; // Origin x du cardre de l'historique dep voir coordonn\u00e9e du cadre dans gui.pde
int yrodep = 650; // Origin y du cardre de l'historique dep voir coordonn\u00e9e du cadre dans gui.pde

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
int oraC = color(245,110,5); // orange
int blC = color(10,10,255); // bleu
int reC = color(255,10,10);// rouge
int veC = color(10,255,10); // vert
int jaC = color(252,252,41); // jaune
int orC = color(175,152,18); // or

public void setup(){
  size(1350, 690, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  smooth();
  // A vous de trouver quel port s\u00e9rie est utilis\u00e9 \u00e0 l'aide de print(Serial.list())
 String portName = Serial.list()[32];
 //print(Serial.list());
 // On initialise la communication s\u00e9rie, \u00e0 la m\u00eame vitesse qu'Arduino
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
    myspeed [q] = 0; // initialise le tableau d'avance centrifuge pour \u00e9liminer les "scories" !!!
  }
}
// Un message est re\u00e7u depuis l'Arduino
public void serialEvent(Serial p) {
 String message = myPort.readStringUntil(LF); // On lit le message re\u00e7u, jusqu'au saut de ligne
 if (message == null){
   
 }
 
 if (message != null)
 {
 print("Message " + message);
 // On d\u00e9coupe le message \u00e0 chaque virgule, on le stocke dans un tableau
 String [] data = message.split(",");

//Message re\u00e7u pour la vitesse
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
 mmhgValue = PApplet.parseInt((707 - pressionadcValue)/1.78f); 
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
 textfield2.setText(str(pressionValue)); // affiche le nombre de degr\u00e9s de d\u00e9pression
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
 textfield7.setText(sdelaySpark); // affiche le nombre de degr\u00e9s r\u00e9sultants
 textfield8.setText(scorrecteddelayDegree); // affiche le nombre de degr\u00e9s centrifuges
 textfield9.setText(sdelaySpark); // affiche le nombre de degr\u00e9s r\u00e9sultants
 //println(sdelaySpark);
 String serrordelaypercent = nf(errordelaypercent, 1, 4);
 textfield10.setText(serrordelaypercent); // affiche le pourcentage d'erreur
 storeavance();
 storedepression();
 
 }


 
 
 }
}

public void calculdegres(){
   usPerDegree = (NT / speedValue / PApplet.parseFloat(Ncyl));  // 30000000 car tour allumeur et tour moteur = tour allumeur * 2
   //delayDegree = ((delayValue+dwellandcodetime) / float(delaydegValue))+advanceStatic ; // calcule le nombre de degr\u00e9s d'avance finale 
   if (stateCent == false ){
   delayDegree = ((delayValue+dwellandcodetime) / usPerDegree)+advanceStatic ; // calcule le nombre de degr\u00e9s d'avance finale
   }
  else{
   delayDegree = ((delayValue+dwellandcodetime) / usPerDegree)+advanceStatic ; // calcule le nombre de degr\u00e9s d'avance finale
  } 
   correcteddelayDegree = topSignal - delayDegree;
   //println(correcteddelayDegree);
   //println(usPerDegree);
}

public void calculdegresavance(){
   
   
   delayAvanceDegree = delayDegree - pressionValue; // Soustrait du d\u00e9lai final le nombre de degr\u00e9s d'avance d\u00e9pression
   delaySpark = topSignal - delayAvanceDegree+advanceStatic;  // Calcule le d\u00e9lai qui s\u00e9pare l'\u00e9tincelle du PMH
   
}

public void calculerreurdelai(){
   
   correctederrordelay = errordelay+(delaydegValue*pressionValue);
   errordelaypercent = (abs(delayValue - correctederrordelay)/PApplet.parseFloat(delayValue))*100; // Calcule le pourcentage d'erreur
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
  //println(av);
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
     advanceStatic = 17.0f;
     nameCurve = "a4114a.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "Allumeur A4114A-SEV TC/TG"; 
     titleCurve2 = "    (M8N - N2 & N5)";
     dwellandcodetime2 = 0;
     stateCent = true;
     break;
   case 1: 
     advanceStatic = 32.0f; 
     nameCurve = "M8S.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "Allumeur SEV pour M8S";
     titleCurve2 = "    (     24CT     )";
     dwellandcodetime2 = 120;
     stateCent = false;
     break;
   case 2: 
     advanceStatic = 17.0f;
     nameCurve = "a132.txt";
     advanceCurve = loadStrings(nameCurve); 
     titleCurve = "    Allumeur A132-SEV"; 
     titleCurve2 = "    (M10S - N1 1965)";
     stateCent = true;
     break;
   case 3: 
     advanceStatic = 17.0f;
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
  text("d\u00b0",xcentOrigin-15,450);
  
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
  float timeDegree = NT / speedData /PApplet.parseFloat(Ncyl);
  float degreeData = (topSignal)-((timeDelay + dwellandcodetime2)/timeDegree)-advanceStatic;
  float lasttimeDegree = NT / lastspeedData /PApplet.parseFloat(Ncyl);
  float lastdegreeData = (topSignal)-((lasttimeDelay + dwellandcodetime2)/lasttimeDegree)-advanceStatic;
  //print(speedData);
  //print(":");
  //println(lastspeedData);
  // Point d'origine pour les courbe (480,680)
  
   int xs = xcentOrigin + (speedData/20);
   float yd = ycentOrigin - (degreeData*10);
   int ydInt = PApplet.parseInt(yd);
   
   int lastxs = xcentOrigin + (lastspeedData/20);
   float lastyd = ycentOrigin - (lastdegreeData*10);
   int lastydInt = PApplet.parseInt(lastyd);
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
  rect(930,390,410,300); // Cadre noir du graphique d'avance d\u00e9pression
  fill(255,255,204);
  rect(940,400,390,280); // Cadre beige du graphique d'avance d\u00e9pression
  fill(0);
  // Trace le cadrillage de l'avance d\u00e9pression
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
  text("Capteur de d\u00e9pression",990,430);
  
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
  text("d\u00b0",xdepOrigin-15,450); 
  
  // Trace les bornes de l'avance d\u00e9pression
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
  
  // Trace les bornes de l'avance d\u00e9pression
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


public void loadConfig(String file){  
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

public void saveConfig(String file){
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
  window1 = new GWindow(this, "Aide \u00e0 la s\u00e9lection", 0, 0, 1350, 690, false, JAVA2D);
  window1.setActionOnClose(G4P.CLOSE_WINDOW);
  window1.addDrawHandler(this, "win_draw2");
  togGroup1 = new GToggleGroup();
  option1 = new GOption(window1.papplet, 110, 90, 160, 20);
  option1.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option1.setText("Type mines");
  option1.setTextBold();
  option1.setOpaque(false);
  option1.addEventHandler(this, "option1_clicked1");
  option2 = new GOption(window1.papplet, 410, 90, 160, 20);
  option2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option2.setText("Type moteur");
  option2.setTextBold();
  option2.setOpaque(false);
  option2.addEventHandler(this, "option2_clicked1");
  option3 = new GOption(window1.papplet, 710, 90, 160, 20);
  option3.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option3.setText("Marque allumeur");
  option3.setTextBold();
  option3.setOpaque(false);
  option3.addEventHandler(this, "option3_clicked1");
  option4 = new GOption(window1.papplet, 1010, 90, 160, 20);
  option4.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  option4.setText("R\u00e9f\u00e9rence Allumeur");
  option4.setTextBold();
  option4.setOpaque(false);
  option4.addEventHandler(this, "option4_clicked1");
  togGroup1.addControl(option1);
  option1.setSelected(true);
  togGroup1.addControl(option2);
  togGroup1.addControl(option3);
  togGroup1.addControl(option4);
  dropList2 = new GDropList(window1.papplet, 110, 140, 160, 220, 10);
  dropList2.setItems(loadStrings("list_988723"), 0);
  dropList2.addEventHandler(this, "dropList2_click1");
  dropList3 = new GDropList(window1.papplet, 410, 140, 160, 140, 6);
  dropList3.setItems(loadStrings("list_846523"), 0);
  dropList3.addEventHandler(this, "dropList3_click1");
  dropList4 = new GDropList(window1.papplet, 710, 140, 160, 80, 3);
  dropList4.setItems(loadStrings("list_362785"), 0);
  dropList4.addEventHandler(this, "dropList4_click1");
  dropList5 = new GDropList(window1.papplet, 1010, 140, 170, 220, 10);
  dropList5.setItems(loadStrings("list_999683"), 0);
  dropList5.addEventHandler(this, "dropList5_click1");
}
 
public void recordwindow(){ 
   window2 = new GWindow(this, "Aide \u00e0 la s\u00e9lection pour param\u00e9trer sa courbe", 0, 0, 1350, 690, false, JAVA2D);
  window2.setActionOnClose(G4P.CLOSE_WINDOW);
  window2.addDrawHandler(this, "win_draw1");
  textfieldrpmmin = new GTextField(window2.papplet, 1020, 50, 110, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmin.setText(" ");
  textfieldrpmmin.setOpaque(true);
  textfieldrpmmin.addEventHandler(this, "textfieldrpmmin_change1");
  label43 = new GLabel(window2.papplet, 920, 50, 80, 20);
  label43.setText("RPM min");
  label43.setTextBold();
  label43.setOpaque(false);
  label44 = new GLabel(window2.papplet, 920, 80, 80, 20);
  label44.setText("RPM max");
  label44.setTextBold();
  label44.setOpaque(false);
  textfieldrpmmax = new GTextField(window2.papplet, 1020, 80, 110, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmax.setText(" ");
  textfieldrpmmax.setOpaque(true);
  textfieldrpmmax.addEventHandler(this, "textfieldrpmmax_change1");
  buttonrun = new GButton(window2.papplet, 50, 50, 90, 50);
  buttonrun.setText("D\u00e9part pr\u00e9d\u00e9finis");
  buttonrun.setTextBold();
  buttonrun.addEventHandler(this, "buttonrun_click1");
  togGroup2 = new GToggleGroup();
  textfieldrpmactual = new GTextField(window2.papplet, 740, 50, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmactual.setOpaque(true);
  textfieldrpmactual.addEventHandler(this, "textfieldrpmactual_change1");
  textfieldtimeactual = new GTextField(window2.papplet, 740, 80, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldtimeactual.setOpaque(true);
  textfieldtimeactual.addEventHandler(this, "textfieldtimeactual_change1");
  label45 = new GLabel(window2.papplet, 600, 50, 120, 20);
  label45.setText("RPM actuel");
  label45.setTextBold();
  label45.setOpaque(false);
  label46 = new GLabel(window2.papplet, 600, 80, 120, 20);
  label46.setText("Temps interne");
  label46.setTextBold();
  label46.setOpaque(false);
  label47 = new GLabel(window2.papplet, 600, 110, 120, 20);
  label47.setText("Temps \u00e9coul\u00e9");
  label47.setTextBold();
  label47.setOpaque(false);
  textfieldelapsedtime1 = new GTextField(window2.papplet, 740, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime1.setText("0");
  textfieldelapsedtime1.setOpaque(true);
  textfieldelapsedtime1.addEventHandler(this, "textfieldelapsedtime1_change1");
  buttonrunfree = new GButton(window2.papplet, 490, 50, 90, 50);
  buttonrunfree.setText("D\u00e9part libre");
  buttonrunfree.setTextBold();
  buttonrunfree.addEventHandler(this, "buttonrunfree_click1");
  label48 = new GLabel(window2.papplet, 160, 50, 80, 20);
  label48.setText("RPM min");
  label48.setTextBold();
  label48.setOpaque(false);
  label49 = new GLabel(window2.papplet, 160, 80, 80, 20);
  label49.setText("RPM max");
  label49.setTextBold();
  label49.setOpaque(false);
  textfieldrpmmin2 = new GTextField(window2.papplet, 260, 50, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmin2.setText("1000");
  textfieldrpmmin2.setOpaque(true);
  textfieldrpmmin2.addEventHandler(this, "textfieldrpmmin2_change1");
  textfieldrpmmax2 = new GTextField(window2.papplet, 260, 80, 160, 20, G4P.SCROLLBARS_NONE);
  textfieldrpmmax2.setText("4000");
  textfieldrpmmax2.setOpaque(true);
  textfieldrpmmax2.addEventHandler(this, "textfieldrpmmax2_change1");
  label50 = new GLabel(window2.papplet, 120, 110, 120, 20);
  label50.setText("Temps \u00e9coul\u00e9");
  label50.setTextBold();
  label50.setOpaque(false);
  textfieldelapsedtime3 = new GTextField(window2.papplet, 260, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime3.setOpaque(true);
  textfieldelapsedtime3.addEventHandler(this, "textfieldelapsedtime3_change1");
  textfieldelapsedtime4 = new GTextField(window2.papplet, 350, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime4.setOpaque(true);
  textfieldelapsedtime4.addEventHandler(this, "textfieldelapsedtime4_change1");
  label51 = new GLabel(window2.papplet, 300, 110, 40, 20);
  label51.setText("Sec");
  label51.setTextBold();
  label51.setOpaque(false);
  textfieldelapsedtime2 = new GTextField(window2.papplet, 830, 110, 30, 20, G4P.SCROLLBARS_NONE);
  textfieldelapsedtime2.setOpaque(true);
  textfieldelapsedtime2.addEventHandler(this, "textfieldelapsedtime2change1");
  label53 = new GLabel(window2.papplet, 780, 110, 40, 20);
  label53.setText("Sec");
  label53.setTextBold();
  label53.setOpaque(false);
  label52 = new GLabel(window2.papplet, 390, 110, 30, 20);
  label52.setText("ms");
  label52.setTextBold();
  label52.setOpaque(false);
  label54 = new GLabel(window2.papplet, 870, 110, 30, 20);
  label54.setText("ms");
  label54.setTextBold();
  label54.setOpaque(false);
  buttonsave = new GButton(window2.papplet, 1170, 50, 100, 20);
  buttonsave.setText("Sauvegarder");
  buttonsave.setTextBold();
  buttonsave.addEventHandler(this, "buttonsave_click1");
  buttonload = new GButton(window2.papplet, 1170, 80, 100, 20);
  buttonload.setText("Historique");
  buttonload.setTextBold();
  buttonload.addEventHandler(this, "buttonload_click1");
  label55 = new GLabel(window2.papplet, 920, 110, 100, 20);
  label55.setText("Date & heure");
  label55.setTextBold();
  label55.setOpaque(false);
  tfd = new GTextField(window2.papplet, 1030, 110, 20, 20, G4P.SCROLLBARS_NONE);
  tfd.setOpaque(true);
  tfd.addEventHandler(this, "tfd_change1");
  tfm = new GTextField(window2.papplet, 1060, 110, 20, 20, G4P.SCROLLBARS_NONE);
  tfm.setOpaque(true);
  tfm.addEventHandler(this, "tfm_change1");
  tfy = new GTextField(window2.papplet, 1090, 110, 40, 20, G4P.SCROLLBARS_NONE);
  tfy.setOpaque(true);
  tfy.addEventHandler(this, "tfy_change1");
  tfh = new GTextField(window2.papplet, 1160, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfh.setOpaque(true);
  tfh.addEventHandler(this, "tfh_change1");
  tfmin = new GTextField(window2.papplet, 1200, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfmin.setOpaque(true);
  tfmin.addEventHandler(this, "tfmin_change1");
  tfs = new GTextField(window2.papplet, 1240, 110, 30, 20, G4P.SCROLLBARS_NONE);
  tfs.setOpaque(true);
  tfs.addEventHandler(this, "tfs_change1");
  buttonpause = new GButton(window2.papplet, 1170, 20, 100, 20);
  buttonpause.setText("Pause");
  buttonpause.setTextBold();
  buttonpause.addEventHandler(this, "buttonpause_click1");
  buttonc1 = new GButton(window2.papplet, 1300, 180, 30, 30);
  buttonc1.setText("+");
  buttonc1.setTextBold();
  buttonc1.addEventHandler(this, "buttonc1_click1");
  buttonc2 = new GButton(window2.papplet, 1300, 220, 30, 30);
  buttonc2.setText("+");
  buttonc2.setTextBold();
  buttonc2.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  buttonc2.addEventHandler(this, "buttonc2_click1");
  buttonc3 = new GButton(window2.papplet, 1300, 260, 30, 30);
  buttonc3.setText("+");
  buttonc3.setTextBold();
  buttonc3.setLocalColorScheme(GCScheme.RED_SCHEME);
  buttonc3.addEventHandler(this, "buttonc3_click1");
  buttonc4 = new GButton(window2.papplet, 1300, 300, 30, 30);
  buttonc4.setText("+");
  buttonc4.setTextBold();
  buttonc4.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  buttonc4.addEventHandler(this, "buttonc4_click1");
  
}

public void saveorselectwindow(){ 
  window3 = new GWindow(this, "Sauvegarde et historique", 0, 0, 370, 150, false, JAVA2D);
  window3.setActionOnClose(G4P.CLOSE_WINDOW);
  window3.addDrawHandler(this, "win_draw3");
  label56 = new GLabel(window3.papplet, 10, 30, 140, 20);
  label56.setText("Nom de la courbe");
  label56.setTextBold();
  label56.setOpaque(false);
  tfsname = new GTextField(window3.papplet, 160, 30, 200, 20, G4P.SCROLLBARS_NONE);
  tfsname.setPromptText("Nom de votre courbe");
  tfsname.setOpaque(true);
  tfsname.addEventHandler(this, "tfsname_change1");
  label57 = new GLabel(window3.papplet, 10, 60, 140, 20);
  label57.setText("Date & heure");
  label57.setTextBold();
  label57.setOpaque(false);
  tfd2 = new GTextField(window3.papplet, 160, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfd2.setOpaque(true);
  tfd2.addEventHandler(this, "tfd2_change1");
  tfm2 = new GTextField(window3.papplet, 190, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfm2.setOpaque(true);
  tfm2.addEventHandler(this, "tfm2_change1");
  tfy2 = new GTextField(window3.papplet, 220, 60, 40, 20, G4P.SCROLLBARS_NONE);
  tfy2.setOpaque(true);
  tfy2.addEventHandler(this, "tfy2_change1");
  tfh2 = new GTextField(window3.papplet, 280, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfh2.setOpaque(true);
  tfh2.addEventHandler(this, "tfh2_change1");
  tfmin2 = new GTextField(window3.papplet, 310, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfmin2.setOpaque(true);
  tfmin2.addEventHandler(this, "tfmin2_change1");
  tfs2 = new GTextField(window3.papplet, 340, 60, 20, 20, G4P.SCROLLBARS_NONE);
  tfs2.setOpaque(true);
  tfs2.addEventHandler(this, "tfs2_change1");
  buttonok = new GButton(window3.papplet, 135, 101, 100, 30);
  buttonok.setText("Enregistrer");
  buttonok.setTextBold();
  buttonok.addEventHandler(this, "buttonok_click1");
  label58 = new GLabel(window3.papplet, 300, 60, 10, 20);
  label58.setText(":");
  label58.setTextBold();
  label58.setOpaque(false);
  label59 = new GLabel(window3.papplet, 330, 60, 10, 20);
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
  ellipse(890,200,270,270); // second cercle noir avance r\u00e9sultante
  ellipse(1200,200,270,270); // troisi\u00e8me cercle noir avance d\u00e9pression
  ellipse(850,520,150,150); // quatri\u00e8me cercle noir erreur d\u00e9lai
  rect(490,340,180,40); // premier cadre noir avance centrifuge
  rect(810,340,180,40); // second cadre noir avance r\u00e9sultante
  rect(1110,340,180,40); // troisi\u00e8me cadre noir avance d\u00e9pression
  rect(110,440,170,40); // quatri\u00e8me cadre noir T/min
  rect(40,490,300,180); // Cadre noir qui sert de tableau r\u00e9capitulatif en bas \u00e0 gauche
  
  fill(150);
  rect(800,610,100,60); // Cadre noir qui sert de bordure au bouton "aide \u00e0 la s\u00e9lection"
  
  fill(255);
  
  ellipse(210,220,340,340);
  
  fill(255,0,0);
  arc(210, 220, 339, 339, -PI/4.6f, 0);  // Zone rouge du compteur T/min
  arc(890, 200, 240, 240, -1.58f, -1.53f);  // Rep\u00e8re rouge qui marque les 33\u00b0 de l'avance centrifuge et statique soit 17 + 16
  
  textFont(f);
  fill(255,0,0);
  text("6",350,110); // Affichage des chiffres en rouge car r\u00e9gime moteur en zone rouge
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
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void knob1_speed(GKnob source, GEvent event) { //_CODE_:knob1:609340:
  //println("knob1 - GKnob >> GEvent." + event + " @ " + millis());
} //_CODE_:knob1:609340:

public void knob2_cent(GKnob source, GEvent event) { //_CODE_:knob2:210755:
  //println("knob2 - GKnob >> GEvent." + event + " @ " + millis());
} //_CODE_:knob2:210755:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:textfield1:769904:
 //println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield1:769904:

public void textfield2_change1(GTextField source, GEvent event) { //_CODE_:textfield2:742190:
  //println("textfield2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield2:742190:

public void textfield3_change1(GTextField source, GEvent event) { //_CODE_:textfield3:612866:
  //println("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield3:612866:

public void textfield4_change1(GTextField source, GEvent event) { //_CODE_:textfield4:676436:
  //println("textfield4 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield4:676436:

public void textfield5_change1(GTextField source, GEvent event) { //_CODE_:textfield5:654001:
  //println("textfield5 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield5:654001:

public void textfield6_change1(GTextField source, GEvent event) { //_CODE_:textfield6:279620:
  //println("textfield6 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield6:279620:

public void textfield7_change1(GTextField source, GEvent event) { //_CODE_:textfield7:470362:
  //println("textfield7 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield7:470362:

public void knob3_sum(GKnob source, GEvent event) { //_CODE_:knob3:735863:
  //println("knob3 - GKnob >> GEvent." + event + " @ " + millis());
} //_CODE_:knob3:735863:

public void knob4_dep(GKnob source, GEvent event) { //_CODE_:knob4:264983:
  //println("knob4 - GKnob >> GEvent." + event + " @ " + millis());
} //_CODE_:knob4:264983:

public void textfield8_change1(GTextField source, GEvent event) { //_CODE_:textfield8:826429:
  //println("textfield8 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield8:826429:

public void textfield9_change1(GTextField source, GEvent event) { //_CODE_:textfield9:428924:
  //println("textfield9 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield9:428924:

public void knob5_turn1(GKnob source, GEvent event) { //_CODE_:knob5:378561:
  //println("knob5 - GKnob >> GEvent." + event + " @ " + millis());
} //_CODE_:knob5:378561:

public void textfield10_change1(GTextField source, GEvent event) { //_CODE_:textfield10:454194:
  //println("textfield10 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfield10:454194:

public void dropList1_click1(GDropList source, GEvent event) { //_CODE_:dropList1:466696:
  //println("dropList1 - GDropList >> GEvent." + event + " @ " + millis());
} //_CODE_:dropList1:466696:

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:365526:
  //println("button1 - GButton >> GEvent." + event + " @ " + millis());
  openhelpwindow();
} //_CODE_:button1:365526:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:315655:
  //println("button2 - GButton >> GEvent." + event + " @ " + millis());
  recordwindow();
} //_CODE_:button2:315655:

synchronized public void win_draw2(GWinApplet appc, GWinData data) { //_CODE_:window1:646447:
  
 // Loading a font for displaying text for title
  ft2 = loadFont("Courier10PitchBT-Bold-32.vlw"); 
  
 // Loading a font for displaying text for title
  fe2 = loadFont("Courier-Bold-12.vlw"); 
 
 // Loading a font for displaying text for graph
  fg2 = loadFont("Courier-Bold-15.vlw"); 
 
  appc.background(255);
  appc.textFont(ft2);
  appc.fill(0,0,255);
  appc.text("Aide \u00e0 la s\u00e9lection pour choisir sa courbe",280,30); // Affichage du titre
  appc.textFont(fe2);
  appc.fill(255,0,0);
  appc.text("(*) A partir du 1er Mars 1965 sur 24 BT (M 8 S)",20,50);
  appc.text("(**) A partir du 5 Mars 1965 sur 24 CT (M 10 S)",600,50);
  appc.text("(***) Pour 24BT a compter de juillet 65, monter des bougies 34 ou 35 HS, ne pas monter 34 ou 35 HS sur cylindres ant\u00e9rieurs \u00e0 juillet 65,lamage du puit de bougies diff\u00e9rent",20,65);
  img2 = loadImage("CDPanhard.png");                // Using a String for a file name
  appc.image(img2,0,100);
  appc.fill(230,230,230,200);
  appc.rect(100,80,200,40); // premier cadre gris 
  appc.rect(400,80,200,40); // deuxi\u00e8me cadre gris
  appc.rect(700,80,200,40); // troisi\u00e8me cadre gris
  appc.rect(1000,80,200,40); // quatri\u00e8me cadre gris
  
  table = loadTable("tableauaideselection.csv", "header");

  int countRow = 0;
  //stringName = "Types mines";  
  //stringList = "Dyna Z";
  println(stringName + " " + stringList);
  
  
  for (TableRow row : table.matchRows(stringList,stringName)) {
       
    appc.textFont(fg2);
    appc.fill(0);
    appc.text((row.getString("Ann\u00e9es")),40,(200 + (countRow * 20))); 
    appc.text(("| " + row.getString("Types mines")),170,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Types moteurs")),500,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Avance \u00e0 l\u2019allumage")),600,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Marques allumeurs")),780,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("R\u00e9f\u00e9rences allumeurs")),1020,(200 + (countRow * 20)));
    
    countRow++;
  }
    //println(countRow);
    appc.fill(230,230,230,100);
    appc.rect(30,180,1280,(10 + (countRow * 20)));
    countRow = 0;
  
} //_CODE_:window1:646447:

public void option1_clicked1(GOption source, GEvent event) { //_CODE_:option1:253996:
  //println("option1 - GOption >> GEvent." + event + " @ " + millis());
  if (option1.isSelected() == true) {
    stateCheck1 = true;
    stringList = dropList2.getSelectedText();
    stringName = "Types mines";
  }  
  else {
    stateCheck1 = false;
  }
} //_CODE_:option1:253996:

public void option2_clicked1(GOption source, GEvent event) { //_CODE_:option2:763640:
  //println("option2 - GOption >> GEvent." + event + " @ " + millis());
  if (option2.isSelected() == true) {
    stateCheck2 = true;
    stringList = dropList3.getSelectedText(); 
    stringName = "Types moteurs";
  }  
  else {
    stateCheck2 = false;
  }
} //_CODE_:option2:763640:

public void option3_clicked1(GOption source, GEvent event) { //_CODE_:option3:786102:
  //println("option3 - GOption >> GEvent." + event + " @ " + millis());
  if (option3.isSelected() == true) {
    stateCheck3 = true;
    stringList = dropList4.getSelectedText();
    stringName = "Marques allumeurs";
  }  
  else {
    stateCheck3 = false;
  }
} //_CODE_:option3:786102:

public void option4_clicked1(GOption source, GEvent event) { //_CODE_:option4:580954:
  //println("option4 - GOption >> GEvent." + event + " @ " + millis());
  if (option4.isSelected() == true) {
    stateCheck4 = true;
    stringList = dropList5.getSelectedText();
    stringName = "R\u00e9f\u00e9rences allumeurs";
  }  
  else {
    stateCheck4 = false;
  }
} //_CODE_:option4:580954:

public void dropList2_click1(GDropList source, GEvent event) { //_CODE_:dropList2:988723:
  //println("dropList2 - GDropList >> GEvent." + event + " @ " + millis());
  //println(stateCheck1);
  if (stateCheck1 == true){
   stringList = dropList2.getSelectedText();
   stringName = "Types mines";
  }
  else {
   stringList = "";
   stringName = "";
  }
  //println(stringList2);
} //_CODE_:dropList2:988723:

public void dropList3_click1(GDropList source, GEvent event) { //_CODE_:dropList3:846523:
  //println("dropList3 - GDropList >> GEvent." + event + " @ " + millis());
  if (stateCheck2 == true){
   stringList = dropList3.getSelectedText(); 
   stringName = "Types moteurs";
  }
  else {
   stringList = "";
   stringName = ""; 
  }
} //_CODE_:dropList3:846523:

public void dropList4_click1(GDropList source, GEvent event) { //_CODE_:dropList4:362785:
  //println("dropList4 - GDropList >> GEvent." + event + " @ " + millis());
  if (stateCheck3 == true){
   stringList = dropList4.getSelectedText();
   stringName = "Marques allumeurs";
  }
  else {
   stringList = "";
   stringName = "";
  }
} //_CODE_:dropList4:362785:

public void dropList5_click1(GDropList source, GEvent event) { //_CODE_:dropList5:999683:
  //println("dropList5 - GDropList >> GEvent." + event + " @ " + millis());
  if (stateCheck4 == true){
   stringList = dropList5.getSelectedText();
   stringName = "R\u00e9f\u00e9rences allumeurs";
  }
  else {
   stringList = "";
   stringName = "";
  }
} //_CODE_:dropList5:999683:

synchronized public void win_draw1(GWinApplet appc, GWinData data) { //_CODE_:window2:324466:
 // Loading a font for displaying text for title
  ft3 = loadFont("Courier10PitchBT-Bold-32.vlw"); 
  
 // Loading a font for displaying text for title
  fe3 = loadFont("Courier-Bold-12.vlw"); 
 
 // Loading a font for displaying text for graph
  fg3 = loadFont("Courier-Bold-15.vlw"); 
 
  appc.background(255);
  appc.textFont(ft3);
  appc.fill(0,0,255);
  appc.text("Chronom\u00e8tre param\u00e9trable pour analyser sa courbe",200,30); // Affichage du titre
  appc.text("Vitesse moteur en tours par minute",340,170); // Affichage du titre graphique rpm
  appc.text("Avance centrifuge",510,355); // Affichage du titre graphique rpm
  appc.text("Avance d\u00e9pression",510,525); // Affichage du titre graphique rpm
  
  textfieldrpmactual.setText(str(speedValue));
  time = millis();
  day = day(); month = month(); year = year(); hour = hour(); minute = minute(); second = second();
  textfieldtimeactual.setText(str(time));
  tfd.setText(str(day)); tfm.setText(str(month)); tfy.setText(str(year));
  tfh.setText(str(hour)); tfmin.setText(str(minute)); tfs.setText(str(second));
  p.recordrpm();
  p.recordavance();
  p.recorddep();
  p.recordall();
  runrpmmin = PApplet.parseInt(textfieldrpmactual.getText());
  runrpmmax = runrpmmin;
  if (stateCheckbtnrun == false && runrpmmin > Irpmmin && Brpmmin == true){
   timestart = millis();
   println(timestart);
   Brpmmin = false;
  }
  if (stateCheckbtnrun == false && runrpmmax > Irpmmax && Brpmmax == true){
   timestop = millis();
   println(timestop);
   Brpmmax = false;
   buttonrun.setTextBold();
   buttonrun.setText("D\u00e9part pr\u00e9d\u00e9finis");
   stateCheckbtnrun = true; 
   elapsedtime = timestop - timestart;
   elapsedtimesec = elapsedtime/1000;
   elapsedtimemsec = elapsedtime - (elapsedtimesec * 1000 );
   textfieldelapsedtime3.setText(str(elapsedtimesec));
   textfieldelapsedtime4.setText(str(elapsedtimemsec));
   Irpmmin = 0;
   runrpmmin =0;
   Irpmmax = 0;
   runrpmmax = 0;
  }
    
  appc.fill(230,230,230,200);
  appc.rect(40,180,1250,150); // premier cadre gris 
  appc.rect(40,360,1250,140); // deuxi\u00e8me cadre gris
  appc.rect(40,530,1250,120); // troisi\u00e8me cadre gris
  yrpmPos = map(speedValue, 0, 7000, 0, 140); // map la valeur de RPM
  ycentPos = map(correcteddelayDegree, 0, 20, 0, 140); // map la valeuur d'avance centrifuge
  ydepPos = map(pressionValue, 0, 20, 0, 120); // map la valeur d'avance d\u00e9pression
  // trace les lignes rpm, cent et dep
 
  for (int i = 1; i<=xrpmPos; i++){
    int lastxr = i - 1;
    float lastyr = myrpmy [i - 1];
    int xr = i;
    float yr = myrpmy [i];    
    //print(xr);
    //print(":");
    //println(yr);
    appc.fill(255,0,0);
    appc.line(xrorpm+lastxr,yrorpm-lastyr,xrorpm+xr,yrorpm-yr);
  }
  
  // Trace le cadrillage des rpm
  for (int i = xrorpm; i < 1260; i = i+180) 
  {
  appc.line(i, 180, i, yrorpm);// ligne verticale
  }
  for (int i = yrorpm; i > 190; i = i-40) 
  {
  appc.line(xrorpm, i, 1290, i); // ligne horizontale
  }
  
  appc.textFont(fg3);
  appc.fill(0,0,0,200);
  appc.text(0,xrorpm-15,yrorpm);
  appc.text(2000,xrorpm-35,yrorpm-40);
  appc.text(4000,xrorpm-35,yrorpm-80);
  appc.fill(255,0,0,200);
  appc.text(6000,xrorpm-35,yrorpm-120);
  appc.text(7000,xrorpm-35,yrorpm-140);
  appc.fill(255,0,0,100);
  appc.rect(40,190,1250,20); // cadre rouge pour signifier la ligne rouge
  
  for (int i = 1; i<=xrpmPos; i++){
    int lastxc = i -1;
    float lastyc = mycenty [i - 1];
    int xc = i;
    float yc = mycenty [i];    
    //print(xr);
    //print(":");
    //println(yr);
    appc.fill(255,0,0);
    appc.line(xrocent+lastxc,yrocent-lastyc,xrocent+xc,yrocent-yc);
  }
  // Trace le cadrillage de l'avance centrifuge
  for (int i = xrocent; i < 1260; i = i+180) 
  {
  appc.line(i, 360, i, yrocent);// ligne verticale
  }
  for (int i = yrocent; i > 360; i = i-28) 
  {
  appc.line(xrocent, i, 1290, i); // ligne horizontale
  }
  
  appc.textFont(fg3);
  appc.fill(0,0,0,200);
  appc.text(0,xrocent-15,yrocent);
  appc.text(4,xrocent-15,yrocent-28);
  appc.text(8,xrocent-15,yrocent-56);
  appc.text(12,xrocent-25,yrocent-84);
  appc.text(16,xrocent-25,yrocent-112);
  
  for (int i = 1; i<=xrpmPos; i++){
    int lastxd = i - 1;
    float lastyd = mydepy [i - 1];
    int xd = i;
    float yd = mydepy [i];    
    //print(xr);
    //print(":");
    //println(yr);
    appc.fill(255,0,0);
    appc.line(xrodep+lastxd,yrodep-lastyd,xrodep+xd,yrodep-yd);
  }
  // Trace le cadrillage de l'avance centrifuge
  for (int i = xrodep; i < 1260; i = i+180) 
  {
  appc.line(i, 530, i, yrodep);// ligne verticale
  }
  for (int i = yrodep; i > 530; i = i-24) 
  {
  appc.line(xrodep, i, 1290, i); // ligne horizontale
  }
  
  appc.textFont(fg3);
  appc.fill(0,0,0,200);
  appc.text(0,xrodep-15,yrodep);
  appc.text(4,xrodep-15,yrodep-24);
  appc.text(8,xrodep-15,yrodep-48);
  appc.text(12,xrodep-25,yrodep-72);
  appc.text(16,xrodep-25,yrodep-96);
  if (stateC1 == true){
     for (int i = 2; i<=1240; i++){
      int lastxr = i - 1;
      float lastyr = map(records1 [i-1][0], 0, 7000, 0, 140);
      int xr = i;
      float yr = map(records1 [i][0], 0, 7000, 0, 140);  
      //println(records1 [i][0]);  
      appc.stroke(blC);
      appc.line(xrorpm+lastxr,yrorpm-lastyr,xrorpm+xr,yrorpm-yr);
      int lastxc = i -1;
      float lastyc = map(records1 [i-1][1], 0, 20, 0, 140);
      int xc = i;
      float yc = map(records1 [i][1], 0, 20, 0, 140);    
      appc.line(xrocent+lastxc,yrocent-lastyc,xrocent+xc,yrocent-yc);
      int lastxd = i - 1;
      float lastyd = map(records1 [i-1][2], 0, 20, 0, 120);
      int xd = i;
      float yd = map(records1 [i-1][2], 0, 20, 0, 120);   
      appc.line(xrodep+lastxd,yrodep-lastyd,xrodep+xd,yrodep-yd);
      appc.stroke(0,0,0);
    }
  }
   
  if (stateC2 == true){
     for (int i = 2; i<=1240; i++){
      int lastxr = i - 1;
      float lastyr = map(records2 [i-1][0], 0, 7000, 0, 140);
      int xr = i;
      float yr = map(records2 [i][0], 0, 7000, 0, 140);  
      //println(records2 [i][0]);  
      appc.stroke(veC);
      appc.line(xrorpm+lastxr,yrorpm-lastyr,xrorpm+xr,yrorpm-yr);
      int lastxc = i -1;
      float lastyc = map(records2 [i-1][1], 0, 20, 0, 140);
      int xc = i;
      float yc = map(records2 [i][1], 0, 20, 0, 140);    
      appc.line(xrocent+lastxc,yrocent-lastyc,xrocent+xc,yrocent-yc);
      int lastxd = i - 1;
      float lastyd = map(records2 [i-1][2], 0, 20, 0, 120);
      int xd = i;
      float yd = map(records2 [i-1][2], 0, 20, 0, 120);   
      appc.line(xrodep+lastxd,yrodep-lastyd,xrodep+xd,yrodep-yd);
      appc.stroke(0,0,0);
    }
  }
  if (stateC3 == true){
  for (int i = 2; i<=1240; i++){
      int lastxr = i - 1;
      float lastyr = map(records3 [i-1][0], 0, 7000, 0, 140);
      int xr = i;
      float yr = map(records3 [i][0], 0, 7000, 0, 140);  
      //println(records3 [i][0]);  
      appc.stroke(reC);
      appc.line(xrorpm+lastxr,yrorpm-lastyr,xrorpm+xr,yrorpm-yr);
      int lastxc = i -1;
      float lastyc = map(records3 [i-1][1], 0, 20, 0, 140);
      int xc = i;
      float yc = map(records3 [i][1], 0, 20, 0, 140);    
      appc.line(xrocent+lastxc,yrocent-lastyc,xrocent+xc,yrocent-yc);
      int lastxd = i - 1;
      float lastyd = map(records3 [i-1][2], 0, 20, 0, 120);
      int xd = i;
      float yd = map(records3 [i-1][2], 0, 20, 0, 120);   
      appc.line(xrodep+lastxd,yrodep-lastyd,xrodep+xd,yrodep-yd);
      appc.stroke(0,0,0);
    }
  }
  if (stateC4 == true){
  for (int i = 2; i<=1240; i++){
      int lastxr = i - 1;
      float lastyr = map(records4 [i-1][0], 0, 7000, 0, 140);
      int xr = i;
      float yr = map(records4 [i][0], 0, 7000, 0, 140);  
      //println(records4 [i][0]);  
      appc.stroke(oraC);
      appc.line(xrorpm+lastxr,yrorpm-lastyr,xrorpm+xr,yrorpm-yr);
      int lastxc = i -1;
      float lastyc = map(records4 [i-1][1], 0, 20, 0, 140);
      int xc = i;
      float yc = map(records4 [i][1], 0, 20, 0, 140);    
      appc.line(xrocent+lastxc,yrocent-lastyc,xrocent+xc,yrocent-yc);
      int lastxd = i - 1;
      float lastyd = map(records4 [i-1][2], 0, 20, 0, 120);
      int xd = i;
      float yd = map(records4 [i-1][2], 0, 20, 0, 120);   
      appc.line(xrodep+lastxd,yrodep-lastyd,xrodep+xd,yrodep-yd);
      appc.stroke(0,0,0);
    }
  }
    
  // \u00e0 la fin de l'\u00e9cran revient au d\u00e9but
  if (xrpmPos >= 1240) {
  xrpmPos = 0; // pour retour de la trace sans ligne
  }
  else {
    if (stateCheckbtnpause == true){
  // incr\u00e9mente la position horizontale (abscisse)
  xrpmPos++;
  //println(xrpmPos);
  }
  else {
    
  }
  } 
} //_CODE_:window2:324466:

public void textfieldrpmmin_change1(GTextField source, GEvent event) { //_CODE_:textfieldrpmmin:253392:
  //println("textfieldrpmmin - GTextField >> GEvent." + event + " @ " + millis());
  stringrpmmin = textfieldrpmmin.getText();
  //println(stringrpmmin);
} //_CODE_:textfieldrpmmin:253392:

public void textfieldrpmmax_change1(GTextField source, GEvent event) { //_CODE_:textfieldrpmmax:463860:
  //println("textfieldrpmmax - GTextField >> GEvent." + event + " @ " + millis());
  stringrpmmax = textfieldrpmmax.getText();
  //println(stringrpmmax);
} //_CODE_:textfieldrpmmax:463860:

public void buttonrun_click1(GButton source, GEvent event) { //_CODE_:buttonrun:731974:
  //println("buttonrun - GButton >> GEvent." + event + " @ " + millis());
  aef.runclicked();
  
} //_CODE_:buttonrun:731974:

public void textfieldrpmactual_change1(GTextField source, GEvent event) { //_CODE_:textfieldrpmactual:210004:
  //println("textfield11 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldrpmactual:210004:

public void textfieldtimeactual_change1(GTextField source, GEvent event) { //_CODE_:textfieldtimeactual:592115:
  //println("textfield12 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldtimeactual:592115:

public void textfieldelapsedtime1_change1(GTextField source, GEvent event) { //_CODE_:textfieldelapsedtime1:517410:
  //println("textfieldelapsedtime - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldelapsedtime1:517410:

public void buttonrunfree_click1(GButton source, GEvent event) { //_CODE_:buttonrunfree:460528:
  //println("buttonrunfree - GButton >> GEvent." + event + " @ " + millis());
  aef.runfreeclicked();
} //_CODE_:buttonrunfree:460528:

public void textfieldrpmmin2_change1(GTextField source, GEvent event) { //_CODE_:textfieldrpmmin2:790169:
  //println("textfieldrpmmin2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldrpmmin2:790169:

public void textfieldrpmmax2_change1(GTextField source, GEvent event) { //_CODE_:textfieldrpmmax2:253948:
  //println("textfieldrpmmax2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldrpmmax2:253948:

public void textfieldelapsedtime3_change1(GTextField source, GEvent event) { //_CODE_:textfieldelapsedtime3:724986:
  //println("textfieldelapsedtime2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldelapsedtime3:724986:

public void textfieldelapsedtime4_change1(GTextField source, GEvent event) { //_CODE_:textfieldelapsedtime4:628798:
  //println("textfieldelapsedtime4 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldelapsedtime4:628798:

public void textfieldelapsedtime2change1(GTextField source, GEvent event) { //_CODE_:textfieldelapsedtime2:366658:
  //println("textfieldelapsedtime2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:textfieldelapsedtime2:366658:

public void buttonsave_click1(GButton source, GEvent event) { //_CODE_:buttonsave:432069:
  //println("buttonsave - GButton >> GEvent." + event + " @ " + millis());
  saveorselectwindow();
  stateCheckbtnsave = false;
  
} //_CODE_:buttonsave:432069:

public void buttonload_click1(GButton source, GEvent event) { //_CODE_:buttonload:645158:
  //println("buttonload - GButton >> GEvent." + event + " @ " + millis());
  window2.close();
  handleFileDialog();
  //aef.loadMesure0();
  recordwindow();
        
} //_CODE_:buttonload:645158:

public void tfd_change1(GTextField source, GEvent event) { //_CODE_:tfd:480943:
  //println("tfd - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfd:480943:

public void tfm_change1(GTextField source, GEvent event) { //_CODE_:tfm:602215:
  //println("tfm - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfm:602215:

public void tfy_change1(GTextField source, GEvent event) { //_CODE_:tfy:417555:
  //println("tfy - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfy:417555:

public void tfh_change1(GTextField source, GEvent event) { //_CODE_:tfh:415514:
  //println("tfh - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfh:415514:

public void tfmin_change1(GTextField source, GEvent event) { //_CODE_:tfmin:558027:
  //println("tfmin - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfmin:558027:

public void tfs_change1(GTextField source, GEvent event) { //_CODE_:tfs:828872:
  //println("tfs - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfs:828872:

public void buttonpause_click1(GButton source, GEvent event) { //_CODE_:buttonpause:542517:
  //println("buttonpause - GButton >> GEvent." + event + " @ " + millis());
  p.pauseclicked();
} //_CODE_:buttonpause:542517:

public void buttonc1_click1(GButton source, GEvent event) { //_CODE_:buttonc1:210509:
  //println("buttonc1 - GButton >> GEvent." + event + " @ " + millis());
  stateC1 = true;
  window2.close();
  handleFileDialog();
  aef.loadMesure1();
  recordwindow();
  //stateC1 = false;
  
} //_CODE_:buttonc1:210509:

public void buttonc2_click1(GButton source, GEvent event) { //_CODE_:buttonc2:465686:
  //println("buttonc2 - GButton >> GEvent." + event + " @ " + millis());
  stateC2 = true;
  window2.close();
  handleFileDialog();
  aef.loadMesure2();
  recordwindow();
  //stateC1 = false;
} //_CODE_:buttonc2:465686:

public void buttonc3_click1(GButton source, GEvent event) { //_CODE_:buttonc3:798770:
  //println("buttonc4 - GButton >> GEvent." + event + " @ " + millis());
  stateC3 = true;
  window2.close();
  handleFileDialog();
  aef.loadMesure3();
  recordwindow();
} //_CODE_:buttonc3:798770:

public void buttonc4_click1(GButton source, GEvent event) { //_CODE_:buttonc4:745563:
  //println("buttonc5 - GButton >> GEvent." + event + " @ " + millis());
  stateC4 = true;
  window2.close();
  handleFileDialog();
  aef.loadMesure4();
  recordwindow();
} //_CODE_:buttonc4:745563:

synchronized public void win_draw3(GWinApplet appc, GWinData data) { //_CODE_:window3:726417:
  appc.background(230);
  tfd2.setText(str(day)); tfm2.setText(str(month)); tfy2.setText(str(year));
  tfh2.setText(str(hour)); tfmin2.setText(str(minute)); tfs2.setText(str(second));
} //_CODE_:window3:726417:

public void tfsname_change1(GTextField source, GEvent event) { //_CODE_:tfsname:813732:
  //println("tfsname - GTextField >> GEvent." + event + " @ " + millis());
  sName = tfsname.getText();
  //println(sName); 
} //_CODE_:tfsname:813732:

public void tfd2_change1(GTextField source, GEvent event) { //_CODE_:tfd2:807301:
  //println("tfd2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfd2:807301:

public void tfm2_change1(GTextField source, GEvent event) { //_CODE_:tfm2:704577:
  //println("tfm2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfm2:704577:

public void tfy2_change1(GTextField source, GEvent event) { //_CODE_:tfy2:310580:
  //println("tfy2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfy2:310580:

public void tfh2_change1(GTextField source, GEvent event) { //_CODE_:tfh2:904975:
  //println("tfh2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfh2:904975:

public void tfmin2_change1(GTextField source, GEvent event) { //_CODE_:tfmin2:407305:
  //println("tfmin2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfmin2:407305:

public void tfs2_change1(GTextField source, GEvent event) { //_CODE_:tfs2:938811:
  //println("tfs2 - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:tfs2:938811:

public void buttonok_click1(GButton source, GEvent event) { //_CODE_:buttonok:574023:
  //println("buttonok - GButton >> GEvent." + event + " @ " + millis());
  if (stateCheckbtnsave == false){
  p.saveall();
  stateCheckbtnsave = true;
  }
  
} //_CODE_:buttonok:574023:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("aecp");
  knob1 = new GKnob(this, 20, 60, 380, 320, 0.8f);
  knob1.setTurnRange(90, 0);
  knob1.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob1.setSensitivity(1);
  knob1.setShowArcOnly(false);
  knob1.setOverArcOnly(false);
  knob1.setIncludeOverBezel(false);
  knob1.setShowTrack(true);
  knob1.setLimits(0.0f, 0.0f, 7000.0f);
  knob1.setNbrTicks(8);
  knob1.setShowTicks(true);
  knob1.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob1.setOpaque(false);
  knob1.addEventHandler(this, "knob1_speed");
  label2 = new GLabel(this, 160, 380, 100, 50);
  label2.setText("X1000 T/min");
  label2.setTextBold();
  label2.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label2.setOpaque(false);
  knob2 = new GKnob(this, 470, 90, 220, 220, 0.8f);
  knob2.setTurnRange(180, 0);
  knob2.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob2.setSensitivity(1);
  knob2.setShowArcOnly(true);
  knob2.setOverArcOnly(false);
  knob2.setIncludeOverBezel(false);
  knob2.setShowTrack(true);
  knob2.setLimits(0.0f, 0.0f, 20.0f);
  knob2.setNbrTicks(21);
  knob2.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob2.setOpaque(false);
  knob2.addEventHandler(this, "knob2_cent");
  label3 = new GLabel(this, 530, 210, 100, 40);
  label3.setText("Centrifuge");
  label3.setTextBold();
  label3.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label3.setOpaque(false);
  label4 = new GLabel(this, 78, 354, 30, 30);
  label4.setText("1");
  label4.setTextBold();
  label4.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  label4.setOpaque(false);
  label5 = new GLabel(this, 12, 240, 30, 30);
  label5.setText("2");
  label5.setTextBold();
  label5.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  label5.setOpaque(false);
  label6 = new GLabel(this, 27, 119, 30, 30);
  label6.setText("3");
  label6.setTextBold();
  label6.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  label6.setOpaque(false);
  label7 = new GLabel(this, 108, 36, 30, 30);
  label7.setText("4");
  label7.setTextBold();
  label7.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  label7.setOpaque(false);
  label8 = new GLabel(this, 234, 24, 30, 30);
  label8.setText("5");
  label8.setTextBold();
  label8.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  label8.setOpaque(false);
  label11 = new GLabel(this, 444, 184, 30, 30);
  label11.setText("0");
  label11.setTextBold();
  label11.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label11.setOpaque(false);
  label12 = new GLabel(this, 564, 64, 30, 30);
  label12.setText("10");
  label12.setTextBold();
  label12.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label12.setOpaque(false);
  label13 = new GLabel(this, 684, 184, 30, 30);
  label13.setText("20");
  label13.setTextBold();
  label13.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label13.setOpaque(false);
  label14 = new GLabel(this, 1307, 164, 30, 30);
  label14.setText("16");
  label14.setTextBold();
  label14.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label14.setOpaque(false);
  label9 = new GLabel(this, 510, 260, 144, 20);
  label9.setText("en degr\u00e9 d'avance");
  label9.setTextBold();
  label9.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label9.setOpaque(false);
  textfield1 = new GTextField(this, 140, 450, 60, 20, G4P.SCROLLBARS_NONE);
  textfield1.setText("0000");
  textfield1.setOpaque(false);
  textfield1.addEventHandler(this, "textfield1_change1");
  textfield2 = new GTextField(this, 1140, 350, 60, 20, G4P.SCROLLBARS_NONE);
  textfield2.setText("00");
  textfield2.setOpaque(false);
  textfield2.addEventHandler(this, "textfield2_change1");
  label10 = new GLabel(this, 200, 450, 80, 20);
  label10.setText("T/min");
  label10.setTextBold();
  label10.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label10.setOpaque(false);
  label15 = new GLabel(this, 580, 350, 80, 20);
  label15.setText("Degr\u00e9s");
  label15.setTextBold();
  label15.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label15.setOpaque(false);
  textfield3 = new GTextField(this, 250, 510, 60, 20, G4P.SCROLLBARS_NONE);
  textfield3.setText("0000000");
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  label16 = new GLabel(this, 40, 510, 200, 20);
  label16.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label16.setText("D\u00e9lai en ms :");
  label16.setTextBold();
  label16.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label16.setOpaque(false);
  label17 = new GLabel(this, 40, 540, 200, 20);
  label17.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label17.setText("Degr\u00e9s centrifuges :");
  label17.setTextBold();
  label17.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label17.setOpaque(false);
  textfield4 = new GTextField(this, 250, 540, 60, 20, G4P.SCROLLBARS_NONE);
  textfield4.setText("00");
  textfield4.setOpaque(true);
  textfield4.addEventHandler(this, "textfield4_change1");
  label18 = new GLabel(this, 40, 570, 200, 20);
  label18.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label18.setText("Degr\u00e9s d\u00e9pression :");
  label18.setTextBold();
  label18.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label18.setOpaque(false);
  label19 = new GLabel(this, 40, 600, 200, 20);
  label19.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label19.setText("Avance statique :");
  label19.setTextBold();
  label19.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label19.setOpaque(false);
  textfield5 = new GTextField(this, 250, 570, 60, 20, G4P.SCROLLBARS_NONE);
  textfield5.setText("00");
  textfield5.setOpaque(true);
  textfield5.addEventHandler(this, "textfield5_change1");
  textfield6 = new GTextField(this, 250, 600, 60, 20, G4P.SCROLLBARS_NONE);
  textfield6.setText("00.00");
  textfield6.setLocalColorScheme(GCScheme.RED_SCHEME);
  textfield6.setOpaque(true);
  textfield6.addEventHandler(this, "textfield6_change1");
  label20 = new GLabel(this, 40, 630, 200, 20);
  label20.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label20.setText("Degr\u00e9s avant \u00e9tincelle :");
  label20.setTextBold();
  label20.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label20.setOpaque(false);
  textfield7 = new GTextField(this, 250, 630, 60, 20, G4P.SCROLLBARS_NONE);
  textfield7.setText("00");
  textfield7.setOpaque(true);
  textfield7.addEventHandler(this, "textfield7_change1");
  knob3 = new GKnob(this, 780, 90, 220, 220, 0.8f);
  knob3.setTurnRange(180, 0);
  knob3.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob3.setSensitivity(1);
  knob3.setShowArcOnly(true);
  knob3.setOverArcOnly(false);
  knob3.setIncludeOverBezel(false);
  knob3.setShowTrack(true);
  knob3.setLimits(16.0f, 16.0f, 50.0f);
  knob3.setNbrTicks(18);
  knob3.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob3.setOpaque(false);
  knob3.addEventHandler(this, "knob3_sum");
  knob4 = new GKnob(this, 1090, 90, 220, 220, 0.8f);
  knob4.setTurnRange(180, 0);
  knob4.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob4.setSensitivity(1);
  knob4.setShowArcOnly(true);
  knob4.setOverArcOnly(false);
  knob4.setIncludeOverBezel(false);
  knob4.setShowTrack(true);
  knob4.setLimits(0.0f, 0.0f, 17.0f);
  knob4.setNbrTicks(18);
  knob4.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob4.setOpaque(false);
  knob4.addEventHandler(this, "knob4_dep");
  label21 = new GLabel(this, 1150, 210, 100, 35);
  label21.setText("D\u00e9pression");
  label21.setTextBold();
  label21.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label21.setOpaque(false);
  label22 = new GLabel(this, 1130, 260, 140, 20);
  label22.setText("en degr\u00e9 d'avance");
  label22.setTextBold();
  label22.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label22.setOpaque(false);
  label23 = new GLabel(this, 840, 210, 96, 40);
  label23.setText("Degr\u00e9s");
  label23.setTextBold();
  label23.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label23.setOpaque(false);
  label24 = new GLabel(this, 900, 350, 80, 20);
  label24.setText("Degr\u00e9s");
  label24.setTextBold();
  label24.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label24.setOpaque(false);
  label25 = new GLabel(this, 1200, 350, 80, 20);
  label25.setText("Degr\u00e9s");
  label25.setTextBold();
  label25.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label25.setOpaque(false);
  textfield8 = new GTextField(this, 520, 350, 60, 20, G4P.SCROLLBARS_NONE);
  textfield8.setText("00");
  textfield8.setOpaque(false);
  textfield8.addEventHandler(this, "textfield8_change1");
  textfield9 = new GTextField(this, 840, 350, 60, 20, G4P.SCROLLBARS_NONE);
  textfield9.setText("00");
  textfield9.setOpaque(false);
  textfield9.addEventHandler(this, "textfield9_change1");
  label26 = new GLabel(this, 850, 260, 80, 20);
  label26.setText("r\u00e9sultants");
  label26.setTextBold();
  label26.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label26.setOpaque(false);
  label1 = new GLabel(this, 750, 190, 30, 30);
  label1.setText("16");
  label1.setTextBold();
  label1.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label1.setOpaque(false);
  label27 = new GLabel(this, 762, 142, 30, 30);
  label27.setText("20");
  label27.setTextBold();
  label27.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label27.setOpaque(false);
  label28 = new GLabel(this, 996, 160, 30, 30);
  label28.setText("48");
  label28.setTextBold();
  label28.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label28.setOpaque(false);
  label29 = new GLabel(this, 1060, 190, 30, 30);
  label29.setText("0");
  label29.setTextBold();
  label29.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label29.setOpaque(false);
  label30 = new GLabel(this, 1113, 89, 30, 30);
  label30.setText("5");
  label30.setTextBold();
  label30.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label30.setOpaque(false);
  label31 = new GLabel(this, 1242, 77, 30, 30);
  label31.setText("11");
  label31.setTextBold();
  label31.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label31.setOpaque(false);
  label32 = new GLabel(this, 786, 100, 30, 30);
  label32.setText("24");
  label32.setTextBold();
  label32.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label32.setOpaque(false);
  label33 = new GLabel(this, 822, 76, 30, 30);
  label33.setText("28");
  label33.setTextBold();
  label33.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label33.setOpaque(false);
  label34 = new GLabel(this, 858, 64, 30, 30);
  label34.setText("32");
  label34.setTextBold();
  label34.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label34.setOpaque(false);
  label35 = new GLabel(this, 912, 70, 30, 30);
  label35.setText("36");
  label35.setTextBold();
  label35.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label35.setOpaque(false);
  label36 = new GLabel(this, 954, 88, 30, 30);
  label36.setText("38");
  label36.setTextBold();
  label36.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label36.setOpaque(false);
  label37 = new GLabel(this, 978, 118, 30, 30);
  label37.setText("42");
  label37.setTextBold();
  label37.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label37.setOpaque(false);
  knob5 = new GKnob(this, 790, 460, 120, 120, 0.8f);
  knob5.setTurnRange(180, 0);
  knob5.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob5.setSensitivity(1);
  knob5.setShowArcOnly(true);
  knob5.setOverArcOnly(false);
  knob5.setIncludeOverBezel(false);
  knob5.setShowTrack(true);
  knob5.setLimits(0.0f, 0.0f, 1.0f);
  knob5.setNbrTicks(11);
  knob5.setShowTicks(true);
  knob5.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob5.setOpaque(false);
  knob5.addEventHandler(this, "knob5_turn1");
  label38 = new GLabel(this, 798, 570, 100, 20);
  label38.setText("En %");
  label38.setTextBold();
  label38.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label38.setOpaque(false);
  textfield10 = new GTextField(this, 822, 546, 60, 20, G4P.SCROLLBARS_NONE);
  textfield10.setOpaque(true);
  textfield10.addEventHandler(this, "textfield10_change1");
  label39 = new GLabel(this, 798, 522, 100, 20);
  label39.setText("Erreur d\u00e9lai");
  label39.setTextBold();
  label39.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label39.setOpaque(false);
  label40 = new GLabel(this, 768, 504, 30, 30);
  label40.setText("0");
  label40.setTextBold();
  label40.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label40.setOpaque(false);
  label41 = new GLabel(this, 900, 504, 30, 30);
  label41.setText("1");
  label41.setTextBold();
  label41.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label41.setOpaque(false);
  label42 = new GLabel(this, 834, 438, 30, 30);
  label42.setText("0.5");
  label42.setTextBold();
  label42.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label42.setOpaque(false);
  dropList1 = new GDropList(this, 360, 360, 100, 180, 5);
  dropList1.setItems(loadStrings("list_466696"), 0);
  dropList1.setLocalColorScheme(GCScheme.RED_SCHEME);
  dropList1.addEventHandler(this, "dropList1_click1");
  button1 = new GButton(this, 810, 620, 80, 40);
  button1.setText("Aide \u00e0 la s\u00e9lection");
  button1.setTextBold();
  button1.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  button2 = new GButton(this, 791, 396, 120, 30);
  button2.setText("Enregistrement");
  button2.setTextBold();
  button2.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  button2.addEventHandler(this, "button2_click1");
  label60 = new GLabel(this, 664, 115, 30, 30);
  label60.setText("16");
  label60.setTextBold();
  label60.setLocalColorScheme(GCScheme.RED_SCHEME);
  label60.setOpaque(false);
  
}

// Variable declarations 
// autogenerated do not edit
GKnob knob1; 
GLabel label2; 
GKnob knob2; 
GLabel label3; 
GLabel label4; 
GLabel label5; 
GLabel label6; 
GLabel label7; 
GLabel label8; 
GLabel label11; 
GLabel label12; 
GLabel label13; 
GLabel label14; 
GLabel label9; 
GTextField textfield1; 
GTextField textfield2; 
GLabel label10; 
GLabel label15; 
GTextField textfield3; 
GLabel label16; 
GLabel label17; 
GTextField textfield4; 
GLabel label18; 
GLabel label19; 
GTextField textfield5; 
GTextField textfield6; 
GLabel label20; 
GTextField textfield7; 
GKnob knob3; 
GKnob knob4; 
GLabel label21; 
GLabel label22; 
GLabel label23; 
GLabel label24; 
GLabel label25; 
GTextField textfield8; 
GTextField textfield9; 
GLabel label26; 
GLabel label1; 
GLabel label27; 
GLabel label28; 
GLabel label29; 
GLabel label30; 
GLabel label31; 
GLabel label32; 
GLabel label33; 
GLabel label34; 
GLabel label35; 
GLabel label36; 
GLabel label37; 
GKnob knob5; 
GLabel label38; 
GTextField textfield10; 
GLabel label39; 
GLabel label40; 
GLabel label41; 
GLabel label42; 
GDropList dropList1; 
GButton button1; 
GButton button2; 
GLabel label60; 
GWindow window1;
GToggleGroup togGroup1; 
GOption option1; 
GOption option2; 
GOption option3; 
GOption option4; 
GDropList dropList2; 
GDropList dropList3; 
GDropList dropList4; 
GDropList dropList5; 
GWindow window2;
GTextField textfieldrpmmin; 
GLabel label43; 
GLabel label44; 
GTextField textfieldrpmmax; 
GButton buttonrun; 
GToggleGroup togGroup2; 
GTextField textfieldrpmactual; 
GTextField textfieldtimeactual; 
GLabel label45; 
GLabel label46; 
GLabel label47; 
GTextField textfieldelapsedtime1; 
GButton buttonrunfree; 
GLabel label48; 
GLabel label49; 
GTextField textfieldrpmmin2; 
GTextField textfieldrpmmax2; 
GLabel label50; 
GTextField textfieldelapsedtime3; 
GTextField textfieldelapsedtime4; 
GLabel label51; 
GTextField textfieldelapsedtime2; 
GLabel label53; 
GLabel label52; 
GLabel label54; 
GButton buttonsave; 
GButton buttonload; 
GLabel label55; 
GTextField tfd; 
GTextField tfm; 
GTextField tfy; 
GTextField tfh; 
GTextField tfmin; 
GTextField tfs; 
GButton buttonpause; 
GButton buttonc1; 
GButton buttonc2; 
GButton buttonc3; 
GButton buttonc4; 
GWindow window3;
GLabel label56; 
GTextField tfsname; 
GLabel label57; 
GTextField tfd2; 
GTextField tfm2; 
GTextField tfy2; 
GTextField tfh2; 
GTextField tfmin2; 
GTextField tfs2; 
GButton buttonok; 
GLabel label58; 
GLabel label59; 

class Aef {    //Data to plot
  
  final int rpm = 0;  //offsets in records ... for now !
  final int cent = 1;
  final int dep = 2;
  
  final int rnum = 3; // this means 3 fields
  
  FloatList rpmlist;
  FloatList centlist;
  FloatList record;
  int recordsCount;
  
//  Plot p;


public int setPath(String f){
  if (f == null) return 0;
  config.set("AEFpath",f);
  saveConfig(cFN);
  frame.setTitle(config.get("AEFpath"));  
  return 1;
}
  
    public void loadMesure1(){
//  println("loadFile");
// populate records
  int i, j;
  float v;
  String items[];
  String lines[] = loadStrings(config.get("AEFpath"));  //Get all the lines of the file
//  println(config.get("TDFpath"));
  items = new String[rnum];  // three items per line: rpm, cent, dep
  records1 = new float[lines.length][rnum];
  //println("lines:",lines.length);
  for (i = 1; i < lines.length; i++){  // for each line in lines
    lines[i] = trim(lines[i]);  // removes spurs like crlf !
    items = split(lines[i]," ");
//    println(items.length);
//    println(lines[i]);
    if (items.length == rnum){  // only if line has 3 fields as expected
       for (j = 0; j < rnum; j++){
//        println(i,j);
        records1 [i][j] = PApplet.parseFloat(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  }
  
    public void loadMesure2(){
//  println("loadFile");
// populate records
  int i, j;
  float v;
  String items[];
  String lines[] = loadStrings(config.get("AEFpath"));  //Get all the lines of the file
//  println(config.get("TDFpath"));
  items = new String[rnum];  // three items per line: rpm, cent, dep
  records2 = new float[lines.length][rnum];
  //println("lines:",lines.length);
  for (i = 1; i < lines.length; i++){  // for each line in lines
    lines[i] = trim(lines[i]);  // removes spurs like crlf !
    items = split(lines[i]," ");
//    println(items.length);
//    println(lines[i]);
    if (items.length == rnum){  // only if line has 3 fields as expected
       for (j = 0; j < rnum; j++){
//        println(i,j);
        records2 [i][j] = PApplet.parseFloat(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  }
 
     public void loadMesure3(){
//  println("loadFile");
// populate records
  int i, j;
  float v;
  String items[];
  String lines[] = loadStrings(config.get("AEFpath"));  //Get all the lines of the file
//  println(config.get("TDFpath"));
  items = new String[rnum];  // three items per line: rpm, cent, dep
  records3 = new float[lines.length][rnum];
  //println("lines:",lines.length);
  for (i = 1; i < lines.length; i++){  // for each line in lines
    lines[i] = trim(lines[i]);  // removes spurs like crlf !
    items = split(lines[i]," ");
//    println(items.length);
//    println(lines[i]);
    if (items.length == rnum){  // only if line has 3 fields as expected
       for (j = 0; j < rnum; j++){
//        println(i,j);
        records3 [i][j] = PApplet.parseFloat(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  } 
  
       public void loadMesure4(){
//  println("loadFile");
// populate records
  int i, j;
  float v;
  String items[];
  String lines[] = loadStrings(config.get("AEFpath"));  //Get all the lines of the file
//  println(config.get("TDFpath"));
  items = new String[rnum];  // three items per line: rpm, cent, dep
  records4 = new float[lines.length][rnum];
  //println("lines:",lines.length);
  for (i = 1; i < lines.length; i++){  // for each line in lines
    lines[i] = trim(lines[i]);  // removes spurs like crlf !
    items = split(lines[i]," ");
//    println(items.length);
//    println(lines[i]);
    if (items.length == rnum){  // only if line has 3 fields as expected
       for (j = 0; j < rnum; j++){
//        println(i,j);
        records4 [i][j] = PApplet.parseFloat(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  } 
  

public void runclicked(){
   Irpmmin = PApplet.parseInt(textfieldrpmmin2.getText());
   Irpmmax = PApplet.parseInt(textfieldrpmmax2.getText());
   //print(Irpmmin);
   //print(",");
   //println(Irpmmax);
   Brpmmin = true;
   Brpmmax = true;
   if (stateCheckbtnrun == true){
   buttonrun.setTextBold();
   buttonrun.setText("Auto");
   stateCheckbtnrun = false; 
   }
   }
  
public void runfreeclicked(){
  if (stateCheckbtnrunfree == true){
   timestart = millis();
   buttonrunfree.setTextBold();
   buttonrunfree.setText("Stop");
   stateCheckbtnrunfree = false; 
   //println(stateCheckbtnrun);
   textfieldrpmmin.setText(str(speedValue));
   }
    else{
   timestop = millis();
   buttonrunfree.setTextBold();
   buttonrunfree.setText("D\u00e9part libre");
   elapsedtime = timestop - timestart;
   elapsedtimesec = elapsedtime/1000;
   elapsedtimemsec = elapsedtime - (elapsedtimesec * 1000 );
   textfieldelapsedtime1.setText(str(elapsedtimesec));
   textfieldelapsedtime2.setText(str(elapsedtimemsec));
   textfieldrpmmax.setText(str(speedValue)); 
   stateCheckbtnrunfree = true; 
   //println(stateCheckbtnrun);
  }
}
  
  
}  //Aef class end


class Plot {    //Presentation
  float t;  // top
  float l;  // left
  float w;  // width
  float h;  // height
  int grX;  // number of grid X. vertical
  int grY;  // number of grid Y, horizontal
  int grC; // grid color
  int bckC;  // BackGround color
  int loadC; // Loadline color
  int pC; // powerline color
  float fsX;  // Full scale value for X axis
  float fsY;  // Full scale value for Y axis
  float scX;  // scale X
  float scY;  // scale Y
  float pwr;  // Power 
  
  
  
  public void init(){
// Values are hard coded for now. Should be settable latter . . .
    grC = color(255,255,255);
    bckC= color(192,192,192);
    loadC = color(135,50,150);
    pC = color(255,128,128);
    t = 0;  // No longer needed because pg is already positioned, but ...
    l = 0;
    w = 800;
    h = 600;
    fsX = 600;  // Means 600V full scale.
    fsY = 0.2f;  // Means 200 mA full scale.
    scX = fsX/w;  
    scY = fsY/h;
    grX = 8;
    grY = 8;
    pwr = 5;
  }  
  
/*
Accepts values from a slider i.e. 0 to 1
*/
  public void setfsX(float k){
    k = 1-k;  // reverse scale
    if(k == 0) return;  //
    fsX = 1000 * k;    // 1KV full scale
    config.set("fsX",str(fsX));
    scX = fsX/w;
    
  }
  
  public void setfsY(float k){
    if(k == 0) return;  //
    fsY = k*k;    // 1A full scale, exponential (log) feeling
    config.set("fsY",str(fsY));
    scY = fsY/h;
    
  }
  
 
 public void recordrpm(){
  int s = xrpmPos;
  float rpm = yrpmPos;
  //print(s);print(",");
  //print(rpm);print(",");
  myrpmy [s] = rpm;
  //print(myrpmy [s]);print(","); 
  //sExportdata = (speedValue + " "); 
}


public void recordavance(){
  int s = xrpmPos;
  float av = ycentPos;
  //print(s);print(",");
  //print(av);print(",");
  mycenty [s] = av;
  //print(mycenty [s]);print(","); 
  //sExportdata += (correcteddelayDegree + " ");
}

public void recorddep(){
  int s = xrpmPos;
  float dep = ydepPos;
  //print(s);print(",");
  //println(dep);
  mydepy [s] = dep;
  //println(mydepy [s]); 
  //sExportdata += (pressionValue +"\r"); 
}

public void recordall(){
  sExportdata = ( sName + " " + day + " " + month + " " + year + " " + hour + " " + minute + " " + second);
  sData[0] = sExportdata;
  sExportdata = (speedValue + " " + correcteddelayDegree + " " + pressionValue +"\r"); // Attention version windows, enlever le "\r" car g\u00e9n\u00e8re un CLRF
  sData[xrpmPos] = sExportdata;
  //println(sExportdata);
  //println(xrpmPos);
  //saveStrings(sName + ".aef", sData);
}

public void saveall(){
  saveStrings((config.get("aefmespath") + sName + ".aef"), sData);
  for (int q = xrpmPos; q<1241; q++){
    sData[q] = (" "); // initialise le tableau pour \u00e9liminer les "scories" !!!
  }
  window3.close();
}

public void loadall(){
  println("uploadra la courbe");
  
  window3.close();
}

public void pauseclicked(){
  if (stateCheckbtnpause == true){
   buttonpause.setTextBold();
   buttonpause.setText("Red\u00e9marrer");
   stateCheckbtnpause = false; 
   //println(stateCheckbtnpause);
   
   }
    else{
   buttonpause.setTextBold();
   buttonpause.setText("Pause");
   stateCheckbtnpause = true; 
   //println(stateCheckbtnpause);
  }
  
}
    
  public float valToPixX(float val){  //Convert value to pixel according to scX
    return (val/scX+l);  
  }
    
  public float valToPixY(float val){ //Convert value to pixel according to scY
    return (t+h-val/scY);
  }
    
  public float pixXToVal(float pix){ //Convert pixel to value according to scX
    return ((pix-l)*scX);
  }
    
  public float pixYToVal(float pix){ //Convert pixel to value according to scY
    return (fsY-(pix-t)*scY);  //Substract from fsY to move origin at bottom.
  }
    
  
} //Plot class end

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "aecp_Duino_Nano" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
