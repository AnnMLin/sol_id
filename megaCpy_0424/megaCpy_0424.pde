// IMPORT EXTERNAL LIBRARIES
import processing.pdf.*;
import processing.opengl.*;   // openGL library
import peasy.*;               // the camera library
import controlP5.*;           // the interface library
import processing.dxf.*;

/*------------------------------------------------------------------
 *** GLOBAL VARIABLES ***
 ------------------------------------------------------------------*/
boolean dxfExport = false;
boolean recording = false;
// camera
PeasyCam  theCamera;
float     bBoxX            = 830;                 // a size of environment
float     bBoxY            = 330;  
float     bBoxZ            = 70;  
// inteface
ControlP5     theGUI;
ControlWindow theGUIWindow;

// ArrayLists of stuff
ArrayList springList        = new ArrayList();   

// particle variables
int       numParticlesX      = 84;
int       numParticlesY      = 34; 
Particle[][] particleList   = new Particle[numParticlesX][numParticlesY];

// spring variables
float gridInc = (float) bBoxX/(numParticlesX-1);
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
  size(1200, 900, OPENGL);
  background(0);
  colorMode(HSB, 100);

  //----------make the camera
  theCamera = new PeasyCam(this, bBoxY*1.65);
  theCamera.lookAt(bBoxX/2, bBoxY/2, bBoxZ/2);


  //----------make particles
  
  for (int i=0 ; i<numParticlesX; ++i) {
    for (int j=0; j<numParticlesY; ++j) {
      PVector tmpPos = new PVector();
      if (i == 15 && j == 15) {
        tmpPos = new PVector(i*gridInc, j*gridInc, bBoxZ*2/3);
      }
      else {
        tmpPos = new PVector(i*gridInc, j*gridInc, bBoxZ);
      }
      // make a particle
      Particle newP  = new Particle(tmpPos);

      // fix perimeter particles


        // fix corners particle
      if ( /*(i==0 && j==0) 
        ||*/ (i==0 && j==numParticlesY-1) 
        || (i==numParticlesX-1 && j==0) 
        /*|| (i==numParticlesX-1 && j==numParticlesY-1)*/ 
        || (i==15 && j==15)
        //|| (i==0 && j==0)  || (i==0 && j==12)  || (i==0 && j==21)  || (i==0 && j==33)
        /*|| (i==10 && j==0) || (i==10 && j==12)*/ || (i==10 && j==21) || (i==10 && j==33)
        || (i==19 && j==0) || (i==19 && j==12) || (i==19 && j==21) || (i==19 && j==33)
        /*|| (i==28 && j==0)*/ || (i==28 && j==12) || (i==28 && j==21) || (i==28 && j==33)
        || (i==37 && j==0) || (i==37 && j==12) || (i==37 && j==21) || (i==37 && j==33)
        /*|| (i==46 && j==0)*/ || (i==46 && j==12) || (i==46 && j==21) || (i==46 && j==33)
        || (i==55 && j==0) || (i==55 && j==12) || (i==55 && j==21) || (i==55 && j==33)
        /*|| (i==64 && j==0)*/ || (i==64 && j==12) || (i==64 && j==21) || (i==64 && j==33)
        || (i==73 && j==0) || (i==73 && j==12) /*|| (i==73 && j==21) || (i==73 && j==33)
        /*|| (i==83 && j==0) || (i==83 && j==12) || (i==83 && j==21) || (i==83 && j==33)*/ ) {
        newP.fixMe();
      }
      
      // store the particle in our list
      particleList[i][j] = newP;
    }
  }




  //----------make springs
  Spring s0, s1;
  for (int i=0; i<numParticlesX; ++i) {
    for (int j=0; j<numParticlesY; ++j) {

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
  
  
  if (dxfExport) {
    beginRaw(DXF, "output.dxf");
  }
  
  //----------visualize our bounding box
  showEnv();

  
  
  //----------update particle physics
  for (int i=0; i<numParticlesX; ++i) {
    for (int j=0; j<numParticlesY; ++j) {
      particleList[i][j].solveForce();
    }
  }

  //----------update particle positions
  for (int i=0; i<numParticlesX; ++i) {
    for (int j=0; j<numParticlesY; ++j) {
      particleList[i][j].update();
    }
  }

  //----------update springs
  for (int i=0; i<springList.size(); ++i) {
    // get a spring from the arraylist
    Spring currS = (Spring) springList.get(i);
    currS.showMe();
  }

  
  if(dxfExport) {
    endRaw();
    dxfExport = false;
  }
  
  if(recording == true){
    saveFrame("frames/####.jpg");
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
  //drawEnvlop();
  translate(bBoxX/2, bBoxY/2, bBoxZ/2);
  box(bBoxX, bBoxY, bBoxZ);
  popMatrix();
}

void drawEnvlop() {
  line(0,0,bBoxZ,bBoxX,0,bBoxZ); line(bBoxX,0,bBoxZ,bBoxX,bBoxY,bBoxZ); line(bBoxX,bBoxY,bBoxZ,0,bBoxY,bBoxZ); line(0,bBoxY,bBoxZ,0,0,bBoxZ);
  line(300,300,0,bBoxX-300,300,0); line(bBoxX-300,300,0,bBoxX-300,bBoxY-300,0); line(bBoxX-300,bBoxY-300,0,300,bBoxY-300,0); line(300,bBoxY-300,0,300,300,0);
  line(0,0,bBoxZ,300,300,0); line(bBoxX,0,bBoxZ,bBoxX-300,300,0); line(bBoxX,bBoxY,bBoxZ,bBoxX-300,bBoxY-300,0); line(0,bBoxY,bBoxZ,300,bBoxY-300,0);
 
}

void keyPressed() {
  
  if (key == 'a') {
    attract = true;
  }
  
  if (key == 's') {
    attract = false;
  }
  
  if (key == 'x') {
    dxfExport = true;
    println("DXF export complete!");
  }
  
  if(key == 'r'){
    recording = true;
  }
  
  if(key == 'e'){
    recording = false;
  }
}

