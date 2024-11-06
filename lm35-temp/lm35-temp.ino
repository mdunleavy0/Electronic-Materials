const int lm35Pin = A0;

const int ioMax = 1023;
const float refV = 5.0;

const float lm35ScaleFactor = 0.01;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);
  
  // serial plotter legend
  Serial.println("Voltage_(V):,Temperature_(C):");
}


void loop() {
  int lm35In = analogRead(lm35Pin);
  float lm35V = lm35In * refV / ioMax;
  float lm35Temp = lm35V / lm35ScaleFactor;

  // print/plot lm35 voltage, temperature
  Serial.print(lm35V);
  Serial.print(",");
  Serial.print(lm35Temp);
  Serial.println();
  
  delay(1000);
}
