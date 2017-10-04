import deadpixel.keystone.*;

PGraphics canvas;
Roads roads;
POIs pois;
POI poi;
TimePark timePark;
boolean showBG = true;
PImage BG;
Keystone ks;
CornerPinSurface keyStone;

//Model coords
//lat: 42.505086, long: 1.509961
//lat: 42.517066, long: 1.544024
//lat: 42.508161, long: 1.549798
//lat: 42.496164, long: 1.515728


final String roadsPath = "roads.geojson";
final String bgPath = "ortoEPSG3857lowRes.jpg";
int simWidth = 1000;
int simHeight = 847;
int timer = millis();
int indice = 0;
String dateS = "hola";
ArrayList deviceNumPark;
IntList occupancy = new IntList();

void setup(){
  fullScreen(P2D,1);
  //size(1000,800);
  simWidth = width;
  simHeight = height;
  BG = loadImage(bgPath);
  BG.resize(width,height);
  roads = new Roads(roadsPath,simWidth,simHeight);
  pois = new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  timePark = new TimePark("Aparcaments_julio.csv"); 
  
  canvas = createGraphics(simWidth, simHeight,P2D);
  
  for(int a = 0; a < pois.count(); a++){
    occupancy.set(a,0);
  }
  
  ks=new Keystone(this);
  keyStone=ks.createCornerPinSurface(simWidth,simHeight,20);
  
}

void draw(){  
    background(180);
    canvas.beginDraw();
    //canvas.translate(-width,-height);
    //canvas.scale(3);
   // canvas.rotate();
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);
    canvas.fill(0);
    
    if(millis()-timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      dateS = timePark.chronometer.get(indice);
      indice++; 
      timer = millis();
    }
    
    if(showBG) canvas.fill(255);
    canvas.text(dateS, 80,80);
       //llamar al array de device y de movtype
       ArrayList deviceNum = timePark.getDeviceNum();
       ArrayList movType = timePark.getMovType();
       ArrayList time = timePark.getTime();
       ArrayList passages = timePark.getPassages();
       //dibujar el occupancy 
       
       pois.draw(deviceNum,movType,dateS,time, passages); 
        
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     canvas.text(mostrar,20,100+13*i);
     canvas.text(str(number),200,100+13*i);
    }
    
    canvas.endDraw();
    image(canvas,0,0);
    keyStone.render(canvas);
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