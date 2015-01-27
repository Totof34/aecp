// Need G4P library
import g4p_controls.*;
// On importe la librairie qui permet de communiquer en série
import processing.serial.*;

Serial myPort; // On créé une instance de la classe Serial
short LF = 10; // "Fin de ligne"

char HEADERSPEED = 'V'; // C'est le caractère que l'on a inséré avant la valeur de vitesse

int speedValue; // Une variable pour stocker la valeur de vitesse
int pressionValue; // Une variable pour stocker la valeur de pression
String spressionValue;
int delayValue; // Une variable pour stocker la valeur du délai
int delaydegValue; // Une variable pour stocker la valeur du délai d'un degré
int errordelay; // Une variable pour stocker la valeur d'erreur du délai
int correctederrordelay; // Corrigé pour anihiler l'action de la dépression dans le calcul de l'erreur
float errordelaypercent;
int usPerDegree;
float delayDegree;
float correcteddelayDegree;
String scorrecteddelayDegree;
float delayAvanceDegree;
String sdelayAvanceDegree;
float delaySpark;
String sdelaySpark;


PImage img;
PFont ft;
PFont fg;
PFont fe;
PFont f;
String[] advanceCurve = new String[176];
String[] depressionCurve = new String[16];
int[][] mydepressionx = new int[12][1];
int[][] mydepressiony = new int[12][1]; 

int myspeedRaw;
int[] myspeed = new int[176];
int mydepressionRaw;
int[] mydepression = new int[16];

