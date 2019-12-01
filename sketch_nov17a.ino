const int stepPin = 8;
const int directionPin = 9;
int motorSpeed;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(stepPin, OUTPUT);
  pinMode(directionPin, OUTPUT);
  motorSpeed = 2000;
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available()>0){
    drive();
    char t = Serial.read();
    delay(100);
    }
}

void drive(){
  int i = 0;
  while(i < 200){
    digitalWrite(stepPin,HIGH);
    delayMicroseconds(motorSpeed);
    digitalWrite(stepPin,LOW);
    delayMicroseconds(motorSpeed);
    i++;
  }
}
