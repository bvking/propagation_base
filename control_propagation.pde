void keyReleased (){ 
  controlPropagation();
   }
  
void controlPropagation(){
  if (keyCode == LEFT) {  
    phaseOffset-=1;
  }
  if (keyCode == RIGHT) { 
    phaseOffset+=1;
  }
  
  if (keyCode == UP) {     
    way=false;  
  }
  
  if (keyCode == DOWN) {
    way=true;    
  }
}   
