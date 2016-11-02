import processing.net.*;

World world;
Server server;
int port = 32999;
String data;
int serverDelay = 50;
Delay serverTimer = new Delay(serverDelay);
//time management variables
long previousTime = 0;
long currentTime = 0;
long deltaTime;
long worldTime;
int keyPressDelay = 250;
//key management variable

Delay keyPressTimer = new Delay(keyPressDelay);

void setup () {
  
  fullScreen(1);
  //size (680, 384);
  world = new World();
  server = new Server(this,port);
}

void draw() {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  
  updateServer(deltaTime);
  background (255);
  
  world.update(deltaTime);
  world.display();
  world.showData();
  
  showThanks();
  
    
  //assure la loop no matter what
  if(world.carnivores.size() == 0 || world.herbivores.size() == 0){
    world = new World();
    
  }
 
    
  keyPressTimer.update(deltaTime); 
  previousTime = currentTime; 
}






void showThanks() {
  fill(50);
  text ("Merci à Jimmy Béland-Bédard pour le PacMan", width - 275, height - 15);
}

void keyPressed() {
  if(keyPressTimer.expired()){
    if (key == 'w')
      world = new World();
    
    if (key == 'f')
      world.addFertilizer(new Fertilizer(random (width), random (height),world));
    
    if (key == 'p')
      world.addPlant(new Plant(random (width), random (height),world));
    
    if (key == 'h')
      world.addHerbivore(new Herbivore(random (width), random (height),world));
    
    if (key == 'c')
      world.addCarnivore(new Carnivore(random (width), random (height), world));
  }
}

/**
  this class contains 4 types of components : fertilizer,herbivore,carnivore,plant
  those components interact with each other. The main idea is to represent world
  simulation with energy.Nothing is lost, nothing is created apply to this energy
  system.
**/
class World {
  
//debug/optimization attributes
  Boolean debug = false;
  int averageValueCount = 100;
  long FertilizerComputingTime;
  long PlantComputingTime;
  long HerbivoreComputingTime;
  long CarnivoreComputingTime;
  IntList fertilizerComputeTimes = new IntList();
  IntList plantComputeTimes = new IntList();
  IntList herbivoreComputeTimes = new IntList();
  IntList carnivoreComputeTimes = new IntList();
  long FertilizerDisplayTime;
  long PlantDisplayTime;
  long HerbivoreDisplayTime;
  long CarnivoreDisplayTime;
  IntList fertilizerDisplayTimes = new IntList();
  IntList plantDisplayTimes = new IntList();
  IntList herbivoreDisplayTimes = new IntList();
  IntList carnivoreDisplayTimes = new IntList();
//config attributes

  final int startingHerbivore = 100;
  final int startingFertilizer = 30;
  final int startingPlant = 200;
  final int startingCarnivore = 2;
  
//world components
  ArrayList<Carnivore> carnivores;
  ArrayList<Fertilizer> fertilizers;
  ArrayList<Herbivore> herbivores;
  ArrayList<Plant> plants;
  ArrayList<Carnivore> deadCarnivores;
  ArrayList<Fertilizer> deadFertilizers;
  ArrayList<Herbivore> deadHerbivores;
  ArrayList<Plant> deadPlants;
  ArrayList<Carnivore> newCarnivores;
  ArrayList<Fertilizer> newFertilizers;
  ArrayList<Herbivore> newHerbivores;
  ArrayList<Plant> newPlants;
  
  float herbivoreAverageStartSpeed;
  float herbivoreAverageCurrentSpeed;
  
  PImage herbImg;
//constructor
  World() {
    
    herbImg = loadImage("plant.png");
    carnivores = new ArrayList<Carnivore>();
    fertilizers = new ArrayList<Fertilizer>();
    herbivores = new ArrayList<Herbivore>();
    plants = new ArrayList<Plant>();
    deadCarnivores = new ArrayList<Carnivore>();
    deadFertilizers = new ArrayList<Fertilizer>();
    deadHerbivores = new ArrayList<Herbivore>();
    deadPlants = new ArrayList<Plant>();
    newCarnivores = new ArrayList<Carnivore>();
    newFertilizers = new ArrayList<Fertilizer>();
    newHerbivores = new ArrayList<Herbivore>();
    newPlants = new ArrayList<Plant>();
    
  //adding component
    float speedSum = 0;
    for (int i = 0; i < startingHerbivore; i++)
      herbivores.add(new Herbivore(random (width), random (height),this));
    for(Herbivore h : herbivores)
      speedSum += h.speed;
    herbivoreAverageStartSpeed = speedSum / startingHerbivore;
      
    for (int i = 0; i < startingFertilizer; i++) 
      fertilizers.add(new Fertilizer(random (width), random (height),this));
      
    for (int i = 0; i < startingPlant; i++) 
      plants.add(new Plant(random (width), random (height),this));
      
    for (int i = 0; i < startingCarnivore; i++) 
      carnivores.add(new Carnivore(random (width), random (height), this));
      
      
   
   for(int i = 0 ; i < averageValueCount ; i++){
     fertilizerComputeTimes.append(0);
     plantComputeTimes.append(0);
     herbivoreComputeTimes.append(0);
     carnivoreComputeTimes.append(0);
     fertilizerDisplayTimes.append(0);
     plantDisplayTimes.append(0);
     herbivoreDisplayTimes.append(0);
     carnivoreDisplayTimes.append(0);
   }
     
  }
  
