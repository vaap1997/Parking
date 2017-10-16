public class PieChart{
  String message;
  PFont f = createFont("Georgia",15,true);
  int r = 360/2;
  int[] angles = {30, 50, 20, 35, 45, 38, 55, 37, 20,30 };
  ArrayList<String> namePark = pois.getPOInames();

  public void draw(){
    textFont(f);
    smooth();
    chart.translate(chart.width / 2, chart.height - 300);
    chart.noFill();
    stroke(0);
    for(int k=0; k < promParkHour.size(); k++){
     pieChart.pieChart(360 - 15*k,(FloatList) promParkHour.get(k));
    }
    
    //draw names
    for(int j = 0; j< namePark.size(); j++){
      float arclength = 0;
      message = namePark.get(j);
      for(int i = 0; i < message.length(); i++){
         // Instead of a constant width, we check the width of each character.
         char currentChar = message.charAt(i);
         float w = textWidth(currentChar);
         arclength += w/2;
         float theta;
         if(j == 0){
          theta = 0 + arclength / r;
        }else{
          int angle =0;
          for(int c = 0; c < j; c++){
            angle += angles[c];
          }
          theta = radians(angle) + arclength / r;    
        }
        chart.pushMatrix();
        // Polar to cartesian coordinate conversion
        chart.translate(r*cos(theta), r*sin(theta));
        // Rotate the box
        chart.rotate(theta+PI/2); // rotation is offset by 90 degrees
        // Display the character
        chart.fill(255);
        chart.textAlign(CENTER);
        chart.text(currentChar,0,0);
        chart.popMatrix();
        // Move halfway again
        arclength += w/2;
      }
    }
    
    chart.pushMatrix();
    chart.translate(-chart.width / 3, -chart.height + 300);
    //continuing drawing
    pois.draw(occupancy, true);
    chart.text("Date:\n" + datesS,chart.width/2 -150 ,40);
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     chart.text(str(number),200,100+13*i);
     chart.textAlign(LEFT);
     String mostrar = (String)namepark.get(i);
     chart.text(mostrar,20,100+13*i);
    }
    chart.popMatrix();
  }
  
  public void pieChart(float diameter, FloatList data) {
      float lastAngle = 0;
      for (int i = 0; i < data.size(); i++) {  
        color colorR= lerpColor(#77DD77, #FF6666, data.get(i));
        chart.fill(colorR);
        chart.stroke(1);
        chart.arc(0,0, diameter, diameter, lastAngle, lastAngle+radians(angles[i]),PIE);
        lastAngle += radians(angles[i]);
      }
  }
}