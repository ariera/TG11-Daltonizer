/********************************************************
 *                                                       *
 *  19/04/2010                                           *
 *  TÉCNICAS GRAFICAS - Ejercicio Opcional: Daltonismo   *
 *                                                       *
 *  Alejandro Riera Mainar                               *
 *  NºMat: 010381                                        *
 *  ariera@gmail.com                                     *
 *                                                       *
 ********************************************************/
int SIZE = 500;
boolean PROTANOPE = true;
String TIPO_DALTONISMO = "protanopia";
PImage daltonizada, input, diferencia, compensada;
int TITLE_HEIGHT = 30;

void setup() {
  colorMode(RGB);
  input  = loadImage("dalt.jpg");
  daltonizada = createImage(input.width, input.height, RGB);
  diferencia = createImage(input.width, input.height, RGB);
  compensada = createImage(input.width, input.height, RGB);
  size(2*input.width,2*input.height+TITLE_HEIGHT +40);
  image(input,0,TITLE_HEIGHT);
  process(input, daltonizada, diferencia);
  displayTitle();
  displayInstructions(input.width, input.height);
}


void displayTitle(){
  textFont(createFont("Helvetica", 18));
  fill(color(0));
  text("Ejercicio Opcional: Daltonizador de imagenes" , 10, 20);
}

void displayImgDesc(int base_width, int base_height){
  textFont(createFont("Helvetica", 14));
  fill(color(0));
  rect(0, TITLE_HEIGHT, 72, 20);
  rect(base_width, TITLE_HEIGHT, 220, 20);
  rect(0, base_height + TITLE_HEIGHT, 65, 20);
  rect(base_width, base_height + TITLE_HEIGHT, 90, 20);
  fill(color(255));
  text("original", 10, 17+TITLE_HEIGHT);  
  text("imagen daltonizada: " + TIPO_DALTONISMO , base_width + 10, 17+TITLE_HEIGHT);
  text("error", 10, base_height + 17+TITLE_HEIGHT);  
  text("correccion", base_width + 10, base_height + 17+TITLE_HEIGHT);
}

void displayInstructions(int base_width, int base_height){
  textFont(createFont("Helvetica", 14));
  fill(color(0));
  text("pulse cualquier tecla para alternar entre los algoritmos de daltonizacion", 10, 17+base_height*2+TITLE_HEIGHT);  
}



void draw() {

}

void process(PImage input, PImage daltonizada, PImage diferencia){
  input.loadPixels();
  daltonizada.loadPixels();
  diferencia.loadPixels();
  compensada.loadPixels();

  daltonizar(input, daltonizada);
  diferencia(input, daltonizada, diferencia);
  compensar(input, diferencia, compensada);

  compensada.updatePixels();
  diferencia.updatePixels();
  daltonizada.updatePixels();
  input.updatePixels();
  image(daltonizada,input.width,TITLE_HEIGHT);
  image(diferencia,0,input.height + TITLE_HEIGHT);
  image(compensada,input.width,input.height + TITLE_HEIGHT);
  displayImgDesc(input.width, input.height);
}


void compensar(PImage input, PImage diferencia, PImage compensada){
  int loc = 0;
  color ca,cb;

  for (int x = 0; x < input.width; x++) {
    for (int y = 0; y < input.height; y++ ) {
      loc = x + y*input.width;
      ca = color(input.pixels[loc]);
      cb = color(diferencia.pixels[loc]);
      compensada.pixels[loc] = color(red(ca) - red(cb), green(ca) - red(cb), blue(ca) + red(cb)*2);
//      compensada.pixels[loc] = color(red(ca), green(ca), blue(ca) + red(cb));
    }
  }
}

void diferencia(PImage a, PImage b, PImage diferencia){
  int loc = 0;
  color ca, cb;

  for (int x = 0; x < a.width; x++) {
    for (int y = 0; y < a.height; y++ ) {
      loc = x + y*a.width;
      ca = color(a.pixels[loc]);
      cb = color(b.pixels[loc]);
      // diferencia.pixels[loc] = color(abs(red(ca) - red(cb)), abs(green(ca) - green(cb)), abs(blue(ca) - blue(cb)));
      diferencia.pixels[loc] = color(red(ca) - red(cb),0,0);
    }
  }

//   int mean = imageMean(diferencia);
//   for (int x = 0; x < a.width; x++) {
//   for (int y = 0; y < a.height; y++ ) {
//   loc = x + y*a.width;
//   if (red(diferencia.pixels[loc]) <= red(mean))
//   diferencia.pixels[loc] = color(0);
//   }
//   }
}

void daltonizar(PImage input, PImage output){
  int loc = 0;
  color c;

  for (int x = 0; x < input.width; x++) {
    for (int y = 0; y < input.height; y++ ) {
      loc = x + y*input.width;
      c = color(input.pixels[loc]);
      output.pixels[loc] = daltonizar(c);
    }
  }
}

color daltonizar(color c){
  float l,m,s,r,g,b = 0;
  l = red(c) * 17.8824 + green(c) * 43.5161 + blue(c) * 4.11935;
  m = red(c) * 3.45565 + green(c) * 27.1554 + blue(c) * 3.86714;
  s = red(c) * 0.0299566 + green(c) * 0.184309 + blue(c) * 1.46709;

  if(PROTANOPE)
    l = m * 2.02344 - s * 2.52581;
  else
    m = l * 0.494207 + s * 1.24827;

  r = l * 0.080944 - m * 0.130504 + s * 0.116721;
  g = l * (-0.0102485) + m * 0.0540194 - s * 0.113615;
  b = l * (-0.000365294) - m * 0.00412163 + s * 0.693513;
  return color((int)r, (int)g, (int)b);
}

color imageMean(PImage img){
  int r_mean = 0; 
  int g_mean = 0; 
  int b_mean = 0;
  int loc = 0;
  int total_pixels = img.height * img.width;

  for (int x = 0; x < input.width; x++) {
    for (int y = 0; y < input.height; y++ ) {
      loc = x + y*input.width;
      r_mean += red(img.pixels[loc]);
      g_mean += green(img.pixels[loc]);
      b_mean += blue(img.pixels[loc]);
      // println("pix: " + i + "(" + red(img.pixels[i]) + ", " + green(img.pixels[i]) + ", " + blue(img.pixels[i]) + ")");
    }
  }

  return color((int)(r_mean / total_pixels),
  (int)(g_mean / total_pixels),
  (int)(b_mean / total_pixels));
}

void keyPressed(){
  PROTANOPE = !PROTANOPE;
  TIPO_DALTONISMO = PROTANOPE ? "protanopia" : "deuteranopia";
  process(input, daltonizada, diferencia);

  //  println(red(imageMean(diferencia)) + ", " + green(imageMean(diferencia)) + ", " + blue(imageMean(diferencia)) + ", " );
}









