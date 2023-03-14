int recordingTimeSec = 4; // // nombre de secondes d'enregistrement dans la fonction sampling (qui n'est pas là)
int networkSize = 6; // number of ball
String debug ="";  // pour lire les bug // not used

// LIBRARY PERSPECTIVE
import peasy.*;
PeasyCam cam;

// LIBRARY TO READ SERIAL PORT 
import processing.serial.*;
Serial DueSerialNativeUSBport101; // To read actual position of encoder
Serial teensyport; // To send data to motor

// MANAGE SETUP of PEREPECTIVE 3D (point of view of camera)    
// change these for screen size
float fov = 45;  // degrees
float w = 1000;
float h = 800;

// don't change these
float cameraZ, zNear, zFar;
float w2 = w / 2;
float h2 = h / 2;
// END CAMERA SETTING

int nbBalls = networkSize-0;  // number of ball in function drawBall
int j; // number of the ball following the previous ball

int oscillatorChange, oldOscillatorChange; //  // renvoie le numero de la 'balle' sur laquelle on module une position, une phase. oldOscillatorChange donne le numero de l'ancienne balle sur laquelle on modulait une position
int nbMaxDelais= 1000; //TOTAL du delais de suivi entre chaque ball (en frame). Exemple si il y a un delai de 2 frames par balle et
//que nous avons 12 balles alors le delai total entre la premiere et derniere balle est de (12-1) * 2  = 22

// la phase est la position en radian sur un cercle. Elle est située entre 0 et deux * pi, TWO_PI. 

float netPhase [] =  new float  [networkSize];  // renvoie la phase de chaque balle.

float signalToSplit, oldSignalToSplit ;  // signal oscillant entre 0 et 1 ou entre - TWO_PI et TWO_PI. oldSignalTosplit est la valeur du signal a la frame precedente. 

int splitTime, oldSplitTime; // renvoie la valeur discontine du timeLFO. Quand timeLFO va de 0 à 1000, splitTimeLfo renvoie la valeur restante du timeLfo

float timeLfo; // met à l'echelle le "signalToSplit" afin qu'il soit limité entre 0 et 1000

float splitTimeLfo, oldSplitTimeLfo; // renvoie la valeur discontine du timeLFO. Quand timeLFO va de 0 à 1000, splitTimeLfo renvoie la valeur restante du timeLfo

float propagationSpeed; // " vitesse " à laquelle on change d'oscillateur

int phaseOffset;

boolean way;

float phaseFollowLFO [] =  new float  [networkSize]; // phase à suivre

float lfoPhase [] =  new float  [networkSize];   // tableau avec different motif de forme d'onde. Il peut y avoir des ondes en dents de scie et des ondes sinusoidales.

float signal [] =  new float  [networkSize];  // tableau où l'on va mettre different signaux (continue, sinusoidale, triangle..)

float LFO [] =  new float  [networkSize]; // tableau où l'on met les données des phases

float newPosXaddSignal [] =  new float  [networkSize]; // tableau avec les nouvelles positions des moteurs des balles

float phaseKeptAtChange [] =  new float  [networkSize]; // tableau avec les dernieres positions enregistrees des balles

boolean doQ, doZ; // faitQ, faitZ ==> change de sens de propagation

char letter;  //  pour aller vers le cas correspondant à la lettre Q, ou Z

boolean oscillatorChanged; // si on change d'oscillateur renvoie l'état est  Vrai sinon renvoie faux.  oldOscillatorChange renvoie si il y a eu un changement d'oscillateur à la frame precedente. 

char formerFormerKey, formerKey; // enregistre les lettres tapées sur le clavier // pas utilisé pour l'instant

int dataMappedForMotor [] =  new int [networkSize];   // renvoie le numero de la 'balle' sur laquelle on module une position, une phase
int [] revLfo = new int [networkSize]; // pour conter le nombre de tour // not used
int numberOfStep = 6400; // nombre de pas du moteur

int [] DataToDueCircularVirtualPosition = new int [networkSize];  // position à envoyer à la la carte Teensy pour controler les moteurs

public void settings() { // configure l'ecran par 600 pixel et en 3D
  size(600, 600, P3D);
}

void setup(){
  //***************************************** SET 3D CAM 
  cam = new PeasyCam(this, 2000);
  cameraZ = (h / 2.0) / tan(radians(fov) / 2.0);
  zNear = cameraZ / 10.0;
  zFar = cameraZ * 10.0;
  println("CamZ: " + cameraZ);
  rectMode(CENTER);
  //***************************************** END 3D CAM 
  frameRate(30); // nombre d'image ou de main loop par seconde
  
  //teensyport = new Serial(this,Serial.list()[1],115200); // to send datas of positions to control motors
}
void draw() 
{ 
  background(0);
  translate(width/2, -height/2, -1000);// To set the center of the perspective
 
  propagationMode();
//  CI DESSOUS 
//  rotate(-HALF_PI ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI   
//  float lastBallPosition =  map (position.x, 0, 300, 0, TWO_PI); //  assigne à les positions x (celles qui viennent du sample non integré ici ) à la variable lastBallPosition. La balle la plus en avant de la machine
//  ballManager.updateAndDraw(lastBallPosition); // CLASSE ballManager utilisé plus tard avec le sample des coordoonées x
}
