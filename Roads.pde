/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella
* @version       2.0
*/

public PVector[] boundaries;
 //buscar pois que estan dentro del shape
//dibujar solo si estan dentro del shape


public class Roads extends Facade<Node>{
      private PVector window;
      private PVector[] bounds;

      public Roads(String file, int x, int y, PVector[] bounds){
        window = new PVector(x,y);
        factory = new RoadFactory();
        this.loadJSON(file,this);
        this.bounds = bounds;
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

     //Find the closest point in the line
     public PVector findClosestPoint(PVector position) {
        Lane closestLane = findClosestLane(position);
        return closestLane.findClosestPoint(position);
     } 

   //Find the closestLane to the poi
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
    

   
   //Scale the roads
    public PVector toXY(float lat, float lon){
      PVector projPoint = Projection.toUTM(lat, lon,Projection.Datum.WGS84);
      return new PVector(
      map(projPoint.x, boundaries[0].x,boundaries[1].x,0,window.x),
      map(projPoint.y, boundaries[0].y,boundaries[1].y,window.y,0)
      );
    }
  
    public void add(Node node) {
      if(node.getID() == -1) {
        node.setID(items.size());
        items.add(node);
       }
    }
  
    
    public void draw(PGraphics canvas, int stroke, color c) {
        for(Node node : items){
          if(node instanceof POI){
            node.draw(canvas, stroke, color(255,0,0));
          }else{
          node.draw(canvas, stroke, c);}
        } 
    }

  public boolean contains(PVector point) {
        return point.x > 0 && point.x < window.x && point.y > 0 && point.y < window.y;
    }
   
  //Take model boundaries and check if the point is inside this shade  
  public String pointInPolygon(PVector point){

      ArrayList<PVector> vertices = new ArrayList();
      vertices.add(toXY(42.496164,1.515728));
      vertices.add(toXY(42.508161,1.549798));
      vertices.add(toXY(42.517066,1.544024));
      vertices.add(toXY(42.505086,1.509961));
      vertices.add(toXY(42.496164,1.515728));
      
      int boundaries=0;
      
      for( PVector vertex : vertices){
       if((vertex.x == point.x) || (vertex.y == point.y)) boundaries++;
      }
      
      int intersections=0;
      
      for(int i=1; i<vertices.size(); i++){
        PVector vertex1= vertices.get(i-1);
        PVector vertex2=vertices.get(i);
        
        if( (vertex1.y == vertex2.y) && (vertex1.y == point.y) && (point.x > min(vertex1.x,vertex2.x)) && (point.x < max(vertex1.x, vertex2.x))){
          boundaries++;
        }
        
        if( (point.y > min(vertex1.y,vertex2.y)) && (point.y <= max(vertex1.y,vertex2.y)) && (point.x <= max(vertex1.x,vertex2.x)) && (vertex1.y != vertex2.y) ){
          float xinters = (point.y - vertex1.y) * (vertex2.x - vertex1.x) / (vertex2.y - vertex1.y) + vertex1.x;
          if(xinters == point.x){
            boundaries++;
          }
          if( (vertex1.x == vertex2.x) || (point.x <=xinters)){
            intersections++;
          } 
        } 
      }
    
      if((intersections%2 != 0) || (boundaries > 0)){
       return "inside"; 
      } else {
       return "outside"; 
      }
  
  }
  
}

public class RoadFactory extends Factory<Node>{
  
  public ArrayList<Node>  loadJSON(File file, Roads roads){
    JSONObject roadNetwork = loadJSONObject(file);
    JSONArray lanes = roadNetwork.getJSONArray("features");
    boundaries = findBound(lanes);
    for(int i = 0; i < lanes.size(); i++){
        JSONObject lane =lanes.getJSONObject(i);
        //JALAR PROPERTIES
        JSONObject props = lane.getJSONObject("properties");
        Accessible access = props.isNull("type")? Accessible.ALL : Accessible.create( props.getString("type") );
        String type = props.isNull("type")? null : props.getString("type");
        
        String name = props.isNull("name")? "null" : props.getString("name");
        boolean oneWay = props.isNull("oneway")? false : props.getInt("oneway") == 1? true : false;
        String direction = props.isNull("direction")? null : props.getString("direction");
        JSONArray points = lane.getJSONObject("geometry").getJSONArray("coordinates");
        
        Node prevNode = null;
        ArrayList vertices = new ArrayList();
        
         for(int j = 0; j < points.size(); j++){
            PVector point = roads.toXY(points.getJSONArray(j).getFloat(1),points.getJSONArray(j).getFloat(0));
                      
                 vertices.add(point);
                 Node currNode = getNodeIfVertex(roads,point);
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
 
 //Find Andorra's boundaries 
  public PVector[] findBound(JSONArray lanes){
    float minLat =  Float.MAX_VALUE;
    float maxLat = -Float.MAX_VALUE;
    float minLon =  Float.MAX_VALUE;
    float maxLon = -Float.MAX_VALUE;
    for(int i = 0; i < lanes.size(); i++){
        JSONObject lane = lanes.getJSONObject(i);
        JSONArray points = lane.getJSONObject("geometry").getJSONArray("coordinates");
        for(int j = 0; j < points.size(); j++){
          float lat = points.getJSONArray(j).getFloat(1);
          float lon = points.getJSONArray(j).getFloat(0);
            minLat = min(minLat,lat);
            maxLat = max(maxLat,lat);
            minLon = min(minLon,lon);
            maxLon = max(maxLon,lon);
        }
    }
     return new PVector[]{
       Projection.toUTM(minLat, minLon, Projection.Datum.WGS84),
       Projection.toUTM(maxLat, maxLon, Projection.Datum.WGS84) 
      };
    }
  
}  