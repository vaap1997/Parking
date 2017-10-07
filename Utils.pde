/**
* Roads - Class to manage the roadmap of simulation
* @author        Marc Vilella
* @version       2.0
*/

//Geometry class
public static class Geometry{
  //Check if a point is contained in a line
    public static boolean inLine(PVector p, PVector a, PVector b) {
        final float EPSILON = 0.001f;
        PVector ap = PVector.sub(p, a);
        PVector ab = PVector.sub(b, a);
        return PVector.angleBetween(ap, ab) <= EPSILON && ap.mag() < ab.mag();
    }
   
   //find the perpendicular projection of the point over a line (find closest line, connect)
    public static PVector scalarProjection(PVector p, PVector a, PVector b) {
        PVector ap = PVector.sub(p, a);
        PVector ab = PVector.sub(b, a).normalize();
        ab.mult(ap.dot(ab));
        return PVector.add(a, ab);
    }
    
    public static boolean inTriangle(PVector p, PVector t1, PVector t2, PVector t3){
       boolean b1 = Sign(p,t1,t2) < 0.0f;
       boolean b2 = Sign(p,t1,t2) < 0.0f;
       boolean b3 = Sign(p,t1,t2) < 0.0f;
       return ((b1 == b2) && (b2 == b3)); 
    }
    
    private static float Sign(PVector p1, PVector p2, PVector p3){
       return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y -p3.y); 
    }
   
   private static PVector linesIntersection(PVector p1,PVector p2, PVector p3, PVector p4){
     float d=(p2.x - p1.x) * (p4.y - p3.y) - (p2.y - p1.y) *(p4.x - p3.x);
     if(d == 0) return null;
     return new PVector(p1.x+(((p3.x - p1.x) * (p4.y - p3.y) - (p3.y - p1.y) * (p4.x - p3.x)) / d)*(p2.x-p1.x), p1.y+(((p3.x - p1.x) * (p4.y - p3.y) - (p3.y - p1.y) * (p4.x - p3.x)) / d)*(p2.y-p1.y));
   }
}