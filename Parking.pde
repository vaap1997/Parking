Roads roads;
POIs pois;
POI poi;
TimePark timePark;
boolean showBG = true;
boolean surfaceMode = true;
boolean run = true;
WarpSurface surface;
PGraphics canvas;
PGraphics legend;
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
String datesS = " ";
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
  
  legend = createGraphics(100,100);

}

void draw(){  
    background(180);
    canvas.beginDraw();
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);
    canvas.fill(0);
    
    if( millis() - timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      datesS = timePark.chronometer.get(indice);
      if (run) indice++; 
      timer = millis();
    }
    
    if(showBG) canvas.fill(255);
    canvas.text(datesS,0,0);
     ArrayList deviceNum = timePark.getDeviceNum();
     ArrayList movType = timePark.getMovType();
     ArrayList time = timePark.getTime();
     ArrayList passages = timePark.getPassages(); 
    pois.draw(deviceNum,movType,datesS,time, passages); 
        
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
    
    legend.beginDraw();
    
    legend.endDraw();
    
    
    
}

void keyPressed(){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'r':
    run = !run;
    break;
    
    case 'z':
    surfaceMode = !surfaceMode;
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