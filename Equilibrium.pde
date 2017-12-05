class Equilibrium {
  JSONObject JSON;
  JSONArray latArray, lonArray, nationArray;
  PVector[] aNode, bNode;
  float[][] congArray;
  float maxCong=0.5;
  float[] linkHierarchy;
  Equilibrium(JSONObject links_JSON, JSONObject hierarchy_JSON){
     linkHierarchy=hierarchy_JSON.getJSONArray("roadTypes").getFloatArray();
     JSON = links_JSON;
     float[] aNodeLat=JSON.getJSONArray("aNodeLat").getFloatArray();
     float[] bNodeLat=JSON.getJSONArray("bNodeLat").getFloatArray();
     float[] aNodeLon=JSON.getJSONArray("aNodeLon").getFloatArray();
     float[] bNodeLon=JSON.getJSONArray("bNodeLon").getFloatArray();
     JSONArray linkCong=JSON.getJSONArray("linkCong");
     numLinks=aNodeLat.length;
     numPeriods=linkCong.getJSONArray(0).getFloatArray().length;
     aNode=new PVector[numLinks];
     bNode=new PVector[numLinks];
     congArray= new float[numLinks][numPeriods];
     
     for (int l=0; l < numLinks; l = l+1){
     aNode[l]=roads.toXY(aNodeLat[l], aNodeLon[l]);
     bNode[l]=roads.toXY(bNodeLat[l], bNodeLon[l]);
     float[] floatArray=linkCong.getJSONArray(l).getFloatArray();
        for (int j = 0; j < floatArray.length; j = j+1){
          congArray[l][j]=floatArray[j];
        }
     }

  }  
  void draw( int currHour){
    canvas.colorMode(HSB, 100);
    
    for (int l=0; l < numLinks; l = l+1){
      float congRatio=((congArray[l][currHour-1])/maxCong);
      float hue=33-sqrt(congRatio)*33;
      //float hue=10;
      canvas.strokeWeight(linkHierarchy[l]);
      //offscreen3DTable.stroke(unhex("FF" + hexArray[l][slideHandler.curHour].substring(1)));
      canvas.stroke(hue,99,100);
      canvas.line(aNode[l].x, aNode[l].y, bNode[l].x, bNode[l].y);
   }
   canvas.noStroke();
   canvas.colorMode(RGB,255);  
   
 
  }
}