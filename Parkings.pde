/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella
* @modifier      Vanesa Alcantara
* @version       2.0
*/
public class POIs extends Facade<POI>{   
  ArrayList<PVector> privatePois = new ArrayList();
  // Create new factory<pois>
  public POIs(){
    factory = new POIFactory();
  }
  
 
  // load POIs, error if there is not file
  public void loadCSV(String path, Roads roadmap) {
    File file = new File( dataPath(path) );
    if( !file.exists() ) println("ERROR! CSV file does not exist");
    else {
      items.addAll( ((POIFactory)factory).loadCSV(path, roadmap) );
    }
  } 
  
  public void loadPrivateCSV(){
    
  }
      
  //Create an array with parking names
  public ArrayList getPOInames(){
    ArrayList<String> namePark = new ArrayList();
    for (POI poi : pois.getAll()){
      namePark.add(new String(poi.NAME));
    }
    return namePark;
  }
  
  //Create an array with parking capacities
  public ArrayList getCapacity(){
     ArrayList CapacityPark = new ArrayList();
     for(POI poi : pois.getAll()){
        CapacityPark.add(int(poi.CAPACITY));
     }
   return CapacityPark;
  }
   
  public int count(){
    int i=0;
    for(POI poi : pois.getAll()){
      i++;
    }
    return i;
  }
  
