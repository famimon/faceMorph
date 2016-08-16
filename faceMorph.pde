
PImage img1, img2, alphaMask;

// Tamaño del puntero
int pointerSize = 10;

// Tamaño de las imágenes, TODAS LAS IMAGENES DEBEN TENER EL MISMO TAMAÑO
int imgWidth = 500;
int imgHeight = 650;

// Temporizador
int timeout = 3; // Tiempo de refresco de las imagenes, 3 minutos
int timer;

// Fuente para la cuenta atras
PFont font;
String timetag;
// Tamaño de la fuente
int fontSize = 48;

void setup() {
  frame.removeNotify(); 
  // Quitar el marco de la ventana
  frame.setUndecorated(true);
  // Poner a pantalla completa
  size(imgWidth, imgHeight);  
  
  // Cargamos la fuente
  font = loadFont("Monospaced-48.vlw");
  textFont(font, fontSize);
  
  // Creamos la imagen del puntero
  PGraphics pg;
  pg = createGraphics(pointerSize, pointerSize);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(255, 0, 0, 120);
  pg.ellipse(mouseX+pointerSize/2, mouseY+pointerSize/2, pointerSize, pointerSize);
  pg.endDraw();
  cursor(pg);

  // Color y grosor de la estela
  stroke(255, 0, 0, 120);
  strokeWeight(pointerSize);  
  alphaMask = createImage(imgWidth, imgHeight, ARGB);
  setWhite(alphaMask);
  loadImages();
  timer=minute();
}

void draw() {    
  // Colocar la ventana en el centro
  frame.setLocation((displayWidth-imgWidth)/2, (displayHeight-imgHeight)/2); 
  background(255);
  adjustMask(alphaMask);
  img1.mask(alphaMask);
  image(img2, (width-imgWidth)/2, (height-imgHeight)/2);
  image(img1, (width-imgWidth)/2, (height-imgHeight)/2);
  line(pmouseX, pmouseY, mouseX, mouseY);
  // After the timer, restart the canvas
  if (minute()-timer > timeout) {
    println("Reload "+(minute()-timer));
    loadImages();
    setWhite(alphaMask);
    timer=minute();
  }
   // Imprimir la cuenta atras
  int minutes = (timeout-(minute()-timer));
  String seconds= (60-second()>=10)? ""+(60-second()) :"0"+(60-second());
   if(second()%2==0){
    text(minutes+":"+seconds, (imgWidth/2)-45, imgHeight-10);
   }else{
     text(minutes+" "+seconds, (imgWidth/2)-45, imgHeight-10);
   }
}

void loadImages() {
  int img1Idx = (int)random(0, 9);
  int img2Idx = (int)random(0, 9);
  while (img1Idx==img2Idx) {
    img2Idx = (int)random(0, 9);
  }
img1 = loadImage("data/imagen_"+img1Idx+".jpeg");
img2 = loadImage("data/imagen_"+img2Idx+".jpeg");  
}

void setWhite(PImage img) {
  img.loadPixels();
  for (int i=0; i<img.pixels.length; i++) {
    img.pixels[i]=color(255);
  }
  img.updatePixels();
}

void adjustMask(PImage img)
{
  PGraphics pg;
  pg = createGraphics(img.width, img.height);
  pg.beginDraw();
  pg.noStroke();
  pg.fill(0, 0, 0, 200);
  pg.ellipse(mouseX, mouseY, pointerSize, pointerSize );
  pg.endDraw();
  img.blend(pg, 0, 0, img.width, img.height, 0, 0, img.width, img.height, BLEND);
}

