//NO ES GITHUB
Roads roads;
POIs pois;
POI poi;
TimePark timePark;
boolean showBG = true;
boolean freeze = true;
boolean names = false;
boolean roadsType = false;
WarpSurface surface;
PGraphics canvas;
PGraphics legend;
PGraphics chart;
PGraphics linearGraphic;
PGraphics speedometerCanvas;
int indiceLine = 0;
PImage BG;
PImage speedometer;


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
final String speedPath = "speedometer2.png";
int simWidth = 1000;
int simHeight = 847;
int timer = millis();
int speed = 200;
int indice = 0;
int lastIndice = 0;
String datesS;
String[] actualDate;
ArrayList deviceNumPark;
ArrayList promParkHour;
ArrayList occPerDate;
IntList occupancy = new IntList();
PieChart pieChart;
ArrayList<PVector> lastCoord = new ArrayList();
int lastNamex = 600 ;
int lastNamey = 600 ;

void setup(){
  fullScreen(P2D,SPAN);
  //fullScreen(P3D, 2);
  background(0);
  smooth(); 
  speedometer = loadImage(speedPath);
  speedometer.resize((int)(speedometer.width*0.48),(int)(speedometer.height*0.45));
  BG = loadImage(bgPath);
  simWidth = BG.width;
  simHeight = BG.height;
  surface = new WarpSurface(this, 1500, 550, 20, 10);
  surface.loadConfig();
  canvas = new Canvas(this, simWidth, simHeight, bounds,roi);
  roads = new Roads(roadsPath,simWidth,simHeight,bounds);
  pois = new POIs();
  pois.loadCSV("Aparcaments.csv",roads);
  timePark = new TimePark("Aparcaments_julio.csv"); 
 
  chart = createGraphics(500,height);
  occPerDate=timePark.getTotalOccupancy();
  print("\n occPerHour loaded");
  promParkHour = timePark.occupancyPerHour();
  print("\n promParlHour loaded");
  
  legend = createGraphics(700, 80);
  linearGraphic = createGraphics(1520, 480);
  speedometerCanvas = createGraphics(1520,480);
  pieChart =  new PieChart();
  
  
  int j=0;
  for(POI poi : pois.getAll()){
     lastCoord.add(j,new PVector(pieChart.borderX,(int)pieChart.lineIni.get(j+1) / poi.CAPACITY)); 
     j++;
  }
  for(int i = 0; i < 5; i++){
    image(speedometer,26 + speedometer.width*i,530);
  }
  
}

void draw(){  
    
    //background(0);

    if(indice > 0) lastIndice = indice;
    if( millis() - timer >= speed){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice){
        indice = 0;
      }
      datesS = timePark.chronometer.get(indice);
      actualDate = split(datesS, ' ');
      if(freeze) {
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
    surface.draw((Canvas) canvas);
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
    image(legend,3025,737);
    
    //--------------PIE----------------------
    chart.beginDraw();
    chart.background(0);
    pieChart.drawPie();
    chart.endDraw();
    image(chart,1920*0.76,0);
    
    //------------LINEAR GRAPHIC---------------
    linearGraphic.beginDraw();
    if(freeze) pieChart.drawLineGraph();
    linearGraphic.endDraw();
    image(linearGraphic,0,0);
    
    //-------------SPEEDOMETER-----------------
    pushMatrix();
    for(int i = 0; i < 5; i++){
    color rectName = color(180,50);
    fill(rectName);
    /*first rect every 15 min*/
    rect(60 + speedometer.width*i, 530 + speedometer.height, speedometer.width - 80 , 50,7);
    /*second block max - min - prom day*/
    rect(60 + speedometer.width*i, 595 + speedometer.height, speedometer.width/2.5 , 30,7);
    rect(60 + speedometer.width*i, 630 + speedometer.height, speedometer.width/2.5 , 30,7);
    rect(60 + speedometer.width*i, 665 + speedometer.height, speedometer.width/2.5 , 30,7);
    rectName = color(220,80);
    fill(rectName);
    rect(80 + speedometer.width*i + speedometer.width/2.5, 595 + speedometer.height, speedometer.width/5 , 30,7);
    rect(80 + speedometer.width*i + speedometer.width/2.5, 630 + speedometer.height, speedometer.width/5 , 30,7);
    rect(80 + speedometer.width*i + speedometer.width/2.5, 665 + speedometer.height, speedometer.width/5 , 30,7);    
        
    textFont(createFont("Georgia",15)); textAlign(CENTER); fill(255);
    if(i == 0) {
      text( "Fener 1 - Fener 2", 26 + speedometer.width*i+speedometer.width/2, 520);
    }
    if(i == 1) {
      text( "Parc Central 1 - Parc Central 2", 26 + speedometer.width*i+speedometer.width/2, 520);
    }
    if(i == 2){
      text( "Centre Historic - Prat de la Creu", 26 + speedometer.width*i+speedometer.width/2, 520);
    }
    if(i == 3) {
      text( "Trilla - Prada Casadet", 26 + speedometer.width*i+speedometer.width/2, 520);
    }
    if(i == 4) {
      text( "Serradells - Antic Cami Ral", 26 + speedometer.width*i+speedometer.width/2, 520);
    }
   }
  
  textFont(createFont("Georgia",12));
  ArrayList namepark = pois.getPOInames();
  ArrayList capacitypark = pois.getCapacity(); 
  pois.draw(occupancy, true);
  for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     textAlign(CENTER);
     
     if(i % 2 == 0){
       textAlign(CENTER);
       text(str(number), 180 + speedometer.width*(i/2), 560 + speedometer.height ); 
       text("capacity", 180 + speedometer.width*(i/2), 545 + speedometer.height );
       text("Max per day", 120 + speedometer.width*(i/2), 615 + speedometer.height );
       text("Min per day", 120 + speedometer.width*(i/2), 650 + speedometer.height );
       text("Average per day", 120 + speedometer.width*(i/2), 685 + speedometer.height );
       textAlign(LEFT);
       text(mostrar,70 + speedometer.width*(i/2), 560 + speedometer.height);
       lastNamex = 180 + speedometer.width*(i/2);
       lastNamey = 560 + speedometer.height ;
     }else{
       textAlign(CENTER);
       text(str(number), lastNamex, lastNamey+13);
       textAlign(LEFT);
       text(mostrar, lastNamex-110, lastNamey+13);
     }
    }
    popMatrix();
    
}

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
      
    case 'k':
    surface.toggleCalibration();
   // ks.toggleCalibration();
    break;
    
    case 'r':
    roadsType = !roadsType;
    break;
    
    case 's':
    //ks.save();
    //ks.load();
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