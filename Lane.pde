/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella 
* @modifier      Vanesa Alcantara
* @version       2.0
*/


private class Lane {
    
    private String name;
    private String access;
    public color co;
    private Node initNode;
    private Node finalNode;
    private float distance;
    private ArrayList<PVector> vertices = new ArrayList();

    
    //private ArrayList<Agent> crowd = new ArrayList();
    private float occupancy;
    
    public Lane(String name, String access, Node initNode, Node finalNode, ArrayList<PVector> vertices) {
        this.name = name;
        this.access = access;
        this.initNode = initNode;
        this.finalNode = finalNode;
        
        if(vertices != null && vertices.size()!= 0) this.vertices = new ArrayList(vertices);
        else {
            this.vertices.add(initNode.getPosition());
            this.vertices.add(finalNode.getPosition());   
        }
        distance = calcLength();
        
        if(access.equals("primary")) {
           co = color(#FFF500); //yellow
         }else if((access.equals("pedestrian") )|| (access.equals("living_street")) || (access.equals("footway")) || (access.equals("steps"))){
           co = color(#CC68FF); //purple
         }else if( access.equals("secondary")){
           co = color(#002ADA); //blue
         }else{
          co=color(100); 
         } 
    }
    

   public Node getEnd() {
        return finalNode;
    }
    
   public boolean contains(PVector vertex) {
        return vertices.indexOf(vertex) >= 0;
    }
    
   public ArrayList<PVector> getVertices() {
        return new ArrayList(vertices);
    }
    
    
    public float calcLength() {
        float dist = 0;
        for(int i = 1; i < vertices.size(); i++) dist += vertices.get(i-1).dist( vertices.get(i) );
        return dist;
    }
    
    public Lane findContrariwise() {
        for(Lane otherLane : finalNode.outboundLanes()) {
            if( otherLane.isContrariwise(this) ) return otherLane;
        }
        return null;
    }
    
    

    public boolean isContrariwise(Lane lane) {
        ArrayList<PVector> reversedVertices = new ArrayList(lane.getVertices());
        Collections.reverse(reversedVertices);
        return vertices.equals(reversedVertices);
    }
    
   //Find the closest point to the POI in the lane selected 
    public PVector findClosestPoint(PVector position) {
        Float minDistance = Float.NaN;
        PVector closestPoint = null;
        for(int i = 1; i < vertices.size(); i++) {
            PVector projectedPoint = Geometry.scalarProjection(position, vertices.get(i-1), vertices.get(i));
            float distance = PVector.dist(position, projectedPoint);
            if(minDistance.isNaN() || distance < minDistance) {
                minDistance = distance;
                closestPoint = projectedPoint;
            }
        }
        return closestPoint;
    }
    
   protected boolean divide(Node node) {
        int i = vertices.indexOf(node.getPosition());
        if(i > 0 && i < vertices.size()-1) {
            ArrayList<PVector> dividedVertices = new ArrayList( vertices.subList(i, vertices.size()) );
            PVector type = vertices.get(2);
            node.connect(finalNode, dividedVertices, name, access);
            vertices = new ArrayList( vertices.subList(0,i+1) );
            finalNode = node;
            distance = calcLength();
            return true;
        }
        return false;
    }
    
    
    //Create a new node to connect the POI with the closest point in the closest lane
    protected Node split(Node node) {
        if( node.getPosition().equals(vertices.get(0)) ) return initNode;
        else if( node.getPosition().equals(finalNode.getPosition()) ) return finalNode;
        for(int i = 1; i < vertices.size(); i++) {
            if( Geometry.inLine(node.getPosition(), vertices.get(i-1), vertices.get(i)) ) {
                
                ArrayList<PVector> splittedVertices = new ArrayList();
                splittedVertices.add(node.getPosition());
                splittedVertices.addAll( vertices.subList(i, vertices.size()) );
                node.connect(finalNode, splittedVertices, name, access);
                
                vertices = new ArrayList( vertices.subList(0, i) );
                vertices.add(node.getPosition());
                finalNode = node;
                distance = calcLength();
                return node;
            }
        }
        return null;
    }    
   
   //Draw and color line
   public void draw(PGraphics canvas, int stroke, color c) {  
     for(int i = 1; i < vertices.size(); i++) { 
          if(roadsType){
            canvas.stroke(co, 127); canvas.strokeWeight(stroke);
          }else{
            canvas.stroke(c, 127); canvas.strokeWeight(stroke);
          }
            PVector prevVertex = vertices.get(i-1);
            PVector vertex = vertices.get(i);
            canvas.line(prevVertex.x, prevVertex.y, vertex.x, vertex.y); 
     }
   }   
}