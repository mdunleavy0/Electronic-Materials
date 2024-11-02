const int thermistorPin = A0;
const int lm35Pin = A1;

const int ioMax = 1023;
const float refV = 3.3;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);

  // serial plotter legend
  Serial.println("Thermistor_(V):,LM35_(V):");
}


void loop() {
  int thermistorIn = analogRead(thermistorPin);
  int lm35In = analogRead(lm35Pin);
  float thermistorV = thermistorIn * refV / ioMax;
  float lm35V = lm35In * refV / ioMax;
  
  // print/plot thermistor voltage, LM35 voltage
  Serial.print(thermistorV);
  Serial.print(",");
  Serial.print(lm35V);
  Serial.println();

  delay(1000);
}
