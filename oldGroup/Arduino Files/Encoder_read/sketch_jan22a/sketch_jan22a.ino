/*
 * Encoder example sketch
 * by Andrew Kramer
 * 1/1/2016
 *
 * Records encoder ticks for each wheel
 * and prints the number of ticks for
 * each encoder every 500ms
 *
 */

// pins for the encoder inputs
#define LH_ENCODER_A 2 
#define LH_ENCODER_B 4

// variables to store the number of encoder pulses
// for each motor
volatile unsigned long leftCount = 0;

void setup() {
  pinMode(LH_ENCODER_A, INPUT);
  pinMode(LH_ENCODER_B, INPUT);
  
  // initialize hardware interrupts
  attachInterrupt(0, leftEncoderEvent, CHANGE);
  
  Serial.begin(9600);
}

void loop() {
  Serial.print("Left Count: ");
  Serial.println(leftCount);
  Serial.println();
  delay(500);
}

// encoder event for the interrupt call
void leftEncoderEvent() {
  if (digitalRead(LH_ENCODER_A) == HIGH) {
    if (digitalRead(LH_ENCODER_B) == LOW) {
      leftCount++;
    } else {
      leftCount--;
    }
  } else {
    if (digitalRead(LH_ENCODER_B) == LOW) {
      leftCount--;
    } else {
      leftCount++;
    }
  }
}
