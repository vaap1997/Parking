PGraphics canvas;
Roads roads;
POIs pois;
POI poi;
TimePark timepark;

final String roadsPath= "roads.geojson";
int simWidth = 1000;
int simHeight = 847;
int timer=millis();
int indice=0;
String FechaTexto = "hola";
ArrayList DeviceNumPark;
IntList occupancy= new IntList();

void setup(){
  size(1000,847);
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
    canvas.background(255);
    roads.draw(canvas, 1, #000000);
    canvas.fill(0);
    if(millis()-timer >= 100){
      int maxIndice=timepark.getmax();
      if(indice>=maxIndice) indice=0;
      FechaTexto= timepark.chronometer.get(indice);
      indice++; 
      timer=millis();
    }

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