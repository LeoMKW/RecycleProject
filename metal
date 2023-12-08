#include <Stepper.h>

const int stepsPerRevolution = 2048;
Stepper myStepper(stepsPerRevolution, 11, 9, 10, 8);
const int metalSensorPin1 = A0;
const int metalSensorPin2 = A1;

const int trigPin = 6;
const int echoPin = 7;

void setup() {
  myStepper.setSpeed(10);
  Serial.begin(9600);
  pinMode(echoPin, INPUT);
  pinMode(trigPin, OUTPUT);
}

void loop() {
  long duration, distance;
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = ((float)(340 * duration) / 1000) / 2;
  Serial.print("거리: ");
  Serial.print(distance);
  Serial.println(" mm");

  int metalValue1 = analogRead(metalSensorPin1);
  int metalValue2 = analogRead(metalSensorPin2);

  Serial.print("금속 감지 값 1: ");
  Serial.println(metalValue1);
  Serial.print("금속 감지 값 2: ");
  Serial.println(metalValue2);

  // 거리가 0보다 크고 190보다 작은 경우에만 코드 블록 내의 동작을 실행
  if (distance < 190) {
    delay(6000);
    if (metalValue1 < 50 || metalValue2 < 50) {
      myStepper.step(-stepsPerRevolution / 5);
      delay(3000);
      myStepper.step(stepsPerRevolution / 5);
      Serial.println("금속 감지: 시계방향");
    } else {
      myStepper.step(stepsPerRevolution / 5);
      delay(3000);
      myStepper.step(-stepsPerRevolution / 5);
      Serial.println("금속 미감지: 반시계방향");
    }
  }

  delay(1000);
}
