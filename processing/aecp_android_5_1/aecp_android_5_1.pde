/*Interface pour allumage électronique cartographique pour Panhard
 créez sous Processing 3.3 pour smartphone Haier L56 sous Android 5.1
 Finalisée le 21/08/2017 
 Adaptation du code issu du commentaire ci-dessous */
/* ConnectBluetooth: Written by ScottC on 18 March 2013 using 
 Processing version 2.0b8
 Tested on a Samsung Galaxy SII, with Android version 2.3.4
 Android ADK - API 10 SDK platform */

// Import needed Android libs
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.widget.Toast;
import android.view.Gravity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;

import java.util.UUID;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.GpsStatus.Listener;
import android.os.Bundle;


import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import controlP5.*;

import android.app.Activity;
import android.view.WindowManager;
import android.view.View;
import android.os.*;

Activity act;
View decorView;
int uiOptions;

public BluetoothSocket scSocket;

ControlP5 cp5;

// Set up the variables for the LocationManager and LocationListener
LocationManager locationManager;
MyLocationListener locationListener;


// Variables to hold the current GPS data
float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
float currentSpeed = 0;
float currentDistance = 0;
float travelDistance = 0;
String currentProvider = "";

int measureAverageCount = 10;
float advAbsoluteAverageRatio = 0.1;
float advPeakmesure = 0;

long advCurrentSum = 0; 
int measureLoopCount = 0;
float advCurrentAverage = 0;


int myColorBackground = color(150, 150, 150);
int knobValue = 100;
int radiusknobA = 180;
int radiusknobB = 120;
int radiusknobC = 120;
int radiusknobD = 150;
int marginEdge = 50;
int marginBottom = 100;

Knob myKnobRPM;
Knob myKnobDEP;
Knob myKnobCENT;
Knob myKnobTOT;

Textlabel myTextlabelTitle;
Textlabel myTextlabelRPM;
Textlabel myTextlabelRPMunit;
Textlabel myTextlabelDEP;
Textlabel myTextlabelDEPunit;
Textlabel myTextlabelCENT;
Textlabel myTextlabelCENTunit;
Textlabel myTextlabelTOT;
Textlabel myTextlabelTOTunit;
Textlabel myTextlabel1rpm;
Textlabel myTextlabel2rpm;
Textlabel myTextlabel3rpm;
Textlabel myTextlabel4rpm;
Textlabel myTextlabel5rpm;
Textlabel myTextlabel6rpm;
Textlabel myTextlabel7rpm;
Textlabel myTextlabelSPEED;
Textlabel myTextlabelSPEEDunit;
Textlabel myTextlabelDIST;
Textlabel myTextlabelDISTunit;

Button myButtonRAZ;
Button myBtGraph;

PGraphics panel1;
Canvas cc;
ControlP5 c1;

PGraphics panel2;
Canvas cc2;
ControlP5 c2;

boolean foundDevice=false; //When true, the screen turns green.
boolean BTisConnected=false; //When true, the screen turns purple.
boolean showcent=false;
boolean showdep=false;
boolean showtot=false;

PFont myFont ;
PFont myFont2 ;
PFont myFont3 ;

char HEADERSPEED = 'S'; // C'est le caractère que l'on a inséré avant la valeur de vitesse

int speedValue; // Une variable pour stocker la valeur de vitesse
float pressionValue; // Une variable qui stocke le nombre de degré de dépression
float delayValue; // Une variable pour stocker la valeur du délai
float avtotValue; // Une variable pour stocker la valeur du délai d'un degré
int adcValue; // Une variable pour stocker la valeur de la mesure du capteur de dépression
int mmhgValue; // Conversion de la valeur numérique en mm de mercure
int staticValue = 0; // Une variable pour stocker la valeur de l'avance statique en degré
float coefSpeed = (20 / 1.5 ); // Un coefficient multiplicateur pour afficher les résulats
int coefCent = 15; // Un coefficient multiplicateur pour afficher les résulats 
float coefDep = 7.5; // Un coefficient multiplicateur pour afficher les résulats
int coefCentTot = 10; // Un coefficient multiplicateur pour afficher les résulats 
float coefDepTot = 10; // Un coefficient multiplicateur pour afficher les résulats
int coefTot = 10; // Un coefficient multiplicateur pour afficher les résulats
float coefTotaff = 1.3; // Un coefficient multiplicateur pour afficher les résulats sur le graphique
int rangeSpeed = 525; // Une variable pour le dimensionement et la position de l'affichage, ici vitesse maxi/coefSpeed = (7000/20)*1.5
int rangeCent = 300; // Une variable pour le dimensionement et la position de l'affichage, ici avance centrifuge maxi*coefCent = (20*10)*1.5
int rangeDep = 300; // Une variable pour le dimensionement et la position de l'affichage, ici avance dépression maxi*coefDep = (20*10)*1.5
int rangeMmhg = 450; // Une variable pour le dimensionement et la position de l'affichage, ici mm de mercure maxi = 300*1.5
int rangeTot = 845; // Une variable pour le dimensionement et la position de l'affichage, ici avance dépression maxi*coefTot = 65*10
int rangeTime = 650; //Une variable pour le dimensionement et la position de l'affichage, ici temps passé par rapport à la largeur d'écran

float[] myspeed = new float[700]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0
float[] mymmhg = new float[1000]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0
float[][] myadvancetot = new float[1000][4]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0
int countertot = 0; // Compteur pour stoquer les avances pour en faire un graphique

color blaC = color(0, 0, 0); // noir
color whiC = color(255, 255, 255); // blanc
color oraC = color(250, 210, 10); // orange
color blC = color(10, 10, 255); // bleu
color puC = color(140, 80, 220); // mauve
color reC = color(255, 10, 10);// rouge
color grC = color(10, 255, 10); // vert
color yeC = color(252, 252, 41); // jaune
color goC = color(175, 152, 18); // or
color textblack = color(0); // écrit du texte en noir
color textwhite = color(255); // écrit du texte en blanc