  void update(long delta) {
  long timeNano;
  //update component

    timeNano = System.nanoTime();
    for(Herbivore h : herbivores)
      h.update(delta);
    HerbivoreComputingTime = System.nanoTime() - timeNano;
    
    timeNano = System.nanoTime();
    for(Plant p : plants)
      p.update(delta);
    PlantComputingTime = System.nanoTime() - timeNano;
    
    timeNano = System.nanoTime();
    for(Fertilizer f : fertilizers)
      f.update(delta);
    FertilizerComputingTime = System.nanoTime() - timeNano;
    
    timeNano = System.nanoTime();
    for(Carnivore c : carnivores)
      c.update(delta);
    CarnivoreComputingTime = System.nanoTime() - timeNano;
    
    fertilizerComputeTimes.append((int)FertilizerComputingTime);
    plantComputeTimes.append((int)PlantComputingTime);
    herbivoreComputeTimes.append((int)HerbivoreComputingTime);
    carnivoreComputeTimes.append((int)CarnivoreComputingTime);

    fertilizerComputeTimes.remove(0);
    plantComputeTimes.remove(0);
    herbivoreComputeTimes.remove(0);
    carnivoreComputeTimes.remove(0);
   //kill component
     fertilizers.removeAll(deadFertilizers);
     carnivores.removeAll(deadCarnivores);
     plants.removeAll(deadPlants);
     herbivores.removeAll(deadHerbivores);
     deadFertilizers.clear();
     deadCarnivores.clear();
     deadPlants.clear();
     deadHerbivores.clear();
     
   //add new component
     fertilizers.addAll(newFertilizers);
     carnivores.addAll(newCarnivores);
     plants.addAll(newPlants);
     herbivores.addAll(newHerbivores);
     newFertilizers.clear();
     newCarnivores.clear();
     newPlants.clear();
     newHerbivores.clear();
     
     
    
  }
  
  void display () {
    long timeNano;
    //render component
    timeNano = System.nanoTime();
    for(Fertilizer f : fertilizers)
      f.render();
    FertilizerDisplayTime = System.nanoTime() - timeNano;
    
    timeNano = System.nanoTime();
    for(Plant p : plants)
      p.render();
    PlantDisplayTime = System.nanoTime() - timeNano; 
    
    timeNano = System.nanoTime();  
    for(Herbivore h : herbivores)
      h.render();
    HerbivoreDisplayTime = System.nanoTime() - timeNano;  
    
    timeNano = System.nanoTime();  
    for(Carnivore c : carnivores)
      c.render();
    CarnivoreDisplayTime = System.nanoTime() - timeNano;  
    
    fertilizerDisplayTimes.append((int)FertilizerDisplayTime);
    plantDisplayTimes.append((int)PlantDisplayTime);
    herbivoreDisplayTimes.append((int)HerbivoreDisplayTime);
    carnivoreDisplayTimes.append((int)CarnivoreDisplayTime);
    fertilizerDisplayTimes.remove(0);
    plantDisplayTimes.remove(0);
    herbivoreDisplayTimes.remove(0);
    carnivoreDisplayTimes.remove(0);
    
    println("fertilizerComputeTime : " +getAverage(fertilizerComputeTimes));
    println("plantComputeTime : " +getAverage(plantComputeTimes));
    println("herbivoreComputeTime : " +getAverage(herbivoreComputeTimes));
    println("carnivoreComputeTime : " +getAverage(carnivoreComputeTimes));
    println("fertilizerDisplayTime : " +getAverage(fertilizerDisplayTimes));
    println("plantDisplayTime : " +getAverage(plantDisplayTimes));
    println("herbivoreDisplayTime : " +getAverage(herbivoreDisplayTimes));
    println("carnivoreDisplayTime : " +getAverage(carnivoreDisplayTimes));
    println(" ");
   
  }
  
