/* Encoder Library - Basic Example
   http://www.pjrc.com/teensy/td_libs_Encoder.html

   This example code is in the public domain.
*/

#include <Encoder.h>


#define encA  8
#define encB  10
#define trimmer A0  //potentiometer

static int ENA = 2; //pin digitale tramite il quale inviare un segnale di tipo PWM tramite la funzione analgWrite()
static int IN1 = 3; //pin digitale per determinare gli stati logici da inviare al modulo
static int IN2 = 4;
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

double e_speed = 0;
double e_speed_pre = 0;
double e_speed_sum = 0;
double pwm_pulse = 0;

int kp = 300;
int ki = 50;
int set_speed=3500;   // max speed is 5500 rpm with pwm = 255


//   Change these two numbers to the pins connected to your encoder.
//   Best Performance: both pins have interrupt capability
//   Good Performance: only the first pin has interrupt capability
//   Low Performance:  neither pin has interrupt capability
Encoder myEnc(encA, encB);

void setup() {
  Serial.begin(115200);
  pinMode(trimmer, INPUT); //input in quanto legge il valore analogico del pin A0
  pinMode(ENA, OUTPUT);
  pinMode(IN1, OUTPUT); //output perche' definisce lo stato logico del pin IN1 del modulo L298N
  pinMode(IN2, OUTPUT); //output perche' definisce lo stato logico del pin IN2 del modulo L298N
  //pullUP sensore pinAcceleratore
  digitalWrite(ENA, HIGH);   //motore con encoder
  digitalWrite(IN1, HIGH);
  digitalWrite(IN2, LOW);
//analogReadResolution(12);

}

long oldPosition  = -999;

void loop() {
  //analogRead() gives a 10 bit number,
  // int p = analogRead(trimmer);  //read the value from the potentiometer
  // int set_speed = map(p, 0, 4096, 0, 6000);   // 16 max [rad/s]

  long newPosition = myEnc.read();
  if (newPosition != oldPosition) {
    oldPosition = newPosition;
  }
  newtime = micros();
  newangle = newPosition * 360 / 11.0;
  vel_degrees = (newangle - oldangle ) / 4.0 * 1000000 / (newtime - oldtime);  // *1000000 because time is micros()
  //omega = vel_degrees * 3.1415 / (180.0) / 4.0;    // angular speed, first in [rad/s]
  double rpm = vel_degrees * 0.16666; // then in RPM
  oldangle = newangle;
  oldtime = newtime;

  //  Serial.print("Rpm: ");
  //  Serial.println(rpm);


  //PID program
  e_speed = set_speed - rpm;
  pwm_pulse = e_speed * kp  + e_speed_sum * ki ;// + (e_speed - e_speed_pre) * kd;
  e_speed_pre = e_speed;  //save last (previous) error
  e_speed_sum += e_speed; //sum of error
  //  if (e_speed_sum > 4000) e_speed_sum = 4000;   // anti windup
  //  if (e_speed_sum < -4000) e_speed_sum = -4000;

  //update new speed
  if (ENA <255 & ENA >0) {
    analogWrite(ENA, pwm_pulse); //set motor speed
  }
  else {
    if (ENA > 255) {
      analogWrite(ENA, 255);
    }
    else {
      analogWrite(ENA, 0);
    }
  }

  Serial.print("Rpm: ");
  Serial.println(rpm);
  Serial.print("Set_speed: ");
  Serial.println(set_speed);


  delay(3);
}
