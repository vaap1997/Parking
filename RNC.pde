import org.joda.time.*;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.DateTimeFormat;


public class RNCs extends Facade<RNC>{
  DateTime min = null;
  DateTime max = new DateTime("1990-12-13T21:39:45.618-08:00");
  ArrayList<DateTime> dates = new ArrayList();
  
  public RNCs(){
   factory = new RNCFactory(); 
  }
  
  public StringDict loadMCC(String path){
    StringDict MCC = new StringDict();
    File file = new File( dataPath(path) );
    if( !file.exists() ) println("ERROR! CSV file does not exist");
    else {
      MCC = ((RNCFactory)factory).loadMCC(path) ;
    }
    return MCC;
  }
  
  public void loadCSV(String path, StringDict MCC, Roads roads){
   File file = new File( dataPath(path) );
    if( !file.exists() ) println("ERROR! CSV file does not exist");
    else {
      items.addAll( ((RNCFactory)factory).loadCSV(path,MCC, roads) );
    }
    setMax();
    setMin();
  }
  
   public void draw(PGraphics canvas, DateTime indiceRnc) {
        for(RNC rnc : rncs.getAll()) rnc.draw(canvas,indiceRnc);
    }
  
  public DateTime setMax(){
    for(RNC rnc: rncs.getAll()){
      if( rnc.rncTime.isAfter(max) || rnc.rncTime == null){
        max = rnc.rncTime;
      }
    }
    return max;
  }
  
  public DateTime setMin(){
    for(RNC rnc: rncs.getAll()){
     if( rnc.rncTime.isBefore(min) || rnc.rncTime == null){
        min = rnc.rncTime;
      }
    }
    return min;
  }
  
  public DateTime getMax(){
   //print(max);
   return max;
  }
  
  public DateTime getMin(){
   //print(min);
   return min; 
  }
  
}

public class RNCFactory extends Factory{
  
  public ArrayList<RNC> loadJSON(File JSONFile, Roads roads){
    print("Loading RNC ... ");
    ArrayList<RNC> rncs = new ArrayList();
    int count = count();
    DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyyMMddHHmmss");
    DateTime rncTime;
    
    JSONArray JSONRnc = loadJSONObject(JSONFile).getJSONArray("features");
    
    for(int i=0; i < JSONRnc.size(); i++){
      JSONObject rnc = JSONRnc.getJSONObject(i); 
      PVector rncCoord = roads.toXY(rnc.getFloat("Latitude"), rnc.getFloat("Longitude"));
      if( roads.contains(rncCoord)){
      String timestamp = rnc.getString("timestamp");
      rncTime = fmt.parseDateTime(timestamp);
      String rncColor = rnc.getString("Color");
      
      rncs.add(new RNC(rncCoord, rncTime, rncColor, roads));
      
      }
    }
    print("LOADED");
    return rncs;
  }
  
  public ArrayList<RNC> loadCSV(String path,StringDict MCC, Roads roads){
    print("\nLoading RNC....");
    ArrayList<RNC> rncs = new ArrayList();
    int count = count();
    DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyyMMddHHmmss");
    DateTime rncTime;
    
    Table table = loadTable(path, "header");
    for(TableRow row : table.rows()){
      PVector rncCoord = roads.toXY(row.getFloat("Latitude"),row.getFloat("Longitude"));
      if(roads.contains(rncCoord)){
        String timestamp = row.getString("Timestamp");
        rncTime = fmt.parseDateTime(timestamp);
        String rncMCC =  row.getString("MCC");
       
        String rncColor;
          if( rncMCC.equals("213") || rncMCC.equals("214") || rncMCC.equals("208")){
            rncColor = MCC.get(rncMCC);
          }else {
            rncColor = MCC.get("Others");
          }
            
          //if(MCC.get(rncMCC).equals(null)){
          //rncColor = MCC.get("Others");
          //} else {
          //rncColor = MCC.get(rncMCC);
          //}
          
          //print(rncColor);
        
        rncs.add(new RNC(rncCoord, rncTime,rncColor, roads));
        
        } 
    }
    print("LOADED");
    return rncs;
  }
  
  public StringDict loadMCC(String path){
    StringDict MCC = new StringDict();
    
    Table table = loadTable(path,"header");
    for(TableRow row:table.rows()){
     MCC.set(row.getString("MCC"), row.getString("Color"));
    }
    return MCC;
  }
  
}

public class RNC implements Placeable{
  PVector position;
  DateTime rncTime;
  private int size = 6;
  private boolean selected = false;
  private String rncColor;
  
  public RNC(PVector rncCoord, DateTime rncTime, String rncColor, Roads roads){
    this.position = rncCoord;
    this.rncTime = rncTime;
    this.rncColor = rncColor;
    place(roads);
  }
  
  /**
  *Locate a point in the closest road
  *Add the rnc agent to the lane's crowd
  */
  public void place(Roads roads){
    roads.locateRNC(this);
    for(Node node: roads.items){
      for(Lane lane : node.outboundLanes()) {
        lane.OccupancyRNC(this);
      }
    }
  }
  
  public PVector getPosition(){
    return this.position;  
  }
  
  public void changePosition(PVector closestPoint){
   this.position = closestPoint;
  }
  
  public void draw(PGraphics p, DateTime indiceRnc){
    //print(rncColor);
    //color c = unhex(rncColor);
    // p.stroke(c);
    if(rncTime.isEqual(indiceRnc)){
       p.ellipse( position.x, position.y, 6,6);
    }
  }
  
  public void draw(PGraphics canvas){
    
  };
  
   public boolean select(int mouseX, int mouseY) {
        selected = dist(mouseX, mouseY, position.x, position.y) < size;
        return selected;
    }
    
}