//TODO: Fix legend
import deadpixel.keystone.*;
Keystone ks;
CornerPinSurface keyStone1;
CornerPinSurface keyStone2;
PGraphics canvas;
PGraphics legend;
boolean showBG = true;
PImage BG;
Roads roads;
POIs pois;
POI poi;
TimePark timePark;
final String roadsPath = "roads.geojson";
final String bgPath = "orto_small.jpg";
int simWidth = 1000;
int simHeight = 847;
int timer = millis();
int indice = 0;
String dateS = " ";
ArrayList deviceNumPark;
IntList occupancy = new IntList();

//Model coords
//lat: 42.505086, long: 1.509961
//lat: 42.517066, long: 1.544024
//lat: 42.508161, long: 1.549798
//lat: 42.496164, long: 1.515728

void setup(){
  fullScreen(P3D,1);
  //size(1000,800);
  simWidth = width;
  simHeight = height;  
  ks=new Keystone(this);
  keyStone1=ks.createCornerPinSurface(width,height,20);
  keyStone2=ks.createCornerPinSurface(500,200,20);
  canvas = createGraphics(simWidth, simHeight,P3D);
  legend= createGraphics(500,800,P3D);
  BG = loadImage(bgPath);
  BG.resize(width,height);
  roads = new Roads(roadsPath,simWidth,simHeight);
  pois = new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  timePark = new TimePark("Aparcaments_julio.csv"); 
  for(int a = 0; a < pois.count(); a++){
    occupancy.set(a,0);
  }
}

void draw(){  
    background(0);

 //--------------------MAP-----------------------
    canvas.beginDraw(); 
    /*get closer the part we are interesting in */
    canvas.translate(-width/3,-height/2);
    canvas.scale(1.8);
    // canvas.rotate();
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);
    ArrayList deviceNum = timePark.getDeviceNum();
    ArrayList movType = timePark.getMovType();
    ArrayList time = timePark.getTime();
    ArrayList passages = timePark.getPassages();
    pois.draw(deviceNum,movType,dateS,time, passages,false); 
    canvas.endDraw();
    
  //----------------LEGEND-----------------------  
    legend.beginDraw();
    legend.fill(255);
    if(millis()-timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      dateS = timePark.chronometer.get(indice);
      indice++; 
      timer = millis();
    }  
    legend.text(dateS, 80,80);
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     legend.text(mostrar,20,100+13*i);
     legend.text(str(number),200,100+13*i); 
    }
    pois.draw(deviceNum,movType,dateS,time, passages,true);
    legend.endDraw();
   
    background(0);
    keyStone1.render(canvas);
    keyStone2.render(legend);
}

void keyPressed(){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'k':
    ks.toggleCalibration();
    break;
    
    case 's':
    ks.save();
    break;
    
    case 'l':
    ks.load();
    break;
  } 
}