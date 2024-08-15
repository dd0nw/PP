// ecg신호검증
#include <Arduino.h>

const int sampleRate = 180; // 샘플링 속도 (Hz)
const unsigned long interval = 1000 / sampleRate; // 샘플링 주기 (ms)

unsigned long startMillis; // 시작 시간 기록
const unsigned long runDuration = 10; // 실행 시간 (25초 = 25000ms)

void setup() {
  Serial.begin(115200); // 시리얼 통신 속도 설정
  pinMode(A0, INPUT); // GPIO0 핀을 입력으로 설정 (ADC1_CH0)

  startMillis = millis(); // 시작 시간 기록
}

void loop() {
  if (millis() - startMillis >= runDuration) {
    // 지정된 실행 시간이 경과하면 loop 종료
    return;
  }

  static unsigned long lastSampleTime = 0;
  unsigned long currentMillis = millis();

  if (currentMillis - lastSampleTime >= interval) {
    lastSampleTime = currentMillis;
    int rawValue = analogRead(A0); // 원시 ADC 값 읽기
    
    // 원시 값을 시리얼 모니터에 출력
    Serial.println(rawValue); 
  }
}
