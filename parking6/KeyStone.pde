//import deadpixel.keystone.*;
//Keystone ks;
//CornerPinSurface keyStone;
//...
//void setup(){
//...
//    ks = new Keystone(this);   //creas el objeto keystone
//    keyStone = ks.createCornerPinSurface( x, y, 20);   //creas las esquinas con las que calibraras tu keystone
//}
//void draw(){
//    background(0);  //Si no añades background al mover el keystone el background no se actualiza y se quedarán todas las imágenes guardadas detras.
//    ...
//    keyStone.render(canvas)  //el canvas es donde tu dibujas todo, por lo tanto si pones el canvas en el keystone podras mover como quieras tu canvas (es la idea principal de la librería)
//}
//void keyPressed(){
//  switch(key){
//    case ' ':
//    showBG= !showBG;
//    break;
    
//    case 'k':
//    ks.toggleCalibration();      //tienes que ayadir este método para que puedas entrar en el modo de calibración
//    break;
    
//    case 's':
//    ks.save();   //Una vez esté el sketch cuadrado con la maqueta este método te permite guardar la posición de los corners en un xml
//    break;
    
//    case 'l':
//    ks.load();  //Este método te permite cargar la posición del xml una vez guardado. Podrias ponerlo en void setup() una vez tengas un xml generado para cargar automáticamente la posición, peró no antes porque estará intentando buscar algo que no existe aún y te dará error. 
//    break;
//  }
//}