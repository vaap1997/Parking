/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella
* @version       2.0
*/

public PVector[] boundaries;

public class Roads extends Facade<Node>{

  private PVector window;

  
  public Roads(String file, int x, int y){
    window= new PVector(x,y);
    factory = new RoadFactory();
    this.loadJSON(file,this);
  }



  //Conect POIs
    private void connect(POI poi) {
        
        Lane closestLane = findClosestLane(poi.getPosition());
        Lane closestLaneBack = closestLane.findContrariwise();
        PVector closestPoint = closestLane.findClosestPoint(poi.getPosition());
        
        Node connectionNode = new Node(closestPoint);
        connectionNode = closestLane.split(connectionNode);
        if(closestLaneBack != null) connectionNode = closestLaneBack.split(connectionNode);
        this.add(connectionNode);
        
        poi.connectBoth(connectionNode, null, "Access", poi.access);
        add(poi);
        
    }
 //
 //Conect POIs with multiples entries
 private void connectP(POI poi, PVector[] coords){
  
  for(PVector coord:coords){
        Lane closestLane = findClosestLane(coord);
        Lane closestLaneBack = closestLane.findContrariwise();
        PVector closestPoint = closestLane.findClosestPoint(coord);
        
        Node connectionNode = new Node(closestPoint);
        connectionNode = closestLane.split(connectionNode);
        if(closestLaneBack != null) connectionNode = closestLaneBack.split(connectionNode);
        this.add(connectionNode);
        
        poi.connectBoth(connectionNode, null, "Access", poi.access);
  }
  add(poi);
 }
 //
 
 
 
 //Find the closest point in the line
    public PVector findClosestPoint(PVector position) {
        Lane closestLane = findClosestLane(position);
        return closestLane.findClosestPoint(position);
    } 
 //
 //Find the closestLane to the s
    public Lane findClosestLane(PVector position) {
        Float minDistance = Float.NaN;
        Lane closestLane = null;
        for(Node node : items) {
            for(Lane lane : node.outboundLanes()) {
                PVector linePoint = lane.findClosestPoint(position);
                float distance = position.dist(linePoint);
                if(minDistance.isNaN() || distance < minDistance) {
                    minDistance = distance;
                    closestLane = lane;
                }
            }
        }
        return closestLane;
    }
    //
    //Check if point is on the canvas
    public boolean contains(PVector point) {
        return point.x > 0 && point.x < window.x && point.y > 0 && point.y < window.y;
    }    
   //
    public PVector toXY(float lat, float lon){
    return new PVector(
    map(lat, boundaries[0].x,boundaries[1].x,0,width),
    map(lon, boundaries[0].y,boundaries[1].y,height,0)
    );
  }
  
  public void add(Node node) {
    if(node.getID() == -1) {
      node.setID(items.size());
      items.add(node);
     }
  }
  
  //PENDIENTE
  
      public void draw(PGraphics canvas, int stroke, color c) {
        for(Node node : items){
          if(node instanceof POI){
            node.draw(canvas, stroke, color(255,0,0));
          }else{
          node.draw(canvas, stroke, c);}
        } 
    }
    

}

public class RoadFactory extends Factory<Node>{
  
  public ArrayList<Node>  loadJSON(File file, Roads roads){
    JSONObject roadNetwork=loadJSONObject(file);
    JSONArray lanes =roadNetwork.getJSONArray("features");
    boundaries = findBound(lanes);
    for(int i=0; i<lanes.size();i++){
        JSONObject lane =lanes.getJSONObject(i);
        //JALAR PROPERTIES
        JSONObject props= lane.getJSONObject("properties");
        Accessible access = props.isNull("type")? Accessible.ALL : Accessible.create( props.getString("type") );
        int type=props.isNull("type")? 0: props.getString("type")=="primary"? 1: props.getString("type")=="secondary"? 2:3;
        
        String name = props.isNull("name")? "null" : props.getString("name");
        boolean oneWay=props.isNull("oneway")? false:props.getInt("oneway")==1? true:false;
        String direction=props.isNull("direction")? null: props.getString("direction");
        JSONArray points=lane.getJSONObject("geometry").getJSONArray("coordinates");
        
        Node prevNode=null;
        ArrayList vertices=new ArrayList();
        
         for(int j=0; j<points.size(); j++){
           PVector point=roads.toXY(points.getJSONArray(j).getFloat(1),points.getJSONArray(j).getFloat(0));
           
           vertices.add(point);
           
           Node currNode=getNodeIfVertex(roads,point);
           if(currNode != null) {
                        if(prevNode != null && j < points.size()-1) {
                            if(oneWay) prevNode.connect(currNode, vertices, name, access);
                            else prevNode.connectBoth(currNode, vertices, name, access);
                            vertices = new ArrayList();
                            vertices.add(point);
                            prevNode = currNode;
                        }
                    } else currNode = new Node(point);
                    
                    if(prevNode == null) {
                        prevNode = currNode;
                        currNode.place(roads);
                    } else if(j == points.size()-1) {
                        if(oneWay) prevNode.connect(currNode, vertices, name, access);
                        else prevNode.connectBoth(currNode, vertices, name, access);
                        currNode.place(roads);
                        if(direction != null) currNode.setDirection(direction);
                    }
         }
    }
    
            println("LOADED");
        return new ArrayList();
  }
  
  private Node getNodeIfVertex(Roads roads, PVector position) {
        for(Node node : roads.getAll()) {
            if( position.equals(node.getPosition()) ) return node;
            for(Lane lane : node.outboundLanes()) {
                if( position.equals(lane.getEnd().getPosition()) ) return lane.getEnd();
                else if( lane.contains(position) ) {
                    Lane laneBack = lane.findContrariwise();
                    Node newNode = new Node(position);
                    if(lane.divide(newNode)) {
                        if(laneBack != null) laneBack.divide(newNode);
                        newNode.place(roads);
                        return newNode;
                    }
                }
            }
        }
        return null;
    }
 
 //Crear funcion de fronteras de mapas 
  
  public PVector[] findBound(JSONArray lanes){
    float minLat = Float.MAX_VALUE;
    float maxLat=-(Float.MAX_VALUE);
    float minLon=Float.MAX_VALUE;
    float maxLon= -(Float.MAX_VALUE);
    for(int i=0; i<lanes.size();i++){
        JSONObject lane =lanes.getJSONObject(i);
        JSONArray points=lane.getJSONObject("geometry").getJSONArray("coordinates");
        for(int j=0; j<points.size(); j++){
          float lat = points.getJSONArray(j).getFloat(1);
          float lon = points.getJSONArray(j).getFloat(0);
            minLat=min(minLat,lat);
            maxLat=max(maxLat,lat);
            minLon=min(minLon,lon);
            maxLon=max(maxLon,lon);
        }
    }
     PVector[] bound ={new PVector(minLat,minLon),new PVector(maxLat, maxLon)};
     return bound;   
  }
}
  
  