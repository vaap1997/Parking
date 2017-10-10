import deadpixel.keystone.*;
Keystone ks;
CornerPinSurface keyStone;

Roads roads;
POIs pois;
POI poi;
TimePark timePark;
TimeP timeP;
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
int indice = 1;
String datesS;
String dateS1;
ArrayList deviceNumPark;
IntList occupancy = new IntList();


void setup(){
  fullScreen(P3D,1);
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
  
  legend = createGraphics(700,height);
  ks = new Keystone(this);
  keyStone = ks.createCornerPinSurface(legend.width,legend.height,20);
}

void draw(){  
    background(180);
    
    ArrayList deviceNum = timePark.getDeviceNum();
    ArrayList movType = timePark.getMovType();
    ArrayList time = timePark.getTime();
    ArrayList passages = timePark.getPassages();
    
    if( millis() - timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      datesS = timePark.chronometer.get(indice);
      if(run) occupancy = pois.getOccupancy(deviceNum, movType, datesS, time, passages);
      if(run) indice++; 
      timer = millis();
    }
    
    //-------------MAP---------------
    canvas.beginDraw();
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);  
    pois.draw( occupancy,false); 
    canvas.endDraw(); 
    if(surfaceMode) surface.draw((Canvas) canvas);
    else image(canvas,0,0);
    //---------- LEGEND----------------------------
    legend.beginDraw();
    
    legend.background(0);
    legend.fill(255);
    legend.fill(0);

    pois.draw(occupancy, true);
    legend.text("Date:\n" + datesS,600,50);
    
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     legend.text(mostrar,20,100+13*i);
     legend.text(str(number),200,100+13*i);
    }
    
    legend.text("Parking's occupancy ratios",20,20);
    legend.text("Size",150,40); legend.noFill();
    legend.rect( 150,50,20,20);
    for(int i = 0; i < 6; i++){
     legend.fill(lerpColor(#77DD77, #FF6666,0.2*i)); legend.noStroke();
     legend.text(str(int(0.2*i*100)),10+20*i,40);
     legend.rect(10+20*i,50,20,20);
    }
    

    
    
    legend.endDraw();
    keyStone.render(legend);
    
    
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
    
    case 'k':
    surface.toggleCalibration();
    ks.toggleCalibration();
    break;
    
    case 's':
    ks.save();
    break;
    
    case 'l':
    if( surface.isCalibrating() ) surface.loadConfig();
    ks.load();
    break;
  } 
}