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


int setPath(String f){
  if (f == null) return 0;
  config.set("AEFpath",f);
  saveConfig(cFN);
  frame.setTitle(config.get("AEFpath"));  
  return 1;
}
  
    void loadMesure1(){
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
        records1 [i][j] = float(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  }
  
    void loadMesure2(){
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
        records2 [i][j] = float(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  }
 
     void loadMesure3(){
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
        records3 [i][j] = float(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  } 
  
       void loadMesure4(){
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
        records4 [i][j] = float(items[j]);
//        println(records[i][j]);
      }      
      }
    }
  
  recordsCount = i;
  rpmlist = new FloatList();
  centlist = new FloatList();

  } 
  

public void runclicked(){
   Irpmmin = int(textfieldrpmmin2.getText());
   Irpmmax = int(textfieldrpmmax2.getText());
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
   buttonrunfree.setText("Départ libre");
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
  color grC; // grid color
  color bckC;  // BackGround color
  color loadC; // Loadline color
  color pC; // powerline color
  float fsX;  // Full scale value for X axis
  float fsY;  // Full scale value for Y axis
  float scX;  // scale X
  float scY;  // scale Y
  float pwr;  // Power 
  
  
  
  void init(){
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
    fsY = 0.2;  // Means 200 mA full scale.
    scX = fsX/w;  
    scY = fsY/h;
    grX = 8;
    grY = 8;
    pwr = 5;
  }  
  
/*
Accepts values from a slider i.e. 0 to 1
*/
  void setfsX(float k){
    k = 1-k;  // reverse scale
    if(k == 0) return;  //
    fsX = 1000 * k;    // 1KV full scale
    config.set("fsX",str(fsX));
    scX = fsX/w;
    
  }
  
  void setfsY(float k){
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
  sExportdata = (speedValue + " " + correcteddelayDegree + " " + pressionValue +"\r"); // Attention version windows, enlever le "\r" car génère un CLRF
  sData[xrpmPos] = sExportdata;
  //println(sExportdata);
  //println(xrpmPos);
  //saveStrings(sName + ".aef", sData);
}

public void saveall(){
  saveStrings((config.get("aefmespath") + sName + ".aef"), sData);
  for (int q = xrpmPos; q<1241; q++){
    sData[q] = (" "); // initialise le tableau pour éliminer les "scories" !!!
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
   buttonpause.setText("Redémarrer");
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
    
  float valToPixX(float val){  //Convert value to pixel according to scX
    return (val/scX+l);  
  }
    
  float valToPixY(float val){ //Convert value to pixel according to scY
    return (t+h-val/scY);
  }
    
  float pixXToVal(float pix){ //Convert pixel to value according to scX
    return ((pix-l)*scX);
  }
    
  float pixYToVal(float pix){ //Convert pixel to value according to scY
    return (fsY-(pix-t)*scY);  //Substract from fsY to move origin at bottom.
  }
    
  
} //Plot class end

