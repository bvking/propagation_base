void propagationMode(){ 

     textSize (100);  // AFFICHE les textes ci dessous à la taille 100
     text ("Change way of propagation with q or z ", -width-200, -height- 600 );
     text ("signal2 " +nf(signal[2], 0, 2) + " intervalle de temps " + splitTimeLfo, -width-200, -height- 500 );
     text (" oldOscillatorChange " + oldOscillatorChange + " oscillatorChange " + oscillatorChange, -width-200, -height- 400 );
     text (" propagationSpeed " + propagationSpeed + " key " + key, -width-200, -height- 300 );
     
  
   if (key=='q' || key=='z' ) { // enregistre la lettre
     letter = key;   
     }
     
  switch(letter) {
    case 'q': // change way of propagation
    doZ=false;
    break;
    case 'z': // change way of propagation
    doZ=true;
    break;
    }
  propagationSpeed=50.0;
  splitTimeScale(propagationSpeed); //  50.0=> vitesse de propagation. On change de sens de ROTATION avec q et z.
 // ici le signal de propagation est continue, alors chaque intervalle de temps de 10% est équi-temporel
 // splitTimeLfoScale();  // // ici le signal de propagation est sinusoidale, alors chaque intervalle de temps de 10% varie. Surtout quand le signal est au crête


  //  AJOUT GESTION du decalage entre les boules et du sens de propagation

  // A l'avenir cette fonction devra gerer la position des balles qui ont ete changées.
  // les boules devront toutes avoir des vitesses de rotations identiques sauf unes.
  // La boule avec la vitesse de rotation differente (*1,5/ aux autres) devra donner sa vitesse à celle d'apres où à la precedente
//  controlPropagation(1, true);
  propagation2way(); 
  

  //****  affiche les balles à l'ecran  ****
 
  for (int k = 0; k < this.nbBalls; k++) 
     {    
        drawBallGeneral(k, newPosXaddSignal[k] );  
     }     
   }
 
 void propagation2way() { // dans cette example de propagation, les balles tournent dans le meme sens dans les deux cas.
 // Donc les deux conditions vraie et fausse de doZ sont les mêmes 
 // phaseKeptAtChange[oscillatorChange]=newPosXaddSignal[oldOscillatorChange]; // on l'utilisera plus tard
      
  // controlPropagation();  
 // keyReleasedPropagation();
   doZ=way;
   println (" way " + way + " phaseOffset " + phaseOffset );
   if (doZ==true){ 

       LFO[oscillatorChange] =  LFO[oldOscillatorChange]+QUARTER_PI*phaseOffset/2 ;  // on ajoute à la position de la balle precedente QUARTER_PI*1/2 afin que la balle qui est en train de changer
       LFO[oscillatorChange] =  LFO[oscillatorChange]%TWO_PI; // la phase est toujours comprise entre 0 et TWO_PI
       dataMappedForMotor[oscillatorChange]= (int) map (LFO[oscillatorChange], 0, TWO_PI , 0, numberOfStep);  // 
       println (" true phaseKeptAtChange[oscillatorChange] ", oscillatorChange, " " ,  phaseKeptAtChange[oldOscillatorChange]);
 
       newPosXaddSignal[oscillatorChange]= map (dataMappedForMotor[oscillatorChange], 0, numberOfStep, 0, TWO_PI); // met à l'echelle les positions pour les moteurs
     }
     
    if (doZ==false){ 

       LFO[oscillatorChange] =  LFO[oldOscillatorChange]+QUARTER_PI*phaseOffset/2 ;  //
       LFO[oscillatorChange] =  LFO[oscillatorChange] %TWO_PI; //

       dataMappedForMotor[oscillatorChange]= (int) map (LFO[oscillatorChange], 0, TWO_PI , 0, numberOfStep);  // 
       println (" true phaseKeptAtChange[oscillatorChange] ", oscillatorChange, " " ,  phaseKeptAtChange[oldOscillatorChange]);
      
       newPosXaddSignal[oscillatorChange]= map (dataMappedForMotor[oscillatorChange], 0, numberOfStep, 0, TWO_PI);
     }
  }

  void  splitTimeScale(float propagationSpeed) {  // fonction qui decoupe le temps de 10%. Apres 10%, la balle en mouvement change.
 // Soit la balle de derriere avec Z. // Soit la balle de devant avec q. 

    signal[2] = (0*PI + (frameCount / propagationSpeed) * cos (1000 / 500.0)*-1)%1; // signal allant de 0 à 1. Si propagationSpeed est petit alors le signal va de 0 à 1 tres rapidement
         
if (doZ==false){  // la balle de derrière (nommée oscillatorChange) est celle qui change 
  if (oldSplitTimeLfo>splitTimeLfo){ // si l'intervalle de temps est passé
 
      oldOscillatorChange=oscillatorChange; // la balle changée (nommée oldOscillatorChange) prend la valeur de la balle qui change 
      oscillatorChange=oscillatorChange+1;// la balle qui change est maintenant la balle +1
   } 

      oscillatorChange=oscillatorChange%networkSize; // quand la balle atteint le nombre de balle totale alors la balle qui change est 0
     if (oscillatorChange<=0) { 
      oldOscillatorChange=networkSize-1; // si la balle qui change est 0 alors la balle changée est la balle 5 (6-1)
   } 
  }
  
if (doZ==true){ // la balle devant  (nommée oscillatorChange) est celle qui change 
   if (  oldSplitTimeLfo>splitTimeLfo){ // si l'intervalle de temps est passé

      oldOscillatorChange=oscillatorChange; // la balle changée (nommée oldOscillatorChange) prend la valeur de la balle qui change 
      oscillatorChange=oscillatorChange-1; // la balle qui change est maintenant la balle -1
   } 
   
      if (oscillatorChange<=-1) {
        oldOscillatorChange=0;
        oscillatorChange=networkSize-1;
   }
  }       
  
   timeLfo = (int) map (signal[2], 0, 1, 0, 1000); // linear time  to map between 0 and 1000
   println ( " ***************************************************    SPLIT TIME  timeLfoooooooooo " + " signal[2] " + signal[2] + " oldSplitTime " + oldSplitTime + " splitTime " + splitTime );

   oldSplitTimeLfo=splitTimeLfo;  // met à jour l'ancienne intervalle de temps
   splitTimeLfo= int  (timeLfo%100); // la valeur de l'intervalle de temps situé à sur un decile du signal[2]  
}


