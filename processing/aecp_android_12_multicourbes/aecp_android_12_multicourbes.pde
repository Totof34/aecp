/*Interface pour allumage électronique cartographique pour Panhard
 créez sous Processing 4 pour smartphone Xiaomi Redminote 8 Pro sous Android 12
 Finalisée le 22/06/2026 
 Adaptation du code issu du commentaire ci-dessous */
/* ConnectBluetooth: Written by ScottC on 18 March 2013 using 
 Processing version 2.0b8
 Tested on a Samsung Galaxy SII, with Android version 2.3.4
 Android ADK - API 10 SDK platform */

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.location.GpsStatus.Listener;
import android.os.Bundle;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.widget.Toast;
import android.view.Gravity;
import android.app.Activity;
import android.view.WindowManager;
import android.view.View;
import android.os.*;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.Manifest;
import java.util.Set;
import java.util.UUID;
import controlP5.*;

LocationManager locationManager;
MyLocationListener locationListener;

boolean hasLocation = false;

ControlP5 cp5;
 
// Make sure sketch permissions are set for Bluetooth
// ACCESS_COARSE_LOCATION
// BLUETOOTH
// BLUETOOTH_ADMIN

// DropDownList control => a.)displayFld b.)arrow c.)list


Activity act;
View decorView;
int uiOptions;

public BluetoothSocket scSocket;

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
int radiusknobA = 280;
int radiusknobB = 220;
int radiusknobC = 220;
int radiusknobD = 250;
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


PGraphics panel1;
Canvas cc;
//ControlP5 c1;
ControlWindow c1;

PGraphics panel2;
Canvas cc2;
//ControlP5 c2;
ControlWindow c2;

boolean showcent=false;
boolean showdep=false;
boolean showtot=false;
boolean showa=false;
boolean showb=false;
boolean showc=false;
boolean showd=false;
boolean showe=false;
boolean showf=false;
boolean showg=false;
boolean showh=false;
boolean showi=false;
boolean showj=false;

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
float CoefRangeX = 1.6; // dilate l'échelle d'affichage horizontalement
float CoefRangeY = 2; // dilate l'échelle d'affichage verticalement
float coefSpeed = ((20 / 1.5 )/CoefRangeX); // Un coefficient multiplicateur pour afficher les résulats
int coefCent = int(15 * CoefRangeY); // Un coefficient multiplicateur pour afficher les résulats init 15
float coefDep = int(7.5 * CoefRangeY); // Un coefficient multiplicateur pour afficher les résulats init 7.5
float coefMmhg = (1.5 * CoefRangeX);
float CoefRangeTotX = 1.4; // dilate l'échelle d'affichage horizontalement
float CoefRangeTotY = 1.8; // dilate l'échelle d'affichage verticalement
int coefCentTot = 10; // Un coefficient multiplicateur pour afficher les résulats 
float coefDepTot = 10; // Un coefficient multiplicateur pour afficher les résulats
int coefTot = 10; // Un coefficient multiplicateur pour afficher les résulats
float coefTotaff = (1.3 * CoefRangeTotY); // Un coefficient multiplicateur pour afficher les résulats sur le graphique
int rangeSpeed = int(525 * CoefRangeX); // Une variable pour le dimensionement et la position de l'affichage, ici vitesse maxi/coefSpeed = (7000/20)*1.5 init 525
int rangeCent = int(300 * CoefRangeY); // Une variable pour le dimensionement et la position de l'affichage, ici avance centrifuge maxi*coefCent = (20*10)*1.5 init 300
int rangeDep = int(300 * CoefRangeY); // Une variable pour le dimensionement et la position de l'affichage, ici avance dépression maxi*coefDep = (20*10)*1.5 init 300
int rangeMmhg = int(450 * CoefRangeX); // Une variable pour le dimensionement et la position de l'affichage, ici mm de mercure maxi = 300*1.5
int rangeTot = int(845 * CoefRangeTotY); // Une variable pour le dimensionement et la position de l'affichage, ici avance dépression maxi*coefTot = 65*10
int rangeTime = int(650 *CoefRangeTotX) ; //Une variable pour le dimensionement et la position de l'affichage, ici temps passé par rapport à la largeur d'écran

float[] myspeed = new float[2000]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0, [700]
float[] mymmhg = new float[2000]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0
float[][] myadvancetot = new float[2000][4]; // Tableau pour sauvegarder les données envoyées par la Nano V3.0
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

//Partie qui va servire à la gestion multicourbes 
String letrToSend="";
String[] sendLetter={"f","g","h","i","j","a","b","c","d","e"}; //Letters to send when button pressed

//*******//*********Courbe   a
int Na[] = {0, 1000, 1240, 2050, 2500, 3400, 4100, 4200, 7000, 0};
//degrés d'avance vilebrequin correspondant soit en tour volant moteur ( attention ! ):
float Anga[] = {0, 0, 0.1, 4, 6, 10, 14, 16, 16, 0};
//*******//*********Courbe   b
int Nb[] = {0, 1500, 1640, 2000, 2480, 3800, 4000, 4120,4240, 4360, 7000, 0}; //Courbe b 
float Angb[] = {0, 0, 0.1, 2, 4, 10, 11, 12, 13, 14, 14, 0};
//*******//*********Courbe   c
int Nc[] = {0, 700, 840, 2100, 3000, 3400, 3760, 3880, 3950, 4000, 7000, 0}; //Courbe c
float Angc[] = {0, 0, 0.1, 6, 10, 12, 14, 15, 16, 18, 18, 0};
//*******//*********Courbe   d
int Nd[] = {0, 1500, 1640, 2520, 2840, 3760, 3880, 3990, 4000, 7000, 0}; //Courbe d
float Angd[] = {0, 0, 0.1, 5, 7, 14, 15, 16, 18, 18, 0};
//*******//*********Courbe   e
int Ne[] = {0, 700, 840, 2000, 2580, 3520, 3800, 4000, 4120, 4240, 4360, 7000, 0}; //Courbe e
float Ange[] = {0, 0, 0.1, 4, 6, 9, 10, 11, 12, 13, 14, 14, 0};
//*******//*********Courbe   f
int Nf[] = {0, 75, 80, 210, 300, 0};
float Angf[] = {0, 0, 0.1, 30, 30, 0};
//*******//*********Courbe   g
int Ng[] = {0, 95, 100, 225, 300, 0};
float Angg[] = {0, 0, 0.1, 28, 28, 0};
//*******//*********Courbe   h
int Nh[] = {0, 55, 60, 195, 300, 0};
float Angh[] = {0, 0, 0.1, 32, 32, 0};
//*******//*********Courbe   i
int Ni[] = {0, 95, 100, 195, 300, 0};
float Angi[] = {0, 0, 0.1, 32, 32, 0};
//*******//*********Courbe   j
int Nj[] = {0, 55, 60, 225, 300, 0};
float Angj[] = {0, 0, 0.1, 28, 28, 0};

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
//SendReceiveBytes sendReceiveBT = null;
ConnectedThread  sendReceiveBT = null;

//Get the Bluetooth adapter
BluetoothAdapter bluetoothAdapter = null;

final int _deviceDisplayX =  30;
final int _deviceDisplayY = 730;
final int _deviceDisplayW = 450;
final int _deviceDisplayH = 60;
final int _deviceItemH = 120;
final int _deviceArrwX = _deviceDisplayX + _deviceDisplayW;
final int _deviceArrwY = _deviceDisplayY;
final int _deviceArrwSize = _deviceDisplayH;

final int _connectBtnX = 700;
final int _connectBtnY = 730;
final int _connectBtnW = 270;
final int _connectBtnH = 60;

final int _quitBtnX = 470;
final int _quitBtnY = 2160;
final int _quitBtnW = 170;
final int _quitBtnH = 70;

boolean firstpage=true;

final int _dataDisplayX = 30;
final int _dataDisplayY = 60;
final int _dataDisplayW = 150;
final int _dataDisplayH = 60;

