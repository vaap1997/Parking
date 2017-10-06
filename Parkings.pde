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
  
  // Draw parking occupancy for the chronometer time
  public void draw(ArrayList deviceNum, ArrayList movType,String dateS,ArrayList time, ArrayList passages, Boolean legends){   
    int c = 0;
    for(POI poi:pois.getAll()){
        ArrayList devices = poi.DEVICENUM;
        for(int j = 0; j<devices.size(); j++){   
              for(int i = 0; i<deviceNum.size(); i++){         
                if(((int)devices.get(j) == (int) deviceNum.get(i))&&(dateS.equals(time.get(i)))){                  
                  if((int)movType.get(i) == 0){ 
                    occupancy.set(c,(int)occupancy.get(c)+(int)passages.get(i)); 
                    //occupancy.add(c,(int)passages.get(i));
                  }                  
                  if((int)movType.get(i) == 1){
                    occupancy.set(c,(int)occupancy.get(c)-(int)passages.get(i)); 
                  }  
                }    
             }       
          }
        int Occupancy = (int) map(occupancy.get(c),0,3000,0,150);
        boolean selected = abs(dist(poi.POSITION.x, poi.POSITION.y, mouseX, mouseY) )<= abs(4);
        
        if(selected) canvas.text("Parking: "+ poi.NAME,400,100);
        
        float use =(float)occupancy.get(c) / (float)poi.CAPACITY;
        color occColor = lerpColor(#77DD77, #FF6666,use);
        if(legends){
          legend.text((int) occupancy.get(c),180,60+13*c);
          legend.text(str(use)+"%",220,60+13*c); 
        }else{
          canvas.rectMode(CENTER); canvas.noFill(); canvas.stroke(occColor); canvas.strokeWeight(2);        
          canvas.rect(poi.POSITION.x,poi.POSITION.y,2+Occupancy,2+ Occupancy); 
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
 protected final ArrayList DEVICENUM;
 public ArrayList OCCUPANCY= new ArrayList(0);


 protected float occupancy;
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
        
    public void draw(PGraphics canvas, int stroke, color c){      
      color occColor = lerpColor(#77DD77, #FF6666, occupancy);        
      canvas.rectMode(CENTER); canvas.noFill(); canvas.stroke(occColor); canvas.strokeWeight(2);
      int cap = (int) map(CAPACITY,0,3000,0,150);
      canvas.rect(POSITION.x,POSITION.y,cap,cap);    
    } 
      
    @Override
    public boolean select(int mouseX, int mouseY) {
        selected = abs(dist(POSITION.x, POSITION.y, mouseX, mouseY) ) <= abs(size*2);
        return selected;
    } 
    
}