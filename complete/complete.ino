#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_LEDBackpack.h>


const int thermistorPin = A0;
const int lm35Pin = A1;
const int pwrPin = A2;
const int gndPin = A3;

const int ioMax = 1023;
const float refV = 3.3;

const int resistorR = 10000;
const float lm35ScaleFactor = 0.01;

Adafruit_7segment display;


void setup() {
  analogReference(EXTERNAL);
  Serial.begin(9600);

  // serial plotter legend
  Serial.println(
    "Thermistor_V_(V),"
    "Thermistor_R_(Ohm),"
    "Thermistor_Temperature_(C),"
    "LM35_Temperature_(C)"
  );

  pinMode(pwrPin, OUTPUT);
  pinMode(gndPin, OUTPUT);
  digitalWrite(pwrPin, HIGH);
  digitalWrite(gndPin, LOW);
  
  display = Adafruit_7segment();
  display.begin(0x70);
  display.setBrightness(15);
}


void loop() {
  int thermistorIn = analogRead(thermistorPin);
  int lm35In = analogRead(lm35Pin);

  float thermistorV = thermistorIn * refV / ioMax;
  float thermistorR = (thermistorV * resistorR) / (refV - thermistorV);

  float lm35V = lm35In * refV / ioMax;
  float lm35Temp = lm35V / lm35ScaleFactor;
  
  float thermistorTemp = resToTemp(thermistorR);
  
  /*
    print/plot thermistor voltage, thermistor resitstance,
      thermistor temperature, lm35 temperature
  */
  Serial.print(thermistorV, 3);
  Serial.print(",");
  Serial.print(thermistorR);
  Serial.print(",");
  Serial.print(thermistorTemp);
  Serial.print(",");
  Serial.print(lm35Temp);
  Serial.println();
  
  display.print(thermistorTemp, 2);
  display.writeDisplay();

  delay(1000);
}


// beta parameter prediction of temperature (deg C) given resistance (Ohm)
float resToTemp(float res) {
  static const float absZero = -273.15;
  static const float beta = 3724.14;
  static const float refR = 10108.15;
  static const float refTempK = 297.34;
  
  static const float refConst = refR * exp(-beta/refTempK);
  float tempK = beta / log(res/refConst);
  float temp = tempK + absZero;
  return temp;
}
