const int thermistorPin = A0;

const int ioMax = 1023;
const float refV = 3.3;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);
  
  // serial plotter legend
  Serial.println("Thermistor_(V):,Resistor_(V):");
}


void loop() {
  int thermistorIn = analogRead(thermistorPin);
  float thermistorV = thermistorIn * refV / ioMax;
  float resistorV = refV - thermistorV;

  // print/plot thermistor voltage, resistor voltage
  Serial.print(thermistorV);
  Serial.print(",");
  Serial.print(resistorV);
  Serial.println();
  
  delay(1000);
}
