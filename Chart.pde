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
  ArrayList<Line> lines = new ArrayList();
  
  public void drawZoneIndice(){
    color occColor = 255;
    for(int i = 0; i < 7;i++){
       chart.fill(255);chart.textAlign(CENTER); chart.ellipseMode(CENTER);
       chart.textFont(createFont("Georgia",20));
      if( i == 0){ 
       //chart.textFont(createFont("Georgia",30)); 
       chart.textFont(createFont("IMPACT",30)); 
       chart.text("Date: " + actualDate[0]+"   "+actualDate[1] , chart.width/2, (i * height/7)+60);
       chart.textFont(createFont("Georgia",20));
      }
      if(i == 1){
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2, (i * height/7)+60,130,130);
        chart.fill(255);
        chart.text("TOTAL OCCUPANCY", chart.width/2, (i * height/7) - 30);
        chart.textFont(createFont("Georgia",50));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+70);
      }
      if(i == 2) {
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2,(i * height/7)+80,100,100);
        chart.fill(255);
        chart.text( "Fener 1 - Fener 2", chart.width/2, (i * height/7)+10);
        chart.textFont(createFont("Georgia",40));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+90);
      }
      if(i == 3) {
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2,(i * height/7)+80,100,100);
        chart.fill(255);
        chart.text( "Parc Central 1 - Parc Central 2", chart.width/2, (i * height/7)+10);
        chart.textFont(createFont("Georgia",40));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+90);
      }
      if(i == 4){
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2,(i * height/7)+95,100,100);
        chart.textLeading(20);chart.fill(255);
        chart.text( "Centre Historic - Prat de la Creu\nPrada Casadet", chart.width/2, (i * height/7)+10);
        chart.textFont(createFont("Georgia",40));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+105);
      }
      if(i == 5) {
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2,(i * height/7)+80,100,100);
        chart.fill(255);
        chart.text( "Trilla", chart.width/2, (i * height/7)+20);
        chart.textFont(createFont("Georgia",40));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+90);
      }
      if(i == 6) {
        occColor= lerpColor(#4DFF00, #E60000,occPerZone.get(i-1));
        chart.fill(occColor);
        chart.ellipse(chart.width/2,(i * height/7)+80,100,100);
        chart.fill(255);
        chart.text( "Serradells - Antic Cami Ral", chart.width/2, (i * height/7)+10);
        chart.textFont(createFont("Georgia",40));
        chart.text(int(occPerZone.get(i-1)*100) +"%",chart.width/2, (i * height/7)+90);
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
            if(lastIndice != indice){
              //if(indice >= 4) linearGraphic.line(lastCoord.get(i).x, lastCoord.get(i).y,x,y);
              if(indice>=8) lines.add(new Line(lastCoord.get(i).x,lastCoord.get(i).y,x,y, i+1));
              lastCoord.set(i, new PVector(x,y));
            }
         }
             linearGraphic.background(0);
             linearGraphic.line(borderX,linearGraphic.height-borderY,borderX,borderY);
             linearGraphic.line(borderX,linearGraphic.height-borderY,timePark.chronometer.size()/2+borderX,linearGraphic.height-borderY);
             for(int i = 0; i <= 10; i++){
               linearGraphic.textAlign(CENTER);
               linearGraphic.text(str(i*10) + "%", borderX - 20, linearGraphic.height - borderY * (i+1));
             }
             for(int j = 0; j <= 30; j++){
               if(j <  30)linearGraphic.text(j+2,j*24*2+ borderX, linearGraphic.height - (borderY-20)); 
               if(j == 30)linearGraphic.text("July",j*24*2+ borderX, linearGraphic.height - (borderY-20));
             }
          for(Line line:lines){
            if(type1){
                   if(line.TYPE == 1){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                   }
              }
              if(type2){
                   if(line.TYPE == 2){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type3){
                   if(line.TYPE == 3){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type4){
                   if(line.TYPE == 4){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type5){
                   if(line.TYPE == 5){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type6){
                   if(line.TYPE == 6){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type7){
                   if(line.TYPE == 7){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type8){
                   if(line.TYPE == 8){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type9){
                   if(line.TYPE == 9){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type0){
                   if(line.TYPE == 10){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
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
  
  public void drawIndResume(){
   individualCanvas.background(0);
   individualCanvas.ellipseMode(CENTER); 
     
   int i = 0;
   PVector coordInd = new PVector(0,0);
   color rectName = color(180,50);
   for(POI poi:pois.getAll()){   
     individualCanvas.noFill();individualCanvas.textAlign(CENTER); individualCanvas.stroke(255,50);
     if(i % 2 == 0 ) {
        coordInd.x = 20 + (i/2)*individualCanvas.width/(pois.count()/2);
        coordInd.y = 20;        
     }else{
        coordInd.x = 20 + ((i/1)/2)*individualCanvas.width/(pois.count()/2);
        coordInd.y = individualCanvas.height/2;
     }

        individualCanvas.rect(coordInd.x, coordInd.y,individualCanvas.width/(pois.count()/2) - 40,individualCanvas.height/2 - 60);
        individualCanvas.fill(255,50);
        individualCanvas.ellipse(coordInd.x + 20, coordInd.y + 20, 30,30); 
        individualCanvas.fill(rectName);
        individualCanvas.rect(coordInd.x+30,coordInd.y+62,60,40,7);
        individualCanvas.rect(coordInd.x+100,coordInd.y+62,60,40,7);
        individualCanvas.rect(coordInd.x+170,coordInd.y+62,60,40,7);
        individualCanvas.textFont(createFont("Georgia", 12));individualCanvas.fill(230);individualCanvas.textLeading(15);
        individualCanvas.text("CAPACITY", coordInd.x+60 , coordInd.y+55 );
        individualCanvas.text("PRICE"   , coordInd.x+130, coordInd.y+55 );
        individualCanvas.text("% USE"   , coordInd.x+200, coordInd.y+55 );
        individualCanvas.fill(230);individualCanvas.textLeading(15);
        individualCanvas.text("Max hour of occupancy",  coordInd.x+95, coordInd.y+135 );
        individualCanvas.text("Min hour of occupancy",  coordInd.x+95, coordInd.y+170 );
        individualCanvas.text("Day of max occupancy",  coordInd.x+95, coordInd.y+205  );    
        individualCanvas.fill(80,40);
        individualCanvas.rect(coordInd.x+165,coordInd.y+120,65,30,7);
        individualCanvas.rect(coordInd.x+165,coordInd.y+155,65,30,7);
        individualCanvas.rect(coordInd.x+160,coordInd.y+190,75,30,7);
        individualCanvas.fill(poiColor[i]);individualCanvas.textFont(createFont("Georgia", 20));individualCanvas.textAlign(LEFT);
        individualCanvas.text(poi.NAME,coordInd.x+40, coordInd.y+30);
        individualCanvas.fill(255);individualCanvas.textAlign(CENTER);
        individualCanvas.text(str(i+1),coordInd.x + 20,coordInd.y + 25);
        individualCanvas.textFont(createFont("IMPACT", 22));
        individualCanvas.text(poi.CAPACITY,coordInd.x+60,coordInd.y+88);
        individualCanvas.text(poi.PRICE+"€",coordInd.x+130,coordInd.y+88);
        int use = int(((float)occupancy.get(i) / (float)poi.CAPACITY)*100);
        individualCanvas.text(use+"%",coordInd.x+200,coordInd.y+88);
        individualCanvas.textFont(createFont("Georgia", 15));
        individualCanvas.text( (int) maxMinHour.get(i).x+":00", coordInd.x+197,coordInd.y+140);
        individualCanvas.text( (int) maxMinHour.get(i).y+":00", coordInd.x+197,coordInd.y+175);
        individualCanvas.text( maxDay.get(i), coordInd.x+197,coordInd.y+210);
     i++;
   }
  }
  
  public void drawLegend(){
    legend.background(0);
    legend.stroke(255);
    legend.fill(255);
    legend.textSize(16);
    legend.text("Date:\n" + actualDate[0]+"   "+actualDate[1] ,500,35);
    legend.textSize(13);
    legend.text("Percentage of occupancy",50,20);
    legend.text("Road type",320,20);
    legend.textSize(9);
    legend.noFill();legend.ellipseMode(CENTER);
    legend.ellipse(170,50,20,20);
    legend.ellipse(192,45,10,10);legend.fill(255);
    legend.ellipse(170,50,6,6);
    legend.ellipse(192,57,4,4);
    legend.text("capacity", 205,45);
    legend.text("occupancy", 205,57);
    legend.text("Primary",312,45);
    legend.text("Others",382,60);
    legend.text("Secundary",312,60);
    legend.text("Peatonal",382,45);legend.noStroke();
    legend.fill(#FFF500);
    legend.ellipse(300,45,10,10); 
    legend.fill(#002ADA);
    legend.ellipse(300,60,10,10);
    legend.fill(#CC68FF);
    legend.ellipse(370,45,10,10);
    legend.fill(100);
    legend.ellipse(370,60,10,10);
    for(int i = 0; i < 6; i++){
     legend.fill(lerpColor(#4DFF00, #E60000,0.2*i)); legend.noStroke();
     legend.text(str(int(0.2*i*100)),10+20*i,40);
     legend.rect(10+20*i,50,20,20);
    } 
  }

}

public class Line{
  public int TYPE;
  protected final float LASTCOORDSx;
  protected final float LASTCOORDSy;
  protected final int COORDSx;
  protected final int COORDSy;
  public Line(float lastCoordsx,float lastCoordsy,int coordsx, int coordsy,int type){
    TYPE =  type;
    COORDSx = coordsx;
    COORDSy = coordsy;
    LASTCOORDSy = lastCoordsy;
    LASTCOORDSx = lastCoordsx;
  }
 }