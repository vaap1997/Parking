/**
* Roads - Class to manage the roadmap of simulation
* @author        Vanesa Alcantara
* @version       2.0
*/
public class TimePark{
  ArrayList <TimeP> park;
  ArrayList<String> chronometer;
  IntDict maxMin = new IntDict();
  int totalTime;
  int dayMin =  Integer.MAX_VALUE;
  int dayMax = -Integer.MAX_VALUE;
  int monthMin =  Integer.MAX_VALUE;
  int monthMax = -Integer.MAX_VALUE;
  int yearMin =  Integer.MAX_VALUE;
  int yearMax = -Integer.MAX_VALUE;
  int hourMin =  Integer.MAX_VALUE;
  int hourMax = -Integer.MAX_VALUE;
  int minMin =  Integer.MAX_VALUE;
  int minMax = -Integer.MAX_VALUE;
  
  //Recognize if the file exist
  public TimePark(String path){
    chronometer = new ArrayList();
    if(path!= null) loadCSV(path);
    else println("There is not file");
    chronometer = Chronometer();
  }
  
  //Load CSV file
  public void loadCSV(String path){
    int a=0;
     print("Loading time...");
     park = new ArrayList();   
     Table table = loadTable(path,"header");
     for(TableRow row:table.rows()){
       int movType = row.getInt("Movement Type");
       int passages = row.getInt("Passages");
       if( passages != 0){
         int  carParkNumber = row.getInt("Car Park Number");
         int deviceNum = row.getInt("Device Number");
         for(POI poi:pois.getAll()){
           for(int i=0; i < poi.DEVICENUM.size();i++){
              if( (deviceNum == poi.DEVICENUM.get(i)) && ( poi.PARKNUMBER == carParkNumber) ){
                 String time0 = row.getString("DateTime");       
                 String time1 = time0.replace(" ","/");
                 String time2 = time1.replace(":","/");
                 int[] Time = int(time2.split("/")) ;
                
                 dayMin = min(dayMin,Time[0]);
                 dayMax = max(dayMax,Time[0]);
                 monthMin = min(monthMin,Time[1]);
                 monthMax = max(monthMax,Time[1]);
                 yearMin = min(yearMin,Time[2]);
                 yearMax = max(yearMax,Time[2]);
                 hourMin = min(hourMin,Time[3]);
                 hourMax = max(hourMax,Time[3]);
                 minMin = min(minMin,Time[4]);
                 minMax = max(minMax,Time[4]);
                 a++;
                 park.add(new TimeP(carParkNumber,deviceNum,movType,time0, passages));    
                 
               }
           }   
         } 
       }
    }
     print("LOADED");
  }
  
  //Create an array with all the dates in the range
  public ArrayList<String> Chronometer(){
    ArrayList<String> chronometer = new ArrayList();
      for(int year = yearMin; year <= yearMax; year++){
        
        for(int month = monthMin; month <= monthMax; month++){
          String monthstr = str(month);
          
            if(monthstr.length() == 1){
              monthstr = '0' + monthstr;
            }
            
            for(int day = dayMin; day <= dayMax; day++){
         
                for(int hour = hourMin; hour <= hourMax; hour++){
                    String hourstr = str(hour);
                    if(hourstr.length() == 1){
                     hourstr = "0" + hourstr; 
                    }
                    for(int min = minMin; min <= minMax; min = min + 15){
                        String minstr = str(min);
                        if(minstr.length() == 1){
                         minstr = "0" + minstr; 
                        }
                       String dia = str(day) + "/"+monthstr + "/"+str(year) + " "+hourstr + ":" + minstr;
                       chronometer.add(dia);
                    } 
                } 
            }
        }
      }
     return chronometer;
  }
  
 
  