  // Draw parking occupancy for the chronometer time
public void draw(IntList occupancy){

    int c = 0;
    for(POI poi:pois.getAll()){ 
        //int Occupancy = (int) map(occupancy.get(c),0,800,0,100); 
        int Occupancy = (int) log(occupancy.get(c))*12; 
        float use = ((float)occupancy.get(c) / (float)poi.CAPACITY);
        color occColor = lerpColor(#4DFF00, #E60000,use);

            canvas.ellipseMode(CENTER); canvas.fill(occColor); canvas.stroke(occColor,127); canvas.strokeWeight(2);
            canvas.ellipse(poi.POSITION.x,poi.POSITION.y,2+Occupancy,2+ Occupancy);
            canvas.stroke(occColor);
            //int cap = (int) map(poi.CAPACITY,0,800,0,100);
            canvas.fill(occColor,100);
            int cap = (int) log(poi.CAPACITY)*12;
            canvas.ellipse(poi.POSITION.x,poi.POSITION.y,cap,cap);  
            canvas.fill(255);
            //canvas.ellipse(
            
            if(names) {   
              canvas.pushMatrix();
              canvas.translate(poi.POSITION.x, poi.POSITION.y);
              canvas.strokeWeight(6);
              canvas.rotate(3.5*PI/4);
              canvas.textSize(40);
              canvas.textAlign(CENTER);
              canvas.fill(#ff9f10);
              canvas.text(poi.NAME,0,0);
              canvas.popMatrix();
              
          }
          
        c++;
    }
    
    for( int i = 0; i < privatePois.size(); i++){
       canvas.fill(200,160);canvas.stroke(200,160);
       canvas.ellipse(privatePois.get(i).x, privatePois.get(i).y,log(privatePois.get(i).z)*12,log(privatePois.get(i).z)*12);
     }
  }
  
    public void loadPrivateCSV(String path){
        Table table =  loadTable(path, "header");
        for(TableRow row: table.rows()){
          int capacity = row.getInt("Capacity");
          String coord0 = row.getString("Coords");
          String[] coord1 =  split(coord0,",");
          PVector coords =  roads.toXY(float(coord1[0]),float(coord1[1]));
          PVector coordCap =  new PVector(coords.x, coords.y,capacity);
          privatePois.add(coordCap);
        }
   }
   
}
  
public class POIFactory extends Factory {
  
  //Load a JSON file 
    public ArrayList<POI> loadJSON(File JSONFile, Roads roads) {
        
        print("Loading POIs... ");
        ArrayList<POI> pois = new ArrayList();
        int count = count();
        JSONArray JSONPois = loadJSONObject(JSONFile).getJSONArray("features");
        for(int i = 0; i < JSONPois.size(); i++) {
            JSONObject poi = JSONPois.getJSONObject(i); 
            JSONObject props = poi.getJSONObject("properties");
            int parkNumber = props.getInt("Park number");
            String name = props.isNull("NAME") ? "null" : props.getString("NAME");
            String type = props.isNull("TYPE") ? "null" : props.getString("TYPE");
            int capacity = props.isNull("CAPACITY") ? 0 : props.getInt("CAPACITY");
            float price = props.isNull("Price")? 0 : props.getFloat("Price");
            price = ((int)( price * 100))/100.00;
            print(price);
            JSONArray coord = poi.getJSONObject("geometry").getJSONArray("coordinates");
            PVector location = roads.toXY( coord.getFloat(1), coord.getFloat(0) );
            
            String coords2 = poi.getJSONObject("geometry").getString("coordinates").replace("["," ");
            String coords3 = trim(coords2.replace("]"," "));
            float[] io_coords = float(split(coords3," "));
            PVector[] coords = new PVector[io_coords.length];
            //ArrayList[] DeviceNum = new ArrayList[io_coords.length];
            ArrayList<Integer> deviceNum = new ArrayList();
            
            for(int j = 0 ; j <= io_coords.length; i++){
              coords[j] = roads.toXY(io_coords[0],io_coords[1]);
              deviceNum.add((int)io_coords[2]);
              
            }
             print(deviceNum);   
            if( roads.contains(location) ) {
                pois.add( new POI(roads, parkNumber, name, type, location, capacity, deviceNum, str(price)) );
                counter.increment(type);
                count++;
            }
             
        }
        println("LOADED");
        return pois;  
    }  
    
    //Load CSV file 
    public ArrayList<POI> loadCSV(String path, Roads roads) {
        
        print("Loading POIs... ");
        ArrayList<POI> pois = new ArrayList();
        int count = count();
        
        Table table = loadTable(path, "header");
        
        for(TableRow row : table.rows()) {
            int parkNumber = row.getInt("Park number");
            String name = row.getString("Name");
            String type = row.getString("Type");
            int capacity = row.getInt("Capacity");
            float price =  row.getFloat("Price");
            price = ((int)( price * 100))/100.00;
            PVector location = roads.toXY(row.getFloat("Latitude"),row.getFloat("Longitude"));
            String io = row.getString("IO");
            String[] io_coords = split(io,"|");
            ArrayList deviceNum = new ArrayList();
            
            for(int i = 0; i < io_coords.length; i++){
              deviceNum.add(int(io_coords[i]));
            }
            if( roads.contains(location) ) {
                pois.add( new POI(roads, parkNumber, name, type, location, capacity, deviceNum, str(price)) );
                counter.increment(path); 
                count++;
            }           
        }
        println("LOADED");
        return pois;     
    }
    
    
    
}

//Read the file
public class POI extends Node{
 protected final int PARKNUMBER;
 protected final String NAME;
 protected final int CAPACITY;
 protected final String access;
 //protected final PVector[] COORDS;
 protected final ArrayList<Integer> DEVICENUM;
 protected final String PRICE;
 protected float occupancy;
 protected float entries;
 protected float departures;
 private float size = 2;
 
     //Asign values
     public POI(Roads roads, int parkNumber, String name, String type, PVector position, int capacity, ArrayList<Integer> deviceNum, String price){
            super(position);
            PARKNUMBER = parkNumber ;
            NAME = name;
            CAPACITY = capacity;
            access = type;
            //COORDS = coords;
            DEVICENUM = deviceNum;
            place(roads); 
            PRICE = price;
     }
    
    ////connect POI with the closest point
    //public void place(Roads roads){
    //  roads.connectP(this, COORDS); 
    //}
    
}