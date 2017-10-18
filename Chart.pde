public class PieChart{
  String message;
  PFont f = createFont("Georgia",15,true);
  int r = 360/2;
  int[] angles = {30, 50, 20, 35, 45, 38, 55, 37, 20,30 };
  ArrayList<String> namePark = pois.getPOInames();
  ArrayList lineIni = (ArrayList) occPerDate.get(0);
  int borderX = 40;
  int borderY = 40;


  public void draw(){
    textFont(f);
    smooth();
    chart.translate(chart.width / 4.5, chart.height - 200);
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
    chart.translate(2*chart.width / 8 , - 200);
    //continuing drawing
    pois.draw(occupancy, true);
    chart.text("Date:\n" + datesS, 50 ,40);
    ArrayList namepark = pois.getPOInames();
    ArrayList capacitypark = pois.getCapacity();
    for(int i = 0; i < namepark.size(); i++){
     chart.textAlign(CENTER);
     int number = (int)capacitypark.get(i);
     chart.text(str(number),200,100+13*i);
     String mostrar = (String)namepark.get(i);
     chart.textAlign(LEFT);
     chart.text(mostrar,20,100+13*i);
    }
    chart.popMatrix();
  }
  
  public void drawLineGraph(){
     linearGraphic.textSize(8);
     linearGraphic.fill(255); linearGraphic.stroke(255);
     //linearGraphic
     linearGraphic.line(borderX,linearGraphic.height-borderY,borderX,borderY);
     linearGraphic.line(borderX,linearGraphic.height-borderY,linearGraphic.width-borderX,linearGraphic.height-borderY);
     
     for(int i = 0; i <= 10; i++){
       linearGraphic.textAlign(CENTER);
       linearGraphic.text(str(i*10), borderX - 20, linearGraphic.height - borderY * (i+1));
     }
     
     for(int j = 0; j < 30; j++){
       String date = timePark.chronometer.get(j*96);
       date = date.substring(0,date.indexOf(" "));
       linearGraphic.text(date,(((j)*(linearGraphic.width-80))/(30-1))+ borderX, linearGraphic.height - (borderY-20)); 
     }
     
     if(indice % 4.00 == 0.00) {
       if(indice < timePark.chronometer.size()){
         ArrayList occ = new ArrayList();
         for(int c = 0; c < pois.count(); c++){
           occ.add(c,0);
         }
         for(int i = indice; i < indice+4; i++){ 
           ArrayList occTemp = (ArrayList) occPerDate.get(i);
           for(int j = 0; j < occTemp.size() - 1; j++){
             occ.set(j,(int)occ.get(j)+(int)occTemp.get(j+1));  
           }
         }

         int c=0;
         for(POI poi : pois.getAll()){
          occ.set(c, ((int) occ.get(c) * 100)/(4 * poi.CAPACITY));
          if((int) occ.get(c) >= 100) occ.set(c,100);
          c++;
         }

         for( int i = 0; i < occ.size(); i++){
            int x = (((indiceLine)*(linearGraphic.width - 80))/( timePark.chronometer.size()/4 -1)) + borderX;
            int y = (4 * (100 - (int) occ.get(i))) + borderY;
            linearGraphic.fill(255); linearGraphic.stroke(255);
            color linea=lerpColor(#FF8300,#006699,i/10.00);
            linearGraphic.fill(linea); linearGraphic.stroke(linea);
            if(indice >= 4) linearGraphic.line(lastCoord.get(i).x, lastCoord.get(i).y,x,y);
            lastCoord.set(i, new PVector(x,y));
            
         }
         indiceLine++;
  
       }else{
        background(0);
        indiceLine = 0;
       } 
     } 
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