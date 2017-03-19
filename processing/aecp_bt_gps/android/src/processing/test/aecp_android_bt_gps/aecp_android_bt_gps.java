package processing.test.aecp_android_bt_gps;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
import android.os.Bundle; 
import android.bluetooth.BluetoothServerSocket; 
import android.bluetooth.BluetoothSocket; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class aecp_android_bt_gps extends PApplet {

/*Interface pour allumage \u00e9lectronique cartographique pour Panhard
cr\u00e9ez sous Processing 3.3 pour smartphone sous Android 4.4.2
Adaptation du code issu du commentaire ci-dessous */
/* ConnectBluetooth: Written by ScottC on 18 March 2013 using 
 Processing version 2.0b8
 Tested on a Samsung Galaxy SII, with Android version 2.3.4
 Android ADK - API 10 SDK platform */

// Import needed Android libs


























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
String currentProvider = "";

int myColorBackground = color(150,150,150);
int knobValue = 100;
int radiusknobA = 135;
int radiusknobB = 100;
int radiusknobC = 100;
int radiusknobD = 115;

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



boolean foundDevice=false; //When true, the screen turns green.
boolean BTisConnected=false; //When true, the screen turns purple.

PFont myFont ;
PFont myFont2 ;

char HEADERSPEED = 'S'; // C'est le caract\u00e8re que l'on a ins\u00e9r\u00e9 avant la valeur de vitesse

int speedValue; // Une variable pour stocker la valeur de vitesse
float pressionValue; // Une variable qui stocke le nombre de degr\u00e9 de d\u00e9pression
float delayValue; // Une variable pour stocker la valeur du d\u00e9lai
float avtotValue; // Une variable pour stocker la valeur du d\u00e9lai d'un degr\u00e9

int blaC = color(0,0,0); // noir
int oraC = color(245,110,5); // orange
int blC = color(10,10,255); // bleu
int reC = color(255,10,10);// rouge
int grC = color(10,255,10); // vert
int yeC = color(252,252,41,255); // jaune
int goC = color(175,152,18); // or
int textblack = color(0); // \u00e9crit du texte en noir
int textwhite = color(255); // \u00e9crit du texte en blanc

// Message types used by the Handler
public static final int MESSAGE_WRITE = 1;
public static final int MESSAGE_READ = 2;
String readMessage="";
String[] sData = new String[10];

boolean hasSpeed;
float speed;

//Used to send bytes to the Arduino
SendReceiveBytes sendReceiveBT = null;

//Get the default Bluetooth adapter
BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();

// Loading a font for displaying text 


/*The startActivityForResult() within setup() launches an 
 Activity which is used to request the user to turn Bluetooth on. 
 The following onActivityResult() method is called when this 
 Activity exits. */
@Override
public void onActivityResult(int requestCode, int resultCode, Intent data){
 if(requestCode==0){
 if(resultCode == getActivity().RESULT_OK){
 ToastMaster("Bluetooth has been switched ON");
 } else {
 ToastMaster("You need to turn Bluetooth ON !!!");
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
 // On d\u00e9coupe le message \u00e0 chaque virgule, on le stocke dans un tableau
 String [] data = readMessage.split(",");

//Message re\u00e7u pour la vitesse
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
 
 
 }
 break;
 }
 }
};