public void setup(){
  size(1580, 748, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  smooth();
  // A vous de trouver quel port série est utilisé à l'aide de print(Serial.list())
 String portName = Serial.list()[0];
 print(Serial.list());
 // On initialise la communication série, à la même vitesse qu'Arduino
 myPort = new Serial(this, portName, 115200);
 
 
 
 // Make a new instance of the file dataCurve for loading some data

 
 advanceCurve = loadStrings("advanceCurve.txt");
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
  
}

// Un message est reçu depuis l'Arduino
void serialEvent(Serial p) {
 String message = myPort.readStringUntil(LF); // On lit le message reçu, jusqu'au saut de ligne
 if (message == null){
   
 }
 
 if (message != null)
 {
 print("Message" + message);
 // On découpe le message à chaque virgule, on le stocke dans un tableau
 String [] data = message.split(",");

//Message reçu pour la vitesse
 if (data[0].charAt(0) == HEADERSPEED)
 {
 // On convertit la valeur (String -> Int)
 int speedRaw = Integer.parseInt(data[1]);
 speedValue = speedRaw*2;
 myspeedRaw = speedRaw; 
 knob1.setValue(speedValue);
 // On convertit la valeur (String -> Int)
 int pressionRaw = Integer.parseInt(data[2]);
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
 
 calculdegres();
 calculdegresavance();
 calculerreurdelai();
 //storeavance();
 knob2.setValue(180 - delayDegree);
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
  
   usPerDegree = (60000000 / speedValue / 360);  // 60000000 car tour allumeur
   delayDegree = ((delayValue+3100) / float(delaydegValue))+15.6 ; // calcule le nombre de degrés d'avance finale
   correcteddelayDegree = 180 - delayDegree;
   //println(correcteddelayDegree);
}

public void calculdegresavance(){
   
   
   delayAvanceDegree = delayDegree - pressionValue; // Soustrait du délai final le nombre de degrés d'avance dépression
   delaySpark = 180 - delayAvanceDegree+15.6;  // Calcule le délai qui sépare l'étincelle du PMH
   
}

public void calculerreurdelai(){
   
   correctederrordelay = errordelay+(delaydegValue*pressionValue);
   errordelaypercent = (abs(delayValue - correctederrordelay)/float(delayValue))*100; // Calcule le pourcentage d'erreur
   //println(errordelaypercent);
}


public void storeavance(){
  int s = myspeedRaw/20;
  int av = int(correcteddelayDegree * 1000);
  //print(s);print(",");
  //println(av);
  myspeed [s] = av;
  //println(myspeed [s]); 
   
}

public void drawmycentrifugalcurve(){
  for (int q = 1; q<175; q++){
    int xav = q;
    int lastxav = q-1;
    int xavc = 480 + (q*2);
    int lastxavc = 480 + ((q-1)/20);
    int yav = (myspeed [q]/10);
    int lastyav = (myspeed [q-1]/10);
    int yavc = 680 - (yav/5);
    int lastyavc = 680 - (lastyav);
    //println(myspeed [q]);
    fill(0);
    line(xavc,yavc,xavc+1,yavc-1);
    line(xavc-1,yavc-1,xavc,yavc);
    //print(xavc);print(",");
    //println(yavc);
    //line(480,680,750,525);
  }
}

public void storedepression(){
  int s = mydepressionRaw;
  int dep = s;
  //print(s);print(",");
  //println(av);
  mydepression [s] = dep;
  //print(mydepression [s]);println(","); 
   
}

public void drawmydepressioncurve(){
  for (int g = 1; g<16; g++){
    int xdep = g;
    int lastxdep = g-1;
    int xdepc = 1258 + (g*9);
    int lastxdepc = 1258 + ((g-1)*9);
    int ydep = mydepression [g];
    int lastydep = mydepression [g-1];
    int ydepc = 680 - (ydep*10);
    int lastydepc = 680 - (lastydep*10);
    //println(myspeed [q]);
    fill(0);
    line(lastxdepc,lastydepc,xdepc,ydepc);
    //line(xavc-1,yavc-1,xavc,yavc);
    //print(xavc);print(",");
    //println(yavc);
    //line(480,680,750,525);
  }
}


public void drawcentrifugalcurve(){
  fill(0,0,0);
  rect(450,420,410,300); // Cadre noir du graphique d'avance centrifuge
  fill(255,255,204);
  rect(460,430,390,280);  // Cadre beige du graphique d'avance centrifuge
  fill(0);
  // Trace le cadrillage de l'avance centrifuge
  for (int i = 480; i < 831; i = i+50) 
  {
  line(i, 480, i, 680); // ligne verticale
  
  }
  for (int i = 680; i > 479; i = i-40) 
  {
  line(480, i, 831, i); // ligne horizontale
  }
  
  textFont(f);
  text("Allumeur A4114A pour M8N",500,460);
  
  textFont(fg);
  text(0,480-5,700);
  text(500,480+30,700);
  text(1000,480+80,700);
  text(1500,480+130,700);
  text(2000,480+180,700);
  text(2500,480+230,700);
  text(3000,480+280,700);
  
  text(2,480-15,645);
  text(4,480-15,605);
  text(6,480-15,565);
  text(8,480-15,525);
  
  textFont(fe);
  text("T/min",480+330,700);
  text("d°",480-15,480);
  
  // Trace les bornes de l'avance centrifuge
  for (int i = 1; i<175; i++){
  String ligne = advanceCurve[i];
  String[] cells = split(advanceCurve[i], ",");

  int speedData = Integer.parseInt(cells[0]);
  int timeDelay = Integer.parseInt(cells[1]);
  int timeDegree = Integer.parseInt(cells[2]);
  float degreeData = (180-15.6)-(timeDelay +3100)/float(timeDegree);
  //print(speedData);
  //print(":");
  //println(degreeData);
  // Point d'origine pour les courbe (480,680)
   int xs = 480 + (speedData/10);
   
   float yd = 680 - (degreeData*20);
   int ydInt = int(yd);
   
   fill(0,255,0);
   //line(xs,ydInt,xs+1,ydInt-1); // courbe cible d'origine
   
   line((xs*0.98),(ydInt*0.98),(xs*0.98)+1,(ydInt*0.98)-1);
   
   if (ydInt<668){
   line((xs*1.02),(ydInt*1.02),(xs*1.02)+1,(ydInt*1.02)-1);
   }
   //print(xs);
   //print(":");
   //println(ydInt);
  }
  
  
}

public void drawdepressioncurve(){
  
  fill(0,0,0);
  rect(1150,420,410,300); // Cadre noir du graphique d'avance dépression
  fill(255,255,204);
  rect(1160,430,390,280); // Cadre beige du graphique d'avance dépression
  fill(0);
  // Trace le cadrillage de l'avance dépression
  for (int i = 1180; i < 1531; i = i+50) 
  {
  line(i, 480, i, 680);// ligne verticale
  }
  for (int i = 680; i > 454; i = i-50) 
  {
  line(1180, i, 1530, i); // ligne horizontale
  }
  
  textFont(f);
  fill(0,0,0);
  text("Capteur de dépression",1215,460);
  
  textFont(fg);
  text(0,1180-5,700);
  text(50,1180+40,700);
  text(100,1180+85,700);
  text(150,1180+135,700);
  text(200,1180+185,700);
  text(250,1180+235,700);
  text(300,1180+285,700);
  
  text(5,1180-15,635);
  text(10,1180-20,585);
  text(15,1180-20,535);
 
  textFont(fe);
  text("mmHg",1180+330,700);
  text("d°",1180-15,480); 
  
  // Trace les bornes de l'avance dépression
  for (int i = 0; i<12; i++){
  String ligne = depressionCurve[i];
  String[] cells = split(depressionCurve[i], ",");
  int depressionx = Integer.parseInt(cells[0]);
  int depressiony = Integer.parseInt(cells[1]);
    
  mydepressionx[i][0] = 1180 + depressionx;
  mydepressiony[i][0] = 680 - depressiony;
  
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
    line(lastxd*0.98,lastyd*0.98,xd*0.98,yd*0.98);
    line(lastxd*1.02,lastyd*1.02,xd*1.02,yd*1.02);
    
    
  }
  
}
 
 
public void draw(){
  background(255);
  // Draw the image to the screen at coordinate (0,0)
  image(img,140,130);
  
  textFont(ft);
  fill(0,51,0);
  text("Allumage Electronique Cartographique pour Panhard",450,40); // Affichage du titre
  
  ellipseMode(CENTER);
  fill(20);
  ellipse(250,220,410,410);
  ellipse(650,220,270,270); // Premier cercle noir avance centrifuge
  ellipse(1000,220,270,270); // second cercle noir avance résultante
  ellipse(1350,220,270,270); // troisième cercle noir avance dépression
  ellipse(1005,570,270,270); // quatrième cercle noir erreur délai
  rect(560,360,180,40); // premier cadre noir avance centrifuge
  rect(910,360,180,40); // second cadre noir avance résultante
  rect(1260,360,180,40); // troisième cadre noir avance dépression
  rect(165,440,170,40); // quatrième cadre noir T/min
  rect(90,510,300,180); // Cadre noir qui sert de tableau récapitulatif en bas à gauche
  
  fill(255);
  
  ellipse(250,220,340,340);
  
  textFont(f);
  fill(255,0,0);
  text("6",390,110); // Affichage des chiffres en rouge car régime moteur en zone rouge
  text("7",430,220);
  arc(250, 220, 339, 339, -PI/4.6, 0);  // upper half of circle for speed counter
  
  drawcentrifugalcurve();
  drawdepressioncurve();
  drawmycentrifugalcurve();
  drawmydepressioncurve();
    
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
