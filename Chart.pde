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
  color[] poiColor = { color(#A9BDCF), color(#Ef7501), color(230,0,0), color(#3500E5), color(#0ABCB2), color(#E50083), color(#8448b8), color(#FFF500), color(#00bc6c), color(#e5a68e)};
  //                 {ligh blue, orange, red, blue, water blue, pink, purple, yellow, dark green, pink}
  
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
     //color coLine = 255;
     linearGraphic.textSize(10);
     linearGraphic.fill(255); linearGraphic.stroke(255);
     //linearGraphic
     linearGraphic.line(borderX,linearGraphic.height-borderY,borderX,borderY);
     linearGraphic.line(borderX,linearGraphic.height-borderY,timePark.chronometer.size()/2+borderX,linearGraphic.height-borderY);
     
     for(int i = 0; i <= 10; i++){
       linearGraphic.textAlign(CENTER);
       linearGraphic.text(str(i*10) + "%", borderX - 20, linearGraphic.height - borderY * (i+1));
     }
     
     for(int j = 0; j <= 30; j++){

       //linearGraphic.text(j+2,(((j+1)*(linearGraphic.width-80))/(30))+ borderX, linearGraphic.height - (borderY-20)); 
       if(j <  30)linearGraphic.text(j+2,j*24*2+ borderX, linearGraphic.height - (borderY-20)); 
       if(j == 30)linearGraphic.text("Julio",j*24*2+ borderX, linearGraphic.height - (borderY-20));
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
            int x = indiceLine*2 + borderX;
            int y = (4 * (100 - (int) occ.get(i))) + borderY;
            linearGraphic.fill(255); linearGraphic.stroke(255);
            linearGraphic.fill(poiColor[i]); linearGraphic.stroke(poiColor[i]);
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
  
  public void drawSpeedometer(){
    speedometerCanvas.background(0);
    for(int i = 0; i < 5; i++){
      color rectName = color(180,50);
      speedometerCanvas.fill(rectName); speedometerCanvas.noStroke();
      /*first rect every 15 min*/
      speedometerCanvas.rect(60 + speedometer.width*i, 35 , speedometer.width - 80, 50, 7);
      /*second block max - min - prom day*/
      speedometerCanvas.rect(60 + speedometer.width*i, 100 , speedometer.width/2.5, 30, 7);
      speedometerCanvas.rect(60 + speedometer.width*i, 135 , speedometer.width/2.5, 30, 7);
      speedometerCanvas.rect(60 + speedometer.width*i, 170, speedometer.width/2.5, 30, 7);
      rectName = color(220,80);
      speedometerCanvas.fill(rectName);
      speedometerCanvas.rect(80 + speedometer.width*i + speedometer.width/2.5, 100, speedometer.width/5 , 30,7);
      speedometerCanvas.rect(80 + speedometer.width*i + speedometer.width/2.5, 135, speedometer.width/5 , 30,7);
      speedometerCanvas.rect(80 + speedometer.width*i + speedometer.width/2.5, 170, speedometer.width/5 , 30,7);    
          
      speedometerCanvas.textFont(createFont("Georgia",15)); speedometerCanvas.textAlign(CENTER); speedometerCanvas.fill(255);
      if(i == 0) {
        speedometerCanvas.text( "Fener 1 - Fener 2", 26 + speedometer.width*i+speedometer.width/2, 15);
      }
      if(i == 1) {
        speedometerCanvas.text( "Parc Central 1 - Parc Central 2", 26 + speedometer.width*i+speedometer.width/2, 15);
      }
      if(i == 2){
        speedometerCanvas.text( "Centre Historic - Prat de la Creu", 26 + speedometer.width*i+speedometer.width/2, 15);
      }
      if(i == 3) {
        speedometerCanvas.text( "Trilla - Prada Casadet", 26 + speedometer.width*i+speedometer.width/2, 15);
      }
      if(i == 4) {
        speedometerCanvas.text( "Serradells - Antic Cami Ral", 26 + speedometer.width*i+speedometer.width/2, 15);
      }
   }
  
  speedometerCanvas.textFont(createFont("Georgia",12));
  ArrayList namepark = pois.getPOInames();
  ArrayList capacitypark = pois.getCapacity(); 
  pois.draw(occupancy, true);
  for(int i = 0; i < namepark.size(); i++){
     int number = (int)capacitypark.get(i);
     String mostrar = (String)namepark.get(i);
     speedometerCanvas.textAlign(CENTER);
     
     if(i % 2 == 0){
       speedometerCanvas.textAlign(CENTER);
       speedometerCanvas.text(str(number), 180 + speedometer.width*(i/2), 65 ); 
       speedometerCanvas.text("capacity", 180 + speedometer.width*(i/2), 50 );
       speedometerCanvas.text("Max per day", 120 + speedometer.width*(i/2), 120 );
       speedometerCanvas.text("Min per day", 120 + speedometer.width*(i/2), 155 );
       speedometerCanvas.text("Average per day", 120 + speedometer.width*(i/2), 190 );
       speedometerCanvas.textAlign(LEFT);
       speedometerCanvas.fill(poiColor[i]);
       speedometerCanvas.text(mostrar,70 + speedometer.width*(i/2), 65);
       speedometerCanvas.fill(255);
       lastNamex = 180 + speedometer.width*(i/2);
       lastNamey = 65 ;
     }else{
       speedometerCanvas.textAlign(CENTER);
       speedometerCanvas.text(str(number), lastNamex, lastNamey+13);
       speedometerCanvas.textAlign(LEFT);
       speedometerCanvas.fill(poiColor[i]);
       speedometerCanvas.text(mostrar, lastNamex-110, lastNamey+13);
       speedometerCanvas.fill(255);
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