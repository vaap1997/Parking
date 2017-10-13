/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella and Vanesa Alcantara
* @version       2.0
*/
public class POIs extends Facade<POI>{   
  
  // Create new factory<pois>
  public POIs(){
    factory = new POIFactory();

  }
 
  // load POIs, error if there is not file
  public void loadCSV(String path, Roads roadmap) {
    File file = new File( dataPath(path) );
    if( !file.exists() ) println("ERROR! CSV file does not exist");
    else items.addAll( ((POIFactory)factory).loadCSV(path, roadmap) );
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
public void draw(IntList occupancy,boolean legendB){
    int c = 0;
    for(POI poi:pois.getAll()){ 
        int Occupancy = (int) map(occupancy.get(c),0,2500,0,100);        
        float use = ((float)occupancy.get(c) / (float)poi.CAPACITY);
        color occColor = lerpColor(#4DFF00, #E60000,use);
        if( legendB == true){
            chart.stroke(255);
            chart.fill(255);          
            int useI = round(use * 100);
            chart.text((int) occupancy.get(c),250,100+13*c);
            chart.text(str(useI)+"%",280,100+13*c);      
        }else{canvas.rectMode(CENTER); canvas.fill(occColor,127); canvas.stroke(occColor,127); canvas.strokeWeight(2);
            canvas.rect(poi.POSITION.x,poi.POSITION.y,2+Occupancy,2+ Occupancy);
            canvas.rectMode(CENTER); canvas.noFill(); canvas.stroke(occColor); canvas.strokeWeight(2); 
            int cap = (int) map(poi.CAPACITY,0,2500,0,100);
            canvas.rect(poi.POSITION.x,poi.POSITION.y,cap,cap); 
            if(name) {
              
              canvas.pushMatrix();
              canvas.translate(poi.POSITION.x, poi.POSITION.y);
              canvas.rotate(PI);
              canvas.textSize(10);
              canvas.textAlign(CENTER);
              canvas.fill(#ff9f10);
              canvas.text("Parking: "+ poi.NAME,0,0);
              canvas.popMatrix();
              
          }
        }  
        c++;
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
            
            String name = props.isNull("NAME") ? "null" : props.getString("NAME");
            String type = props.isNull("TYPE") ? "null" : props.getString("TYPE");
            int capacity = props.isNull("CAPACITY") ? 0 : props.getInt("CAPACITY");
            
            JSONArray coord = poi.getJSONObject("geometry").getJSONArray("coordinates");
            PVector location = roads.toXY( coord.getFloat(1), coord.getFloat(0) );
            
            String coords2 = poi.getJSONObject("geometry").getString("coordinates").replace("["," ");
            String coords3 = trim(coords2.replace("]"," "));
            float[] io_coords = float(split(coords3," "));
            PVector[] coords = new PVector[io_coords.length];
            //ArrayList[] DeviceNum = new ArrayList[io_coords.length];
            ArrayList deviceNum = new ArrayList();
            
            for(int j = 0 ; j <= io_coords.length; i++){
              coords[j] = roads.toXY(io_coords[0],io_coords[1]);
              deviceNum.add((int)io_coords[2]);
              
            }
                
            if( roads.contains(location) ) {
                pois.add( new POI(roads, str(count), name, type, location, capacity, coords, deviceNum) );
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
            
            String name = row.getString("Name");
            String description = row.getString("Description");
            String type = row.getString("Type");
            int capacity = row.getInt("Capacity");
            PVector location = roads.toXY(row.getFloat("Latitude"),row.getFloat("Longitude"));
            String io = row.getString("IO");
            String[] io_coords = trim(split(io,"|")); 
            PVector[] coords = new PVector[io_coords.length];
            ArrayList deviceNum = new ArrayList();
            
            for(int i = 0; i < io_coords.length; i++){
              float[] latlonIO = float(split(io_coords[i]," "));
              coords[i] = roads.toXY(latlonIO[0],latlonIO[1]);
              deviceNum.add(((int)latlonIO[2]));
            }
                     
            if( roads.contains(location) ) {
                pois.add( new POI(roads, str(count), name, type, location, capacity,coords, deviceNum) );
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
 protected final String ID;
 protected final String NAME;
 protected final int CAPACITY;
 protected final Accessible access;
 protected final PVector[] COORDS;
 protected final ArrayList<Integer> DEVICENUM;

 protected float occupancy;
 protected float entries;
 protected float departures;
 private float size = 2;
 
     //Asign values
     public POI(Roads roads, String id, String name, String type, PVector position, int capacity, PVector[] coords,ArrayList deviceNum){
            super(position);
            ID = id;
            NAME = name;
            CAPACITY = capacity;
            access = Accessible.create(type);
            COORDS = coords;
            DEVICENUM = deviceNum;
            place(roads);       
     }
    
    //connect POI with the closest point
    public void place(Roads roads){
      roads.connectP(this, COORDS); 
    }
    
}