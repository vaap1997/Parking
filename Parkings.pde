/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella
* @modifier      Vanesa Alcantara
* @version       2.0
*/
public class POIs extends Facade<POI>{   
  ArrayList<PRIVATEPOI> privatePois = new ArrayList();
  int totalAgentsIn;
  
  public POIs(){
    factory = new POIFactory();
  }
  
 
  /**
   * load POIs, error if there is not file
  */ 
  public void loadCSV(String path, Roads roadmap) {
    File file = new File( dataPath(path) );
    if( !file.exists() ) println("ERROR! CSV file does not exist");
    else {
      items.addAll( ((POIFactory)factory).loadCSV(path, roadmap) );
    }
  } 
  
  public void loadPrivateCSV(){
    
  }
   
  /**
   * Create an array with parking names
  */ 
  public ArrayList getPOInames(){
    ArrayList<String> namePark = new ArrayList();
    for (POI poi : pois.getAll()){
      namePark.add(new String(poi.NAME));
    }
    return namePark;
  }
  
  /**
   * Create an array with parking capacity
  */ 
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
  
 /**
 * Draw parking occupancy for the chronometer time
 */ 
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
            canvas.fill(occColor,100);
            int cap = (int) log(poi.CAPACITY)*12;
            canvas.ellipse(poi.POSITION.x,poi.POSITION.y,cap,cap);    
            canvas.fill(255);
            
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
    
    for(PRIVATEPOI privatePoi : privatePois){
       canvas.fill(100,160);canvas.stroke(100);
       canvas.ellipse(privatePoi.position.x , privatePoi.position.y ,log(privatePoi.capacity)*12,log(privatePoi.capacity)*12);
     }
  }
  
 /**
 * Load private parking
 */ 
 public void loadPrivateCSV(String path){
   Table table =  loadTable(path, "header");
   int id=0;
    for(TableRow row: table.rows()){
      String name = row.getString("Name");
      int capacity = row.getInt("Capacity");
      String coord0 = row.getString("Coords");
      String[] coord1 =  split(coord0,",");
      PVector coords =  roads.toXY(float(coord1[0]),float(coord1[1]));
      privatePois.add(new PRIVATEPOI(roads, id, name, coords, capacity));
      id ++;
    }
  }

}

  /**
 * Load public parking (the study ones) 
 * Load in case of a JSON
 * Load in case of CSV
 */
public class POIFactory extends Factory {
  
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
            if( roads.contains(location) ) {
                pois.add( new POI(roads, parkNumber, name, type, location, capacity, deviceNum, str(price),coords));
                counter.increment(type);
                count++;
            }
             
        }
        println("LOADED");
        return pois;  
    }  
    
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
            String entries = row.getString("Entries");
            String[] entries_coords = split(entries,"|");
            PVector[] coords = new PVector[entries_coords.length];
            String io = row.getString("IO");
            String[] io_coords = split(io,"|");
            ArrayList deviceNum = new ArrayList();
            
            for(int i=0; i< entries_coords.length; i++){
              float[] latlonIO = float(split(entries_coords[i]," "));
              coords[i] = roads.toXY(latlonIO[0],latlonIO[1]); 
            }

            for(int i = 0; i < io_coords.length; i++){
              deviceNum.add(int(io_coords[i]));
            }
            if( roads.contains(location) ) {
                pois.add( new POI(roads, parkNumber, name, type, location, capacity, deviceNum, str(price), coords) );
                counter.increment(path); 
                count++;
            }           
        }
        println("LOADED");
        return pois;     
    }
    
    
    
}

 /**
 * create class POI with caracteristic
 */
public class POI extends Node{
 protected final int PARKNUMBER;
 protected final String NAME;
 protected final int CAPACITY;
 protected final String access;
 protected final PVector[] COORDS;
 protected final ArrayList<Integer> DEVICENUM;
 protected final String PRICE;
 public int line;
 protected ArrayList<Vehicle> crowd = new ArrayList();
 
     public POI(Roads roads, int parkNumber, String name, String type, PVector position, int capacity, ArrayList<Integer> deviceNum, String price, PVector[] coords){
            super(position);
            PARKNUMBER = parkNumber ;
            NAME = name;
            CAPACITY = capacity;
            access = type;
            DEVICENUM = deviceNum;
            COORDS = coords;
            PRICE = price;
            place(roads);           
     }
     
    
    /**
    * conect different entries of the poi with the road
    */
    public void place(Roads roads){
      roads.connectP(this, COORDS); 
    }
    
    /**
    * Upload how many agents are insite the POI
    */
    public boolean host(Vehicle vehicle) {
      //int occIn = timePark.getIn(indice,this);
        //if(crowd.size() < occIn) {
            crowd.add(vehicle);
            return true;
        //}
        //return false;
    }
   
    /**
    * Upload how many agents are insite the POI
    */
    public void unhost(Vehicle vehicle) {
        crowd.remove(vehicle);
    } 
}

public class PRIVATEPOI extends Node{
 protected final int id;
 protected final String name;
 protected final PVector position;
 protected final int capacity;
 
 public PRIVATEPOI(Roads roads, int id, String name, PVector position, int capacity){
  super(position);
  this.id = id;
  this.name = name;
  this.position = position;
  this.capacity = capacity;
  place(roads);
 }
}