public void setup(){
 orientation(PORTRAIT);
 
  noStroke();
  fill(0);
  
  myFont = createFont("arial",34);
  textFont(myFont);
  myFont2 = createFont("arial",38);
  textFont(myFont2);
  
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
 if (!bluetooth.isDiscovering()){
 bluetooth.startDiscovery();
 }
 }
 cp5 = new ControlP5(this);
  
  myKnobRPM = cp5.addKnob("T/min")
               .setRange(0,7000)
               .setValue(0)
               .setLabelVisible(false)
               .setPosition(((width/2)-radiusknobA),90)
               .setRadius(radiusknobA)
               .setNumberOfTickMarks(7)
               .setTickMarkLength(6)
               .setTickMarkWeight(5.0f)
               .setColorForeground(color(255))
               .setColorActive(color(255,0,0))
               .snapToTickMarks(false)
               ;
                     
  myKnobDEP = cp5.addKnob("AV Dep")
               .setStartAngle(3.14f)
               .setAngleRange(3.14f)
               .setShowAngleRange(true)
               .setRange(0,20)
               .setValue(0)
               .setLabelVisible(false)
               .setPosition(25,355)
               .setRadius(radiusknobB)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(5)
               .setTickMarkWeight(3.0f)
               .snapToTickMarks(false)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               ;
               
  myKnobCENT = cp5.addKnob("AV Cent")
               .setStartAngle(3.14f)
               .setAngleRange(3.14f)
               .setShowAngleRange(true)
               .setRange(0,20)
               .setValue(0)
               .setLabelVisible(false)
               .setPosition((width/2)+20,355)
               .setRadius(radiusknobC)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(5)
               .setTickMarkWeight(3.0f)
               .snapToTickMarks(false)
               .setColorForeground(color(255))
               .setColorBackground(color(10, 220, 20))
               .setColorActive(color(255,255,0))
               ;
               
  myKnobTOT = cp5.addKnob("AV Total")
               .setRange(0,50)
               .setValue(0)
               .setLabelVisible(false)
               .setPosition(((width/2)-radiusknobD),555)
               .setRadius(radiusknobD)
               .setNumberOfTickMarks(25)
               .setTickMarkLength(5)
               .setTickMarkWeight(3.0f)
               .snapToTickMarks(false)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 80, 100))
               .setColorActive(color(255,255,0))
               ;
                 
 myTextlabelTitle = cp5.addTextlabel("aecp pour smartphone")
                    .setText("aecp pour smartphone")
                    .setPosition(70,5)
                    .setColorValue(textwhite)
                    .setFont(myFont)
                    ;   
                    
 myTextlabel1rpm     = cp5.addTextlabel("1rpm")
                    .setText("1")
                    .setPosition(65,220)
                    .setColorValue(textblack)
                    .setFont(myFont2)
                    ;
                    
 myTextlabel2rpm     = cp5.addTextlabel("2rpm")
                    .setText("2")
                    .setPosition(80,120)
                    .setColorValue(textblack)
                    .setFont(myFont2)
                    ;
 
 myTextlabel3rpm     = cp5.addTextlabel("3rpm")
                    .setText("3")
                    .setPosition(160,55)
                    .setColorValue(textblack)
                    .setFont(myFont2)
                    ;  
                    
 myTextlabel4rpm     = cp5.addTextlabel("4rpm")
                    .setText("4")
                    .setPosition(280,55)
                    .setColorValue(textblack)
                    .setFont(myFont2)
                    ;                   
                    
 myTextlabel5rpm     = cp5.addTextlabel("5rpm")
                    .setText("5")
                    .setPosition(370,120)
                    .setColorValue(textblack)
                    .setFont(myFont2)
                    ;              
 myTextlabel6rpm     = cp5.addTextlabel("6rpm")
                    .setText("6")
                    .setPosition(390,220)
                    .setColorValue(reC)
                    .setFont(myFont2)
                    ;               
                  
 myTextlabel6rpm     = cp5.addTextlabel("7rpm")
                    .setText("7")
                    .setPosition(350,310)
                    .setColorValue(reC)
                    .setFont(myFont2)
                    ; 
                  
 myTextlabelRPM = cp5.addTextlabel("RPM")
                    .setText("0")
                    .setPosition(195,260)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;                
                  
 myTextlabelRPMunit = cp5.addTextlabel("T min")
                    .setText("T/min")
                    .setPosition(190,300)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;
 
 myTextlabelDEP = cp5.addTextlabel("DEP")
                    .setText("0")
                    .setPosition(90,470)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;                   
                    
 myTextlabelDEPunit = cp5.addTextlabel("\u00b0 DEP")
                    .setText("\u00b0 Dep")
                    .setPosition(70,510)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;               
 
 myTextlabelCENT = cp5.addTextlabel("CENT")
                    .setText("0")
                    .setPosition(320,470)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;                   
                     
 myTextlabelCENTunit = cp5.addTextlabel("\u00b0 CENT")
                    .setText("\u00b0 Cent")
                    .setPosition(300,510)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ; 
                    
 myTextlabelTOT = cp5.addTextlabel("AV TOT")
                    .setText("0")
                    .setPosition(205,700)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ;                     
                    
 myTextlabelTOTunit = cp5.addTextlabel("\u00b0 AV TOT")
                    .setText("\u00b0 Av Tot")
                    .setPosition(170,740)
                    .setColorValue(0xffffff00)
                    .setFont(myFont)
                    ; 
                    
 myTextlabelSPEED = cp5.addTextlabel("SPEED")
                    .setText("0")
                    .setPosition(205,170)
                    .setColorValue(textwhite)
                    .setFont(myFont)
                    ; 
             
 myTextlabelSPEEDunit = cp5.addTextlabel("Km/h")
                    .setText("Km/h")
                    .setPosition(190,210)
                    .setColorValue(textwhite)
                    .setFont(myFont)
                    ;            
                  
}




