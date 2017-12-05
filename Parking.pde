/**
* Parking - Visualize parkings behavior
* @author        Vanesa Alcantara
* @version       3.0
*/

import org.joda.time.*;

Roads roads;
POIs pois;
POI poi;
Path path;
TimePark timePark;
WarpSurface surface;
PieChart pieChart;
Equilibrium equilibrium;
Agents agents;
RNCs rncs;

boolean showBG = true;
boolean freeze = true;
boolean names = false;
boolean type1 = true;
boolean type2 = true;
boolean type3 = true;
boolean type4 = true;
boolean type5 = true;
boolean type6 = true;
boolean type7 = true;
boolean type8 = true;
boolean type9 = true;
boolean type0 = true;
boolean trafficEquilibrium = false;
boolean trafficRNC = false;
JSONObject links;
JSONObject hierarchy;
PGraphics canvas;
PGraphics legend;
PGraphics chart;
PGraphics linearGraphic;
PGraphics individualCanvas;
PImage BG;
PImage speedometer;

PVector[] roi = new PVector[] {
    new PVector(42.505086, 1.509961),
    new PVector(42.517066, 1.544024),
    new PVector(42.508161, 1.549798),
    new PVector(42.496164, 1.515728)
};

final PVector[] orthoBounds = new PVector[] {

    new PVector(42.495, 1.50803),
    new PVector(42.5181, 1.55216)
};


final String roadsPath = "roads.geojson";
final String bgPath = "orto.jpg";
String datesS;
String[] actualDate;
int indiceLine = 0;
int simWidth = 1000;
int simHeight = 847;
int timer = millis();
int speed = 200;
int indice = 0;
int lastIndice = 0;
int totalAgent = 200;
int numLinks, numPeriods;
int currhour = 1;
int lastNamex = 600 ;
int lastNamey = 600 ;
public int maxHourT = 23;
ArrayList deviceNumPark;
ArrayList<String> maxDay;
ArrayList occPerDate;
ArrayList<PVector> lastCoord = new ArrayList();
ArrayList<ArrayList> dinamicHours;
ArrayList<String> dinamicDay;
IntList occupancy = new IntList();
//ArrayList<Agent> vehicles;

DateTime indiceRnc;
DateTime maxIndiceRnc;
StringDict MCC;


/**
* Create a canvas by linking more than one screen
* Create a surface to manipulate the canvas
* Upload roads
* Place pois
* Read timeparl
* Create PGraphics and inicialize line graphics
* Read and summarize timePark information
*/
void setup(){
  fullScreen(P2D,SPAN);
  background(0);
  smooth(); 
  
  BG = loadImage(bgPath);
  simWidth = BG.width;
  simHeight = BG.height;
  surface = new WarpSurface(this, 1500, 550, 20, 10);
  //surface.loadConfig();
  canvas = new Canvas(this, simWidth, simHeight, orthoBounds ,roi);
  
  roads = new Roads(roadsPath,simWidth,simHeight,orthoBounds);
  
  pois = new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  pois.loadPrivateCSV("Private_Parkings.csv",roads);

  timePark = new TimePark("Aparcaments_julio.csv"); 
 
  
  occPerDate=timePark.getTotalOccupancy();
  print("LOADED");

  maxDay = timePark.maxDay();
  print("LOADED");
  
  legend = createGraphics(700, 80);
  linearGraphic = createGraphics(1520, 520);
  individualCanvas = createGraphics(1520,height - linearGraphic.height);
  chart = createGraphics(500,height);
  pieChart =  new PieChart();

  int j=0;
  for(POI poi : pois.getAll()){
    if(poi.access.equals("publicPark")){
       lastCoord.add(j,new PVector(pieChart.borderX,(int)pieChart.lineIni.get(j+1) / poi.CAPACITY)); 
       j++;
    }
  }
  
 agents = new Agents();
 agents.loadVehicles(totalAgent, "vehicle", roads);
 agents.setSpeed(3, 6);
 
 hierarchy= loadJSONObject("equilibrium/roadHierarchy.json");
 
 rncs = new RNCs();
 MCC = rncs.loadMCC("RNC/MCC_claves.csv");
 rncs.loadCSV("RNC/20161004T163509.csv",MCC, roads);
 indiceRnc = rncs.getMin();
 maxIndiceRnc = rncs.getMax();
 
}