final int _viewBtnX = 40;
final int _viewBtnY = 2160;
final int _viewBtnW = 240;
final int _viewBtnH = 70;

final int _centBtnX = 40;
final int _centBtnY = 100;
final int _centBtnW = 250;
final int _centBtnH = 70;

final int _deprBtnX = 430;
final int _deprBtnY = 100;
final int _deprBtnW = 250;
final int _deprBtnH = 70;

final int _cumulBtnX = 850;
final int _cumulBtnY = 100;
final int _cumulBtnW = 170;
final int _cumulBtnH = 70;

final int _graphBtnX = 40;
final int _graphBtnY = 2030;
final int _graphBtnW = 240;
final int _graphBtnH = 70;

final int _zeroBtnX = 800;
final int _zeroBtnY = 2030;
final int _zeroBtnW = 240;
final int _zeroBtnH = 70;

final int _progBtnX = 800;
final int _progBtnY = 2160;
final int _progBtnW = 240;
final int _progBtnH = 70;

final int _letaBtnX = 100;
final int _letaBtnY = 1230;
final int _letaBtnW = 120;
final int _letaBtnH = 70;

final int _letbBtnX = 280;
final int _letbBtnY = 1230;
final int _letbBtnW = 120;
final int _letbBtnH = 70;

final int _letcBtnX = 460;
final int _letcBtnY = 1230;
final int _letcBtnW = 120;
final int _letcBtnH = 70;

final int _letdBtnX = 640;
final int _letdBtnY = 1230;
final int _letdBtnW = 120;
final int _letdBtnH = 70;

final int _leteBtnX = 820;
final int _leteBtnY = 1230;
final int _leteBtnW = 120;
final int _leteBtnH = 70;

final int _letfBtnX = 100;
final int _letfBtnY = 120;
final int _letfBtnW = 120;
final int _letfBtnH = 70;

final int _letgBtnX = 280;
final int _letgBtnY = 120;
final int _letgBtnW = 120;
final int _letgBtnH = 70;

final int _lethBtnX = 460;
final int _lethBtnY = 120;
final int _lethBtnW = 120;
final int _lethBtnH = 70;

final int _letiBtnX = 640;
final int _letiBtnY = 120;
final int _letiBtnW = 120;
final int _letiBtnH = 70;

final int _letjBtnX = 820;
final int _letjBtnY = 120;
final int _letjBtnW = 120;
final int _letjBtnH = 70;

final int _sendBtnX = 420;
final int _sendBtnY = 1080;
final int _sendBtnW = 200;
final int _sendBtnH = 70;

int value = 0;

boolean deviceListDrop;
boolean connectSelected;
boolean viewSelected;

color BLUE = color(64,124,188);
color GREEN = color(0,126,0);

String[] deviceArray = {};
String[] deviceAddress = {};
int[] _deviceItemY;
int selectedDevice = -1;
int numDevices = 0;
int[] dataArray;


Thread runThread;
byte[] readBuffer;
int buffer_index;
int counter;
boolean stop_thread, plotting = false, init = true;


 void findPairedBluetoothDevices() {
 bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
 if (bluetoothAdapter == null) {
    println("Device doesn't support Bluetooth.");
 } else {
   Set<BluetoothDevice> pairedDevices = bluetoothAdapter.getBondedDevices();
   if (pairedDevices.size() > 0) {
    // Get the name and address of each paired device.
     for (BluetoothDevice device : pairedDevices) {
      // device = append(device,device);
       String deviceName = device.getName();
       if (deviceName.equals("BTaepl") || deviceName.equals("BTaecp")) {
       String deviceHardwareAddress = device.getAddress(); // MAC address
       deviceAddress = append(deviceAddress, device.getAddress());
       String deviceInfo = deviceName + "\n   " + deviceHardwareAddress;
       deviceArray = append(deviceArray, deviceInfo);
       }
       else{}
       //println(deviceName);
       //println(deviceHardwareAddress);
       //println(deviceAddress);
     }       
  }
 }
}

class DeviceDisplay {
  
 void press() {
 // device arrow touches
  if(deviceListDrop){
   deviceListDrop = false;
   } else {
   deviceListDrop = true;
  }
 }
  
 void deviceDisplayString(String str) {
  fill(255); // display field background color
  noStroke();
  rect(_deviceDisplayX,_deviceDisplayY,_deviceDisplayW,_deviceDisplayH);
  fill(0); // text color
  textSize(42);
  text(str, _deviceDisplayX + 10, _deviceDisplayY + 15, _deviceDisplayW, _deviceDisplayH);
}

 void display(){
 // display field
  if(selectedDevice == -1){
   deviceDisplayString("Select device:");   
  } else {
   deviceDisplayString(deviceArray[selectedDevice]); 
  }
 // arrow
  fill(255);
  noStroke();
  rect(_deviceArrwX, _deviceArrwY, _deviceArrwSize, _deviceArrwSize);
  fill(GREEN);
  triangle(_deviceArrwX+5,_deviceArrwY+5,_deviceArrwX+_deviceArrwSize-5,_deviceArrwY+5,_deviceArrwX+_deviceArrwSize/2,_deviceArrwY+_deviceArrwSize-5);
 }
  
}

DeviceDisplay deviceDisplay;

class DeviceList {
 
 void press(float mx, float my){
   // device list touches
   if (deviceArray.length > 0) {
   for(int j = 0; j < deviceArray.length; j++){
    if((mx >= _deviceDisplayX) && (mx <= _deviceDisplayX + _deviceDisplayW) && (my >= _deviceItemY[j] ) && (my <= _deviceItemY[j] + _deviceItemH)) {
     selectedDevice = j;
     deviceListDrop = false;
     // erases list
     fill(BLUE);
     rect(_deviceDisplayX, _deviceDisplayY, _deviceDisplayW, _deviceDisplayY + _deviceDisplayH + deviceArray.length*_deviceItemH);
    } 
   }
  }
 } 
  
 void display(){
  // deviceListItems
  if (deviceListDrop){
   if (deviceArray.length > 0) { 
   _deviceItemY = new int[deviceArray.length];
    for(int j = 0; j < deviceArray.length; j++) {
     _deviceItemY[j] = (_deviceDisplayY + _deviceDisplayH) + j*_deviceItemH;      
     fill(255);
     noStroke();
     rect(_deviceDisplayX,_deviceItemY[j],_deviceDisplayW,_deviceItemH);
     fill(0);
     textSize(42);
     text(deviceArray[j], _deviceDisplayX + 10, _deviceItemY[j] + 15, _deviceDisplayW, _deviceItemH);
    }  
   }
  }  else {
    if (deviceArray.length > 0) {    
     fill(BLUE);
     noStroke();
     rect(_deviceDisplayX, _deviceDisplayY, _deviceDisplayW, _deviceItemH * numDevices * 2);
    }
   } 
  }
 
 }

DeviceList deviceList;

 class ConnectBtn {
 // Changes color from gray to green when bluetooth is connected  
 void display(){
 if(connectSelected) {
   fill(151,186,66,255); // background color - GREEN
   noStroke();
   rect(_connectBtnX, _connectBtnY, _connectBtnW, _connectBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Déconnecter", _connectBtnX + 20, _connectBtnY + 15, _connectBtnW, _connectBtnH);
  } else {
   fill(209); // background color - GRAY
   noStroke();
   rect(_connectBtnX, _connectBtnY, _connectBtnW, _connectBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  Connecter", _connectBtnX + 20, _connectBtnY + 15, _connectBtnW, _connectBtnH);
  }
 }
 
 void press() {  
  if(connectSelected == false){
  //  connectBluetooth();
    connectSelected = true;
    println("Connect selected.");
    connectThread = new ConnectThread(bluetoothAdapter.getRemoteDevice(deviceAddress[selectedDevice]));
    connectThread.run();
    println(deviceAddress[selectedDevice]);
    } else {
      //disconnectBluetooth();
    connectSelected = false;
    println("Disconnect selected.");
    connectThread.cancel();
   }
 }
}

ConnectBtn connectBtn;

class QuitBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_quitBtnX, _quitBtnY, _quitBtnW, _quitBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Quitter", _quitBtnX + 25, _quitBtnY + 15, _quitBtnW, _quitBtnH);
 }
 
 void press(){
   if (firstpage==false){
   cp5.hide();
   DrawWindow();
   firstpage=true;
   }
   else {
     println("sortir de l'application");
     exit();
   }
 }
  
}
QuitBtn quitBtn;

class ZeroBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_zeroBtnX, _zeroBtnY, _zeroBtnW, _zeroBtnH, 15);
   fill(0); // text color
   textSize(42);
   text(" Mise à 0", _zeroBtnX + 25, _zeroBtnY + 15, _zeroBtnW, _zeroBtnH);
 }
 
 void press(){
   travelDistance = 0;
   println(travelDistance);
 }
  
}
ZeroBtn zeroBtn;

class ViewBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_viewBtnX, _viewBtnY, _viewBtnW, _viewBtnH, 15);
   fill(0); // text color
   textSize(42);
   text(" Courbes", _viewBtnX + 25, _viewBtnY + 15, _viewBtnW, _viewBtnH);
 }
 
 void press(){
        println("Bouton vue appuyé");
        // create a control window canvas and add it to
        // the previously created control window.
        cc = new MyCanvas();
        //cc.pre(); // use cc.post(); to draw on top of existing controllers.
        cc.post(); // use cc.post(); to draw on top of existing controllers.
        cp5.addCanvas(cc); // add the canvas to cp5 
 }
 
}
ViewBtn viewBtn;

class GraphBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_graphBtnX, _graphBtnY, _graphBtnW, _graphBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Graphique", _graphBtnX + 25, _graphBtnY + 15, _graphBtnW, _graphBtnH);
 }
 
 void press(){
        println("Bouton graphique appuyé");
        // create a control window canvas and add it to
        // the previously created control window.
        cc = new MyCanvasTOT();
        //cc.pre(); // use cc.post(); to draw on top of existing controllers.
        cc.post(); // use cc.post(); to draw on top of existing controllers.
        cp5.addCanvas(cc); // add the canvas to cp5    
 }
 
}
GraphBtn graphBtn;

class CentBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_centBtnX, _centBtnY, _centBtnW, _centBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Centrifuge", _centBtnX + 25, _centBtnY + 15, _centBtnW, _centBtnH);
 }
 
 void press(){
   if (showcent == false){
    showcent = true;
    }
    else{
    showcent = false;
    }
 }
  
}
CentBtn centBtn;

class DeprBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_deprBtnX, _deprBtnY, _deprBtnW, _deprBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Dépression", _deprBtnX + 25, _deprBtnY + 15, _deprBtnW, _deprBtnH);
 }
 
 void press(){
   if (showdep == false){
    showdep = true;
    }
    else{
    showdep = false;
    }
 }
  
}
DeprBtn deprBtn;

class CumulBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_cumulBtnX, _cumulBtnY, _cumulBtnW, _cumulBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Cumul", _cumulBtnX + 25, _cumulBtnY + 15, _cumulBtnW, _cumulBtnH);
 }
 
 void press(){
   if (showtot == false){
    showtot = true;
    }
    else{
    showtot = false;
    }
 }
  
}
CumulBtn cumulBtn;

class ProgBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_progBtnX, _progBtnY, _progBtnW, _progBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  Réglage", _progBtnX + 25, _progBtnY + 15, _progBtnW, _progBtnH);
 }
 
 void press(){
        println("Bouton vue appuyé");
        // create a control window canvas and add it to
        // the previously created control window.
        cc = new MyCanvasCUR();
        //cc.pre(); // use cc.post(); to draw on top of existing controllers.
        cc.post(); // use cc.post(); to draw on top of existing controllers.
        cp5.addCanvas(cc); // add the canvas to cp5 
 }
 
}
ProgBtn progBtn;

class LetaBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letaBtnX, _letaBtnY, _letaBtnW, _letaBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  A", _letaBtnX + 25, _letaBtnY + 15, _letaBtnW, _letaBtnH);
 }
 
 void press(){
    if (showa == false){
    showa = true;
    showb = false ; showc = false ; showd = false ; showe = false;
    letrToSend="a";
    //print(letrToSend);
    }
    else{
    showa = false;
    }
 }
  
}
LetaBtn letaBtn;

class LetbBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letbBtnX, _letbBtnY, _letbBtnW, _letbBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  B", _letbBtnX + 25, _letbBtnY + 15, _letbBtnW, _letbBtnH);
 }
 
 void press(){
   if (showb == false){
    showb = true;
    showa = false ; showc = false ; showd = false ; showe = false;
    letrToSend="b";
    //print(letrToSend);
    }
    else{
    showb = false;
    }
 }
  
}
LetbBtn letbBtn;

class LetcBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letcBtnX, _letcBtnY, _letcBtnW, _letcBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  C", _letcBtnX + 25, _letcBtnY + 15, _letcBtnW, _letcBtnH);
 }
 
 void press(){
   if (showc == false){
    showc = true;
    showa = false ; showb = false ; showd = false ; showe = false;
    letrToSend="c";
    //print(letrToSend);
    }
    else{
    showc = false;
    }
 }
  
}
LetcBtn letcBtn;

class LetdBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letdBtnX, _letdBtnY, _letdBtnW, _letdBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  D", _letdBtnX + 25, _letdBtnY + 15, _letdBtnW, _letdBtnH);
 }
 
 void press(){
    if (showd == false){
    showd = true;
    showa = false ; showb = false ; showc = false ; showe = false;
    letrToSend="d";
    //print(letrToSend);
    }
    else{
    showd = false;
    }
 }
  
}
LetdBtn letdBtn;

class LeteBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_leteBtnX, _leteBtnY, _leteBtnW, _leteBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  E", _leteBtnX + 25, _leteBtnY + 15, _leteBtnW, _leteBtnH);
 }
 
 void press(){
   if (showe == false){
    showe = true;
    showa = false ; showb = false ; showc = false ; showd = false ;
    letrToSend="e";
    //print(letrToSend);
    }
    else{
    showe = false;
    }
 }
  
}
LeteBtn leteBtn;

class LetfBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letfBtnX, _letfBtnY, _letfBtnW, _letfBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  F", _letfBtnX + 25, _letfBtnY + 15, _letfBtnW, _letfBtnH);
 }
 
 void press(){
    if (showf == false){
    showf = true;
    showg = false ; showh = false ; showi = false ; showj = false;
    letrToSend="f";
    //print(letrToSend);
    }
    else{
    showf = false;
    }
 }
  
}
LetfBtn letfBtn;

class LetgBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letgBtnX, _letgBtnY, _letgBtnW, _letgBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  G", _letgBtnX + 25, _letgBtnY + 15, _letgBtnW, _letgBtnH);
 }
 
 void press(){
   if (showg == false){
    showg = true;
    showf = false ; showh = false ; showi = false ; showj = false;
    letrToSend="g";
    //print(letrToSend);
    }
    else{
    showg = false;
    }
 }
  
}
LetgBtn letgBtn;

class LethBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_lethBtnX, _lethBtnY, _lethBtnW, _lethBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  H", _lethBtnX + 25, _lethBtnY + 15, _lethBtnW, _lethBtnH);
 }
 
 void press(){
   if (showh == false){
    showh = true;
    showf = false ; showg = false ; showi = false ; showj = false;
    letrToSend="h";
    //print(letrToSend);
    }
    else{
    showh = false;
    }
 }
  
}
LethBtn lethBtn;

class LetiBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letiBtnX, _letiBtnY, _letiBtnW, _letiBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  I", _letiBtnX + 25, _letiBtnY + 15, _letiBtnW, _letiBtnH);
 }
 
 void press(){
   if (showi == false){
    showi = true;
    showf = false ; showg = false ; showh = false ; showj = false;
    letrToSend="i";
    //print(letrToSend);
    }
    else{
    showi = false;
    }
 }
  
}
LetiBtn letiBtn;

class LetjBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_letjBtnX, _letjBtnY, _letjBtnW, _letjBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("  J", _letjBtnX + 25, _letjBtnY + 15, _letjBtnW, _letjBtnH);
 }
 
 void press(){
    if (showj == false){
    showj = true;
    showf = false ; showg = false ; showh = false ; showi = false;
    letrToSend="j";
    //print(letrToSend);
    }
    else{
    showj = false;
    }
 }
  
}
LetjBtn letjBtn;

class SendBtn {
  
 void display(){
   fill(209); // background color - GRAY
   noStroke();
   rect(_sendBtnX, _sendBtnY, _sendBtnW, _sendBtnH, 15);
   fill(0); // text color
   textSize(42);
   text("Envoyer", _sendBtnX + 25, _sendBtnY + 15, _sendBtnW, _sendBtnH);
 }
 
 void press(){
    /* Send the chosen letter to the Arduino/Bluetooth Shield */
    if(scSocket!=null){
      //print(letrToSend);
      sendReceiveBT = new ConnectedThread(scSocket);
      byte[] myByte = stringToBytesUTFCustom(letrToSend);
      sendReceiveBT.write(myByte);
      //print(myByte);
       for (int q = 0; q<myspeed.length; q++) {
        //println(myspeed [q]);
        if (letrToSend == "a" ||letrToSend == "b" ||letrToSend == "c" ||letrToSend == "d" ||letrToSend == "e" ){
        myspeed [q]=0;
        }
        if (letrToSend == "f" ||letrToSend == "g" ||letrToSend == "h" ||letrToSend == "i" ||letrToSend == "j" ){
        mymmhg [q]=0;
        }
      }
      }
 }
  
}
SendBtn sendBtn;

public static byte[] stringToBytesUTFCustom(String str) {
  print(str);
  char[] buffer = str.toCharArray();
  byte[] b = new byte[buffer.length << 1];
  for (int i = 0; i < buffer.length; i++) {
    int bpos = i << 1;
    b[bpos] = (byte) ((buffer[i]&0xFF00)>>8);
    b[bpos + 1] = (byte) (buffer[i]&0x00FF);
    //print(b);
    
  }
  return b;
}


// **** Android Code for Bluetooth Connection **** //
class ConnectedThread extends Thread {
    private final BluetoothSocket mmSocket;
    private final InputStream mmInStream;
    private final OutputStream mmOutStream;
    private byte[] buffer; // mmBuffer store for the stream

    public ConnectedThread(BluetoothSocket socket) {
        mmSocket = socket;
        InputStream tmpIn = null;
        OutputStream tmpOut = null;
        // Get input and output streams using temp objects because
        // member streams are final
        try {
            tmpIn = socket.getInputStream();
            tmpOut = socket.getOutputStream();
        } catch (IOException e) { }

        mmInStream = tmpIn;
        mmOutStream = tmpOut;
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
        buffer[bytes] = (byte) mmInStream.read();

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
        
        break;
      }
    }
  }
    /* Call this from the main activity to send data to the remote device */
    public void write(byte[] bytes) {
        try {
            mmOutStream.write(bytes);
            // Share the sent message with the UI activity.
               //Message writtenMsg = mHandler.obtainMessage(MESSAGE_WRITE, -1, -1, buffer);
               //writtenMsg.sendToTarget();
               //mHandler.obtainMessage(MESSAGE_WRITE, -1, -1, buffer).sendToTarget();
        } catch (IOException e) { }
    }

    /* Call this from the main activity to shutdown the connection */
    public void cancel() {
        try {
            mmSocket.close();
        } catch (IOException e) { }
    }
}

ConnectedThread connectedThread;

class ConnectThread extends Thread {
 final BluetoothSocket mmSocket;
 final BluetoothDevice mmDevice;

    public ConnectThread(BluetoothDevice device) {
        // Use a temporary object that is later assigned to mmSocket because mmSocket is final.
        BluetoothSocket tmp = null;
        mmDevice = device;

        try {
            // Get a BluetoothSocket to connect with the given BluetoothDevice.
            tmp = device.createRfcommSocketToServiceRecord(UUID.fromString("00001101-0000-1000-8000-00805F9B34FB"));
        } catch (IOException e) {
            println("Socket's create() method failed");
        }
        mmSocket = tmp;
    }

void manageConnectedSocket(BluetoothSocket socket) {
    connectedThread = new ConnectedThread(socket);
    connectedThread.start();
}

    public void run() {
        // Cancel discovery because it otherwise slows down the connection.
        bluetoothAdapter.cancelDiscovery();

        try {
            // Connect to the remote device through the socket. This call blocks
            // until it succeeds or throws an exception.
            mmSocket.connect();
            scSocket=mmSocket;
        } catch (IOException connectException) {
            // Unable to connect; close the socket and return.
            println("Could not connect to the client socket: ", connectException);
            try {
                mmSocket.close();
            } catch (IOException closeException) {
                println("Could not close the client socket: ", closeException);
            }
            return;
        }
     // Connection attempt succeeded; perform work associated with connection in separate thread.
        manageConnectedSocket(mmSocket);
    }
    // Closes the client socket and causes the thread to finish.
    public void cancel() {
        try {
            mmSocket.close();
        } catch (IOException e) {
            println("Could not close the client socket");
        }
    }
}

ConnectThread connectThread;



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
      // On traite les scories d'écritures sur le port série
      readMessage=readMessage.replace("..",".");
      readMessage=readMessage.replace(",,",",");
      readMessage=readMessage.replace("-","");
      //print(readMessage);
      // On découpe le message à chaque virgule, on le stocke dans un tableau
      String [] data = readMessage.split(",");
      
      for (int q = 2; q<=3; q++){
      String ErroredMessage = data[q];
      int lengthErroredMessage = ErroredMessage.length();
      //print(lengthErroredMessage);
        if (lengthErroredMessage > 4){
          data[q+3]=data[q+2];
          data[q+2]=data[q+1];
          data[q]= ErroredMessage.substring(0,4);
          String data2 = data[q];
          //print(data2);
          data[q+1]= ErroredMessage.substring(4);
          String data3 = data[q+1];
          //print(data3);
        }
      }

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

