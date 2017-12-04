//public class Vehicle { 
//  PVector velocity;
//  PVector acceleration;
//  float r = 6.0;
//  float maxforce = 0.3;
//  float maxspeed= 5;
//  private final Roads ROADMAP;
//  private float speed;
//  ArrayList<Node> points;
//  protected boolean arrived = false;
//  protected POI destination;
//  PVector position;
//  protected Path path;
//  protected Node inNode;
//  protected float distTraveled;
 
//  Vehicle(Roads roads){
//     ROADMAP = roads;
//     path = new Path(this,roads);
//     inNode = getStart();
//     position = inNode.getPosition();
//     setSpeed();
//     acceleration = new PVector(0,0);
//     velocity = new PVector(maxspeed,0);
     
//     destination = findDestination();
//  }
  
//  /**
//  * Asign speed between 0 and the max speed to all the agents
//  */
//  public void setSpeed(){
//    this.speed = constrain(3, 0, maxspeed) ;
//  }
  
//  /**
//  * increment speedFactor
//  */
//  public void changeSpeed(float inc) {
//     this.speed = constrain(speed + inc, 0, maxspeed);
//  }
    
//  /**
//  * Asign an inicial destination
//  */
//  public Node getStart(){
//   points = new ArrayList();
//     for(Node node:ROADMAP.getAll()){
//       if(node.allows(this)){
//         points.add(node);
//       }
//   }
//  return  points.get(round(random(0, points.size()-1))); 
//  }
  
//  /**
//  * get where the vehicle is
//  */
//  public PVector getPosition(){
//     return position.copy(); 
//  }
  
//  /**
//  * taste if it is still moving or it has arrive
//  */
//  public boolean isMoving(){
//     return !arrived; 
//  }
  
//  /**
//  * Clear the path array to storage the new path
//  * find a new destination
//  */
//  public POI findDestination() {
//        path.reset();
//        arrived = false;
//        POI newDestination = null;
//        ArrayList<POI> possible = pois.getAll();
//        while(newDestination == null || inNode.equals(newDestination)) {
//            newDestination = possible.get( round(random(0, possible.size()-1)) );    // Random POI for the moment
//        }
//        return newDestination;
//  }

//  /**
//  * if the agent has arrive find new destination
//  * idf it has not arrive and there is not a path available it look for a new path
//  * if it has not arrive and there is a path available then you it moves to the next point in the path
//  * if the next point id the one arrive then find next destination otherwise continue moving
//  */
//  public void move(){
//   if(!arrived){
//     if(!path.available()){
//       path.findPath(inNode, destination);
       
//     }else{
//      //PVector movement = path.move(position, speed *speedFactor);  ** speedFactor para cambiar speed
//      PVector movement = path.move(position, this.speed);   
//      position.add(movement);
//      distTraveled+= movement.mag();
//      inNode = path.inNode();
//      if(path.hasArrived()){
//         if(destination.host(this)){
//            arrived = true;
//         } else whenUnhosted();
//      }
//     }
//   } else whenHosted();  
//  }
  
//  /**
//  * once it is no more on the parking finds other destination
//  */
//  protected void whenUnhosted(){
//     destination = findDestination(); 
//  }
  
//  /**
//  * change mode to unhosted
//  *find destination
//  */
//  protected void whenHosted() {
//            destination.unhost(this);    // IMPORTANT! Unhost agent from destination
//            destination = findDestination();
//  }
  
//  /**
//  * draw the vehicle on the canvas
//  */
//  public void display(){
//   canvas.pushMatrix();
//   canvas.noFill();
//   canvas.stroke(175);
//   canvas.translate(position.x,position.y);
//   canvas.ellipse(0,0,r,r);
//   canvas.popMatrix();
//  }
//}


//public class Path{
// private final Roads ROADMAP;
// private final Vehicle VEHICLE;
 
// private ArrayList<Lane> lanes = new ArrayList();
// private float distance = 0;
 
// // Path movement variables
// private Node inNode = null;
// private Lane currentLane;
// private PVector toVertex;
// private boolean arrived = false;
 
// private ArrayList<PVector> points;
// private float radius = 5;
 
 
// public Path(Vehicle vehicle, Roads roads){
//   ROADMAP = roads;
//   VEHICLE = vehicle;
//   points = new ArrayList();
//   for(Node node:ROADMAP.getAll()){
//         points.add(node.POSITION);
//   }
// }

