

// IMPORT EXTERNAL LIBRARIES
import processing.pdf.*;
import processing.opengl.*;   // openGL library
import peasy.*;               // the camera library
import controlP5.*;           // the interface library

/*------------------------------------------------------------------
 *** GLOBAL VARIABLES ***
 ------------------------------------------------------------------*/
// camera
PeasyCam  theCamera;
float     bBox             = 1500;                 // a size of environment
float     bBoxZ            = 400;  
// inteface
ControlP5     theGUI;
ControlWindow theGUIWindow;

// ArrayLists of stuff
ArrayList springList        = new ArrayList();   

// particle variables
int       numParticles      = 35;
Particle[][] particleList   = new Particle[numParticles][numParticles];

// spring variables
float gridInc = (float) bBox/(numParticles-1);
//PVector   gravity           = new PVector(0, 0, 0);
float     SPRING_RESTLENGTH = gridInc;    // the length a spring is at rest
float     limitCons    = 1.1;               // minimum = 1



float weight = -0.3;

boolean exportPDF = false;
boolean attract = false;


/*------------------------------------------------------------------
 *** GLOBAL SETUP ***
 ------------------------------------------------------------------*/
void setup() {

  //----------general
  size(900, 600, OPENGL);
  background(0);
  colorMode(HSB, 100);

  //----------make the camera
  theCamera = new PeasyCam(this, bBox*1.65);
  theCamera.lookAt(bBox/2, bBox/2, bBoxZ/2);


  //----------make particles
  
  for (int i=0; i<numParticles; ++i) {
    for (int j=0; j<numParticles; ++j) {
      // make a vector
      PVector tmpPos = new PVector(i*gridInc, j*gridInc, bBoxZ);
      // make a particle
      Particle newP  = new Particle(tmpPos);

      // fix perimeter particles


        // fix corners particle
      if ( (i==0 && j==0) 
        || (i==0 && j==numParticles-1) 
        || (i==numParticles-1 && j==0) 
        || (i==numParticles-1 && j==numParticles-1) 
        || (i==15 && j==15)
        || (i==24 && j==19) ) {
        newP.fixMe();
      }
      // store the particle in our list
      particleList[i][j] = newP;
    }
  }




  //----------make springs
  Spring s0, s1;
  for (int i=0; i<numParticles; ++i) {
    for (int j=0; j<numParticles; ++j) {

      if ( i>0 ) {
        s0 = new Spring( particleList[i][j], particleList[i-1][j] );
        springList.add(s0);
        particleList[i][j].addSpring(s0);
        particleList[i-1][j].addSpring(s0);
      }

      if ( j>0 ) {
        s1 = new Spring( particleList[i][j], particleList[i][j-1] );
        springList.add(s1);
        particleList[i][j].addSpring(s1);
        particleList[i][j-1].addSpring(s1);
      }
    }
  }

  // print how many springs we made
  println("Number of springs "  + springList.size() );


}



/*------------------------------------------------------------------
 *** GLOBAL CONTINUOUS DRAW ***
 ------------------------------------------------------------------*/
void draw() {
  //----------general
  background(100);
  
  
  
  if (exportPDF) {
    beginRaw(PDF, "exportPDF/3D####.pdf");
  }
  
  //----------visualize our bounding box
  showEnv();

  
  
  //----------update particle physics
  for (int i=0; i<numParticles; ++i) {
    for (int j=0; j<numParticles; ++j) {
      particleList[i][j].solveForce();
    }
  }

  //----------update particle positions
  for (int i=0; i<numParticles; ++i) {
    for (int j=0; j<numParticles; ++j) {
      particleList[i][j].update();
    }
  }

  //----------update springs
  for (int i=0; i<springList.size(); ++i) {
    // get a spring from the arraylist
    Spring currS = (Spring) springList.get(i);
    currS.showMe();
  }

  
  if (exportPDF) {
    endRaw();
    exportPDF = false;
  }
}


/*----------------------------------
 *** DRAW THE BOUNDING BOX
 -----------------------------------*/
void showEnv() {
  stroke(255, 0, 0);
  strokeWeight(1);
  noFill();
  pushMatrix();
  drawEnvlop();
  translate(bBox/2, bBox/2, bBoxZ/2);
  //box(bBox, bBox, bBoxZ);
  popMatrix();
}

void drawEnvlop() {
  line(0,0,bBoxZ,bBox,0,bBoxZ); line(bBox,0,bBoxZ,bBox,bBox,bBoxZ); line(bBox,bBox,bBoxZ,0,bBox,bBoxZ); line(0,bBox,bBoxZ,0,0,bBoxZ);
  line(300,300,0,bBox-300,300,0); line(bBox-300,300,0,bBox-300,bBox-300,0); line(bBox-300,bBox-300,0,300,bBox-300,0); line(300,bBox-300,0,300,300,0);
  line(0,0,bBoxZ,300,300,0); line(bBox,0,bBoxZ,bBox-300,300,0); line(bBox,bBox,bBoxZ,bBox-300,bBox-300,0); line(0,bBox,bBoxZ,300,bBox-300,0);
 
}

void keyPressed() {
if (key == '2') {
    exportPDF = true;
    println("exportedPDF");
  }
  
  if (key == 'a') {
    attract = true;
  }
}

