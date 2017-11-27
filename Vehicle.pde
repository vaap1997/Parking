public class Vehicle { 
  PVector velocity;
  PVector acceleration;
  float r = 6.0;
  float maxforce = 0.3;
  float maxspeed= 5;
  private final Roads ROADMAP;
  ArrayList<Node> points;
  protected boolean arrived = false;
  protected POI destination;
  PVector position;
  protected Path path;
  protected Node inNode;
  protected float distTraveled;
  
  Vehicle(Roads roads){
     ROADMAP = roads;
     path = new Path(this,roads);
     inNode = getStart();
     position = inNode.getPosition();
     maxspeed = constrain(speed, 0, maxspeed);
     acceleration = new PVector(0,0);
     velocity = new PVector(maxspeed,0);
     
     destination = findDestination();
  }
  
  
  
  public Node getStart(){
   points = new ArrayList();
     for(Node node:ROADMAP.getAll()){
       //if((node.access.equals("pedestrian") )|| (node.access.equals("living_street")) || (node.access.equals("footway")) || (node.access.equals("steps"))){
         points.add(node);
       //}
   }
  return  points.get(round(random(0, points.size()-1))); 
  }
  
  public PVector getPosition(){
     return position.copy(); 
  }
  
  public boolean isMoving(){
     return !arrived; 
  }
  
  
  public POI findDestination() {
        path.reset();
        arrived = false;
        POI newDestination = null;
        ArrayList<POI> possible = pois.getAll();
        while(newDestination == null || inNode.equals(newDestination)) {
            newDestination = possible.get( round(random(0, possible.size()-1)) );    // Random POI for the moment
        }
        return newDestination;
  }
  

  
  public void move(float speed){
   if(!arrived){
     if(!path.available()){
       borders();
     }else{
      //PVector movement = path.move(position, speed *speedFactor);  ** speedFactor para cambiar speed
      PVector movement = path.move(position, speed);   
      position.add(movement);
      distTraveled+= movement.mag();
      inNode = path.inNode();
      if(path.hasArrived()){
         if(destination.host(this)){
            arrived = true;
         } else whenUnhosted();
      }
     }
   } else whenHosted();  
  }
  
  protected void whenUnhosted(){
     destination = findDestination(); 
  }
  
  protected void whenHosted() {
            destination.unhost(this);    // IMPORTANT! Unhost agent from destination
            destination = findDestination();
  }
    
  public void display(){
   canvas.pushMatrix();
   canvas.noFill();
   canvas.stroke(175);
   canvas.translate(position.x,position.y);
   canvas.ellipse(0,0,r,r);
   canvas.popMatrix();
  }
  
   public void borders(){
   if(position.x < -r) position.x = canvas.width+r;
   if(position.y < -r) position.y = canvas.height+r;
   if(position.x > canvas.width+r) position.x = -r;
   if(position.y > canvas.height+r) position.y = -r;
  }
  
}


public class Path{
 private final Roads ROADMAP;
 private final Vehicle VEHICLE;
 
 private ArrayList<Lane> lanes = new ArrayList();
 private float distance = 0;
 
 // Path movement variables
 private Node inNode = null;
 private Lane currentLane;
 private PVector toVertex;
 private boolean arrived = false;
 
 private ArrayList<PVector> points;
 private float radius = 5;
 
 
 public Path(Vehicle vehicle, Roads roads){
   ROADMAP = roads;
   VEHICLE = vehicle;
   points = new ArrayList();
   for(Node node:ROADMAP.getAll()){
     //if((node.access.equals("pedestrian") )|| (node.access.equals("living_street")) || (node.access.equals("footway")) || (node.access.equals("steps"))){
         points.add(node.POSITION);
       //}
   }
 }

 public boolean available() {
        return lanes.size() > 0;
 }    

  private float calcLength() {
        float distance = 0;
        for(Lane lane : lanes) distance += lane.getLength();
        return distance;
 }
    
 public float getLength() {
        return distance;
 }
 
 public void addPoint() {
    PVector point = points.get(round(random(0, points.size()-1)));
  }
 
 public boolean hasArrived() {
        return arrived;
 }
 
 public Node inNode() {
        return inNode;
 }
 
 public void reset() {
   lanes = new ArrayList();
   currentLane = null;
   arrived = false;
   distance = 0;
 }
 
 public PVector move(PVector position, float speed) {
  PVector dir = PVector.sub(toVertex, position);
  PVector movement = dir.copy().normalize().mult(speed);
  if(movement.mag() < dir.mag()) return movement;
  else {
    if( currentLane.isLastVertex( toVertex ) ) goNextLane();
    else toVertex = currentLane.nextVertex(toVertex);
    return dir;
  }
 }
 
 public void goNextLane() {
        inNode = currentLane.getEnd();
        int i = lanes.indexOf(currentLane) + 1;
        if( i < lanes.size() ) {
            currentLane = lanes.get(i);
            toVertex = currentLane.getVertex(1);
        } else arrived = true;
 }
    
  public boolean findPath(Node origin, Node destination) {
        if(origin != null && destination != null) {
            lanes = aStar(origin, destination);
            if(lanes.size() > 0) {
                distance = calcLength();
                inNode = origin;
                currentLane = lanes.get(0);
                toVertex = currentLane.getVertex(1);
                arrived = false;
                return true;
            }
        }
        return false;
  }
    
    private ArrayList<Lane> aStar(Node origin, Node destination) {
        ArrayList<Lane> path = new ArrayList();
        if(!origin.equals(destination)) {
            for(Node node : ROADMAP.getAll()) node.reset();
            ArrayList<Node> closed = new ArrayList();
            PriorityQueue<Node> open = new PriorityQueue();
            open.add(origin);
            while(open.size() > 0) {
                Node currNode = open.poll();
                closed.add(currNode);
                if( currNode.equals(destination) ) break;
                for(Lane lane : currNode.outboundLanes()) {
                    Node neighbor = lane.getEnd();
                    if( closed.contains(neighbor)) continue;
                    boolean neighborOpen = open.contains(neighbor);
                    float costToNeighbor = currNode.getG() + lane.getLength();
                    if( costToNeighbor < neighbor.getG() || !neighborOpen ) {
                        neighbor.setParent(currNode); 
                        neighbor.setG(costToNeighbor);
                        neighbor.setF(destination);
                        if(!neighborOpen) open.add(neighbor);
                    }
                }
            }
            path = tracePath(destination);
        }
        return path;
    }
    
   private ArrayList<Lane> tracePath(Node destination) {
        ArrayList<Lane> path = new ArrayList();
        Node pathNode = destination;
        while(pathNode.getParent() != null) {
            path.add( pathNode.getParent().shortestLaneTo(pathNode) );
            pathNode = pathNode.getParent();
        }
        Collections.reverse(path);
        return path;
    } 
 
}