const int thermistorPin = A0;
const int lm35Pin = A1;

const int ioMax = 1023;
const float refV = 3.3;

const int resistorR = 10000;
const float lm35ScaleFactor = 0.01;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);

  // serial plotter legend
  Serial.println(
    "Thermistor_V_(V):,Thermistor_R_(Ohm),Temperature_(C):"
  );
}


void loop() {
  int thermistorIn = analogRead(thermistorPin);
  int lm35In = analogRead(lm35Pin);

  float thermistorV = thermistorIn * refV / ioMax;
  float thermistorR =
    (thermistorV * resistorR) / (refV - thermistorV);

  float lm35V = lm35In * refV / ioMax;
  float lm35Temp = lm35V / lm35ScaleFactor;
  
  /*
    print/plot thermistor voltage,
      thermistor resitstance,
      lm35 temperature
  */
  Serial.print(thermistorV, 3);
  Serial.print(",");
  Serial.print(thermistorR);
  Serial.print(",");
  Serial.print(lm35Temp);
  Serial.println();

  delay(1000);
}
