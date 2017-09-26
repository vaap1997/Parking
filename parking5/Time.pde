public class TimePark{
  ArrayList <TimeP> Park;
  ArrayList<String> chronometer;
  int totalTime;
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
   Park=new ArrayList();
   
   Table table=loadTable(path,"header");
   for(TableRow row:table.rows()){
     int DeviceNum=row.getInt("Device Number");
     int MovType=row.getInt("Movement Type");
     int Skidata=row.getInt("SKIDATA ticket Type");
     String Time=row.getString("DateTime");
     int Passages=row.getInt("Passages");
     
     Park.add(new TimeP(DeviceNum,MovType,Skidata,Time, Passages));

  }
   print("LOADED");
  }
  
  //Create an array with all the dates in the range
  public ArrayList<String> Chronometer(){
  ArrayList<String> chronometer = new ArrayList();
  
    for(int year=16;year<17;year++){
      for(int month=7;month<8;month++){
        String monthstr = str(month);
        if(monthstr.length() == 1){
          monthstr = '0' + monthstr;
        }
        
        for(int day=2;day<=31;day++){
          
          for(int hour=0; hour<=23;hour++){
            String hourstr=str(hour);
            if(hourstr.length()==1){
             hourstr="0"+hourstr; 
            }
            
            for(int min=0;min<46;min=min+15){
              String minstr=str(min);
              if(minstr.length()==1){
               minstr="0"+minstr; 
              }
             //chronometer= append(chronometer,str(day)+"/"+str(month)+"/"+str(year)+" "+str(hour)+":"+str(min));
             String dia = str(day)+"/"+monthstr+"/"+str(year)+" "+hourstr+":"+minstr;
             chronometer.add(dia);
             
            }
          } 
        }
      }
    }
   return chronometer;
  }
  
  public int getmax(){
    totalTime=(17-16)*(8-7)*(31-1)*(24)*(4);
    return totalTime;
  }
  
  
  
  public ArrayList getDeviceNum(){
    ArrayList deviceNum=new ArrayList();
    for(TimeP park : Park){
      deviceNum.add(park.DEVICENUM);
    }
    return deviceNum;
  }
  
  //como se agrega con un int
  public ArrayList getMovType(){
    ArrayList movType= new ArrayList();
    for(TimeP park:Park){
     movType.add(park.MOVTYPE); 
    }
    return movType;
  }  
  
  public ArrayList getTime(){
   ArrayList time=new ArrayList();
   for(TimeP park: Park){
    time.add(park.TIME);
   }
   return time;
  }
  
  public ArrayList getPassages(){
   ArrayList passages= new ArrayList();
   for(TimeP park:Park){
    passages.add(park.PASSAGES);
   }
   return passages;
  }
  
  
}

public class TimeP{
  protected final int DEVICENUM;
  protected final int MOVTYPE;
  protected final int SKIDATA;
  protected final String TIME;
  protected final int PASSAGES;
  
  
  public TimeP(int DeviceNum,int MovType,int Skidata,String Time, int Passages){
    DEVICENUM=DeviceNum;
    MOVTYPE=MovType;
    SKIDATA=Skidata;
    TIME=Time;
    PASSAGES=Passages;
  } 
}