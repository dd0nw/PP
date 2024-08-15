#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <base64.h>
#include <time.h>

const char* ssid = "U+ 7B";
const char* password = "smhrd77777!";
const char* lambdaEndpoint = "https://tvjo6nms0k.execute-api.ap-northeast-2.amazonaws.com/pulse/pulseFunction";

const int sampleRate = 360; // 샘플링 속도 (Hz)
const int sampleDuration = 15; // 샘플링 기간 (초)
const int numReadings = sampleRate * sampleDuration; // 전체 샘플 수

int readings[numReadings];  // 읽은 값을 저장할 배열
int fileIndex = 0;  // 파일 이름에 사용할 인덱스 (ecg0, ecg1, ecg2...)

void setup() {
  Serial.begin(115200);
  pinMode(0, INPUT); // GPIO0 핀을 입력으로 설정 (ADC1_CH0)

  // WiFi 연결
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("WiFi 연결 중...");
  }
  Serial.println("WiFi 연결됨");

  // NTP 서버 설정
  configTime(9 * 3600, 0, "pool.ntp.org", "time.nist.gov");
  if (!syncTime()) {
    Serial.println("시간 동기화 실패");
  }
}

// NTP 시간 동기화 함수
bool syncTime() {
  struct tm timeinfo;
  for (int i = 0; i < 5; i++) { // 10초 동안 시도
    if (getLocalTime(&timeinfo)) {
      Serial.println("시간 동기화 성공: ");
      Serial.printf("%04d-%02d-%02d %02d:%02d:%02d\n",
                    timeinfo.tm_year + 1900,
                    timeinfo.tm_mon + 1,
                    timeinfo.tm_mday,
                    timeinfo.tm_hour,
                    timeinfo.tm_min,
                    timeinfo.tm_sec);
      return true;
    }
    delay(500);
  }

  return false;
}

// 데이터를 업로드하는 함수
void uploadData(const char* fileName, int* data, size_t dataSize, const char* timestamp) {
    if (WiFi.status() == WL_CONNECTED) {
        HTTPClient http;
        http.begin(lambdaEndpoint);
        http.addHeader("Content-Type", "application/json");

        // Base64로 인코딩
        String base64Payload = base64::encode((uint8_t*)data, dataSize);

        // 내부 JSON 데이터 생성
        DynamicJsonDocument doc(2048);
        doc["file_name"] = fileName;
        doc["timestamp"] = timestamp;
        doc["data"] = base64Payload;

        String jsonPayload;
        serializeJson(doc, jsonPayload);

        Serial.println("업로드할 데이터: " + jsonPayload); // 디버깅용 데이터 로그

        int httpResponseCode = http.POST(jsonPayload);

        Serial.print("HTTP 응답 코드: ");
        Serial.println(httpResponseCode);

        if (httpResponseCode == 200) {
            String response = http.getString();
            Serial.println("응답 내용: " + response); // 응답 디버깅
        } else {
            Serial.print("POST 요청 에러: ");
            Serial.println(httpResponseCode);
        }

        http.end();
    } else {
        Serial.println("WiFi 연결 끊김");
    }
}

void loop() {
  char fileName[10];
  snprintf(fileName, sizeof(fileName), "ecg%d", fileIndex);  // 파일 이름 생성

  unsigned long startMillis = millis(); // 시작 시간 기록
  unsigned long currentMillis = startMillis;
  int secondsElapsed = 0;

  // 현재 시간 정보를 얻어오기
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("시간 정보를 얻지 못함");
    return;
  }

  char timestamp[25];
  snprintf(timestamp, sizeof(timestamp), "%04d-%02d-%02dT%02d:%02d:%02dZ",
           timeinfo.tm_year + 1900, timeinfo.tm_mon + 1, timeinfo.tm_mday,
           timeinfo.tm_hour, timeinfo.tm_min, timeinfo.tm_sec);

  Serial.print("데이터 수집 시작: ");
  Serial.println(fileName);

  // 데이터를 수집
  int readIndex = 0;
  while (millis() - startMillis < sampleDuration * 1000) {
    if (readIndex < numReadings) {
      int rawValue = analogRead(0); // 원시 ADC 값 읽기
      Serial.println(rawValue);
      readings[readIndex] = rawValue; // 원시 값을 배열에 저장
      readIndex++;
      delay(1000 / sampleRate); // 샘플링 속도에 맞춰 지연
    }

    // 1초가 지날 때마다 경과 시간 출력
    currentMillis = millis();
    if ((currentMillis - startMillis) / 1000 > secondsElapsed) {
      secondsElapsed++;
      Serial.printf("경과 시간: %d초\n", secondsElapsed);
      Serial.println(numReadings);
    }
  }

  Serial.println("데이터 수집 완료");
  Serial.println(numReadings);

  // 데이터 업로드
  uploadData(fileName, readings, sizeof(readings), timestamp);

  // 파일 인덱스 증가
  fileIndex = (fileIndex + 1) % 3; // 0, 1, 2 로 순환

  // 다음 루프를 위한 대기
  Serial.println("다음 루프를 준비 중...");
  // delay(1000); // 1분 대기
  if (!syncTime()) {
    Serial.println("시간 동기화 실패");
  } else {
    Serial.println("시간 동기화 성공");
  }
  Serial.println("루프 완료");
}
