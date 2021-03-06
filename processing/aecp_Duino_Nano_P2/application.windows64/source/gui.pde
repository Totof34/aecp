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
  appc.text("Aide à la sélection pour choisir sa courbe",280,30); // Affichage du titre
  appc.textFont(fe2);
  appc.fill(255,0,0);
  appc.text("(*) A partir du 1er Mars 1965 sur 24 BT (M 8 S)",20,50);
  appc.text("(**) A partir du 5 Mars 1965 sur 24 CT (M 10 S)",600,50);
  appc.text("(***) Pour 24BT a compter de juillet 65, monter des bougies 34 ou 35 HS, ne pas monter 34 ou 35 HS sur cylindres antérieurs à juillet 65,lamage du puit de bougies différent",20,65);
  img2 = loadImage("CDPanhard.png");                // Using a String for a file name
  appc.image(img2,0,100);
  appc.fill(230,230,230,200);
  appc.rect(100,80,200,40); // premier cadre gris 
  appc.rect(400,80,200,40); // deuxième cadre gris
  appc.rect(700,80,200,40); // troisième cadre gris
  appc.rect(1000,80,200,40); // quatrième cadre gris
  
  table = loadTable("tableauaideselection.csv", "header");

  int countRow = 0;
  //stringName = "Types mines";  
  //stringList = "Dyna Z";
  println(stringName + " " + stringList);
  
  
  for (TableRow row : table.matchRows(stringList,stringName)) {
       
    appc.textFont(fg2);
    appc.fill(0);
    appc.text((row.getString("Années")),40,(200 + (countRow * 20))); 
    appc.text(("| " + row.getString("Types mines")),170,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Types moteurs")),500,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Avance à l’allumage")),600,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Marques allumeurs")),780,(200 + (countRow * 20)));
    appc.text(("| " + row.getString("Références allumeurs")),1020,(200 + (countRow * 20)));
    
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
    stringName = "Références allumeurs";
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
   stringName = "Références allumeurs";
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
  appc.text("Chronomètre paramétrable pour analyser sa courbe",200,30); // Affichage du titre
  appc.text("Vitesse moteur en tours par minute",340,170); // Affichage du titre graphique rpm
  appc.text("Avance centrifuge",510,355); // Affichage du titre graphique rpm
  appc.text("Avance dépression",510,525); // Affichage du titre graphique rpm
  
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
  runrpmmin = int(textfieldrpmactual.getText());
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
   buttonrun.setText("Départ prédéfinis");
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
  appc.rect(40,360,1250,140); // deuxième cadre gris
  appc.rect(40,530,1250,120); // troisième cadre gris
  yrpmPos = map(speedValue, 0, 7000, 0, 140); // map la valeur de RPM
  ycentPos = map(correcteddelayDegree, 0, 20, 0, 140); // map la valeuur d'avance centrifuge
  ydepPos = map(pressionValue, 0, 20, 0, 120); // map la valeur d'avance dépression
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
    
  // à la fin de l'écran revient au début
  if (xrpmPos >= 1240) {
  xrpmPos = 0; // pour retour de la trace sans ligne
  }
  else {
    if (stateCheckbtnpause == true){
  // incrémente la position horizontale (abscisse)
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
  knob1 = new GKnob(this, 20, 60, 380, 320, 0.8);
  knob1.setTurnRange(90, 0);
  knob1.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob1.setSensitivity(1);
  knob1.setShowArcOnly(false);
  knob1.setOverArcOnly(false);
  knob1.setIncludeOverBezel(false);
  knob1.setShowTrack(true);
  knob1.setLimits(0.0, 0.0, 7000.0);
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
  knob2 = new GKnob(this, 470, 90, 220, 220, 0.8);
  knob2.setTurnRange(180, 0);
  knob2.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob2.setSensitivity(1);
  knob2.setShowArcOnly(true);
  knob2.setOverArcOnly(false);
  knob2.setIncludeOverBezel(false);
  knob2.setShowTrack(true);
  knob2.setLimits(0.0, 0.0, 20.0);
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
  label9.setText("en degré d'avance");
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
  label15.setText("Degrés");
  label15.setTextBold();
  label15.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label15.setOpaque(false);
  textfield3 = new GTextField(this, 250, 510, 60, 20, G4P.SCROLLBARS_NONE);
  textfield3.setText("0000000");
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  label16 = new GLabel(this, 40, 510, 200, 20);
  label16.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label16.setText("Délai en ms :");
  label16.setTextBold();
  label16.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label16.setOpaque(false);
  label17 = new GLabel(this, 40, 540, 200, 20);
  label17.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label17.setText("Degrés centrifuges :");
  label17.setTextBold();
  label17.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label17.setOpaque(false);
  textfield4 = new GTextField(this, 250, 540, 60, 20, G4P.SCROLLBARS_NONE);
  textfield4.setText("00");
  textfield4.setOpaque(true);
  textfield4.addEventHandler(this, "textfield4_change1");
  label18 = new GLabel(this, 40, 570, 200, 20);
  label18.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
  label18.setText("Degrés dépression :");
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
  label20.setText("Degrés avant étincelle :");
  label20.setTextBold();
  label20.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label20.setOpaque(false);
  textfield7 = new GTextField(this, 250, 630, 60, 20, G4P.SCROLLBARS_NONE);
  textfield7.setText("00");
  textfield7.setOpaque(true);
  textfield7.addEventHandler(this, "textfield7_change1");
  knob3 = new GKnob(this, 780, 90, 220, 220, 0.8);
  knob3.setTurnRange(180, 0);
  knob3.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob3.setSensitivity(1);
  knob3.setShowArcOnly(true);
  knob3.setOverArcOnly(false);
  knob3.setIncludeOverBezel(false);
  knob3.setShowTrack(true);
  knob3.setLimits(16.0, 16.0, 50.0);
  knob3.setNbrTicks(18);
  knob3.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob3.setOpaque(false);
  knob3.addEventHandler(this, "knob3_sum");
  knob4 = new GKnob(this, 1090, 90, 220, 220, 0.8);
  knob4.setTurnRange(180, 0);
  knob4.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob4.setSensitivity(1);
  knob4.setShowArcOnly(true);
  knob4.setOverArcOnly(false);
  knob4.setIncludeOverBezel(false);
  knob4.setShowTrack(true);
  knob4.setLimits(0.0, 0.0, 17.0);
  knob4.setNbrTicks(18);
  knob4.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  knob4.setOpaque(false);
  knob4.addEventHandler(this, "knob4_dep");
  label21 = new GLabel(this, 1150, 210, 100, 35);
  label21.setText("Dépression");
  label21.setTextBold();
  label21.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label21.setOpaque(false);
  label22 = new GLabel(this, 1130, 260, 140, 20);
  label22.setText("en degré d'avance");
  label22.setTextBold();
  label22.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label22.setOpaque(false);
  label23 = new GLabel(this, 840, 210, 96, 40);
  label23.setText("Degrés");
  label23.setTextBold();
  label23.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label23.setOpaque(false);
  label24 = new GLabel(this, 900, 350, 80, 20);
  label24.setText("Degrés");
  label24.setTextBold();
  label24.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label24.setOpaque(false);
  label25 = new GLabel(this, 1200, 350, 80, 20);
  label25.setText("Degrés");
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
  label26.setText("résultants");
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
  knob5 = new GKnob(this, 790, 460, 120, 120, 0.8);
  knob5.setTurnRange(180, 0);
  knob5.setTurnMode(GKnob.CTRL_HORIZONTAL);
  knob5.setSensitivity(1);
  knob5.setShowArcOnly(true);
  knob5.setOverArcOnly(false);
  knob5.setIncludeOverBezel(false);
  knob5.setShowTrack(true);
  knob5.setLimits(0.0, 0.0, 1.0);
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
  label39.setText("Erreur délai");
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
  button1.setText("Aide à la sélection");
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