//  /**
//  * there is option for a path
//  */
// public boolean available() {
//        return lanes.size() > 0;
// }    

//  /**
//  * distance between everylane
//  */
//  private float calcLength() {
//        float distance = 0;
//        for(Lane lane : lanes) distance += lane.getLength();
//        return distance;
// }
    
// public float getLength() {
//        return distance;
// }
 
// public void addPoint() {
//    PVector point = points.get(round(random(0, points.size()-1)));
//  }
 
// public boolean hasArrived() {
//        return arrived;
// }
 
// public Node inNode() {
//        return inNode;
// }
 
// /**
//  * reset all nodes to find a new path
//  */
// public void reset() {
//   lanes = new ArrayList();
//   currentLane = null;
//   arrived = false;
//   distance = 0;
// }
 
// /**
//  * create a new vector between the next path and the position to find the direction to move
//  * normalize desired and scale maximun speed
//  * if the vertex is the last vertex of the line insite the path go to the next lane in the path
//  */
// public PVector move(PVector position, float speed) {
//  PVector dir = PVector.sub(toVertex, position);
//  PVector movement = dir.copy().normalize().mult(speed);
//  if(movement.mag() < dir.mag()) return movement;
//  else {
//    if( currentLane.isLastVertex( toVertex ) ) goNextLane();
//    else toVertex = currentLane.nextVertex(toVertex);
//    return dir;
//  }
// }
 
// /**
//  * if there is other lane get the second vertex of the line (the first is the one that conect the lane before)
//  * if there is not other lane is because it has arrive
//  */
// public void goNextLane() {
//        inNode = currentLane.getEnd();
//        int i = lanes.indexOf(currentLane) + 1;
//        if( i < lanes.size() ) {
//            currentLane = lanes.get(i);
//            toVertex = currentLane.getVertex(1);
//        } else arrived = true;
// }
  
//  /**
//  * if the there is an origin and a destination find the path
//  * if the path has more than 0 lanes, calculate the distance
//  * set the origin as the position
//  * take the first vertex of the first line
//  */
//  public void findPath(Node origin, Node destination) {
//        if(origin != null && destination != null) {
//            lanes = aStar(origin, destination);
//            if(lanes.size() > 0) {
//                distance = calcLength();
//                inNode = origin;
//                currentLane = lanes.get(0);
//                toVertex = currentLane.getVertex(1);
//                arrived = false;
//            } else {
//             destination = VEHICLE.findDestination();
//            }
//        }
//  }
    
    
//    /**
//  * create an arraylist path
//  * go to everynode and reset it
//  * create a compare arraylist of nodes "open"
//  * if the current nose is equal to the destination ends
//  * otherwase compare every lane and change to open the best path
//  * trace path and return path
//  */
//    private ArrayList<Lane> aStar(Node origin, Node destination) {
//        ArrayList<Lane> path = new ArrayList();
//        if(!origin.equals(destination)) {
//            for(Node node : ROADMAP.getAll()) node.reset();
//            ArrayList<Node> closed = new ArrayList();
//            PriorityQueue<Node> open = new PriorityQueue();
//            open.add(origin);
//            while(open.size() > 0) {
//                Node currNode = open.poll();
//                closed.add(currNode);
//                if( currNode.equals(destination) ) break;
//                for(Lane lane : currNode.outboundLanes()) {
//                    Node neighbor = lane.getEnd();
//                    if( closed.contains(neighbor) || (!lane.allows(VEHICLE))) continue;
//                    boolean neighborOpen = open.contains(neighbor);
//                    float costToNeighbor = currNode.getG() + lane.getLength();
//                    if( costToNeighbor < neighbor.getG() || !neighborOpen ) {
//                        neighbor.setParent(currNode); 
//                        neighbor.setG(costToNeighbor);
//                        neighbor.setF(destination);
//                        if(!neighborOpen) open.add(neighbor);
//                    }
//                }
//            }
//            path = tracePath(destination);
//        }
//        return path;
//    }
  
//  /**
//  * add shortet lane to the destination
//  */
//   private ArrayList<Lane> tracePath(Node destination) {
//        ArrayList<Lane> path = new ArrayList();
//        Node pathNode = destination;
//        while(pathNode.getParent() != null) {
//            path.add( pathNode.getParent().shortestLaneTo(pathNode) );
//            pathNode = pathNode.getParent();
//        }
//        Collections.reverse(path);
//        return path;
//    } 
 
//}