// Message types used by the Handler
public static final int MESSAGE_WRITE = 1;
public static final int MESSAGE_READ = 2;
String readMessage="";
String[] sData = new String[10];

boolean hasSpeed;
float speed;

// Pour tracer les lignes des graphiques sur les écrans secondaires
int lastxr = 0;
float lastyr = 0;
int xr = 0;
float yr = 0; 
int lastxrdep = 0;
float lastyrdep = 0;
int xrdep = 0;
float yrdep = 0;  

// Pour tracer les graphiques sur les écrans secondaires
int xcentOrigin = 0;
int xdepOrigin = 0;
int ycentOrigin = 0;
int ydepOrigin = 0;
int xtotOrigin = 0;
int ytotOrigin = 0;

//Used to send bytes to the Arduino
SendReceiveBytes sendReceiveBT = null;

//Get the default Bluetooth adapter
BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();

/*The startActivityForResult() within setup() launches an 
 Activity which is used to request the user to turn Bluetooth on. 
 The following onActivityResult() method is called when this 
 Activity exits. */
@Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
  if (requestCode==0) {
    if (resultCode == getActivity().RESULT_OK) {
      ToastMaster("Le Bluetooth doit être activé");
    } else {
      ToastMaster("Vous devez activez le Bluetooth !!!");
    }
  }
}

/* Create a BroadcastReceiver that will later be used to 
 receive the names of Bluetooth devices in range. */
BroadcastReceiver myDiscoverer = new myOwnBroadcastReceiver();

/* Create a BroadcastReceiver that will later be used to
 identify if the Bluetooth device is connected */
BroadcastReceiver checkIsConnected = new myOwnBroadcastReceiver();


// The Handler that gets information back from the Socket
private final Handler mHandler = new Handler() {
  @Override
    public void handleMessage(Message msg) {
    switch (msg.what) {
    case MESSAGE_WRITE:
      //Do something when writing
      break;
    case MESSAGE_READ:
      //Get the bytes from the msg.obj
      byte[] readBuf = (byte[]) msg.obj;
      // construct a string from the valid bytes in the buffer
      String readMessage = new String(readBuf, 0, msg.arg1);
      //print(readMessage);
      // On découpe le message à chaque virgule, on le stocke dans un tableau
      String [] data = readMessage.split(",");

      //Message reçu pour la vitesse
      if (data[0].charAt(0) == HEADERSPEED)
      {
        // On convertit la valeur (String -> Int)
        int speedRaw = Integer.parseInt(data[1]);
        speedValue = speedRaw;
        myKnobRPM.setValue(speedRaw);
        //myTextlabelRPM.setText(str(speedValue));
        //print(speedValue);

        // On convertit la valeur (String -> Int)
        float pressionRaw = Float.parseFloat(data[2]);
        pressionValue = pressionRaw ;
        myKnobDEP.setValue(pressionRaw);
        //print(pressionRaw);

        // On convertit la valeur (String -> Int)
        //int delayRaw = Integer.parseInt(data[3]);
        float delayRaw = Float.parseFloat(data[3]);
        delayValue = delayRaw ;
        myKnobCENT.setValue(delayRaw);
        //print(delayRaw);

        // On convertit la valeur (String -> Int)
        float avanceRaw = Float.parseFloat(data[4]);
        avtotValue = avanceRaw ;
        myKnobTOT.setValue(avanceRaw);
        //print(avanceRaw);

        // On convertit la valeur (String -> Int)
        int adcRaw = Integer.parseInt(data[5]);
        adcValue = adcRaw;
        mmhgValue = int((707 - adcValue)/1.78); 
        //print(mmhgValue);
        //print(adcValue);

        staticValue = int(avtotValue - pressionValue - delayValue);
        
        advCurrentSum += avtotValue;
        if (++measureLoopCount >= measureAverageCount)
        {
          advCurrentAverage += ((advCurrentSum / measureLoopCount) - advCurrentAverage) * advAbsoluteAverageRatio;
          measureLoopCount = 0;
          advCurrentSum = 0;
        }
        if (advPeakmesure < avtotValue )
        {
          advPeakmesure = avtotValue;
        }
        
      }
      break;
    }
  }
};

@ Override
  public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  act = this.getActivity();
  uiOptions = View.SYSTEM_UI_FLAG_VISIBLE;
  decorView = act.getWindow().getDecorView();
  act.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
  decorView.setSystemUiVisibility(uiOptions);
}

