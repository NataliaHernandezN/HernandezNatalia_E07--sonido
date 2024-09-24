// Bola disco acompanada de la cancion de don't stop the party
// cargar la libreria para hacer fft
import ddf.minim.*;
import ddf.minim.analysis.*;

//inicializar libreria
Minim minim;
AudioPlayer player;
FFT fft;

// Nombrar Variables
int numFacetas = 30;  // cantidad de circulos que van a formar la esfera grande 
float rotacion = 0;   
float radio = 150; 

void setup() {
  size(900, 700, P3D); //  P3D indicar que se quiere crear un espacio tridimensional
  
  // nueva instancia de minim de la libreria que importamos
  minim = new Minim(this);
  
    // cargamos el archivo  con load file
  player = minim.loadFile("The Black Eyed Peas - Dont Stop The Party.mp3", 1024);
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
}

void draw() {
  // establecer fondo
  background(0);
  // analisis fft
  fft.forward(player.mix);
  
   //Mover el origen del dibujo al centro y aplicar la rotación
  translate(width/2, height/2);
  rotateY(rotacion);
  rotacion += 0.01; //velocidad de la rotacion
  
  noStroke();
 // Funcion del for, iterar
 
  for (int i = 0; i < numFacetas; i+=1) {   //iterar para crear la cuadrícula de puntos que cubren la superficie de la esfera
    float angulo2 = PI *2 * i / numFacetas;  // Angulo Horizontal
    
    for (int j = 0; j < numFacetas; j+=1) {  // iterar para crear la cuadrícula de puntos que cubren la superficie de la esfera
      float angulo1 = PI * j / numFacetas;  // Angulo Verical 
      
      
      //Coordenadas
// x: Determina la posición en el eje horizontal.
//y: Determina la posición en el eje vertical.
//z: Determina la profundidad o distancia, variable de 3D
      
      float x = radio * sin(angulo1) * cos(angulo2);
      float y = radio * sin(angulo1) * sin(angulo2);
      float z = radio * cos(angulo1);
      
      // Medir frecuencia para despues introducirla con los circulos pequenos y color
      float level = fft.getBand(i % fft.specSize());
      
      // calcular el tamano de cada circulo pequeno y se usa (level / 10) para que las esferas crezcan  en base al audio.
      float tamano = 5 + level / 10;
      
      //  Establecer el color basado en el audio 
      fill(level * 2.55, 100, 255);
      
      // Dibujar circulo pequeno
      translate(x, y, z);
      sphere(tamano); // La figura esfera se puede usar ya que es 3D
      translate(-x, -y, -z);
    }
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
