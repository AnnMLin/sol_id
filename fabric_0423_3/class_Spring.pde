class Spring {
  
  /*------------------------------------------------------------------
   *** CLASS VARIABLES ***
   ------------------------------------------------------------------*/
  // declare all the class variables
  Particle p00;
  Particle p01;

  /*------------------------------------------------------------------
   *** CLASS CONSTRUCTOR ***
   ------------------------------------------------------------------*/
  Spring (Particle INPUT_00, Particle INPUT_01) {
    // assign all the class variables
    p00 = INPUT_00;
    p01 = INPUT_01;
  } 


  /*------------------------------------------------------------------
   *** CLASS FUNCTIONS ***
   ------------------------------------------------------------------*/

  //----------Draw myself
  void showMe() {
    
    
    if (PVector.dist(p00.pos, p01.pos) <= gridInc) {
      stroke(63, 100, 100);
    } 
    else if (PVector.dist(p00.pos, p01.pos) > gridInc && PVector.dist(p00.pos, p01.pos) <= gridInc*1.5){
      stroke(73, 100, 100);
    }
    else if (PVector.dist(p00.pos, p01.pos) > gridInc*1.5 && PVector.dist(p00.pos, p01.pos) <= gridInc*2){
      stroke(87, 100, 100);
    }
    strokeWeight(0.5);
    noFill();
    line(
    p00.pos.x, p00.pos.y, p00.pos.z,  
    p01.pos.x, p01.pos.y, p01.pos.z
      );
  }
}