public void DrawWindow(){
  
  connectBtn = new ConnectBtn();
  quitBtn = new QuitBtn();
  viewBtn = new ViewBtn();
  zeroBtn = new ZeroBtn();
  graphBtn = new GraphBtn();
  progBtn = new ProgBtn();
  centBtn = new CentBtn();
  deprBtn = new DeprBtn();
  cumulBtn = new CumulBtn();
  letaBtn = new LetaBtn();
  letbBtn = new LetbBtn();
  letcBtn = new LetcBtn();
  letdBtn = new LetdBtn();
  leteBtn = new LeteBtn();
  letfBtn = new LetfBtn();
  letgBtn = new LetgBtn();
  lethBtn = new LethBtn();
  letiBtn = new LetiBtn();
  letjBtn = new LetjBtn();
  sendBtn = new SendBtn();
  
  frameRate(60);
  
    
  cp5 = new ControlP5(this);
  
  // Font for displaying text 
  myFont = createFont("arial", 54);
  textFont(myFont);
  myFont2 = createFont("arial", 72);
  textFont(myFont2);
  myFont3 = createFont("arial", 42);
  textFont(myFont3);

  myKnobRPM = cp5.addKnob("T/min")
    .setRange(0, 7000)
    .setValue(0)
    .setLabelVisible(false)
    .setPosition(((width/2)-radiusknobA), 140)
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
    .setPosition(((width /2)-250),0)
    .setColorValue(textwhite)
    .setFont(myFont)
    ;   

  myTextlabel1rpm     = cp5.addTextlabel("1rpm")
    .setText("1")
    .setPosition(((width/2)-radiusknobA - 50), (radiusknobA + 150))
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
    .setPosition(((width/2)- radiusknobA + 130), (radiusknobA - 190))
    .setColorValue(textblack)
    .setFont(myFont2)
    ;  

  myTextlabel4rpm     = cp5.addTextlabel("4rpm")
    .setText("4")
    .setPosition(((width/2)+ radiusknobA - 180), (radiusknobA - 190))
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
    .setPosition(((width/2)+ radiusknobA + 30), (radiusknobA + 150))
    .setColorValue(reC)
    .setFont(myFont2)
    ;               

  myTextlabel6rpm     = cp5.addTextlabel("7rpm")
    .setText("7")
    .setPosition(((width/2)+ radiusknobA - 60), (radiusknobA + 350))
    .setColorValue(reC)
    .setFont(myFont2)
    ; 

  myTextlabelSPEED = cp5.addTextlabel("SPEED")
    .setText("0.00")
    .setPosition(((width/2) - 55), (radiusknobA + 10))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 

  myTextlabelSPEEDunit = cp5.addTextlabel("Km/h")
    .setText("Km/h")
    .setPosition(((width/2) - 55), (radiusknobA + 80))
    .setColorValue(textwhite)
    .setFont(myFont)
    ;                    

  myTextlabelRPM = cp5.addTextlabel("RPM")
    .setText("0")
    .setPosition(((width/2) - 55), (radiusknobA + 150))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                

  myTextlabelRPMunit = cp5.addTextlabel("T min")
    .setText("T/min")
    .setPosition(((width/2) - 55), (radiusknobA + 220))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;

  myTextlabelDEP = cp5.addTextlabel("DEP")
    .setText("0")
    .setPosition((marginEdge + radiusknobB - 50), ((height/2)- 20))
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
    .setPosition((width- radiusknobC - marginEdge) - 50, ((height/2)- 20))
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
    .setPosition(((width/2)-50), ((height - 2.5 * radiusknobD)+ 10))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ;                     

  myTextlabelTOTunit = cp5.addTextlabel("° AV TOT")
    .setText("° Av Tot")
    .setPosition(((width/2)-70), ((height - 2.5 * radiusknobD)+ 90))
    .setColorValue(0xffffff00)
    .setFont(myFont)
    ; 

  myTextlabelDIST = cp5.addTextlabel("DIST")
    .setText("0000.0")
    .setDecimalPrecision(2)
    .setPosition(((width/2)-60), ((height - 2.5 * radiusknobD)+ 160))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 

  myTextlabelDISTunit = cp5.addTextlabel("KM")
    .setText("Km")
    .setPosition(((width/2)-40), ((height - 2.5 * radiusknobD)+ 230))
    .setColorValue(textwhite)
    .setFont(myFont)
    ; 

   if (connectSelected == true) {
      background(255, 210, 255); // purple screen
      fill(blaC);
      rect(0, 0, width, 60);
      deviceDisplay.display();
      if(deviceListDrop == true) {
         deviceList.display();
        }
      connectBtn.display();
      viewBtn.display();

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
   } else {
      background(200, 255, 165); // green screen
      fill(blaC);
      rect(0, 0, width, 60);
      //background(200, 255, 165); // green screen
      // maintains display of buttons 
      deviceDisplay.display();
      if(deviceListDrop == true) {
         deviceList.display();
        }
      connectBtn.display();
      viewBtn.display();
      zeroBtn.display();
      graphBtn.display();
      quitBtn.display();
      progBtn.display();
    }

}

void setup() {
  fullScreen();
  orientation(PORTRAIT); 
  requestPermission("android.permission.ACCESS_FINE_LOCATION", "initLocation");
  findPairedBluetoothDevices();
  deviceDisplay = new DeviceDisplay();
  deviceList = new DeviceList();
  deviceListDrop = false;
  DrawWindow();
  firstpage=true;
  
}

void draw() {
    
  if (connectSelected == true) {
      background(255, 210, 255); // purple screen
      fill(blaC);
      rect(0, 0, width, 60);
      deviceDisplay.display();
      if(deviceListDrop == true) {
         deviceList.display();
        }
      connectBtn.display();
      viewBtn.display();
      zeroBtn.display();
      graphBtn.display();
      quitBtn.display();
      progBtn.display();

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
      
    } else {
      background(200, 255, 165); // green screen
      fill(blaC);
      rect(0, 0, width, 60);
      //background(200, 255, 165); // green screen
      // maintains display of buttons 
      deviceDisplay.display();
      if(deviceListDrop == true) {
         deviceList.display();
        }
      connectBtn.display();
      viewBtn.display();
      zeroBtn.display();
      graphBtn.display();
      quitBtn.display();
      progBtn.display();
    }
 
}

