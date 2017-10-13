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
boolean name = false;
WarpSurface surface;
PGraphics canvas;
PGraphics legend;
PGraphics chart;
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

int[] angles = { 30, 10, 45, 35, 60, 38, 55, 37, 50 };

final String roadsPath = "roads.geojson";
final String bgPath = "orto_small.jpg";
int simWidth = 1000;
int simHeight = 847;

int timer = millis();
int speed = 200;
int indice = 1;
String datesS;
String[] actualDate;
ArrayList deviceNumPark;
ArrayList promParkHour;
IntList occupancy = new IntList();


void setup(){
  fullScreen(P3D,SPAN);
  //fullScreen(P3D, 2);
  background(0);
  smooth(); 
  BG = loadImage(bgPath);
  if(surfaceMode){
    simWidth = BG.width;
    simHeight = BG.height;
    
    //surface = new WarpSurface(this,1500,600,10,5);
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

  for(int a = 0; a < pois.count(); a++){
    occupancy.set(a,0);
  }
  
  legend = createGraphics(700, 80);
  ks = new Keystone(this);
  keyStone = ks.createCornerPinSurface(legend.width,legend.height,20);
  ks.load();
  chart = createGraphics(800,height);
  promParkHour = timePark.occupancyPerHour();
}

void draw(){  
    background(0);
    //if(key == 'n'){println("true";)}
    if( millis() - timer >= speed){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
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
    legend.rect( 150,50,20,20);
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
    for(int k=0; k < promParkHour.size(); k++){
     pieChart(360 - 15*k, angles,(FloatList) promParkHour.get(k));
    }

    pois.draw(occupancy, true);
    chart.text("Date:\n" + datesS,600,40);
    
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     chart.text(mostrar,20,100+13*i);
     chart.text(str(number),200,100+13*i);
    }
    
    chart.endDraw();
    image(chart,0,0);
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
    println("true");
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



void pieChart(float diameter, int[] angles, FloatList data) {
  float lastAngle = 0;
  for (int i = 0; i < data.size(); i++) {  
    color colorR= lerpColor(#77DD77, #FF6666, data.get(i));
    chart.fill(colorR);
    chart.stroke(1);
    chart.arc(chart.width/2, chart.height/3, diameter, diameter, lastAngle, lastAngle+radians(angles[i]),PIE);
    lastAngle += radians(angles[i]);
  }
}