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
  
  //Total time in seconds
  public int getmax(){
    totalTime = (yearMax - yearMin+1) * (monthMax - monthMin +1) * (dayMax - dayMin + 1) * (24) * (4);
    return totalTime;
  }
    
  public ArrayList getDeviceNum(){
    ArrayList deviceNum = new ArrayList();
    for(TimeP park : park){
      deviceNum.add(park.DEVICENUM);
    }
    return deviceNum;
  }
  
  public ArrayList getMovType(){
    ArrayList movType = new ArrayList();
    for(TimeP park : park){
     movType.add(park.MOVTYPE); 
    }
    return movType;
  }  
  
  public ArrayList getTime(){
   ArrayList time = new ArrayList();
   for(TimeP park : park){
    time.add(park.TIME);
   }
   return time;
  }
  
  public ArrayList getPassages(){
   ArrayList passages = new ArrayList();
   for(TimeP park : park){
    passages.add(park.PASSAGES);
   }
   return passages;
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