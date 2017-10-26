/**
* Chart - Class to create pie, line and speedometer charts
* @author        Vanesa Alcantara
* @version       1.0
*/
public class PieChart{
  String message;
  PFont f = createFont("Georgia",15,true);
  int r = 360/2;
  int[] angles = {30, 50, 20, 35, 45, 38, 55, 37, 20,30 };
  ArrayList<String> namePark = pois.getPOInames();
  ArrayList lineIni = (ArrayList) occPerDate.get(0);
  int borderX = 40;
  int borderY = 40;
  //String[] poiColor = { 

  /*
  **Draw a pieChart for every hour
  **Draw every name and fit it to the pieChart
  */
  public void drawPie(){
    textFont(f);
    smooth();
    chart.translate(chart.width / 2, 250);
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
  
  }
  
  /*
  **Draw the cartesian plane
  **Daw percentage legend
  **Draw days legend
  **Media per hour
  **Draw lines coordinate with the chronometer
  **Refresh with every chronometer complete
  */
  public void drawLineGraph(){
     color coLine = 255;
     linearGraphic.textSize(10);
     linearGraphic.fill(255); linearGraphic.stroke(255);
     //linearGraphic
     linearGraphic.line(borderX,linearGraphic.height-borderY,borderX,borderY);
     linearGraphic.line(borderX,linearGraphic.height-borderY,timePark.chronometer.size()/4+borderX,linearGraphic.height-borderY);
     
     for(int i = 0; i <= 10; i++){
       linearGraphic.textAlign(CENTER);
       linearGraphic.text(str(i*10) + "%", borderX - 20, linearGraphic.height - borderY * (i+1));
     }
     
     for(int j = 0; j <= 30; j++){

       //linearGraphic.text(j+2,(((j+1)*(linearGraphic.width-80))/(30))+ borderX, linearGraphic.height - (borderY-20)); 
       if(j <  30)linearGraphic.text(j+2,j*24+ borderX, linearGraphic.height - (borderY-20)); 
       if(j == 30)linearGraphic.text("Julio",j*24+ borderX, linearGraphic.height - (borderY-20));
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
            //int x = (((indiceLine)*(linearGraphic.width - 80))/(timePark.chronometer.size())) + borderX;
            int x = indiceLine + borderX;
            int y = (4 * (100 - (int) occ.get(i))) + borderY;
            if(i == 0) coLine = color(#71FF01);  //ligh green
            if(i == 1) coLine = color(#Ef7501);  //orange
            if(i == 2) coLine = color(#FF100E);  //red
            if(i == 3) coLine = color(#3500E5);  //blue
            if(i == 4) coLine = color(#0ABCB2);  //water blue
            if(i == 5) coLine = color(#E50083);  //pink
            if(i == 6) coLine = color(#8448b8);  //purple
            if(i == 7) coLine = color(#FFF500);  //yellow
            if(i == 8) coLine = color(#00bc6c);  //dark green
            if(i == 9) coLine = color(#e5a68e);  //pink
            linearGraphic.fill(255); linearGraphic.stroke(255);
            linearGraphic.fill(coLine); linearGraphic.stroke(coLine);
            if(lastIndice != indice){
              if(indice >= 4) linearGraphic.line(lastCoord.get(i).x, lastCoord.get(i).y,x,y);
              lastCoord.set(i, new PVector(x,y));
            }
         }
         if(lastIndice != indice) indiceLine++;
  
       }else{
          linearGraphic.background(0);
          indiceLine = 0;
          int j=0;
          for(POI poi : pois.getAll()){
             lastCoord.add(j,new PVector(pieChart.borderX,(int)pieChart.lineIni.get(j+1) / poi.CAPACITY)); 
             j++;
          }
       } 
     } 
  }
  
  public void pieChart(float diameter, FloatList data) {
      float lastAngle = 0;
      for (int i = 0; i < data.size(); i++) {  
        color colorR= lerpColor(#48C639, #FF0000, data.get(i));
        //color colorR= lerpColor(#1AB848, #FF0000, data.get(i));
        chart.fill(colorR);
        chart.stroke(1);
        chart.arc(0,0, diameter, diameter, lastAngle, lastAngle+radians(angles[i]),PIE);
        lastAngle += radians(angles[i]);
      }
  }
}