// traps button touches
void mousePressed(){
 if((mouseX >= _deviceArrwX) && (mouseX <= _deviceArrwX+_deviceArrwSize) && (mouseY >= _deviceArrwY) && (mouseY <= _deviceArrwY+_deviceArrwSize)){
  deviceDisplay.press();
 }  
 if(deviceListDrop) {
  if((mouseX >= _deviceDisplayX) && (mouseX <= _deviceDisplayX + _deviceDisplayW) && (mouseY >= _deviceDisplayY + _deviceDisplayH) && (mouseY <= _deviceDisplayY + _deviceDisplayH + deviceArray.length*_deviceItemH)) {
    deviceList.press(mouseX, mouseY);
   }
 }
  
 if((mouseX >= _connectBtnX) && (mouseX <= _connectBtnX+_connectBtnW) && (mouseY >= _connectBtnY) && (mouseY <= _connectBtnY+_connectBtnH)){
  connectBtn.press();
 }

 if((mouseX >= _quitBtnX) && (mouseX <= _quitBtnX + _quitBtnW) && (mouseY >= _quitBtnY) && (mouseY <= _quitBtnY + _quitBtnH)){
  quitBtn.press();
 }
 
 if((mouseX >= _viewBtnX) && (mouseX <= _viewBtnX + _viewBtnW) && (mouseY >= _viewBtnY) && (mouseY <= _viewBtnY + _viewBtnH)){
  viewBtn.press();
 }
 
  if((mouseX >= _zeroBtnX) && (mouseX <= _zeroBtnX + _zeroBtnW) && (mouseY >= _zeroBtnY) && (mouseY <= _zeroBtnY + _zeroBtnH)){
  zeroBtn.press();
 }
 
  if((mouseX >= _graphBtnX) && (mouseX <= _graphBtnX + _graphBtnW) && (mouseY >= _graphBtnY) && (mouseY <= _graphBtnY + _graphBtnH)){
  graphBtn.press();
 }
 
  if((mouseX >= _centBtnX) && (mouseX <= _centBtnX + _centBtnW) && (mouseY >= _centBtnY) && (mouseY <= _centBtnY + _centBtnH)){
  centBtn.press();
 }
 
  if((mouseX >= _deprBtnX) && (mouseX <= _deprBtnX + _deprBtnW) && (mouseY >= _deprBtnY) && (mouseY <= _deprBtnY + _deprBtnH)){
  deprBtn.press();
 }
 
  if((mouseX >= _cumulBtnX) && (mouseX <= _cumulBtnX + _cumulBtnW) && (mouseY >= _cumulBtnY) && (mouseY <= _cumulBtnY + _cumulBtnH)){
  cumulBtn.press();
 }
 
 if((mouseX >= _progBtnX) && (mouseX <= _progBtnX + _progBtnW) && (mouseY >= _progBtnY) && (mouseY <= _progBtnY + _progBtnH)){
  progBtn.press();
 }
 
 if((mouseX >= _letaBtnX) && (mouseX <= _letaBtnX + _letaBtnW) && (mouseY >= _letaBtnY) && (mouseY <= _letaBtnY + _letaBtnH)){
  letaBtn.press();
 }
 
 if((mouseX >= _letbBtnX) && (mouseX <= _letbBtnX + _letbBtnW) && (mouseY >= _letbBtnY) && (mouseY <= _letbBtnY + _letbBtnH)){
  letbBtn.press();
 }
 
 if((mouseX >= _letcBtnX) && (mouseX <= _letcBtnX + _letcBtnW) && (mouseY >= _letcBtnY) && (mouseY <= _letcBtnY + _letcBtnH)){
  letcBtn.press();
 }
 
  if((mouseX >= _letdBtnX) && (mouseX <= _letdBtnX + _letdBtnW) && (mouseY >= _letdBtnY) && (mouseY <= _letdBtnY + _letdBtnH)){
  letdBtn.press();
 }
 
 if((mouseX >= _leteBtnX) && (mouseX <= _leteBtnX + _leteBtnW) && (mouseY >= _leteBtnY) && (mouseY <= _leteBtnY + _leteBtnH)){
  leteBtn.press();
 }
 
 if((mouseX >= _letfBtnX) && (mouseX <= _letfBtnX + _letfBtnW) && (mouseY >= _letfBtnY) && (mouseY <= _letfBtnY + _letfBtnH)){
  letfBtn.press();
 }
 
 if((mouseX >= _letgBtnX) && (mouseX <= _letgBtnX + _letgBtnW) && (mouseY >= _letgBtnY) && (mouseY <= _letgBtnY + _letgBtnH)){
  letgBtn.press();
 }
 
 if((mouseX >= _lethBtnX) && (mouseX <= _lethBtnX + _lethBtnW) && (mouseY >= _lethBtnY) && (mouseY <= _lethBtnY + _lethBtnH)){
  lethBtn.press();
 }
 
 if((mouseX >= _letiBtnX) && (mouseX <= _letiBtnX + _letiBtnW) && (mouseY >= _letiBtnY) && (mouseY <= _letiBtnY + _letiBtnH)){
  letiBtn.press();
 }
 
  if((mouseX >= _letjBtnX) && (mouseX <= _letjBtnX + _letjBtnW) && (mouseY >= _letjBtnY) && (mouseY <= _letjBtnY + _letjBtnH)){
  letjBtn.press();
 }
 
  if((mouseX >= _sendBtnX) && (mouseX <= _sendBtnX + _sendBtnW) && (mouseY >= _sendBtnY) && (mouseY <= _sendBtnY + _sendBtnH)){
  sendBtn.press();
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
    ycentOrigin = height-250;
    xdepOrigin = (( width/2 ) - ( rangeMmhg/2 )); // Position du graphique de l'avance dépression
    ydepOrigin = ((height/2)-250);

    mylastx = ( xcentOrigin + rangeSpeed +1 ); // +1 pour finir de tracer le cadrillage
    mylasty = ( ycentOrigin - rangeCent -1 ); // -1 pour finir de tracer le cadrillage
    mylastxdep = ( xdepOrigin + rangeMmhg +1 ); // +1 pour finir de tracer le cadrillage
    mylastydep = ( ydepOrigin - rangeDep -1 ); // -1 pour finir de tracer le cadrillage
  }  

  public void draw(PGraphics pg) {

    firstpage=false;
    
    pg.background(250, 220, 150);
    pg.stroke(0);
    pg.strokeWeight(0);  // Epaisseur du trait

    // Trace le cadrillage de l'avance centrifuge
    for (int i = xcentOrigin; i < mylastx; i = i+ int(75 * CoefRangeX)) 
    {
      pg.line(i, mylasty, i, ycentOrigin);// ligne verticale
    }
    for (int i = ycentOrigin; i > mylasty; i = i- int(75 * CoefRangeY)) 
    {
      pg.line(xcentOrigin, i, mylastx, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance centrifuge", ((width/2)-220), (ycentOrigin-((75 * 4 * CoefRangeY)+50)));
    
    pg.text(0, xcentOrigin+((75 * 0 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(1, xcentOrigin+((75 * 1 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(2, xcentOrigin+((75 * 2 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(3, xcentOrigin+((75 * 3 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(4, xcentOrigin+((75 * 4 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(5, xcentOrigin+((75 * 5 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(6, xcentOrigin+((75 * 6 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(7, xcentOrigin+((75 * 7 * CoefRangeX)-20), ycentOrigin+50);

    pg.text(5, xcentOrigin-50, ycentOrigin-(75 * 1 * CoefRangeY));
    pg.text(10, xcentOrigin-80, ycentOrigin-(75 * 2 * CoefRangeY));
    pg.text(15, xcentOrigin-80, ycentOrigin-(75 * 3 * CoefRangeY));

    pg.textFont(myFont3);
    pg.text("x 1000 t/min", xcentOrigin+((75 * 6 * CoefRangeX)-50), ycentOrigin+100);
    pg.text("d°", xcentOrigin-50, ycentOrigin-(75 * 4 * CoefRangeY));
    pg.textFont(myFont);

    // Trace le cadrillage de l'avance dépression
    for (int i = xdepOrigin; i < mylastxdep; i = i+ int(75 * CoefRangeX)) 
    {
      pg.line(i, mylastydep, i, ydepOrigin);// ligne verticale
    }
    for (int i = ydepOrigin; i > mylastydep; i = i- int(75 * CoefRangeY)) 
    {
      pg.line(xdepOrigin, i, mylastxdep, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance dépression", ((width/2)-220), (ydepOrigin-((75 * 4 * CoefRangeY)+50)));
    
    pg.text(10, xdepOrigin-80, ydepOrigin-(75 * 1 * CoefRangeY));
    pg.text(20, xdepOrigin-80, ydepOrigin-(75 * 2 * CoefRangeY));
    pg.text(30, xdepOrigin-80, ydepOrigin-(75 * 3 * CoefRangeY));

    pg.textFont(myFont3);
    pg.text(0, xdepOrigin+((75 * 0 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(50, xdepOrigin+((75 * 1 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(100, xdepOrigin+((75 * 2 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(150, xdepOrigin+((75 * 3 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(200, xdepOrigin+((75 * 4 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(250, xdepOrigin+((75 * 5 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(300, xdepOrigin+((75 * 6 * CoefRangeX)-20), ydepOrigin+50);

    pg.text("mmhg", xdepOrigin+((75 * 6 * CoefRangeX)-50), ydepOrigin+100);
    pg.text("d°", xdepOrigin-50, ydepOrigin-(75 * 4 * CoefRangeY));
    pg.textFont(myFont);
    
    pg.text("Avance Statique", ((width/2)-200), ((height/2)-80));
    pg.fill(whiC);
    pg.rect(((width/2)-60), (height/2)-30, 100, 80);
    pg.fill(blaC);
    pg.text(str(staticValue), ((width/2)-40), ((height/2)+30));
    pg.text("d°", ((width/2)+50), ((height/2)+30));

    pg.strokeWeight(6);  // Epaisseur du trait

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
        pg.stroke(reC);
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
//********************************************************************************************************        
    // Trace en filigranne la courbe constructeur
    for (int q = 0; q<Na.length; q++) {
      float xr = Na[q];
      float yr = Anga [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
     
      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
                
        pg.stroke(blaC);
        pg.strokeWeight(2);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
               
      }
    }
    for (int q = 0; q<Nf.length; q++) {
      float xrdep = Nf[q];
      float yrdep = Angf [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      
      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        
        pg.stroke(blaC);
        pg.strokeWeight(2);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
              
      }
    }
    // Entête et bouton "Quitter"
    pg.fill(0);
    pg.rect(0, 0,width,60);
    pg.fill(whiC);
    pg.text("aecp pour smartphone", ((width/2)-250), 40);
    quitBtn.display();
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
    
    xtotOrigin = ((( width/2 ) +10) - ( rangeTime/2 )); // Position du graphique de l'avance centrifuge
    ytotOrigin = height-300;
    
    mylastxtot = ( xtotOrigin + rangeTime +1 ); // +1 pour finir de tracer le cadrillage
    mylastytot = ( ytotOrigin - rangeTot -1 ); // -1 pour finir de tracer le cadrillage
    
  }  

  public void draw(PGraphics pg) {

    firstpage=false;
    
    pg.background(250, 220, 150);
    pg.stroke(0);
    pg.strokeWeight(0);  // Epaisseur du trait

    // Trace le cadrillage de l'avance totale
    for (int i = xtotOrigin; i < mylastxtot; i = i+int(65 * CoefRangeTotX)) 
    {
      pg.line(i, mylastytot, i, ytotOrigin);// ligne verticale
    }
    for (int i = ytotOrigin; i > mylastytot; i = i-int(65 * CoefRangeTotY)) 
    {
      pg.line(xtotOrigin, i, mylastxtot, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("    ", xtotOrigin+35,ytotOrigin+60);
    pg.text("    ", xtotOrigin+135,ytotOrigin+60);
    pg.text("    ", mylastxtot-185,ytotOrigin+60);
    pg.text("    ", mylastxtot-85,ytotOrigin+60);
    
    pg.text(nfc(pressionValue,1), xtotOrigin+05,ytotOrigin+80);
    pg.text(nfc(delayValue,1), xtotOrigin+135,ytotOrigin+80);
    pg.text(nfc((avtotValue-delayValue-pressionValue),1), mylastxtot-205,ytotOrigin+80);
    pg.fill(puC);
    pg.text(nfc(avtotValue,1), mylastxtot-85,ytotOrigin+80);
    
    pg.fill(blaC);
    pg.text("Avance totale", ((width/2)-180), (ytotOrigin-((65 * 13 * CoefRangeTotY)+50)));
    
    pg.text(5, xtotOrigin-50, ytotOrigin-(65 * 1 * CoefRangeTotY));
    pg.text(10, xtotOrigin-80, ytotOrigin-(65 * 2 * CoefRangeTotY));
    pg.text(15, xtotOrigin-80, ytotOrigin-(65 * 3 * CoefRangeTotY));
    pg.text(20, xtotOrigin-80, ytotOrigin-(65 * 4 * CoefRangeTotY));
    pg.text(25, xtotOrigin-80, ytotOrigin-(65 * 5 * CoefRangeTotY));
    pg.text(30, xtotOrigin-80, ytotOrigin-(65 * 6 * CoefRangeTotY));
    pg.text(35, xtotOrigin-80, ytotOrigin-(65 * 7 * CoefRangeTotY));
    pg.text(40, xtotOrigin-80, ytotOrigin-(65 * 8 * CoefRangeTotY));
    pg.text(45, xtotOrigin-80, ytotOrigin-(65 * 9 * CoefRangeTotY));
    pg.text(50, xtotOrigin-80, ytotOrigin-(65 * 10 * CoefRangeTotY));
    pg.text(55, xtotOrigin-80, ytotOrigin-(65 * 11 * CoefRangeTotY));
    pg.text(60, xtotOrigin-80, ytotOrigin-(65 * 12 * CoefRangeTotY));

    pg.textFont(myFont3);
    pg.text("d°", xtotOrigin-50, ytotOrigin-(65 * 13 * CoefRangeTotY));
    pg.text("dep", xtotOrigin+35,ytotOrigin+30);
    pg.text("cent", xtotOrigin+155,ytotOrigin+30);
    pg.text("fix", mylastxtot-175,ytotOrigin+30);
    pg.text("tot", mylastxtot-55,ytotOrigin+30);
    
    pg.fill(whiC);
    pg.rect(((width/2)-460), (height-110), 160, 100);
    pg.rect((width-210), (height-110), 160, 100);
    pg.fill(blaC);
    pg.text("Av moyenne", ((width/2)-490),(height-140) );
    pg.text("Av crête", (width-210),(height-140) );
    pg.textFont(myFont2);
    pg.text(nfc(advCurrentAverage,1), ((width/2)-445),(height-30) );
    pg.text(nfc(advPeakmesure,1), (width-195),(height-30) );
    
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
       pg.strokeWeight(6);  // Epaisseur du trait
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
       pg.strokeWeight(6);  // Epaisseur du trait
       pg.stroke(reC);
       pg.line((xtotOrigin+lastxrdep),(ytotOrigin-lastyrdepsingle),(xtotOrigin+xrdep),(ytotOrigin-yrdepsingle));
       pg.fill(reC);
       pg.rect(xtotOrigin+05,ytotOrigin+10,20,20,3);
      }
      }
      if (showtot == true){
        if (yrdep == 0){ }
      else{
       pg.strokeWeight(6);  // Epaisseur du trait
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
       pg.rect(xtotOrigin+05,ytotOrigin+10,20,20,3);
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
       pg.rect(mylastxtot-205,ytotOrigin+10,20,20,3);
      }
      
    }
   }
   // Entête et bouton "Quitter"
    pg.stroke(0);
    pg.fill(0);
    pg.rect(0, 0,width,60);
    pg.fill(whiC);
    pg.text("aecp pour smartphone", ((width/2)-250), 40);
    quitBtn.display();
    centBtn.display();
    deprBtn.display();
    cumulBtn.display();
  }
}

// MyCanvas, your Canvas render class
class MyCanvasCUR extends Canvas {

  int mylastx = 0;
  int mylasty = 0;
  int mylastxdep = 0;
  int mylastydep = 0;

  public void setup(PGraphics pg) {
    xcentOrigin = (( width/2 ) - ( rangeSpeed/2 )); // Position du graphique de l'avance centrifuge
    ycentOrigin = height-210;
    xdepOrigin = (( width/2 ) - ( rangeMmhg/2 )); // Position du graphique de l'avance dépression
    ydepOrigin = ((height/2)-180);

    mylastx = ( xcentOrigin + rangeSpeed +1 ); // +1 pour finir de tracer le cadrillage
    mylasty = ( ycentOrigin - rangeCent -1 ); // -1 pour finir de tracer le cadrillage
    mylastxdep = ( xdepOrigin + rangeMmhg +1 ); // +1 pour finir de tracer le cadrillage
    mylastydep = ( ydepOrigin - rangeDep -1 ); // -1 pour finir de tracer le cadrillage
  }  

  public void draw(PGraphics pg) {

    firstpage=false;
    
    pg.background(250, 220, 150);
    pg.stroke(0);
    pg.strokeWeight(0);  // Epaisseur du trait

    // Trace le cadrillage de l'avance centrifuge
    for (int i = xcentOrigin; i < mylastx; i = i+ int(75 * CoefRangeX)) 
    {
      pg.line(i, mylasty, i, ycentOrigin);// ligne verticale
    }
    for (int i = ycentOrigin; i > mylasty; i = i- int(75 * CoefRangeY)) 
    {
      pg.line(xcentOrigin, i, mylastx, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance centrifuge", ((width/2)-220), (ycentOrigin-((75 * 4 * CoefRangeY)+50)));
    
    pg.text(0, xcentOrigin+((75 * 0 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(1, xcentOrigin+((75 * 1 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(2, xcentOrigin+((75 * 2 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(3, xcentOrigin+((75 * 3 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(4, xcentOrigin+((75 * 4 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(5, xcentOrigin+((75 * 5 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(6, xcentOrigin+((75 * 6 * CoefRangeX)-20), ycentOrigin+50);
    pg.text(7, xcentOrigin+((75 * 7 * CoefRangeX)-20), ycentOrigin+50);

    pg.text(5, xcentOrigin-50, ycentOrigin-(75 * 1 * CoefRangeY));
    pg.text(10, xcentOrigin-80, ycentOrigin-(75 * 2 * CoefRangeY));
    pg.text(15, xcentOrigin-80, ycentOrigin-(75 * 3 * CoefRangeY));

    pg.textFont(myFont3);
    pg.text("x 1000 t/min", xcentOrigin+((75 * 6 * CoefRangeX)-50), ycentOrigin+100);
    pg.text("d°", xcentOrigin-50, ycentOrigin-(75 * 4 * CoefRangeY));
    pg.textFont(myFont);

    // Trace le cadrillage de l'avance dépression
    for (int i = xdepOrigin; i < mylastxdep; i = i+ int(75 * CoefRangeX)) 
    {
      pg.line(i, mylastydep, i, ydepOrigin);// ligne verticale
    }
    for (int i = ydepOrigin; i > mylastydep; i = i- int(75 * CoefRangeY)) 
    {
      pg.line(xdepOrigin, i, mylastxdep, i); // ligne horizontale
    }

    pg.fill(blaC);
    pg.text("Avance dépression", ((width/2)-220), (ydepOrigin-((75 * 4 * CoefRangeY)+50)));
    
    pg.text(10, xdepOrigin-80, ydepOrigin-(75 * 1 * CoefRangeY));
    pg.text(20, xdepOrigin-80, ydepOrigin-(75 * 2 * CoefRangeY));
    pg.text(30, xdepOrigin-80, ydepOrigin-(75 * 3 * CoefRangeY));

    pg.textFont(myFont3);
    pg.text(0, xdepOrigin+((75 * 0 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(50, xdepOrigin+((75 * 1 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(100, xdepOrigin+((75 * 2 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(150, xdepOrigin+((75 * 3 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(200, xdepOrigin+((75 * 4 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(250, xdepOrigin+((75 * 5 * CoefRangeX)-20), ydepOrigin+50);
    pg.text(300, xdepOrigin+((75 * 6 * CoefRangeX)-20), ydepOrigin+50);

    pg.text("mmhg", xdepOrigin+((75 * 6 * CoefRangeX)-50), ydepOrigin+100);
    pg.text("d°", xdepOrigin-50, ydepOrigin-(75 * 4 * CoefRangeY));
    pg.textFont(myFont);
    
    pg.fill(whiC);
    pg.rect(((width/2)+180), (ycentOrigin-100), 120, 80);
    pg.rect(((width/2)+180), (ydepOrigin-100), 120, 80);
    pg.fill(blaC);
    pg.text("Courbe a charger", ((width/2)+5),(ycentOrigin-120) );
    pg.text("Courbe a charger", ((width/2)+5),(ydepOrigin-120) );
    pg.textFont(myFont2);
    pg.fill(reC);
    if (letrToSend == "a" ||letrToSend == "b" ||letrToSend == "c" ||letrToSend == "d" ||letrToSend == "e" ){
    pg.text(letrToSend, ((width/2)+220), (ycentOrigin-40) );
    showf = false ;showg = false ; showh = false ; showi = false ; showj = false;
    }
    else {
    pg.text(letrToSend, ((width/2)+220), (ydepOrigin-40) );
    showa = false ;showb = false ; showc = false ; showd = false ; showe = false;
    }
    pg.textFont(myFont);
    pg.fill(blaC);

    pg.strokeWeight(3);  // Epaisseur du trait
/* **************************************************** */
    
      for (int q = 0; q<Na.length; q++) {
      //String send = " ";
      float xr = Na[q];
      float yr = Anga [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
      //println(xr);
      //println(yr);

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
        if (showa == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        
      }
    }
/* ************************************************* */
    
      for (int q = 0; q<Nb.length; q++) {
      //String send = " ";
      float xr = Nb[q];
      float yr = Angb [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
      //println(xr);
      //println(yr);

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
        if (showb == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        
      }
    }
/* ************************************************* */
      
      for (int q = 0; q<Nc.length; q++) {
      //String send = " ";
      float xr = Nc[q];
      float yr = Angc [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
      //println(xr);
      //println(yr);

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
        if (showc == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        
      }
    }    
    

/* *************************************************** */

          
      for (int q = 0; q<Nd.length; q++) {
      //String send = " ";
      float xr = Nd[q];
      float yr = Angd [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
      //println(xr);
      //println(yr);

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
        if (showd == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        
      }
    }

/* *************************************************** */

      for (int q = 0; q<Ne.length; q++) {
      //String send = " ";
      float xr = Ne[q];
      float yr = Ange [q];
      xr = xr/coefSpeed;
      yr = yr*(coefCent);
      //println(xr);
      //println(yr);

      if ( xr < lastxr ) {
        lastxr = 0;
        lastyr = 0;
      }

      if (yr == 0 ) {
      } else {
        if (showe == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xcentOrigin+lastxr, ycentOrigin-lastyr, xcentOrigin+xr, ycentOrigin-yr);
        lastxr = int(xr);
        lastyr = yr;
       }
        
      }
    }    
    

/* *************************************************** */
      
      for (int q = 0; q<Nf.length; q++) {
      //String send = " ";
      float xrdep = Nf[q];
      float yrdep = Angf [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      //println(xrdep);
      //println(yrdep);

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        if (showf == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        
      }
    }
/* ************************************************* */
    
      for (int q = 0; q<Ng.length; q++) {
      //String send = " ";
      float xrdep = Ng[q];
      float yrdep = Angg [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      //println(xrdep);
      //println(yrdep);

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        if (showg == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        
      }
    }
/* ************************************************* */
    
      for (int q = 0; q<Nh.length; q++) {
      //String send = " ";
      float xrdep = Nh[q];
      float yrdep = Angh [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      //println(xrdep);
      //println(yrdep);

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        if (showh == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        
      }
    }
/* ************************************************* */
    
      for (int q = 0; q<Ni.length; q++) {
      //String send = " ";
      float xrdep = Ni[q];
      float yrdep = Angi [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      //println(xrdep);
      //println(yrdep);

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        if (showi == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        
      }
    }
/* ************************************************* */
    
      for (int q = 0; q<Nj.length; q++) {
      //String send = " ";
      float xrdep = Nj[q];
      float yrdep = Angj [q];
      xrdep = xrdep*coefMmhg;
      yrdep = yrdep*(coefDep);
      //println(xrdep);
      //println(yrdep);

      if ( xrdep < lastxrdep ) {
        lastxrdep = 0;
        lastyrdep = 0;
      }

      if (yrdep == 0 ) {
      } else {
        if (showj == true){
        pg.stroke(reC);
        pg.strokeWeight(6);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        else {
        pg.stroke(blaC);
        pg.strokeWeight(3);  // Epaisseur du trait
        pg.line(xdepOrigin+lastxrdep, ydepOrigin-lastyrdep, xdepOrigin+xrdep, ydepOrigin-yrdep);
        lastxrdep = int(xrdep);
        lastyrdep = yrdep;
       }
        
      }
    }
/* ************************************************* */
      // Entête et bouton "Quitter"
      pg.stroke(0);
      pg.fill(0);
      pg.rect(0, 0,width,60);
      pg.fill(whiC);
      pg.text("aecp pour smartphone", ((width/2)-250), 40);
      quitBtn.display();
      letaBtn.display();
      letbBtn.display();
      letcBtn.display();
      letdBtn.display();
      leteBtn.display();
      letfBtn.display();
      letgBtn.display();
      lethBtn.display();
      letiBtn.display();
      letjBtn.display();
      sendBtn.display();
    
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
  int d = int(mmhgValue * coefMmhg);
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

// Override the activity class methods
void onResume()
{
  super.onResume();

  locationListener = new MyLocationListener();
  locationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);    

  // Register the listener with the Location Manager to receive location updates
  //locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 500, 1, locationListener);
}

void onPause()
{
  super.onPause();
}

void initLocation(boolean granted) {
  if (granted) {    
    Context context = getContext();
    locationListener = new MyLocationListener();
    locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);    
    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 500, 1, locationListener);
    hasLocation = true;
  } else {
    hasLocation = false;
  }
}
/*****************************************************************/

class MyLocationListener implements LocationListener {
  

  private Location lastLocation = null;
  private double calculatedSpeed = 0;
  // Define all LocationListener methods
  public void onLocationChanged(Location location) {
  // Save new GPS data
    currentLatitude  = (float)location.getLatitude();
    currentLongitude = (float)location.getLongitude();
    currentAccuracy  = (float)location.getAccuracy();
    println(currentLatitude);
    println(currentLongitude);
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