/**
* Inicialize choronometer
* draw roads and vehicles insite the surface
* draw surface
* draw legend
* draw linear graphic
* draw a chart with basic parking's statidistics
*/
void draw(){  
     indiceRnc.plusSeconds(10);
  
    if(indice > 0) lastIndice = indice-1;
    if( millis() - timer >= speed){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice){
        indice = 0;
      }
      datesS = timePark.chronometer.get(indice);
      actualDate = split(datesS, ' ');
      if(freeze) {
        occupancy = timePark.getOccupancy(datesS);
      }
      
      if(indiceRnc.isEqual(maxIndiceRnc)) indiceRnc = rncs.getMin();
      else indiceRnc = indiceRnc.plusSeconds(1);
     
      
      timer = millis();
    }
    //-------------MAP---------------
    canvas.beginDraw();
    canvas.background(0);
    //canvas.background(100);
    if(showBG){
      canvas.image(BG,0,0); 
    }else if(trafficEquilibrium){
      links = loadJSONObject("equilibrium/linksCong2016_07_03.json");
      equilibrium = new Equilibrium(links,hierarchy);
      equilibrium.draw(currhour);
    }
      else roads.draw(canvas,3,#cacfd6);  
    pois.draw(occupancy);
    agents.move();
    
    if(!trafficEquilibrium){
      rncs.draw(canvas, indiceRnc);
  
    //agents.draw(canvas);
      
    }
    canvas.endDraw(); 
    surface.draw((Canvas) canvas);
    ////-------------- LEGEND ----------------------
    //legend.beginDraw();
    //pieChart.drawLegend();
    //legend.endDraw();
    //image(legend,3025,737);
    
    ////----------- SUMMARY ----------------------
    //chart.beginDraw();
    //chart.background(0);
    //pieChart.drawSummary();
    //chart.endDraw();
    //image(chart,1520,0);
    
    ////------------LINEAR GRAPHIC---------------
    //linearGraphic.beginDraw();
    //if(freeze) pieChart.drawLineGraph();
    //linearGraphic.endDraw();
    //image(linearGraphic,0,0);
    
    ////-------------SPEEDOMETER-----------------
    //individualCanvas.beginDraw();
    //pieChart.BasicParkingStats();
    //individualCanvas.endDraw();
    //image(individualCanvas,0,linearGraphic.height);
    
    if(freeze){
     indice++; 
     if((currhour <= maxHourT ) && (indice%4.00==0) && (lastIndice != indice-1)){
      currhour++; 
     }else{
       currhour = 1;
     }
    }
}

/**
*Upload diffent funtionalities
*/
void keyPressed(KeyEvent e){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'f':
    freeze = !freeze;
    break;
    
    case 'n':
    names = !names;
    break;
    
    case 't':
    trafficEquilibrium = !trafficEquilibrium;
    break;
      
    case 'k':
    surface.toggleCalibration();
   // ks.toggleCalibration();
    break;
    
    case 's':
    //ks.save();
    //ks.load();
    break;
    
    case 'g':
    surface.saveConfig();
    break;
    
    case 'r':
    trafficRNC = !trafficRNC;
    break;
    
    case '+':
      speed = speed - 20 ;
        agents.changeSpeed(1);
    break;
   
    case '-':
      speed = speed + 20;
        agents.changeSpeed(-1);
    break;
    
    case '1':
    type1 = !type1;
    break;
    
    case '2':
    type2 = !type2;
    break;
    
    case '3':
    type3 = !type3;
    break;
    
    case '4':
    type4 = !type4;
    break;
    
    case '5':
    type5 = !type5;
    break;
    
    case '6':
    type6 = !type6;
    break;
    
    case '7':
    type7 = !type7;
    break;
    
    case '8':
    type8 = !type8;
    break;
    
    case '9':
    type9 = !type9;
    break;
    
    case '0':
    type0 = !type0;
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