void setup() {
  orientation(PORTRAIT);
  //fullScreen();
  size(displayWidth, displayHeight );
  noStroke();
  fill(0);
  
  // Font for displaying text 
  myFont = createFont("arial", 34);
  textFont(myFont);
  myFont2 = createFont("arial", 38);
  textFont(myFont2);
  myFont3 = createFont("arial", 26);
  textFont(myFont3);


  /*IF Bluetooth is NOT enabled, then ask user permission to enable it */
  if (!bluetooth.isEnabled()) {
    Intent requestBluetooth = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    startActivityForResult(requestBluetooth, 0);
  }

  /*If Bluetooth is now enabled, then register a broadcastReceiver to report any
   discovered Bluetooth devices, and then start discovering */
  if (bluetooth.isEnabled()) {
    this.getActivity().registerReceiver(myDiscoverer, new IntentFilter(BluetoothDevice.ACTION_FOUND));
    this.getActivity().registerReceiver(checkIsConnected, new IntentFilter(BluetoothDevice.ACTION_ACL_CONNECTED));

    //Start bluetooth discovery if it is not doing so already
    if (!bluetooth.isDiscovering()) {
      bluetooth.startDiscovery();
    }
  }
  cp5 = new ControlP5(this);

  myKnobRPM = cp5.addKnob("T/min")
    .setRange(0, 7000)
    .setValue(0)
    .setLabelVisible(false)
    .setPosition(((width/2)-radiusknobA), 90)
    .setRadius(radiusknobA)
    .setNumberOfTickMarks(7)
    .setTickMarkLength(10)
    .setTickMarkWeight(5.0)
    .setColorForeground(color(255))
    .setColorActive(color(255, 0, 0))
    .snapToTickMarks(false)
    ;

  myKnobDEP = cp5.addKnob("AV Dep")
    .setStartAngle(3.14)
    .setAngleRange(3.14)
    .setShowAngleRange(true)
    .setRange(0, 40)
    .setValue(0)
    .setLabelVisible(false)
    .setPosition(marginEdge, (height/2-(radiusknobB)))
    .setRadius(radiusknobB)
    .setNumberOfTickMarks(9)
    .setTickMarkLength(10)
    .setTickMarkWeight(3.0)
    .snapToTickMarks(false)
    .setColorForeground(color(255))
    .setColorBackground(color(0, 160, 100))
    .setColorActive(color(255, 255, 0))
    ;

  myKnobCENT = cp5.addKnob("AV Cent")
    .setStartAngle(3.14)
    .setAngleRange(3.14)
    .setShowAngleRange(true)
    .setRange(0, 20)
    .setValue(0)
    .setLabelVisible(false)
    .setPosition((width-(2*radiusknobC)-marginEdge), (height/2-(radiusknobC)))
    .setRadius(radiusknobC)
    .setNumberOfTickMarks(9)
    .setTickMarkLength(10)
    .setTickMarkWeight(3.0)
    .snapToTickMarks(false)
    .setColorForeground(color(255))
    .setColorBackground(color(10, 220, 20))
    .setColorActive(color(255, 255, 0))
    ;

  myKnobTOT = cp5.addKnob("AV Total")
    .setRange(15, 65)
    .setValue(0)
    .setLabelVisible(false)
    .setPosition(((width/2)-radiusknobD), (height - 3 * radiusknobD) )
    .setRadius(radiusknobD)
    .setNumberOfTickMarks(24)
    .setTickMarkLength(10)
    .setTickMarkWeight(3.0)
    .snapToTickMarks(false)
    .setColorForeground(color(255))
    .setColorBackground(color(0, 80, 100))
    .setColorActive(color(255, 255, 0))
    ;

  myTextlabelTitle = cp5.addTextlabel("aecp pour smartphone")
    .setText("aecp pour smartphone")
    .setPosition(((width /2)-170), 5)
    .setColorValue(textwhite)
    .setFont(myFont)
    ;   

  myTextlabel1rpm     = cp5.addTextlabel("1rpm")
    .setText("1")
    .setPosition(((width/2)-radiusknobA - 50), (radiusknobA + 100))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;

  myTextlabel2rpm     = cp5.addTextlabel("2rpm")
    .setText("2")
    .setPosition(((width/2)- radiusknobA - 30), (radiusknobA - 50))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;

  myTextlabel3rpm     = cp5.addTextlabel("3rpm")
    .setText("3")
    .setPosition(((width/2)- radiusknobA + 90), (radiusknobA - 130))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;  

  myTextlabel4rpm     = cp5.addTextlabel("4rpm")
    .setText("4")
    .setPosition(((width/2)+ radiusknobA - 120), (radiusknobA - 130))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;                   

  myTextlabel5rpm     = cp5.addTextlabel("5rpm")
    .setText("5")
    .setPosition(((width/2)+ radiusknobA - 10), (radiusknobA - 50))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;              
  myTextlabel6rpm     = cp5.addTextlabel("6rpm")
    .setText("6")
    .setPosition(((width/2)+ radiusknobA + 30), (radiusknobA + 100))
    .setColorValue(reC)
    .setFont(myFont2)
    ;               

  myTextlabel6rpm     = cp5.addTextlabel("7rpm")
    .setText("7")
    .setPosition(((width/2)+ radiusknobA - 40), (radiusknobA + 230))
    .setColorValue(reC)
    .setFont(myFont2)
    ; 

  myTextlabelSPEED = cp5.addTextlabel("SPEED")
    .setText("0.00")
    .setPosition(((width/2) - 50), (radiusknobA + 10))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 

  myTextlabelSPEEDunit = cp5.addTextlabel("Km/h")
    .setText("Km/h")
    .setPosition(((width/2) - 50), (radiusknobA + 60))
    .setColorValue(textwhite)
    .setFont(myFont)
    ;                    

  myTextlabelRPM = cp5.addTextlabel("RPM")
    .setText("0")
    .setPosition(((width/2) - 50), (radiusknobA + 110))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                

  myTextlabelRPMunit = cp5.addTextlabel("T min")
    .setText("T/min")
    .setPosition(((width/2) - 50), (radiusknobA + 150))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;

  myTextlabelDEP = cp5.addTextlabel("DEP")
    .setText("0")
    .setPosition((marginEdge + radiusknobB - 50), ((height/2)+ 20))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                   

  myTextlabelDEPunit = cp5.addTextlabel("° DEP")
    .setText("° Dep")
    .setPosition((marginEdge + radiusknobB - 50), ((height/2)+ 60))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;               

  myTextlabelCENT = cp5.addTextlabel("CENT")
    .setText("0")
    .setPosition((width- radiusknobC - marginEdge) - 50, ((height/2)+ 20))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                   

  myTextlabelCENTunit = cp5.addTextlabel("° CENT")
    .setText("° Cent")
    .setPosition((width- radiusknobC - marginEdge) - 50, ((height/2)+ 60))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ; 

  myTextlabelTOT = cp5.addTextlabel("AV TOT")
    .setText("0")
    .setPosition(((width/2)-40), ((height - 2 * radiusknobD)-70))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                     

  myTextlabelTOTunit = cp5.addTextlabel("° AV TOT")
    .setText("° Av Tot")
    .setPosition(((width/2)-60), ((height - 2 * radiusknobD)-20))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ; 

  myTextlabelDIST = cp5.addTextlabel("DIST")
    .setText("0000.0")
    .setDecimalPrecision(2)
    .setPosition(((width/2)-50), ((height - 2 * radiusknobD)+20))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 

  myTextlabelDISTunit = cp5.addTextlabel("KM")
    .setText("Km")
    .setPosition(((width/2)-30), ((height - 2 * radiusknobD)+60))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 
  // create a new button with name 'RAZ'
  myButtonRAZ = cp5.addButton("RAZ")
    .setValue(0)
    .setFont(myFont)
    .setPosition((width - marginEdge - 90), (height - marginBottom))
    .setSize(90, 60)
    .setColorBackground(color(0, 80, 100))
    ; 

  myBtGraph = cp5.addButton("VUE")
    .setValue(0)
    .setFont(myFont)
    .setPosition(marginEdge, (height - marginBottom))
    .setSize(90, 60)
    .setColorBackground(color(0, 80, 100))
    ; 

  panel1 = createGraphics( width, height );
  c1 = new ControlP5( this );
  
  panel2 = createGraphics( width, height );
  c2 = new ControlP5( this );
}




