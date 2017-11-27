/**
* Node - Class to manage nodes
* @author        Marc Vilella
* @version       2.0
*/

import java.util.Collections;
import java.util.*;

private class Node implements Placeable{
  public int id;
  public final PVector POSITION;
  protected boolean selected;
  protected ArrayList<Lane> lanes = new ArrayList();
  private String direction = null;
  public String typeRoad;
  public String access;
  private Node parent;
  private float f;
  private float g;
    
  public Node(PVector position){
    id = -1;
    this.POSITION = position;
  }
  
    //Set node ID
    public void setID(int id) {
        this.id = id;
    }
    
 
    //Ser node ID
    public int getID() {
        return id;
    }
    
  
  public void place(Roads roads) {
        roads.add(this);
  }
  
  public boolean select(int mouseX, int mouseY) {
     selected = dist(POSITION.x, POSITION.y, mouseX, mouseY) < 2;
     return selected;
  }
  
  public PVector getPosition() {
    return POSITION.copy();
  }
  
  public void draw(PGraphics canvas, int stroke, color c) {
         for(Lane lane : lanes) {
           lane.draw(canvas, stroke, c);
         }
  }
  
   public void draw(PGraphics canvas) {
        canvas.fill(#000000); 
        canvas.ellipse(POSITION.x, POSITION.y, 3, 3);
        draw(canvas, 1, #F0F3F5);
   }
   
   public Lane shortestLaneTo(Node node) {
        Float shortestLaneLength = Float.NaN;
        Lane shortestLane = null;
        for(Lane lane : lanes) {
            if(node.equals(lane.getEnd())) {
                if(shortestLaneLength.isNaN() || lane.getLength() < shortestLaneLength) {
                    shortestLaneLength = lane.getLength();
                    shortestLane = lane;
                }
            }
        }
        return shortestLane;
    }
   
   protected void connect(Node node, ArrayList<PVector> vertices, String name, String access) {
     this.access = access;
     lanes.add( new Lane(name, access, this, node, vertices) );
   }
   
   protected void connectBoth(Node node, ArrayList<PVector> vertices, String name, String access) {
        this.access = access;
        connect(node, vertices, name, access);
        if(vertices != null) Collections.reverse(vertices); 
        node.connect(this, vertices, name, access);
        
    }
    
    protected void setDirection(String direction) {
        this.direction = direction;
    }
    
    public ArrayList<Lane> outboundLanes() {
        return lanes;
    }
    
    public void setParent(Node parent) {
        this.parent = parent;
    }
    
    public Node getParent() {
        return parent;
    }
    
    public void setG(float g) {
        this.g = g;
    }
    
    public float getG() {
        return g;
    }
    
    public void setF(Node nextNode) {
        float h =  POSITION.dist(nextNode.getPosition());
        f = g + h;
    }
    
    public float getF() {
        return f;
    }
    
    public void reset() {
        parent = null;
        f = g = 0.0;
    }
  
}