#include <WiFi.h>
#include <HTTPClient.h>

// WiFi 정보
const char* ssid = "U+ 7B";
const char* password = "smhrd77777!";

// Flask 서버 주소
const char* serverUrl = "http://192.168.219.228:5000/api/data"; // 여기에 컴퓨터의 무선랜 IP 주소를 사용

void connectToWiFi() {
  Serial.print("Connecting to WiFi: ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  // WiFi 연결 대기
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nWiFi Connected");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
    Serial.print("RSSI: ");
    Serial.println(WiFi.RSSI());
  } else {
    Serial.println("\nWiFi Connection Failed");
    while (true); // 무한 대기
  }
}

void sendData(int sensorValue) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    // 서버 URL 설정
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    // JSON 형식으로 데이터 생성
    String jsonData = "{\"value\":" + String(sensorValue) + "}";

    // HTTP POST 요청으로 데이터 전송
    int httpResponseCode = http.POST(jsonData);

    // 서버 응답 코드 확인
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.print("HTTP Response code: ");
      Serial.println(httpResponseCode); // HTTP 응답 코드 출력
      Serial.print("Response from server: ");
      Serial.println(response); // 서버 응답 내용 출력
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }

    // 요청 종료
    http.end();
  } else {
    Serial.println("WiFi Disconnected. Attempting to reconnect...");
    connectToWiFi();
  }
}

void setup() {
  // GPIO36 핀 입력 모드 설정
  pinMode(36, INPUT);

  // 시리얼 통신 시작 (속도를 115200으로 설정)
  Serial.begin(115200);

  // WiFi 연결
  connectToWiFi();
}

void loop() {
  // 조도센서에서 데이터 읽기
  int sensorValue = analogRead(36);
  Serial.print("Sensor Value: ");
  Serial.println(sensorValue);

  // 데이터 전송
  sendData(sensorValue);


}