void  splitTimeLfoScale() {  // change de sens de propagagtion.   ATTENTION dans ce reglage le signalToSplit de propgation est UP continue de 0 à TWO_PI

    lfoPhase[1] = (frameCount / 10.0 * cos (1000 / 500.0)*-1)%TWO_PI;  // continue 0 to TWO_PI;
    lfoPhase[3] = map ((((cos  (frameCount / 30.0))*-1) %2), -1, 1, -TWO_PI, TWO_PI);  // sinusoidale lente
    lfoPhase[2] = map ((((cos  (frameCount / 100.0))*-1) %2), -1, 1, -TWO_PI, TWO_PI); // sinusoidale rapide
    
    println (" forme d'onde lfoPhase[1] ", lfoPhase[1], "lfoPhase[2] ", lfoPhase[2], "lfoPhase[3]= signalTosplit ", lfoPhase[3]); 

    oldSignalToSplit=signalToSplit;
    signalToSplit= lfoPhase[3];
 
  if (oldSignalToSplit> signalToSplit ) {
  //  key = 'q' ; // when signal goes down --> propagation FRONT SIDE
   timeLfo= map (signalToSplit, TWO_PI, -TWO_PI, 0, 1000);  //  if we have an oscillation as  lfoPhase[3]
    }
  else if (oldSignalToSplit< signalToSplit ) { // on est dans cette configuration avec  signalToSplit= lfoPhase[1]
//   key = 'z';  //  when signal goes down --> propagation BEHIND SIDE 
//   key = 'q' ;  // propagation in on the same way
   timeLfo= map (signalToSplit, -TWO_PI, TWO_PI, 0, 1000);  // if we have an oscillation  lfoPhase[3]
 //**   timeLfo= map (signalToSplit, 0, TWO_PI, 0, 1000);  // if we have a continuois from 0 to TWO_PI 
 //   timeLfo= map (signalToSplit, 0, 1, 0, 1000); //  if we have a continuois from 0 to TWO_PI from an other software

   }

  int splitTimeLfo= int  (timeLfo%100);   // 100 is the size of the gate trigging the change of the ball  
   
      println ( " oldSignalToSplit " + oldSignalToSplit + " signalToSplit " + signalToSplit );
      print (" timeLfo "); print ( timeLfo );   print (" splittimeLfo "); println ( splitTimeLfo );


 if (doZ==false){  // case q
  if (oldSplitTimeLfo>splitTimeLfo){

      oldOscillatorChange=oscillatorChange;
      oscillatorChange=oscillatorChange+1;
   } 
      oscillatorChange=oscillatorChange%networkSize;
      
  if (oscillatorChange<=0) {
  //    oscillatorChange=0;
      oldOscillatorChange=networkSize-1;
   } 
  }
  
 if (doZ==true){ // case z
  if (  oldSplitTimeLfo>splitTimeLfo){

      oldOscillatorChange=oscillatorChange;
      oscillatorChange=oscillatorChange-1;
   } 
      if (oscillatorChange<=-1) {

      oldOscillatorChange=0;
      oscillatorChange=networkSize-1;
   }
  }  

  if ( oldOscillatorChange!=oscillatorChange )
  {
   oscillatorChanged=true;
  } 
   oldSplitTimeLfo = splitTimeLfo;           
}

 
