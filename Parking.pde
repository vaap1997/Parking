Roads roads;
POIs pois;
POI poi;
TimePark timePark;
boolean showBG = true;
boolean surfaceMode = true;
boolean run = true;
WarpSurface surface;
PGraphics canvas;
PImage BG;


final PVector[] bounds = new PVector[] {
    new PVector(42.482119, 1.489794),
    new PVector(42.533768, 1.572122)
};

PVector[] roi = new PVector[] {
    new PVector(42.505086, 1.509961),
    new PVector(42.517066, 1.544024),
    new PVector(42.508161, 1.549798),
    new PVector(42.496164, 1.515728)
};

final String roadsPath = "roads.geojson";
final String bgPath = "orto_small.jpg";
int simWidth = 1000;
int simHeight = 847;
int timer = millis();
int indice = 0;
String dateS = " ";
ArrayList deviceNumPark;
IntList occupancy = new IntList();

void setup(){
  fullScreen(P2D,1);
  smooth(); 
  BG = loadImage(bgPath);
  if(surfaceMode){
    simWidth = BG.width;
    simHeight = BG.height;
    
    surface = new WarpSurface(this,900,300,10,5);
    surface.loadConfig();
    canvas = new Canvas(this, simWidth, simHeight, bounds,roi);
  } else {
   BG.resize(simWidth, simHeight);
   canvas = createGraphics(simWidth, simHeight);
  }
  
  roads = new Roads(roadsPath,simWidth,simHeight,bounds);
  pois = new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  timePark = new TimePark("Aparcaments_julio.csv"); 
  
  
  for(int a = 0; a < pois.count(); a++){
    occupancy.set(a,0);
  }

}

void draw(){  
    background(180);
    canvas.beginDraw();
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);
    canvas.fill(0);
    
    if(millis()-timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      dateS = timePark.chronometer.get(indice);
      if (run) indice++; 
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
    
    if(surfaceMode) surface.draw((Canvas) canvas);
    else image(canvas,0,0);

}

void keyPressed(){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'f':
    run = !run;
    break;
    
    case 'k':
    surface.toggleCalibration();
    break;
    
    case 'l':
    if( surface.isCalibrating() ) surface.loadConfig();
    break;
  } 
}