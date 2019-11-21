
#define encoder0PinA  8
#define encoder0PinB  10

volatile long encoder49Pos = 0;

long newposition;
long oldposition = 0;
unsigned long newtime;
unsigned long oldtime = 0;
double velocity;
double newangle;
double oldangle;
double vel_degrees;
long vel;
double omega;

void setup() {
  pinMode(encoder0PinA, INPUT);
  digitalWrite(encoder0PinA, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinB, INPUT);
  digitalWrite(encoder0PinB, HIGH);       // turn on pullup resistor

  //pinMode(trimmer, INPUT); //input in quanto legge il valore analogico del pin A0
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT); //output perche' definisce lo stato logico del pin IN1 del modulo L298N
  pinMode(4, OUTPUT); //output perche' definisce lo stato logico del pin IN2 del modulo L298N
  //pullUP sensore pinAcceleratore
  digitalWrite(2, HIGH);   //motore con encoder
  digitalWrite(3, HIGH);
  digitalWrite(4, LOW);



  attachInterrupt(8, doEncoder, RISING);  // encoDER ON PIN 2

  Serial.begin (115200);
  Serial.println("start");                // a personal quirk
}

void loop() { 
  analogWrite(2,255);
  newposition = encoder49Pos;
  newangle = newposition*360/11.0;
  //Serial.println(newposition);
  newtime = millis();
  vel_degrees = (newangle - oldangle )*1000 / (newtime - oldtime);
  Serial.print("RPM: ");
 Serial.println(vel_degrees*0.166666);
  //Serial.print("rad/s: ");
  //omega = vel_degrees*3.1415/(180.0*40);
 // Serial.println(omega);
  oldangle=newangle;
  oldposition = newposition;
  oldtime = newtime;

  //Serial.println();
delay(100);

}

void doEncoder(){
  if (digitalRead(encoder0PinA) == digitalRead(encoder0PinB)) {
    encoder49Pos++;
  } else {
    encoder49Pos--;
  }
}


//// encoder event for the interrupt call
//void doEncoder() {
//  if (digitalRead(encoder0PinA) == HIGH) {
//    if (digitalRead(encoder0PinB) == LOW) {
//      encoder49Pos++;
//    } else {
//      encoder49Pos--;
//    }
//  } else {
//    if (digitalRead(encoder0PinB) == LOW) {
//      encoder49Pos--;
//    } else {
//      encoder49Pos++;
//    }
//  }
//}

