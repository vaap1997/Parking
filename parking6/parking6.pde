PGraphics canvas;
Roads roads;
POIs pois;
POI poi;
TimePark timepark;
boolean showBG=true;
PImage BG;

final String roadsPath= "roads.geojson";
final String bgPath="ortoEPSG3857lowRes.jpg";
int simWidth = 1000;
int simHeight = 847;
int timer=millis();
int indice=0;
String FechaTexto = "hola";
ArrayList DeviceNumPark;
IntList occupancy= new IntList();

void setup(){
  fullScreen(P2D,1);
  //size(1000,800);
  pixelDensity(2);
  BG=loadImage(bgPath);
  BG.resize(width,height);
  roads=new Roads(roadsPath,simWidth,simHeight);
  pois= new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  timepark= new TimePark("Aparcaments_julio.csv"); 
  canvas = createGraphics(simWidth, simHeight);
  
  for(int a=0;a<pois.count();a++){
    occupancy.set(a,0);
  }
  

}

void draw(){  
    background(255);   
    canvas.beginDraw();
    //canvas.translate(-width,-height);
    //canvas.scale(3);
   // canvas.rotate();
    canvas.background(255);
    if(showBG)canvas.image(BG,0,0); 
    else roads.draw(canvas,1,0);
    canvas.fill(0);
    if(millis()-timer >= 100){
      int maxIndice=timepark.getmax();
      if(indice>=maxIndice) indice=0;
      FechaTexto= timepark.chronometer.get(indice);
      indice++; 
      timer=millis();
    }
    
    if(showBG) canvas.fill(255);
    canvas.text(FechaTexto, 80,80);
       //llamar al array de device y de movtype
       ArrayList deviceNum=timepark.getDeviceNum();
       ArrayList MovType=timepark.getMovType();
       ArrayList time=timepark.getTime();
       ArrayList Passages=timepark.getPassages();
       //dibujar el occupancy 
       
       pois.draw(deviceNum,MovType,FechaTexto,time, Passages); 
        
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark=pois.getCapacity();
    for(int i=0; i<namepark.size();i++){
     int number = (int)capacitypark.get(i);
     String mostrar=(String)namepark.get(i);
     canvas.text(mostrar,20,100+13*i);
     canvas.text(str(number),200,100+13*i);
    }
    
    canvas.endDraw();
    image(canvas, 0, 0);

}

void keyPressed(){
  switch(key){
    case ' ':
    showBG= !showBG;
    break;
  }
}