class Particle {

  /*------------------------------------------------------------------
   *** CLASS VARIABLES ***
   ------------------------------------------------------------------*/
  int       pID;
  PVector   pos;
  PVector   vel;
  PVector   acc;
  float     pSize;
  boolean   pFixed;

  ArrayList conSprings = new ArrayList();

  /*------------------------------------------------------------------
   *** CLASS CONSTRUCTOR ***
   ------------------------------------------------------------------*/
  Particle(PVector STARTPOS) {
    // assign all the class variables
    pos    = STARTPOS;
    vel    = new PVector();
    acc    = new PVector(0,0,weight);
    pSize  = 10.0;
    pID    = 0;
    pFixed = false;
  }

  /*------------------------------------------------------------------
   *** CLASS FUNCTIONS ***
   ------------------------------------------------------------------*/

  //----------MOVE AND DRAW TO SCREEN
  void update() {
    if (pFixed==false) {
      if (attract == true) {
        updatePos();
        //attraction();
      }
    }
    
  }

  //----------SOLVE THE SPRINGS
  void solveForce() {
    if (attract == true) {
      if (pFixed==false) {
      
        Particle otherP;
        PVector  sumForces = new PVector(0, 0, 0);
        
  
        // loop thru our connections
        for (int i = 0; i<conSprings.size(); ++i) {
          // get a spring
          Spring s = (Spring) conSprings.get(i);
          // get other end of spring
          if ( s.p00 == this ) {
            otherP = s.p01;
          }
          else {
            otherP = s.p00;
          }
          // calculate the pull of spring
          PVector vecBet     = PVector.sub(otherP.pos, pos);   //vector between
          float   currLen    = vecBet.mag();                   //current lengh
          float   lenDiff = currLen-SPRING_RESTLENGTH;         //lengh difference
          float   limitLen   = gridInc*limitCons;                    //lengh limit
          
          if (currLen < limitLen){
            vecBet.normalize();  //change magnitude to 1
            vecBet.mult(lenDiff/2);  //the larger the difference, the larger the pull-back force
            vecBet.add(acc);
            
          }
          /*
          else {
            vecBet.mult(0);
          }
          */
          // add this force to our sum of forces
          sumForces.add(vecBet);
                
        }
        
        // add the resultant force to our vel 
        vel.add(sumForces);
      }
    }
    
  }

  void updatePos() {
    vel.limit(1);
    pos.add(vel);
    vel = new PVector(0, 0, 0);

  }



  //----------Make the particle fixed / free
  void fixMe() {
    pFixed=true;
  }
  void freeMe() {
    pFixed=false;
  }

  //----------Add a spring to my list of springs
  void addSpring(Spring S) {
    // store this spring
    conSprings.add(S);
  }
}


  

