import java.util.Collections;
import java.util.*;

private class Node implements Placeable{
  public int id;
  public final PVector POSITION;
  protected boolean selected;
  protected ArrayList<Lane> lanes = new ArrayList();
  private String direction = null;
    
  public Node(PVector position){
    id=-1;
    this.POSITION=position;
  }
  
    /**
    * Set node ID
    * @param id    ID of the node
    */
    public void setID(int id) {
        this.id = id;
    }
    
 
    /**
    * Get node ID
    * @return node ID
    */
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
   
   protected void connect(Node node, ArrayList<PVector> vertices, String name, Accessible access) {
     lanes.add( new Lane(name, access, this, node, vertices) );
   }
   
   protected void connectBoth(Node node, ArrayList<PVector> vertices, String name, Accessible access) {
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
  
}