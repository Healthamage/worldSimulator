/**
  this class represent food for Plant. Fertilizer is generated by herbivore and
  carnivore poop.
**/
class Fertilizer extends WorldObject{
  
//config attributes
  static final float energySizeMultiplicator = 0.005;//used to calcul sizeModifier
  static final int defaultWidth = 30;
  static final int defaultHeight = 10;
  static final int defaultEnergy = 500;
  
//attributes
  float sizeModifier;
  int energy;
  color fillColor;
  color strokeColor;
  float fertilizingRayon;
  
//constructors 
  Fertilizer(float x, float y, World world){
  //WorldObject attributes
    this.world = world;
    location = new PVector (x , y );
    size = new PVector();
  //Fertilizer attributes
    fillColor = #8B4513;
    strokeColor = 0;
    energy = defaultEnergy;
    updateSize();
    fertilizingRayon = size.x ;
  }
  
  Fertilizer(float x, float y, World world,int energy){
  //WorldObject attributes
    this.world = world;
    location = new PVector (x , y );
    size = new PVector();
  //Fertilizer attributes
    fillColor = #8B4513;
    strokeColor = 0;
    this.energy = energy;
    updateSize();
    fertilizingRayon = size.x ;
  }

//inherited methods
  void update(long deltaTime){

    updateSize();
    if(energy <= 0)
      world.removeFertilizer(this);
  }
  
  void render(){
   
    fill(fillColor);
    noStroke();
    ellipse (location.x, location.y, size.x, size.y);

  }
  
//methods
  int deplete(int amount){

    if(energy >= amount){
      energy -= amount;
      return amount;
    }
    else if(energy > 0){
      int value = energy;
      energy = 0;
      return value;
    }
    return 0;
  }
  
  void updateSize(){
    sizeModifier = (float) energySizeMultiplicator * energy;
    size.set(defaultWidth*sizeModifier,defaultHeight*sizeModifier);
  }
}