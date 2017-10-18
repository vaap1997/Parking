import deadpixel.keystone.*;
Keystone ks;
Keystone ks1;
Keystone ks2;

CornerPinSurface keyStone;
CornerPinSurface KeyStoneChart;
CornerPinSurface keyStoneLine;

Roads roads;
POIs pois;
POI poi;
TimePark timePark;
boolean showBG = true;
boolean surfaceMode = true;
boolean run = true;
boolean name = false;
WarpSurface surface;
PGraphics canvas;
PGraphics legend;
PGraphics chart;
PGraphics linearGraphic;
int indiceLine = 0;
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
int speed = 200;
int indice = 0;
String datesS;
String[] actualDate;
ArrayList deviceNumPark;
ArrayList promParkHour;
ArrayList occPerDate;
IntList occupancy = new IntList();


PieChart pieChart;
ArrayList<PVector> lastCoord = new ArrayList();

void setup(){
  fullScreen(P3D,SPAN);
  //fullScreen(P3D, 2);
  background(0);
  smooth(); 
  BG = loadImage(bgPath);
  if(surfaceMode){
    simWidth = BG.width;
    simHeight = BG.height;
    surface = new WarpSurface(this, 1500, 550, 20, 10);
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
 
  chart = createGraphics(1440,height);
  ks1 = new Keystone(this);
  KeyStoneChart = ks1.createCornerPinSurface(chart.width, chart.height,20);
  occPerDate=timePark.getTotalOccupancy();
  promParkHour = timePark.occupancyPerHour();

  legend = createGraphics(700, 80);
  ks = new Keystone(this);
  keyStone = ks.createCornerPinSurface(legend.width,legend.height,20);
  ks.load();
  
  linearGraphic = createGraphics(1440, 480);
  ks2 = new Keystone(this);
  keyStoneLine = ks2.createCornerPinSurface(linearGraphic.width, linearGraphic.height,20);
  pieChart =  new PieChart();
  
  int j=0;
  for(POI poi : pois.getAll()){
     lastCoord.add(j,new PVector(pieChart.borderX,(int)pieChart.lineIni.get(j+1) / poi.CAPACITY)); 
     //lastCoord.add(j,new PVector(pieChart.borderX,pieChart.borderY)); 
     j++;
  }
}

void draw(){  

    background(0);
    //print(indice, timePark.chronometer.get((indice-1)*96));
    if( millis() - timer >= speed){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice){
        indice = 0;
      }
      datesS = timePark.chronometer.get(indice);
      actualDate = split(datesS, ' ');
      if(run) {
        indice++;
        occupancy = timePark.getOccupancy(datesS);
      }
      
      timer = millis();
    }
    
    //-------------MAP---------------
    canvas.beginDraw();
    canvas.background(0);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,#cacfd6);  
    pois.draw( occupancy,false); 
    canvas.endDraw(); 
    if(surfaceMode) surface.draw((Canvas) canvas);
    else image(canvas,0,0);
    //---------- LEGEND----------------------------
    legend.beginDraw();
    legend.background(0);
    legend.stroke(255);
    legend.fill(255);
    legend.textSize(16);
    legend.text("Date:\n" + actualDate[0]+"   "+actualDate[1] ,550,35);
    legend.textSize(13);
    legend.text("Parking's occupancy ratios",20,20);
    legend.textSize(9);
    legend.text("Size",150,40); legend.noFill();
    legend.rect(150,50,20,20);
    for(int i = 0; i < 6; i++){
     legend.fill(lerpColor(#4DFF00, #E60000,0.2*i)); legend.noStroke();
     legend.text(str(int(0.2*i*100)),10+20*i,40);
     legend.rect(10+20*i,50,20,20);
    } 
    legend.endDraw();
    keyStone.render(legend);
    
    //--------------PIE----------------------
    chart.beginDraw();
    chart.background(0);
    pieChart.draw();
    chart.endDraw();
    KeyStoneChart.render(chart);
    
    //------------LINEAR GRAPHIC---------------
    linearGraphic.beginDraw();
    pieChart.drawLineGraph();
    
    linearGraphic.endDraw();
    keyStoneLine.render(linearGraphic);
    
}

void keyPressed(KeyEvent e){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'r':
    run = !run;
    break;
    
    case 'n':
    name = !name;
    break;
    
   /* case 'z':
    surfaceMode = !surfaceMode;
    break;*/
    
    case 'k':
    surface.toggleCalibration();
    ks.toggleCalibration();
    break;
    
    case 's':
    ks.save();
    break;
    
    case 'g':
    surface.saveConfig();
    break;
    
    case '+':
      speed = speed - 20 ;
    break;
    
    case '-':
      speed = speed + 20;
    break;
    
  }
  switch(e.getKeyCode()){
    case UP:
    surface.move(0,-5);
    break;
    case DOWN:
    surface.move(0,5);
    break;
    case LEFT:
    surface.move(-5,0);
    break;
    case RIGHT:
    surface.move(5,0);
    break;
  } 
  
  
  
}