  public ArrayList getTotalOccupancy(){
    print("\nLoading occPerDate...");
    ArrayList occPerDate = new ArrayList(); 
    IntList occPerPoi = new IntList();
    ArrayList<PVector> maxmin = new ArrayList();
    for(int a = 0; a < chronometer.size(); a++){
    occPerPoi.set(a,0);
    }
    for(int i=0; i <chronometer.size(); i++){ 
      for(int a = 0; a < pois.count(); a++){
        maxmin.add(a,new PVector(0,0));
      }
        for(TimeP park:park){
          if(park.TIME.equals(chronometer.get(i))){
            int c=0;
             for( POI poi:pois.getAll()){
                    if( poi.PARKNUMBER == park.CARPARKNUMBER){
                        if(park.MOVTYPE == 1){
                          occPerPoi.set(c,occPerPoi.get(c)-park.PASSAGES);
                          maxmin.set(c,new PVector(maxmin.get(c).x,maxmin.get(c).y+park.PASSAGES));
                        }else{
                          occPerPoi.set(c,occPerPoi.get(c)+park.PASSAGES);
                          if(park.MOVTYPE == 0 | (park.MOVTYPE ==2 && park.MOVTYPE > 0)){
                            maxmin.set(c, new PVector(maxmin.get(c).x+park.PASSAGES,maxmin.get(c).y));
                          }else{
                            maxmin.set(c, new PVector(maxmin.get(c).x, maxmin.get(c).y-park.PASSAGES));
                          }   
                        }
                    }
             c++; 
          }
        }
      }
     ArrayList occTemporal = new ArrayList();
         occTemporal.add(0,chronometer.get(i));
         int k=1;
         for(POI poi:pois.getAll()){
           occTemporal.add(k,occPerPoi.get(k-1));
           maxMin.set(chronometer.get(i)+poi.PARKNUMBER+"in",(int)maxmin.get(k-1).x);
           maxMin.set(chronometer.get(i)+poi.PARKNUMBER+"out",(int)maxmin.get(k-1).y);
            k++;
         }
     occPerDate.add(occTemporal);    
    }
   return occPerDate;
  }
  
   public int getIn(int indice, POI poi){
    return maxMin.get(indice+poi.PARKNUMBER+"in"); 
   }
   
   public int getOut(String indice, POI poi){
    return maxMin.get(indice+poi.PARKNUMBER+"out"); 
   }
    
  public IntList getOccupancy(String dateS){
      IntList occupancy = new IntList(pois.count());
      for(int i = 0; i < occPerDate.size(); i++){
       ArrayList temporal = (ArrayList) occPerDate.get(i);
       if(dateS.equals(temporal.get(0))){
          for(int c = 1; c < temporal.size(); c++){
            occupancy.set(c-1,(int)temporal.get(c));
          }
       }
      }
    return occupancy;
  }
 
  public ArrayList<ArrayList> dinamicHours(int indexResume){
    ArrayList<ArrayList> dinamicHours = new ArrayList();
    ArrayList<PVector> dinamicHoursValue = new ArrayList();
    
    for(int k=0; k<pois.count();k++){
      ArrayList a = new ArrayList();
      a.add(" ");
      a.add(" ");
      dinamicHours.add(a);
      dinamicHoursValue.add(new PVector(-Integer.MAX_VALUE,Integer.MAX_VALUE));
    }

      for(int i=indexResume; i<indexResume+96;i++){
         ArrayList temporal = (ArrayList) occPerDate.get(i);
         String date = (String) temporal.get(0);
         int place = date.indexOf(":"); 
         String dayToCompare = date.substring(place-2,place+3);
         for(int x=1; x<temporal.size(); x++){
           float compare1 = float((int)temporal.get(x));
           float maximo = max((float) dinamicHoursValue.get(x-1).x,compare1);
           float minimo = min((float) dinamicHoursValue.get(x-1).y,compare1);
           dinamicHoursValue.set(x-1,new PVector( maximo, minimo));
           ArrayList b = (ArrayList) dinamicHours.get(x-1);
           if(dinamicHoursValue.get(x-1).x == compare1) b.set(0,dayToCompare);
           if(dinamicHoursValue.get(x-1).y == compare1) b.set(1,dayToCompare);
           dinamicHours.set(x-1,b);
         }
      }

    //print("\n"+ dinamicHours);
    return dinamicHours;
  }
  

