//TODO:implement Mark's warp layer

WarpSurface suface;
PGraphics canvas;
PGraphics canvas1;
PGraphics legend;
boolean showBG = true;
PImage BG;
Roads roads;
POIs pois;
final String roadsPath = "roads.geojson";
final String bgPath = "orto_epsg3857.jpg";
int simWidth;
int simHeight;
String dateS = " ";
ArrayList deviceNumPark;
IntList occupancy = new IntList();

TimePark timePark;
int timer = millis();
int indice = 0;

//Model coords
//lat: 42.505086, long: 1.509961
//lat: 42.517066, long: 1.544024
//lat: 42.508161, long: 1.549798
//lat: 42.496164, long: 1.515728


final LatLon[] ROI = new LatLon[] {
    new LatLon(42.505085,1.509961),
    new LatLon(42.517067,1.544024),
    new LatLon(42.508160,1.549798),
    new LatLon(42.496162,1.515728)
};

final LatLon[] bounds = new LatLon[] {
    new LatLon(42.5181, 1.50803),
    new LatLon(42.495, 1.55216)
};

void setup(){
  fullScreen(P3D,1);
  //size(900,700,P2D);
  smooth();
  simWidth = width;
  simHeight = height; 
  BG = loadImage(bgPath);
  //BG.resize(simWidth,simHeight);
  
  canvas = createGraphics(BG.width, BG.height,P3D);
  canvas1 = createGraphics(BG.width, BG.width,P3D);
  legend= createGraphics(500,800,P3D);
  
  canvas = new Canvas(this, canvas, "orto_epsg3857.jpg" , bounds);
  surface = new WarpSurface(this, 700, 300, 6, 3, ROI);
  surface.loadConfig();
 
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
    //canvas.translate(-width/4,-height/2);
    //canvas.scale(1.8);
    //canvas.rotate(PI/18.0);
    canvas.background(180);
    if(showBG)canvas.image(BG,0,0); 
      else roads.draw(canvas,1,0);
    ArrayList deviceNum = timePark.getDeviceNum();
    ArrayList movType = timePark.getMovType();
    ArrayList time = timePark.getTime();
    ArrayList passages = timePark.getPassages();
    pois.draw(deviceNum,movType,dateS,time, passages,false);
    int dimension = BG.width * BG.height;
    canvas.loadPixels();
    canvas1.beginDraw();
    canvas1.loadPixels();
    for (int i = 0; i < dimension; i ++) {
      canvas1.pixels[i] = canvas.pixels[i];
    }
    canvas1.updatePixels();
    canvas1.endDraw();

    for (int i = 0; i < dimension; i ++) { 
    canvas.pixels[i] = canvas1.pixels[dimension-i-1]; 
    } 
    canvas.updatePixels();
    canvas.endDraw();
    
    
  ////----------------LEGEND-----------------------  
    legend.beginDraw();
    legend.fill(255);
    legend.rect(0,0,500,800);
    legend.fill(0);
    if(millis() - timer >= 100){
      int maxIndice = timePark.getmax();
      if(indice >= maxIndice) indice = 0;
      dateS = timePark.chronometer.get(indice);
      indice++; 
      timer = millis();
    }
      
    legend.text(dateS, 80,20);
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     legend.text(mostrar,20,60+13*i);
     legend.text(str(number),130,60+13*i); 
    }
    pois.draw(deviceNum,movType,dateS,time, passages,true);
    legend.endDraw();
   
    background(0);
    surface.draw(canvas);

}

void mousePressed() {

    LatLon loc = surface.unmapPoint(mouseX, mouseY);
    println(loc);
    if(loc != null) {
        PVector pos = canvas.toScreen(loc.getLat(), loc.getLon());
        canvas.beginDraw();
        canvas.fill(#FF0000);
        canvas.ellipse(pos.x, pos.y, 10, 10);
        canvas.endDraw();
    }

}


void keyPressed(){
  switch(key){
    case ' ':
    showBG = !showBG;
    break;
    
    case 'k':
    surface.toggleCalibration();
    break;
    
    case 's':
    surface.saveConfig("surface.xml");
    break;
    
    case 'l':
    surface.loadConfig("surface.xml");
    break;
  } 
}