/**
* Chart - Class to create pie, line and speedometer charts
* @author        Vanesa Alcantara
* @version       1.0
*/
public class PieChart{
  String message;
  PFont f = createFont("Georgia",15,true);
  ArrayList<String> namePark = pois.getPOInames();
  ArrayList lineIni = (ArrayList) occPerDate.get(0);
  int borderX = 40;
  int borderY = 40;
  color[] poiColor = { color(#A9BDCF), color(#Ef7501), color(230,0,0), color(#3500E5), color(#0ABCB2), color(#E50083), color(#8448b8), color(#FFF500), color(#00bc6c), color(#e5a68e)};
  //                 {ligh blue, orange, red, blue, water blue, pink, purple, yellow, dark green, pink}
  ArrayList<Line> lines = new ArrayList();
  int repeat = 0;
  
  /**
  * Draw the cartesian plane
  * Daw percentage legend
  * Draw days legend
  * Media per hour
  * Draw lines coordinate with the chronometer and depending if the parking is selected or not
  * Refresh with every chronometer complete
  */
  public void drawLineGraph(){
     //color coLine = 255;
     
     linearGraphic.textSize(10);
     linearGraphic.fill(255); linearGraphic.stroke(255);
     
     if (indice % 4.00 == 0.00) {
       if(indice < occPerDate.size()){
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
           if(poi.access.equals("publicPark")){
              occ.set(c, ((int) occ.get(c) * 100)/(4 * poi.CAPACITY));
              if((int) occ.get(c) >= 100) occ.set(c,100);
              c++;
           }
         }

         for( int i = 0; i < occ.size(); i++){
            int x = indiceLine + borderX;
            int y = (4 * (100 - (int) occ.get(i))) + borderY*2;
            linearGraphic.fill(255); linearGraphic.stroke(255);
            
            if(lastIndice != indice){
              if(indice>=8)  lines.add(new Line(lastCoord.get(i).x,lastCoord.get(i).y,x,y, i+1, repeat));
              lastCoord.set(i, new PVector(x,y));
            }
         }
             linearGraphic.background(0);
             linearGraphic.line(borderX,linearGraphic.height-borderY,borderX,borderY*2);
             linearGraphic.line(borderX,linearGraphic.height-borderY,timePark.chronometer.size()/2+borderX,linearGraphic.height-borderY);
             linearGraphic.textFont(createFont("Raleway", 20)); linearGraphic.textAlign(LEFT);
             linearGraphic.text("Average parking occupancy in July 2016",borderX,40);
             linearGraphic.textSize(10);
             for(int i = 0; i <= 10; i++){
               linearGraphic.textAlign(CENTER);
               linearGraphic.text(str(i*10) + "%", borderX - 20, linearGraphic.height - borderY * (i+1));
             }
             for(int j = 0; j <= 30; j++){
               if(j <  30)linearGraphic.text(j+2,j*24+ borderX, linearGraphic.height - (borderY-20)); 
               if(j == 30)linearGraphic.text("July",j*24+ borderX, linearGraphic.height - (borderY-20));
             }
          for(Line line:lines){
            if(type1){
                   if((line.TYPE == 1) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                   }
              }
              if(type2){
                   if((line.TYPE == 2) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type3){
                   if((line.TYPE == 3) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type4){
                   if((line.TYPE == 4) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type5){
                   if((line.TYPE == 5) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type6){
                   if((line.TYPE == 6) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type7){
                   if((line.TYPE == 7) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type8){
                   if((line.TYPE == 8) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type9){
                   if((line.TYPE == 9) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
              if(type0){
                   if((line.TYPE == 10) && (line.repeat == repeat)){
                    linearGraphic.fill(poiColor[line.TYPE-1]); linearGraphic.stroke(poiColor[line.TYPE-1]);
                    linearGraphic.line(line.LASTCOORDSx,line.LASTCOORDSy,line.COORDSx, line.COORDSy); 
                  }
              }
          }
          
       if(lastIndice != indice) indiceLine++;   
       } else {
          linearGraphic.background(0);
          repeat++;
          indiceLine = 0;
          int j=0;
          for(POI poi : pois.getAll()){
           if(poi.access.equals("publicPark")){
             lastCoord.add(j,new PVector(pieChart.borderX,(int)pieChart.lineIni.get(j+1) / poi.CAPACITY)); 
             j++;
           }
         }
       } 
     } 
  }
 
  
  /**
  * Upload every daythe maximum and minimun time of occupancy of the day
  * Upload every week the maximun day of occupancy
  * Fill the parking name with color in case it is selected
  * Draw the use's percentage for every parking
  * Draw capacity, name, max and min hour of the day, maxday of the week
  */
  
  public void BasicParkingStats(){
   individualCanvas.background(0);
   individualCanvas.textFont(createFont("Raleway", 20)); individualCanvas.textAlign(LEFT); individualCanvas.fill(255);
   individualCanvas.text("Basic parking stats", 40, 20);
   if(indice % 96 == 0){
      dinamicHours = timePark.dinamicHours(indice);
   }
   if(indice % 672 == 0){
     maxDay = timePark.dinamicDay(indice);
   }
   int i=0;
   for(POI poi:pois.getAll()){ 
     if(poi.access.equals("publicPark")){
       if(type1 && i==0)individualCanvas.fill(poiColor[0]);
       if(type2 && i==1)individualCanvas.fill(poiColor[1]);
       else individualCanvas.fill(255);
       if(type3 && i==2)individualCanvas.fill(poiColor[2]); 
       if(type4 && i==3)individualCanvas.fill(poiColor[3]); 
       if(type5 && i==4)individualCanvas.fill(poiColor[4]); 
       if(type6 && i==5)individualCanvas.fill(poiColor[5]);
       if(type7 && i==6)individualCanvas.fill(poiColor[6]);
       if(type8 && i==7)individualCanvas.fill(poiColor[7]);
       if(type9 && i==8)individualCanvas.fill(poiColor[8]); 
       if(type0 && i==9)individualCanvas.fill(poiColor[9]);  
       individualCanvas.textSize(15.5); individualCanvas.textAlign(CENTER);
       individualCanvas.text(poi.NAME,((i+1)*individualCanvas.width/(pois.count()+1))+40,50);   
       individualCanvas.fill(255);individualCanvas.textSize(14);
       int use = int(((float)occupancy.get(i) / (float)poi.CAPACITY)*100);
       individualCanvas.text(use+"%",((i+1)*individualCanvas.width/(pois.count()+1))+40,2* individualCanvas.height/8);
       individualCanvas.text(poi.CAPACITY,((i+1)*individualCanvas.width/(pois.count()+1))+40, 3* individualCanvas.height/8);
       individualCanvas.text(poi.PRICE+"€",((i+1)*individualCanvas.width/(pois.count()+1))+40, 4* individualCanvas.height/8);
       ArrayList b = (ArrayList) dinamicHours.get(i);
       String tempmax= (String) b.get(0);
       String tempmin= (String) b.get(1);
       individualCanvas.text( tempmax, ((i+1)*individualCanvas.width/(pois.count()+1))+40, 5* individualCanvas.height/8);
       individualCanvas.text( tempmin, ((i+1)*individualCanvas.width/(pois.count()+1))+40, 6* individualCanvas.height/8);
       
       individualCanvas.text( maxDay.get(i), ((i+1)*individualCanvas.width/(pois.count()+1))+40, 7* individualCanvas.height/8);
       i++;
     }
   }
   individualCanvas.textAlign(RIGHT);individualCanvas.fill(255);individualCanvas.textSize(11);
   individualCanvas.text("OCCUPANCY", 90, 2* individualCanvas.height/8);
   individualCanvas.text("CAPACITY", 90, 3* individualCanvas.height/8);
   individualCanvas.text("PRICE", 90, 4* individualCanvas.height/8);
   individualCanvas.text("MAX", 90, 5* individualCanvas.height/8);
   individualCanvas.text("MIN", 90, 6* individualCanvas.height/8);
   individualCanvas.text("DAY", 90, 7* individualCanvas.height/8);

  }
  
  
  public void drawIndResume(){
   individualCanvas.background(0);
   individualCanvas.ellipseMode(CENTER); 
   PVector coordInd = new PVector(0,0);
   color rectName = color(180,50);
   if(indice % 96 == 0){
      dinamicHours = timePark.dinamicHours(indice);
   }

   int i = 0;
   for(POI poi:pois.getAll()){
     if(poi.access.equals("publicPark")){
       individualCanvas.noFill();individualCanvas.textAlign(CENTER); individualCanvas.stroke(255,50);
       if(i % 2 == 0 ) {
          coordInd.x = 20 + (i/2)*individualCanvas.width/(pois.count()/2);
          coordInd.y = 20;        
       }else{
          coordInd.x = 20 + ((i/1)/2)*individualCanvas.width/(pois.count()/2);
          coordInd.y = individualCanvas.height/2;
       }
          int heightRect = individualCanvas.width/(pois.count()/2) - 40 ;
          int widthRect = individualCanvas.height/2 - 60;
          individualCanvas.rect(coordInd.x, coordInd.y,heightRect,widthRect);
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
          ArrayList b = (ArrayList) dinamicHours.get(i);
          String tempmax= (String) b.get(0);
          String tempmin= (String) b.get(1);
          individualCanvas.text( tempmax, coordInd.x+197,coordInd.y+140);
          individualCanvas.text( tempmin, coordInd.x+197,coordInd.y+175);
          individualCanvas.text( maxDay.get(i), coordInd.x+197,coordInd.y+210);
       i++;
     }
   }
  }
  
  
 /**
 * Draw legend in order to explain Andorra's surface
 */
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

/**
* class to link every lane to a parking
* let draw just the ones link with the parking selected
* let have a new line chart with every total repetition (at the end of all the month)
*/
public class Line{
  public int TYPE;
  protected final float LASTCOORDSx;
  protected final float LASTCOORDSy;
  protected final int COORDSx;
  protected final int COORDSy;
  protected final int repeat;
  public Line(float lastCoordsx,float lastCoordsy,int coordsx, int coordsy,int type, int repeat){
    TYPE =  type;
    COORDSx = coordsx;
    COORDSy = coordsy;
    LASTCOORDSy = lastCoordsy;
    LASTCOORDSx = lastCoordsx;
    this.repeat =  repeat;
    
  }

 }