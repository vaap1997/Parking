
public class TimePark{
  ArrayList <TimeP> Park;
  ArrayList<String> chronometer;
  int totalTime;
   int dayMin=Integer.MAX_VALUE;
   int dayMax=-Integer.MAX_VALUE;
   int monthMin=Integer.MAX_VALUE;
   int monthMax=-Integer.MAX_VALUE;
   int yearMin=Integer.MAX_VALUE;
   int yearMax=-Integer.MAX_VALUE;
   int hourMin=Integer.MAX_VALUE;
   int hourMax=-Integer.MAX_VALUE;
   int minMin=Integer.MAX_VALUE;
   int minMax=-Integer.MAX_VALUE;
  
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
     String Time0=row.getString("DateTime");
     int Passages=row.getInt("Passages");
     String Time1=Time0.replace(" ","/");
     String Time2=Time1.replace(":","/");
     int[] Time=int(Time2.split("/")) ;
     //print(Time[0],"\n");
     dayMin=min(dayMin,Time[0]);
     dayMax=max(dayMax,Time[0]);
     monthMin=min(monthMin,Time[1]);
     monthMax=max(monthMax,Time[1]);
     yearMin=min(yearMin,Time[2]);
     yearMax=max(yearMax,Time[2]);
     hourMin=min(hourMin,Time[3]);
     hourMax=max(hourMax,Time[3]);
     minMin=min(minMin,Time[4]);
     minMax=max(minMax,Time[4]);
     
     Park.add(new TimeP(DeviceNum,MovType,Skidata,Time0, Passages));

  }
   print("LOADED");
  }
  
  //Create an array with all the dates in the range
  public ArrayList<String> Chronometer(){
  ArrayList<String> chronometer = new ArrayList();
  print(minMax);
    for(int year=yearMin;year<=yearMax;year++){
      for(int month=monthMin;month<=monthMax;month++){
        String monthstr = str(month);
        if(monthstr.length() == 1){
          monthstr = '0' + monthstr;
        }
        
        for(int day=dayMin;day<=dayMax;day++){
          
          for(int hour=hourMin; hour<=hourMax;hour++){
            String hourstr=str(hour);
            if(hourstr.length()==1){
             hourstr="0"+hourstr; 
            }
            
            for(int min=minMin;min<=minMax;min=min+15){
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
    totalTime=(yearMax-yearMin+1)*(monthMax-monthMin+1)*(dayMax-dayMin+1)*(24)*(4);
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