/**
* Roads - Class to manage the roadmap of simulation
* @author        Vanesa Alcantara
* @version       2.0
*/
public class TimePark{
  ArrayList <TimeP> park;
  ArrayList<String> chronometer;
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
     print("Loading time...");
     park = new ArrayList();   
     Table table = loadTable(path,"header");
     for(TableRow row:table.rows()){
       int movType = row.getInt("Movement Type");
       int passages = row.getInt("Passages");
       if( movType != 2 && passages != 0){
           int deviceNum = row.getInt("Device Number");
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
           
           park.add(new TimeP(deviceNum,movType,time0, passages));
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
    ArrayList occPerDate = new ArrayList(); 
    IntList occPerPoi = new IntList();
    for(int a = 0; a < chronometer.size(); a++){
    occPerPoi.set(a,0);
    }
    for(int i=0; i <chronometer.size(); i++){ 
        for(TimeP park:park){
          if(park.TIME.equals(chronometer.get(i))){
            int c=0;
             for( POI poi:pois.getAll()){
             ArrayList devices = poi.DEVICENUM;
                  for(int j = 0; j < devices.size(); j++){
                    if( park.DEVICENUM == (int) devices.get(j)){
                        if(park.MOVTYPE == 0){ 
                          occPerPoi.add(c,park.PASSAGES);
                        }
                       if(park.MOVTYPE == 1){
                          occPerPoi.set(c,(int)occPerPoi.get(c)-park.PASSAGES);
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
            k++;
         }
     //print(occTemporal, chronometer.get(i));
     occPerDate.add(occTemporal);    
    }
   return occPerDate;
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
  
  public ArrayList<FloatList> occupancyPerHour(){
   ArrayList<FloatList> promParkHour = new ArrayList();
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
               parkingPerHour.add(j-1,(int)temporal.get(j));                                 
             }
           }
         }
        int k=0;
        FloatList parkingTemporal = new FloatList();
        for(POI poi:pois.getAll()){
           parkingTemporal.set(k,(parkingPerHour.get(k)/120)/poi.CAPACITY);
           k++;
        }
         promParkHour.add(i, parkingTemporal);
        }
         //print("\n"+promParkHour);
         return promParkHour;
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
  
  
  public TimeP(int deviceNum,int movType,String time, int passages){
    DEVICENUM = deviceNum;
    MOVTYPE = movType;
    TIME = time;
    PASSAGES = passages;
  } 
}