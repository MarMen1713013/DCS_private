// L298N

//definizione dei pin
static int pinPot = A0; //pin analogico deputato a leggere i valori del potenziometro
static int ENA = 2; //pin digitale tramite il quale inviare un segnale di tipo PWM tramite la funzione analgWrite()
static int IN1 = 3; //pin digitale per determinare gli stati logici da inviare al modulo
static int IN2 = 4;
static int IN3 = 5;
static int IN4 = 6;
static int ENB = 7;

//variabili usate per gestire e mostrare i valori di operaizone
int pot;  //valore letto dal pinPot
int pwm;  //valore in uscita dal pin PWM_pin
double current;

void setup() {
  Serial.begin(115200);
 analogReadResolution(12);
  //inizializzo variabili
  pot = 0;
  pwm = 0;
  current = 0;

  //definisco tipologia pin
  pinMode(pinPot, INPUT); //input in quanto legge il valore analogico del pin A0
  pinMode(ENA, OUTPUT);
  pinMode(IN1, OUTPUT); //output perche' definisce lo stato logico del pin IN1 del modulo L298N
  pinMode(IN2, OUTPUT); //output perche' definisce lo stato logico del pin IN2 del modulo L298N
  pinMode(IN3, OUTPUT); //output perche' definisce lo stato logico del pin IN1 del modulo L298N
  pinMode(IN4, OUTPUT);
  pinMode(ENB, OUTPUT);  //output perche' definisce il valore PWM del pin EN1 del modulo L298N
  //pullDown sensore pinAcceleratore
  digitalWrite(ENA, HIGH);   //motore con encoder
  digitalWrite(ENB, LOW);    //load

  //Definisco il senso di marcia del motore
  /*
    mA |   mB  | Evento
    -----|-------|----------------------
    LOW  | LOW   | fermo
    LOW  | HIGH  | Movimento in un senso
    HIGH | LOW   | Movimento senso opposto
    HIGH | HIGH  | Fermo
  */

  digitalWrite(IN1, LOW);  // opposite rotation (depends how you connect the pin)
  digitalWrite(IN2, HIGH);
  digitalWrite(IN3, LOW);
  digitalWrite(IN4, HIGH);
}


void loop() {

  //leggo il valore analogico del potenziometro sul pin A0.
  pot = analogRead(pinPot);

  /*
    Il range dei valori analogici e' da 0 a 1024 mentre il range dei valori PWM  e' da 0 a 255
    per mantenere questa proporzionalita' eseguo la mappatura dei valori
  */
  pwm = map(pot, 0, 4096, 0, 255);

  //invio costantemente il valore PWM della potenza in modo da far variare la velocita' del motore in base alla posizione del potenziometro
  analogWrite(ENB, pwm); //load

  current = analogRead(A1) / 4096.0 / 2 * 3.3 ;
  
  Serial.println(current);

  delay(100);
}


