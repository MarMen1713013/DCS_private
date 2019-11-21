/* Encoder Library - Basic Example
   http://www.pjrc.com/teensy/td_libs_Encoder.html

   This example code is in the public domain.
*/

#include <Encoder.h>


#define encoder0PinA  49
#define encoder0PinB  51
#define trimmer A0
#define PWM_pin 8

volatile long encoder49Pos = 0;

//long newposition;
//long oldposition = 0;
unsigned long newtime;
unsigned long oldtime = 0;
double velocity;
double newangle;
double oldangle;
double vel_degrees;
long vel;
double omega;


// Change these two numbers to the pins connected to your encoder.
//   Best Performance: both pins have interrupt capability
//   Good Performance: only the first pin has interrupt capability
//   Low Performance:  neither pin has interrupt capability
Encoder myEnc(encoder0PinA, encoder0PinB);
//   avoid using pins with LEDs attached

void setup() {
  Serial.begin(115200);
  pinMode(PWM_pin, OUTPUT);
  Serial.println("Basic Encoder Test:");
}

long oldPosition  = -999;

void loop() {
  //analogRead() gives a 10 bit number,
  int p = analogRead(trimmer);  //read the value from the potentiometer
  p = map(p, 0, 1023, 0, 255);  //Map an analog value to 8 bits (0 to 255)
  analogWrite(PWM_pin, p);  

  long newPosition = myEnc.read();
  if (newPosition != oldPosition) {
    oldPosition = newPosition;
  }
  newtime = micros();
  newangle = newPosition * 360 / 11.0;
  vel_degrees = (newangle - oldangle ) * 1000000 / (newtime - oldtime);
  omega = vel_degrees * 3.1415 / (180.0 * 40) / 4.0;
  Serial.print(omega);
  //Serial.print(',');
  //Serial.println(newtime/1000);
  oldangle = newangle;
  oldtime = newtime;
  delay(3);
}