  void showData() {
    fill(50);
    int fertilizerEnergy = getFertilizerEnergy();
    int plantEnergy = getPlantEnergy();
    int herbivoreEnergy = getHerbivoreEnergy();
    int carnivoreEnergy = getCarnivoreEnergy();
    int worldEnergy = herbivoreEnergy + plantEnergy + fertilizerEnergy + carnivoreEnergy;
    
    float speedSum = 0;
    for(Herbivore h : herbivores)
      speedSum += h.speed;
    herbivoreAverageCurrentSpeed = speedSum / herbivores.size();
    text ("Fertilizer count: " + fertilizers.size(), width - 275, 15);
    text ("total energy: " + fertilizerEnergy, width - 150, 15);
    
    text ("Plant count: " + plants.size(), width - 275, 25);
    text ("total energy: " + plantEnergy, width - 150, 25);
    
    text ("Herbivore count: " + herbivores.size(), width - 275, 35);
    text ("total energy: " + herbivoreEnergy, width - 150, 35);
    
    text ("Carnivore count: " + carnivores.size(), width - 275, 45);
    text ("total energy: " + carnivoreEnergy, width - 150, 45);
    
    text ("total world energy: " + worldEnergy, width - 150, 55);
    
    text ("Herbivore startSpeed average " + herbivoreAverageStartSpeed, width - 275, 85);
    text ("herbivore Average Current Speed :  " + herbivoreAverageCurrentSpeed, width - 275, 95);
  }

//Components management methods
  //Fertilizer
  void addFertilizer(Fertilizer fertilizer){
    newFertilizers.add(fertilizer);
  }
  
  void removeFertilizer(Fertilizer fertilizer){
    deadFertilizers.add(fertilizer);
  }
  
  int getFertilizerEnergy(){
    int sum = 0;
    for(Fertilizer f:fertilizers)
      sum += f.energy;
    return sum;
  }
  
  //Plant
  void addPlant(Plant plant){
    newPlants.add(plant);
  }
  
  void removePlant(Plant plant){
    deadPlants.add(plant);
  }
  
  int getPlantEnergy(){
    int sum = 0;
    for(Plant p:plants)
      sum += p.energy;
    return sum;
  }
  
  //Herbivore
  void addHerbivore(Herbivore herbivore){
    newHerbivores.add(herbivore);
  }
  
  void removeHerbivore(Herbivore herbivore){
    deadHerbivores.add(herbivore);
  }
  
  int getHerbivoreEnergy(){
    int sum = 0;
    for(Herbivore h:herbivores)
      sum += h.energy;
    return sum;
  }
  
  //Carnivore
  void addCarnivore(Carnivore carnivore){
    newCarnivores.add(carnivore);
  }
  
  void removeCarnivore(Carnivore carnivore){
    deadCarnivores.add(carnivore);
  }
  
  int getCarnivoreEnergy(){
    int sum = 0;
    for(Carnivore c:carnivores)
      sum += c.energy;
    return sum;
  }
  
  int getAverage(IntList list){
    int sum = 0;
    for(int i = 0 ; i < list.size();i++)
      sum += list.get(i);
    return sum / list.size();
  }
  
}

void updateServer(long deltaTime){
    
    Client client = server.available();
    if (client != null) {
      
     serverTimer.update(deltaTime);
      if(serverTimer.expired()){
        data = client.readStringUntil('\n'); // Le ~ permet d'indiquer au serveur la fin des données envoyé par le client
  
        if (data != null) {
          data = data.replaceAll("\n", "");
          if(data.equals("add herbivore"))
            world.addHerbivore(new Herbivore(random (width), random (height),world));
          else if(data.equals("add carnivore"))
            world.addCarnivore(new Carnivore(random (width), random (height), world));
          else if(data.equals("add plant"))
            world.addPlant(new Plant(random (width), random (height),world));
          else if(data.equals("add fertilizer"))
            world.addFertilizer(new Fertilizer(random (width), random (height),world));
          else if(data.equals("remove herbivore"))
            world.removeHerbivore(world.herbivores.get(0));
          else if(data.equals("remove carnivore"))
            world.removeCarnivore(world.carnivores.get(0));
          else if(data.equals("remove plant"))
            world.removePlant(world.plants.get(0));
          else if(data.equals("remove fertilizer"))
            world.removeFertilizer(world.fertilizers.get(0));
          else if(data.equals("reset world"))
            world = new World();
          data = null;
          client.clear();
        }
      }
    }
  }