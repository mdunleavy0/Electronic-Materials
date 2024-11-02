const int lm35Pin = A0;

const int ioMax = 1023;
const float refV = 5.0;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);
  
  // serial plotter legend
  Serial.println("LM35_(V):");
}


void loop() {
  int lm35In = analogRead(lm35Pin);
  float lm35V = lm35In * refV / ioMax;

  // print/plot lm35 voltage
  Serial.print(lm35V);
  Serial.println();
  
  delay(1000);
}