public void draw(){
 //Display a green screen if a device has been found,
 //Display a purple screen when a connection is made to the device
 if(foundDevice){
 if(BTisConnected){
 background(255,210,255); // purple screen
 fill(blaC);
 rect(0,0,width,40);
 
 if (speedValue > 6000) {
   myKnobRPM.setColorForeground(color(255,0,0));
   myTextlabelRPM.setText(str(speedValue));}
 else {
   myKnobRPM.setColorForeground(color(255));
   myTextlabelRPM.setText(str(speedValue));
 }
 
 myTextlabelDEP.setText(str(pressionValue));
 myTextlabelCENT.setText(str(delayValue));
 myTextlabelTOT.setText(str(avtotValue));
 myTextlabelSPEED.setText(str(PApplet.parseInt(currentSpeed)));
 
 
 
 }else {
 background(200,255,165); // green screen
 fill(blaC);
 rect(0,0,width,40);
 }
 }
 
}





/* This BroadcastReceiver will display discovered Bluetooth devices */
public class myOwnBroadcastReceiver extends BroadcastReceiver {
 @Override
 public void onReceive(Context context, Intent intent) {
 String action=intent.getAction();
 //ToastMaster("ACTION:" + action);
 
 //Notification that BluetoothDevice is FOUND
 if(BluetoothDevice.ACTION_FOUND.equals(action)){
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
 if(discoveredDeviceName.equals("BTaecp")){
 //ToastMaster("Connecte BTaecp");
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


public class ConnectToBluetooth implements Runnable{
 private BluetoothDevice btShield;
 private BluetoothSocket mySocket = null;
 private UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
 
 public ConnectToBluetooth(BluetoothDevice bluetoothShield) {
 btShield = bluetoothShield;
 try{
 mySocket = btShield.createRfcommSocketToServiceRecord(uuid);
 //print(mySocket);
 }catch(IOException createSocketException){
 //Problem with creating a socket
 }
 }
 
 //@Override
 public void run() {
 /* Cancel discovery on Bluetooth Adapter to prevent slow connection */
 bluetooth.cancelDiscovery();
 //print("cancelDiscovery is done");
 
 try{
 /*Connect to the bluetoothShield through the Socket. This will block
 until it succeeds or throws an IOException */
 mySocket.connect();
 scSocket=mySocket;
 //print("mySocket is connected");
 } catch (IOException connectException){
 try{
 mySocket.close(); //try to close the socket
 //print("mySocket is closed");
 }catch(IOException closeException){
 }
 return;
 }
 }
 
 /* Will cancel an in-progress connection, and close the socket */
 public void cancel() {
 try {
 mySocket.close();
 } catch (IOException e){
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
 }
 else
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
public void onResume()
{
  super.onResume();

  locationListener = new MyLocationListener();
  locationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);    

  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, locationListener);
}

public void onPause()
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
  public void onLocationChanged(Location location)
  {
    // Save new GPS data
    //currentLatitude  = (float)location.getLatitude();
    //currentLongitude = (float)location.getLongitude();
    //currentAccuracy  = (float)location.getAccuracy();
    //currentProvider  = location.getProvider();
    if (lastLocation != null) {
            double elapsedTime = (location.getTime() - lastLocation.getTime()) / 1000; // Convert milliseconds to seconds
            calculatedSpeed = lastLocation.distanceTo(location) / elapsedTime;
        }
        this.lastLocation = location;

        double speed = location.hasSpeed() ? location.getSpeed() : calculatedSpeed;

        /* There you have it, a speed value in m/s */

    currentSpeed = (float)(speed * 3.6f);
  }

  public void onProviderDisabled (String provider)
  { 
    currentProvider = "";
  }

  public void onProviderEnabled (String provider)
  { 
    currentProvider = provider;
  }

  public void onStatusChanged (String provider, int status, Bundle extras)
  {
    // Nothing yet...
  }
}
 

/* My ToastMaster function to display a messageBox on the screen */
public void ToastMaster(String textToDisplay){
 Toast myMessage = Toast.makeText(getActivity().getApplicationContext(), 
 textToDisplay,
 Toast.LENGTH_SHORT);
 myMessage.setGravity(Gravity.CENTER, 0, 0);
 myMessage.show();
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "aecp_android_bt_gps" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
