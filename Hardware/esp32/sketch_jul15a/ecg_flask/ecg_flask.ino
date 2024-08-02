#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include "protocentral_ads1292r.h"
#include "ecgRespirationAlgo.h"

// WiFi 정보
const char* ssid =  "U+ 7B";
const char* password = "smhrd77777!";

// Flask 서버 주소
const char* serverUrl = "http://192.168.219.228:5000/api/data";

// ADS1292R 설정
volatile uint8_t globalHeartRate = 0;
volatile uint8_t globalRespirationRate = 0;

const int ADS1292_DRDY_PIN = 6;
const int ADS1292_CS_PIN = 7;
const int ADS1292_START_PIN = 5;
const int ADS1292_PWDN_PIN = 4;

int16_t ecgWaveBuff, ecgFilterout;
int16_t resWaveBuff, respFilterout;

ads1292r ADS1292R;
ecg_respiration_algorithm ECG_RESPIRATION_ALGORITHM;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  SPI.begin();
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE1);
  SPI.setClockDivider(SPI_CLOCK_DIV16);

  pinMode(ADS1292_DRDY_PIN, INPUT);
  pinMode(ADS1292_CS_PIN, OUTPUT);
  pinMode(ADS1292_START_PIN, OUTPUT);
  pinMode(ADS1292_PWDN_PIN, OUTPUT);

  ADS1292R.ads1292Init(ADS1292_CS_PIN, ADS1292_PWDN_PIN, ADS1292_START_PIN);
  Serial.println("Initialization done");

  // Timer 설정: 360Hz 샘플링 속도
  hw_timer_t *timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  timerAlarmWrite(timer, 2777, true);
  timerAlarmEnable(timer);
}

void IRAM_ATTR onTimer() {
  int32_t ecgData[2];
  boolean ret = ADS1292R.getAds1292EcgAndRespirationSamples(ADS1292_DRDY_PIN, ADS1292_CS_PIN, &ecgData);

  if (ret) {
    ecgWaveBuff = (int16_t)(ecgData[1] >> 8);
    resWaveBuff = (int16_t)(ecgData[0] >> 8);

    if (!ecgData.leadoffDetected) {
      ECG_RESPIRATION_ALGORITHM.ECG_ProcessCurrSample(&ecgWaveBuff, &ecgFilterout);
      ECG_RESPIRATION_ALGORITHM.QRS_Algorithm_Interface(ecgFilterout, &globalHeartRate);

      // 데이터 서버로 전송
      sendDataToServer(ecgFilterout, resWaveBuff);
    } else {
      ecgFilterout = 0;
      respFilterout = 0;
    }
  }
}

void sendDataToServer(int16_t ecg, int16_t res) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    char payload[100];
    sprintf(payload, "{\"ecg\": %d, \"res\": %d}", ecg, res);

    int httpResponseCode = http.POST(payload);
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}

void loop() {
  // 주기적으로 데이터를 확인하고 전송
}