void draw() {
  //Display a green screen if a device has been found,
  //Display a purple screen when a connection is made to the device
  if (foundDevice) {
    if (BTisConnected) {
      background(255, 210, 255); // purple screen
      fill(blaC);
      rect(0, 0, width, 40);

      if (speedValue > 6000) {
        myKnobRPM.setColorForeground(color(255, 0, 0));
        myTextlabelRPM.setText(str(speedValue));
      } else {
        myKnobRPM.setColorForeground(color(255));
        myTextlabelRPM.setText(str(speedValue));
      }

      myTextlabelDEP.setText(str(pressionValue));
      myTextlabelCENT.setText(str(delayValue));
      myTextlabelTOT.setText(str(avtotValue));
      myTextlabelSPEED.setText(nfc(currentSpeed, 2));
      myTextlabelDIST.setText(nf(travelDistance, 4, 1));

      storeavance();
      storedep();
      storetot();

      if (myButtonRAZ.isPressed()) { // button is pressed
        travelDistance = 0;
      }

      if (myBtGraph.isPressed()) { // button is pressed
        //print("Bouton vue pressé");
        // create a control window canvas and add it to
        // the previously created control window.  

        c1.enableShortcuts();
        c1.setBackground( color( 250, 220, 150 ) );
        c1.addButton("aecp pour smartphone").setSize(width, 40).setPosition( 0, 0 ).setFont(myFont).setColorBackground(color(0));
        c1.addButton("Sortir").setSize(140, 60).setPosition( ((width/2)-70), (height-100) ).setFont(myFont).setId(1);
        cc = new MyCanvas();
        cc.pre(); // use cc.post(); to draw on top of existing controllers.
        c1.addCanvas(cc); // add the canvas to cp5
        c1.setGraphics( panel1, 0, 0);
        c1.show();
      }
      
      if (myKnobTOT.isMousePressed()) { // knob is pressed
        //print("Disque avance totale pressé");
        // create a control window canvas and add it to
        // the previously created control window.  
        
        c2.enableShortcuts();
        c2.setBackground( color( 250, 220, 150 ) );
        c2.addButton("aecp pour smartphone").setSize(width, 40).setPosition( 0, 0 ).setFont(myFont).setColorBackground(color(0));
        c2.addButton("Cent").setSize(100, 60).setPosition( ((width/2)-200), 80 ).setFont(myFont).setId(3);
        c2.addButton("Dep").setSize(100, 60).setPosition( ((width/2)-50), 80 ).setFont(myFont).setId(4);
        c2.addButton("Tot").setSize(100, 60).setPosition( ((width/2)+100), 80 ).setFont(myFont).setId(5);
        c2.addButton("Sortir").setSize(140, 60).setPosition( ((width/2)-70), (height-100) ).setFont(myFont).setId(2);
        cc2 = new MyCanvasTOT();
        cc2.pre(); // use cc.post(); to draw on top of existing controllers.
        c2.addCanvas(cc2); // add the canvas to cp5
        c2.setGraphics( panel2, 0, 0);
        c2.show();
      }
      
    } else {
      background(200, 255, 165); // green screen
      fill(blaC);
      rect(0, 0, width, 40);
    }
  }
}

// MyCanvas, your Canvas render class
class MyCanvas extends Canvas {

  int mylastx = 0;
  int mylasty = 0;
  int mylastxdep = 0;
  int mylastydep = 0;

  public void setup(PGraphics pg) {
    xcentOrigin = (( width/2 ) - ( rangeSpeed/2 )); // Position du graphique de l'avance centrifuge
    ycentOrigin = height-200;
    xdepOrigin = (( width/2 ) - ( rangeMmhg/2 )); // Position du graphique de l'avance dépression
    ydepOrigin = ((height/2)-200);

    mylastx = ( xcentOrigin + rangeSpeed +1 ); // +1 pour finir de tracer le cadrillage
    mylasty = ( ycentOrigin - rangeCent -1 ); // -1 pour finir de tracer le cadrillage
    mylastxdep = ( xdepOrigin + rangeMmhg +1 ); // +1 pour finir de tracer le cadrillage
    mylastydep = ( ydepOrigin - rangeDep -1 ); // -1 pour finir de tracer le cadrillage
  }  