  public ArrayList<PVector> maxMinHour(){
   print("\nLoading max and min per hour...");
   ArrayList<PVector> MaxMin = new ArrayList(pois.count());
   ArrayList<PVector> MaxMinValor = new ArrayList(pois.count());
   for(int k=0; k<pois.count();k++){
      MaxMin.add(k,new PVector(1,-1));
      MaxMinValor.add(k,new PVector(-Integer.MAX_VALUE,Integer.MAX_VALUE)); 
   }
   for( int i = 0; i <24; i++){
         FloatList parkingPerHour = new FloatList(); 
         int x=0;
         for( POI poi:pois.getAll()){
            parkingPerHour.set(x,0);
            x++;
         } 
         for(int c=0; c <occPerDate.size(); c++){
           ArrayList temporal = (ArrayList) occPerDate.get(c);
           String date = (String) temporal.get(0);
           int place = date.indexOf(":"); 
           int dayToCompare = int( date.substring(place-2,place));
           if( dayToCompare == i){
             for(int j = 1; j < temporal.size(); j++){                            
               parkingPerHour.set(j-1,parkingPerHour.get(j-1)+(int)temporal.get(j));                                 
             }
           }
         } 
         for(int k = 0; k < pois.count();k++){
           float maximo = max(MaxMinValor.get(k).x,parkingPerHour.get(k));
           float minimo = min(MaxMinValor.get(k).y,parkingPerHour.get(k));
           MaxMinValor.set(k,new PVector( maximo, minimo));
           if(MaxMinValor.get(k).x == parkingPerHour.get(k)) MaxMin.get(k).x = i;
           if(MaxMinValor.get(k).y == parkingPerHour.get(k)) MaxMin.get(k).y = i;
         }         
   }
   return MaxMin;
 }
 
 
 
 public ArrayList<String> dinamicDay(int indexResume){
   ArrayList<Float> total = new ArrayList();
   ArrayList<String> maxDay = new ArrayList();
   String[] nameDay = {"SAT", "SUN", "MON", "TUE", "WED", "THR", "FRI"};
   for(int k=0; k<pois.count();k++){
     total.add(k,-Float.MAX_VALUE);
     maxDay.add(k,null);
   }
   int x=0;
   for(int i = indexResume; i<indexResume+642; i=i+96){
     FloatList parkingPerDay = new FloatList();
     for(int c=0; c<pois.count();c++){
       parkingPerDay.set(c,0);
     }
     for(int j=i; j<i+96;j++){
      ArrayList temporal = (ArrayList) occPerDate.get(j);
        for(int k = 1; k < temporal.size(); k++){                            
          parkingPerDay.set(k-1,parkingPerDay.get(k-1)+(int)temporal.get(k));                                 
        } 
     }
     
     for(int j = 0; j < pois.count();j++){
       float maximo = max(total.get(j),parkingPerDay.get(j));
       total.set(j,maximo);
       if(total.get(j) == parkingPerDay.get(j)) maxDay.set(j, nameDay[x]);
     }
     x++;
   }
   return maxDay;  
 } 
 
 public ArrayList<String>  maxDay(){
   ArrayList<Float> total = new ArrayList();
   ArrayList<String> maxDay = new ArrayList();
   String[] nameDay = {"SAT", "SUN", "MON", "TUE", "WED", "THR", "FRI"};
   print("\nLoading max per day...");
   for(int k=0; k <pois.count();k++){
     total.add(k,-Float.MAX_VALUE);
     maxDay.add(k, null);
   }
   /*0=sabado,1=domingo, 2=lunes, 3=martes, 4=miercoles, 5=jueves, 6= viernes
   */
   for(int k = 0; k < 7; k++){
     FloatList parkingPerDay = new FloatList();
     for(int c=0; c<pois.count();c++){
       parkingPerDay.set(c,0);
     }
     for(int c = k; c < occPerDate.size(); c=c+28){
       for(int i=c; i < c+4; i++){
         ArrayList temporal = (ArrayList) occPerDate.get(c);
           for(int j = 1; j < temporal.size(); j++){                            
              parkingPerDay.set(j-1,parkingPerDay.get(j-1)+(int)temporal.get(j));                                 
            }
       }
     }
     
     for(int j = 0; j < pois.count();j++){
       float maximo = max(total.get(j),parkingPerDay.get(j));
       total.set(j,maximo);
       if(total.get(j) == parkingPerDay.get(j)) maxDay.set(j, nameDay[k]);
     }
   }
  return maxDay; 
 }
 


  //Total time in seconds

  public int getmax(){
    totalTime = (yearMax - yearMin+1) * (monthMax - monthMin +1) * (dayMax - dayMin + 1) * (24) * (4);
    return totalTime;
  }

}

public class TimeP{
  protected final int DEVICENUM;
  protected final int MOVTYPE;
  protected final String TIME;
  protected final int PASSAGES;
  protected final int CARPARKNUMBER;

  
  
  public TimeP(int carParkNumber,int deviceNum,int movType,String time, int passages){
    DEVICENUM = deviceNum;
    MOVTYPE = movType;
    TIME = time;
    PASSAGES = passages;
    CARPARKNUMBER = carParkNumber;
  } 
}