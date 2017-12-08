/**
* Roads - Class to manage the roadmap of simulation
* @author        Vanesa Alcantara
* @version       2.0
*/
public class TimePark{
  ArrayList <TimeP> park;
  ArrayList<DateTime> chronometer;
  IntDict maxMin = new IntDict();
  int totalTime;
  DateTime minDate = null;
  DateTime maxDate = null;
  Period differenceInTime;
  //private POIs pois;
  
  /**
  * Recognize if the file exist
  */
  public TimePark(String path){
    chronometer = new ArrayList();
    if(path!= null) loadCSV(path);
    else println("There is not file");
    chronometer = Chronometer();
  }
  
  /**
  * Load CSV file
  */
  public void loadCSV(String path){
    DateTime parkingTime;
     print("Loading time...");
     
     park = new ArrayList();   
     Table table = loadTable(path,"header");
     for(TableRow row:table.rows()){
       int movType = row.getInt("Movement Type");
       int passages = row.getInt("Passages");
       if( passages != 0){
         int carParkNumber = row.getInt("Car Park Number");
         int deviceNum = row.getInt("Device Number");
         for(POI poi:pois.getAll()){
           if(poi.access.equals("publicPark")){
             for(int i=0; i < poi.DEVICENUM.size();i++){
                if( (deviceNum == poi.DEVICENUM.get(i)) && ( poi.PARKNUMBER == carParkNumber) ){
                   String timestamp = row.getString("DateTime");
                   parkingTime = fmtPark.parseDateTime(timestamp);
                   
                    if( parkingTime.isAfter(maxDate) || maxDate == null){
                        maxDate = parkingTime;
                    }
                    
                    if(parkingTime.isBefore(minDate) || minDate == null ){
                        minDate = parkingTime;
                    }

                   park.add(new TimeP(carParkNumber,deviceNum,movType, parkingTime, passages));         
                 }
             }   
           } 
         }
       }
    }
     print("LOADED");
  }
  
  /**
  * Create an array with all the dates in the range
  */
  public ArrayList<DateTime> Chronometer(){
    ArrayList<DateTime> chronometer = new ArrayList();
    DateTime actualDate = minDate;
    while(actualDate.isBefore(maxDate) || actualDate.isEqual(maxDate)){
       chronometer.add(actualDate);
       actualDate =  actualDate.plusMinutes(15);
    }
     return chronometer;
  }
  
 
  /**
  * Create an array with all the occupancies every date
  */
  public ArrayList getTotalOccupancy(){
    print("\nLoading occPerDate...");
    ArrayList occPerDate = new ArrayList(); 
    IntList occPerPoi = new IntList();
    for(int a = 0; a < chronometer.size(); a++){
    occPerPoi.set(a,0);
    }
    for(int i=0; i <chronometer.size(); i++){ 
        for(TimeP park:park){
          if(park.TIME.isEqual(chronometer.get(i))){
            int c=0;
             for( POI poi:pois.getAll()){
               if(poi.access.equals("publicPark")){
                    if( poi.PARKNUMBER == park.CARPARKNUMBER){
                        if(park.MOVTYPE == 1){
                          occPerPoi.set(c,occPerPoi.get(c)-park.PASSAGES);
                        }else{
                          occPerPoi.set(c,occPerPoi.get(c)+park.PASSAGES);
                        }
                    }
               c++; 
            }
          }
        }
      }
     ArrayList occTemporal = new ArrayList();
         occTemporal.add(0,chronometer.get(i).toString(fmtToShow));
         int k=1;
         for(POI poi:pois.getAll()){
           if(poi.access.equals("publicPark")){
             occTemporal.add(k,occPerPoi.get(k-1));
              k++;
           }
         }
     occPerDate.add(occTemporal);    
    }
   return occPerDate;
  }
  
  /**
 * Return the occupancy in the date given 
 */  
  public IntList getOccupancy(String dateS){
      IntList occupancy = new IntList(pois.count());
      for(int i = 0; i < occPerDate.size(); i++){
       ArrayList temporal = (ArrayList) occPerDate.get(i);
       if(dateS.equals(temporal.get(0) )){
          for(int c = 1; c < temporal.size(); c++){
            occupancy.set(c-1,(int)temporal.get(c));
          }
        }
      }
    return occupancy;
  }
 
 /**
 * compare hours in a day begining by the date given 
 */
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
  
  /**
 * find the max and min hour in promedio in the month
 */
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
           if(poi.access.equals("publicPark")){
              parkingPerHour.set(x,0);
              x++;
           }
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
 
  /**
 * make arrays statistics of day media occupancy every days for 7 days and compare everyday statistics to find the max day
 */
 public ArrayList<String> dinamicDay(int indexResume){
   ArrayList<Float> total = new ArrayList();
   ArrayList<String> maxDay = new ArrayList();
   String[] nameDay = {"SAT", "SUN", "MON", "TUE", "WED", "THR", "FRI"};
   for(int k=0; k<pois.count();k++){
     total.add(k,-Float.MAX_VALUE);
     maxDay.add(k,null);
   }
   int x=0;
   for(int i = indexResume; i<indexResume+672; i=i+96){
     FloatList parkingPerDay = new FloatList();
     for(int c=0; c<pois.count();c++){
       parkingPerDay.set(c,0);
     }
     for(int j=i; j<i+96;j++){
      if(j<occPerDate.size()){
        ArrayList temporal = (ArrayList) occPerDate.get(j);
          for(int k = 1; k < temporal.size(); k++){                            
            parkingPerDay.set(k-1,parkingPerDay.get(k-1)+(int)temporal.get(k));                                 
          } 
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
 
 
 /**
 * make arrays statistics of everyday of the weekend and find the media of the month
 */
 public ArrayList<String>  maxDay(){
   ArrayList<Float> total = new ArrayList();
   ArrayList<String> maxDay = new ArrayList();
   String[] nameDay = {"SAT", "SUN", "MON", "TUE", "WED", "THR", "FRI"};
   print("\nLoading max per day...");
   for(int k=0; k <pois.count();k++){
     total.add(k,-Float.MAX_VALUE);
     maxDay.add(k, null);
   }

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
 
  /**
  * total time in seconds that contain the file
  */
  public int getmax(){
    Minutes minBetween = Minutes.minutesBetween(minDate, maxDate);
    totalTime = minBetween.getMinutes() / 15;
    return totalTime;
  }

}

public class TimeP{
  protected final int DEVICENUM;
  protected final int MOVTYPE;
  protected final DateTime TIME;
  protected final int PASSAGES;
  protected final int CARPARKNUMBER;


  public TimeP(int carParkNumber,int deviceNum,int movType,DateTime time, int passages){
    DEVICENUM = deviceNum;
    MOVTYPE = movType;
    TIME = time;
    PASSAGES = passages;
    CARPARKNUMBER = carParkNumber;
  } 
}