  public void draw(PGraphics pg) {

    pg.stroke(0);
    pg.strokeWeight(0);  // Epaisseur du trait

    // Trace le cadrillage de l'avance centrifuge
    for (int i = xcentOrigin; i < mylastx; i = i+75) 
    {
      pg.line(i, mylasty, i, ycentOrigin);// ligne verticale
    }
    for (int i = ycentOrigin; i > mylasty; i = i-75) 
    {
      pg.line(xcentOrigin, i, mylastx, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance centrifuge", ((width/2)-140), ((height/2)+80));

    pg.text(0, xcentOrigin-10, ycentOrigin+30);
    pg.text(1, xcentOrigin+65, ycentOrigin+30);
    pg.text(2, xcentOrigin+140, ycentOrigin+30);
    pg.text(3, xcentOrigin+215, ycentOrigin+30);
    pg.text(4, xcentOrigin+290, ycentOrigin+30);
    pg.text(5, xcentOrigin+365, ycentOrigin+30);
    pg.text(6, xcentOrigin+440, ycentOrigin+30);
    pg.text(7, xcentOrigin+515, ycentOrigin+30);

    pg.text(5, xcentOrigin-25, ycentOrigin-75);
    pg.text(10, xcentOrigin-40, ycentOrigin-150);
    pg.text(15, xcentOrigin-40, ycentOrigin-225);

    pg.textFont(myFont3);
    pg.text("x1000 t/min", xcentOrigin+400, ycentOrigin+60);
    pg.text("d°", xcentOrigin-25, ycentOrigin-300);
    pg.textFont(myFont);

    // Trace le cadrillage de l'avance dépression
    for (int i = xdepOrigin; i < mylastxdep; i = i+75) 
    {
      pg.line(i, mylastydep, i, ydepOrigin);// ligne verticale
    }
    for (int i = ydepOrigin; i > mylastydep; i = i-75) 
    {
      pg.line(xdepOrigin, i, mylastxdep, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance dépression", ((width/2)-140), 80);

    pg.text(10, xdepOrigin-40, ydepOrigin-75);
    pg.text(20, xdepOrigin-40, ydepOrigin-150);
    pg.text(30, xdepOrigin-40, ydepOrigin-225);

    pg.textFont(myFont3);
    pg.text(0, xdepOrigin-10, ydepOrigin+30);
    pg.text(50, xdepOrigin+65, ydepOrigin+30);
    pg.text(100, xdepOrigin+140, ydepOrigin+30);
    pg.text(150, xdepOrigin+215, ydepOrigin+30);
    pg.text(200, xdepOrigin+290, ydepOrigin+30);
    pg.text(250, xdepOrigin+365, ydepOrigin+30);
    pg.text(300, xdepOrigin+440, ydepOrigin+30);

    pg.text("mmhg", xdepOrigin+400, ydepOrigin+60);
    pg.text("d°", xdepOrigin-25, ydepOrigin-300);
    pg.textFont(myFont);

    pg.strokeWeight(3);  // Epaisseur du trait

    for (int q = 1; q<mylastx; q++) {
      //println(myspeed [q]);
      String send = " ";
      int xr = q;
      float yr = myspeed [q];

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {

        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        //send = lastxr + "," + lastyr + "," + xr + "," + yr ;
        //send = (xcentOrigin+lastxr) + "," + (ycentOrigin-lastyr) + "," + (xcentOrigin+xr)+ "," + (ycentOrigin-yr) ;
        //println(send);
        lastxr = xr;
        lastyr = yr;
      }
    }

    for (int t = 1; t<mylastxdep; t++) {
      //println(mymmhg [t]);
      int xrdep = t;
      float yrdep = mymmhg [t];

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {

        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = xrdep;
        lastyrdep = yrdep;
      }
    }

    pg.text("Avance Statique", ((width/2)-130), ((height/2)-60));
    pg.fill(whiC);
    pg.rect(((width/2)-30), (height/2)-35, 60, 40);
    pg.fill(blaC);
    pg.text(str(staticValue), ((width/2)-20), ((height/2)-5));
    pg.text("d°", ((width/2)+40), ((height/2)-5));
  }
}

// MyCanvas, Graphique de l'avance totale
class MyCanvasTOT extends Canvas {

  int mylastxtot = 0;
  int mylastytot = 0;
  int mylastxfix = 0;
  int mylastyfix = 0;
  int mylastxcent = 0;
  int mylastycent = 0;
  int mylastxdep = 0;
  int mylastydep = 0;

  public void setup(PGraphics pg) {
    xtotOrigin = ((( width/2 )+10) - ( rangeTime/2 )); // Position du graphique de l'avance centrifuge
    ytotOrigin = height-160;
    
    mylastxtot = ( xtotOrigin + rangeTime +1 ); // +1 pour finir de tracer le cadrillage
    mylastytot = ( ytotOrigin - rangeTot -1 ); // -1 pour finir de tracer le cadrillage
    
  }  

  public void draw(PGraphics pg) {

    pg.stroke(0);
    pg.strokeWeight(0);  // Epaisseur du trait

    // Trace le cadrillage de l'avance totale
    for (int i = xtotOrigin; i < mylastxtot; i = i+50) 
    {
      pg.line(i, mylastytot, i, ytotOrigin);// ligne verticale
    }
    for (int i = ytotOrigin; i > mylastytot; i = i-65) 
    {
      pg.line(xtotOrigin, i, mylastxtot, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("    ", xtotOrigin+35,ytotOrigin+60);
    pg.text("    ", xtotOrigin+135,ytotOrigin+60);
    pg.text("    ", mylastxtot-185,ytotOrigin+60);
    pg.text("    ", mylastxtot-85,ytotOrigin+60);
    
    pg.text(nfc(pressionValue,1), xtotOrigin+35,ytotOrigin+60);
    pg.text(nfc(delayValue,1), xtotOrigin+135,ytotOrigin+60);
    pg.text(nfc((avtotValue-delayValue-pressionValue),1), mylastxtot-185,ytotOrigin+60);
    pg.fill(puC);
    pg.text(nfc(avtotValue,1), mylastxtot-85,ytotOrigin+60);
    
    pg.fill(blaC);
    pg.text("Avance totale", ((width/2)-100), ((height/2)-430));
    
    pg.text(5, xtotOrigin-25, ytotOrigin-60);
    pg.text(10, xtotOrigin-40, ytotOrigin-125);
    pg.text(15, xtotOrigin-40, ytotOrigin-190);
    pg.text(20, xtotOrigin-40, ytotOrigin-255);
    pg.text(25, xtotOrigin-40, ytotOrigin-320);
    pg.text(30, xtotOrigin-40, ytotOrigin-385);
    pg.text(35, xtotOrigin-40, ytotOrigin-450);
    pg.text(40, xtotOrigin-40, ytotOrigin-515);
    pg.text(45, xtotOrigin-40, ytotOrigin-580);
    pg.text(50, xtotOrigin-40, ytotOrigin-645);
    pg.text(55, xtotOrigin-40, ytotOrigin-710);
    pg.text(60, xtotOrigin-40, ytotOrigin-775);

    pg.textFont(myFont3);
    pg.text("d°", xtotOrigin-25, ytotOrigin-840);
    pg.text("dep", xtotOrigin+55,ytotOrigin+30);
    pg.text("cent", xtotOrigin+155,ytotOrigin+30);
    pg.text("fix", mylastxtot-155,ytotOrigin+30);
    pg.text("tot", mylastxtot-55,ytotOrigin+30);
    
    pg.fill(whiC);
    pg.rect(((width/2)-250), (height-50), 80, 35);
    pg.rect((width-170), (height-50), 80, 35);
    pg.fill(blaC);
    pg.text("Av moyenne", ((width/2)-280),(height-60) );
    pg.text("Av crête", (width-180),(height-60) );
    pg.textFont(myFont2);
    pg.text(nfc(advCurrentAverage,1), ((width/2)-245),(height-20) );
    pg.text(nfc(advPeakmesure,1), (width-165),(height-20) );
    
    pg.textFont(myFont);

    pg.strokeWeight(1);  // Epaisseur du trait
           
    for (int i = 2; i<=countertot; i++){
      int lastxrfix = i - 1;
      float lastyrfix = myadvancetot [i-1][0];
      int xrfix = i;
      float yrfix = myadvancetot [i][0]; 
      int lastxrcent = i - 1;
      float lastyrcentorigin = lastyrfix;
      float lastyrcent = myadvancetot [i-1][1] + lastyrfix;
      float lastyrcentsingle = myadvancetot [i-1][1];
      int xrcent = i;
      float yrcentorigin = yrfix;
      float yrcent = myadvancetot [i][1] + yrfix; 
      float yrcentsingle = myadvancetot [i][1]; 
      int lastxrdep = i - 1;
      float lastyrdeporigin = lastyrcent;
      float lastyrdep = myadvancetot [i-1][2] + lastyrcent;
      float lastyrdepsingle = myadvancetot [i-1][2];
      int xrdep = i;
      float yrdeporigin = yrcent;
      float yrdep = myadvancetot [i][2] + yrcent;
      float yrdepsingle = myadvancetot [i][2];
      
      //println(myadvancetot [i][0]);
      
      if (showcent == true){
        if (yrcentsingle == 0){ }
      else{
       pg.strokeWeight(3);  // Epaisseur du trait
       pg.stroke(grC);
       pg.fill(grC);
       //pg.quad((xtotOrigin+lastxrcent),(ytotOrigin-lastyrcentorigin),(xtotOrigin+lastxrcent),(ytotOrigin-lastyrcent),(xtotOrigin+xrcent),(ytotOrigin-yrcent),(xtotOrigin+xrcent),(ytotOrigin-yrcentorigin));
       pg.line((xtotOrigin+lastxrcent),(ytotOrigin-lastyrcentsingle),(xtotOrigin+xrcent),(ytotOrigin-yrcentsingle));
       pg.fill(grC);
       pg.rect(xtotOrigin+125,ytotOrigin+10,20,20,3);
      }
      }
      if (showdep == true){
        if (yrdepsingle == 0){ }
      else{
       pg.strokeWeight(3);  // Epaisseur du trait
       pg.stroke(reC);
       pg.line((xtotOrigin+lastxrdep),(ytotOrigin-lastyrdepsingle),(xtotOrigin+xrdep),(ytotOrigin-yrdepsingle));
       pg.fill(reC);
       pg.rect(xtotOrigin+25,ytotOrigin+10,20,20,3);
      }
      }
      if (showtot == true){
        if (yrdep == 0){ }
      else{
       pg.strokeWeight(3);  // Epaisseur du trait
       pg.stroke(puC);
       pg.line((xtotOrigin+lastxrdep),(ytotOrigin-lastyrdep),(xtotOrigin+xrdep),(ytotOrigin-yrdep));
       pg.fill(puC);
       pg.rect(mylastxtot-85,ytotOrigin+10,20,20,3);
      }
      }
      
      if (showcent == false && showdep == false && showtot == false){
       if (yrdep == 0){ }
      else{
       pg.strokeWeight(6);  // Epaisseur du trait
       pg.stroke(reC);
       pg.quad((xtotOrigin+lastxrdep),(ytotOrigin-lastyrdeporigin),(xtotOrigin+lastxrdep),(ytotOrigin-lastyrdep),(xtotOrigin+xrdep),(ytotOrigin-yrdep),(xtotOrigin+xrdep),(ytotOrigin-yrdeporigin));
       pg.fill(reC);
       pg.rect(xtotOrigin+25,ytotOrigin+10,20,20,3);
      }
      
       if (yrcent == 0){ }
      else{
       pg.stroke(grC);
       pg.fill(grC);
       pg.quad((xtotOrigin+lastxrcent),(ytotOrigin-lastyrcentorigin),(xtotOrigin+lastxrcent),(ytotOrigin-lastyrcent),(xtotOrigin+xrcent),(ytotOrigin-yrcent),(xtotOrigin+xrcent),(ytotOrigin-yrcentorigin));
       //pg.line((xtotOrigin+lastxrcent),(ytotOrigin-lastyrcent-lastyrfix),(xtotOrigin+xrcent),(ytotOrigin-yrcent-yrfix));
       pg.fill(grC);
       pg.rect(xtotOrigin+125,ytotOrigin+10,20,20,3);
      }
      
       if (yrfix == 0){ }
      else{
       pg.stroke(blC);
       pg.strokeWeight(6);  // Epaisseur du trait
       //pg.quad((xtotOrigin+lastxrfix),ytotOrigin,(xtotOrigin+lastxrfix),(ytotOrigin-lastyrfix),(xtotOrigin+xrfix),(ytotOrigin-yrfix),(xtotOrigin+xrfix),ytotOrigin);
       pg.line((xtotOrigin+lastxrfix),(ytotOrigin-lastyrfix+3),(xtotOrigin+xrfix),(ytotOrigin-yrfix+3));
       pg.strokeWeight(1);  // Epaisseur du trait
       pg.fill(blC);
       pg.rect(mylastxtot-185,ytotOrigin+10,20,20,3);
      }
      
    }
   }        
  }
}


public void storeavance() {
  int s = int(speedValue/coefSpeed);
  float av = 0;
  av = delayValue*(coefCent);  
  //print(s);print(",");
  //println(av);
  myspeed [s] = av;
  //println(myspeed [s]);
}
public void storedep() {
  int d = int(mmhgValue * 1.5);
  float dep = 0;
  dep = pressionValue*coefDep;  
  //print(d);print(",");
  //println(dep);
  mymmhg [d] = dep;
  //println(mymmmhg [d]);
}
public void storetot(){
   int c = countertot;
   float tot = 0;
   float av = 0;
   float dep = 0;
   float fix = 0;
   
   tot = int(avtotValue*coefTot*coefTotaff);
   av = int(delayValue*coefCentTot*coefTotaff);  
   dep = int(pressionValue*coefDepTot*1*coefTotaff); // *2 pour harmoniser les coefCent, coefDep et coefTot
   fix = tot - dep - av;
   
   myadvancetot [c][0] = fix;
   myadvancetot [c][1] = av;
   myadvancetot [c][2] = dep;
   myadvancetot [c][3] = tot;
   
   //println(delayValue + "," + pressionValue);
   //println(dep + "," + av + "," + fix + "," + tot);
   
   
   if ( countertot > (rangeTime) ){
     countertot =0;
   }
   else{
     countertot = countertot + 1;
   }
}

void controlEvent(ControlEvent theEvent) {
  //println("got a control event from controller with id "+theEvent.getController().getId());

  if (theEvent.isFrom(cp5.getController("n1"))) {
    //println("this event was triggered by the button exit");
  }

  switch(theEvent.getController().getId()) {
    case(1):
    c1.hide();

    break;
    case(2):
    c2.hide();
   
    break;
    case(3):
    if (showcent == false){
    showcent = true;
    }
    else{
    showcent = false;
    }
   
    break;
    case(4):
    if (showdep == false){
    showdep = true;
    }
    else{
    showdep = false;
    }
   
    break;
    case(5):
    if (showtot == false){
    showtot = true;
    }
    else{
    showtot = false;
    }
   
    break;
  }
}

/* This BroadcastReceiver will display discovered Bluetooth devices */
public class myOwnBroadcastReceiver extends BroadcastReceiver {
  @Override
    public void onReceive(Context context, Intent intent) {
    String action=intent.getAction();
    //ToastMaster("ACTION:" + action);

    //Notification that BluetoothDevice is FOUND
    if (BluetoothDevice.ACTION_FOUND.equals(action)) {
      //Display the name of the discovered device
      String discoveredDeviceName = intent.getStringExtra(BluetoothDevice.EXTRA_NAME);
      //ToastMaster("Discovered: " + discoveredDeviceName);

      //Display more information about the discovered device
      BluetoothDevice discoveredDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
      //ToastMaster("getAddress() = " + discoveredDevice.getAddress());
      //ToastMaster("getName() = " + discoveredDevice.getName());

      //Change foundDevice to true which will make the screen turn green
      foundDevice=true;

      //Connect to the discovered bluetooth device (BTaecp)
      if (discoveredDeviceName.equals("BTaepl") || discoveredDeviceName.equals("BTaecp")) {
        ToastMaster("Connecte BTaepl ou BTaecp");
        context.unregisterReceiver(myDiscoverer);


        ConnectToBluetooth connectBT = new ConnectToBluetooth(discoveredDevice);
        //Connect to the the device in a new thread
        new Thread(connectBT).start();
        ToastMaster("c'est parti");
      }
    }

    //Notification if bluetooth device is connected
    if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
      print(action);  
      int counter=0;
      while (scSocket==null) {
        //do nothing
      }
      //ToastMaster("scSocket" + scSocket);
      BTisConnected=true; //turn screen purple 
      if (scSocket!=null) {
        sendReceiveBT = new SendReceiveBytes(scSocket);
        new Thread(sendReceiveBT).start();
        String red = "r";
        byte[] myByte = stringToBytesUTFCustom(red);
        sendReceiveBT.write(myByte);
      }
    }
  }
}

public static byte[] stringToBytesUTFCustom(String str) {
  char[] buffer = str.toCharArray();
  byte[] b = new byte[buffer.length << 1];
  for (int i = 0; i < buffer.length; i++) {
    int bpos = i << 1;
    b[bpos] = (byte) ((buffer[i]&0xFF00)>>8);
    b[bpos + 1] = (byte) (buffer[i]&0x00FF);
  }
  return b;
}


public class ConnectToBluetooth implements Runnable {
  private BluetoothDevice btShield;
  private BluetoothSocket mySocket = null;
  private UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

  public ConnectToBluetooth(BluetoothDevice bluetoothShield) {
    btShield = bluetoothShield;
    try {
      mySocket = btShield.createRfcommSocketToServiceRecord(uuid);
      //print(mySocket);
    }
    catch(IOException createSocketException) {
      //Problem with creating a socket
    }
  }

  //@Override
  public void run() {
    /* Cancel discovery on Bluetooth Adapter to prevent slow connection */
    bluetooth.cancelDiscovery();
    //print("cancelDiscovery is done");

    try {
      /*Connect to the bluetoothShield through the Socket. This will block
       until it succeeds or throws an IOException */
      mySocket.connect();
      scSocket=mySocket;
      //print("mySocket is connected");
    } 
    catch (IOException connectException) {
      try {
        mySocket.close(); //try to close the socket
        //print("mySocket is closed");
      }
      catch(IOException closeException) {
      }
      return;
    }
  }

  /* Will cancel an in-progress connection, and close the socket */
  public void cancel() {
    try {
      mySocket.close();
    } 
    catch (IOException e) {
    }
  }
}

private class SendReceiveBytes implements Runnable {
  private BluetoothSocket btSocket;
  private InputStream btInputStream = null;
  private OutputStream btOutputStream = null;
  String TAG = "SendReceiveBytes";

  public SendReceiveBytes(BluetoothSocket socket) {
    btSocket = socket;
    try {
      btInputStream = btSocket.getInputStream(); 
      btOutputStream = btSocket.getOutputStream();
    } 
    catch (IOException streamError) { 
      Log.e(TAG, "Error when getting input or output Stream");
    }
  }


  public void run() {
    short FL = 10; // "Fin de ligne" 
    byte[] buffer = new byte[1024]; // buffer store for the stream
    int bytes = 0; // bytes returned from read()
    // Keep listening to the InputStream until an exception occurs
    while (true) {
      try {
        // Read from the InputStream
        //bytes = btInputStream.read(buffer);
        buffer[bytes] = (byte) btInputStream.read();

        // Send the obtained bytes to the UI activity
        if (buffer[bytes] == '\n')
        {
          mHandler.obtainMessage(MESSAGE_READ, bytes, -1, buffer).sendToTarget();
          bytes=0;
        } else
          bytes++;

        //mHandler.obtainMessage(MESSAGE_READ, bytes, -1, buffer).sendToTarget();
      } 
      catch (IOException e) {
        Log.e(TAG, "Error reading from btInputStream");
        break;
      }
    }
  }
  /* Call this from the main activity to send data to the remote device */
  public void write(byte[] bytes) {
    try {
      btOutputStream.write(bytes);
    } 
    catch (IOException e) { 
      Log.e(TAG, "Error when writing to btOutputStream");
    }
  }


  /* Call this from the main activity to shutdown the connection */
  public void cancel() {
    try {
      btSocket.close();
    } 
    catch (IOException e) { 
      Log.e(TAG, "Error when closing the btSocket");
    }
  }
}


// Override the activity class methods
void onResume()
{
  super.onResume();

  locationListener = new MyLocationListener();
  locationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);    

  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
}

void onPause()
{
  super.onPause();
}

/*****************************************************************/

// Class for capturing the GPS data
class MyLocationListener implements LocationListener
{

  private Location lastLocation = null;
  private double calculatedSpeed = 0;
  // Define all LocationListener methods
  void onLocationChanged(Location location)
  {
    // Save new GPS data
    currentLatitude  = (float)location.getLatitude();
    currentLongitude = (float)location.getLongitude();
    currentAccuracy  = (float)location.getAccuracy();
    currentProvider  = location.getProvider();
    if (lastLocation != null) {
      double elapsedTime = (location.getTime() - lastLocation.getTime()) / 1000; // Convert milliseconds to seconds
      currentDistance = lastLocation.distanceTo(location) / 1000;
      calculatedSpeed = lastLocation.distanceTo(location) / elapsedTime;
    }
    this.lastLocation = location;

    double speed = location.hasSpeed() ? location.getSpeed() : calculatedSpeed;

    /* There you have it, a speed value in m/s */

    currentSpeed = (float)(speed * 3.6); //To convert in Km/hour
    if (currentSpeed != 0) {
      travelDistance += currentDistance;
    }
  }

  void onProviderDisabled (String provider)
  { 
    currentProvider = "";
  }

  void onProviderEnabled (String provider)
  { 
    currentProvider = provider;
  }

  void onStatusChanged (String provider, int status, Bundle extras)
  {
    // Nothing yet...
  }
}



/* My ToastMaster function to display a messageBox on the screen */
void ToastMaster(String textToDisplay) {
  Toast myMessage = Toast.makeText(getActivity().getApplicationContext(), 
    textToDisplay, 
    Toast.LENGTH_SHORT);
  myMessage.setGravity(Gravity.CENTER, 0, 0);
  myMessage.show();
}