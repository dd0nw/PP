#include <SPI.h>
#include "protocentral_ads1292r.h"
#include "ecgRespirationAlgo.h"
#include <WiFi.h>
#include <HTTPClient.h>

// WiFi 정보
const char* ssid = "U+ 7B";
const char* password = "smhrd77777!";

// Flask 서버 주소
const char* serverUrl = "http://192.168.219.228:5000/api/data";

// ADS1292R 설정
volatile uint8_t globalHeartRate = 0;
volatile uint32_t lastQRS = 0;
volatile uint32_t rrInterval = 0;

const int ADS1292_DRDY_PIN = 6;
const int ADS1292_CS_PIN = 7;
const int ADS1292_START_PIN = 5;
const int ADS1292_PWDN_PIN = 4;

int16_t ecgWaveBuff, ecgFilterout;

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
}

void loop() {
  ads1292OutputValues ecgRespirationValues;
  boolean ret = ADS1292R.getAds1292EcgAndRespirationSamples(ADS1292_DRDY_PIN, ADS1292_CS_PIN, &ecgRespirationValues);

  if (ret) {
    ecgWaveBuff = (int16_t)(ecgRespirationValues.sDaqVals[1] >> 8);

    if (!ecgRespirationValues.leadoffDetected) {
      ECG_RESPIRATION_ALGORITHM.ECG_ProcessCurrSample(&ecgWaveBuff, &ecgFilterout);
      bool qrsDetected = ECG_RESPIRATION_ALGORITHM.QRS_Algorithm_Interface(ecgFilterout, &globalHeartRate);
      
      if (qrsDetected) {
        uint32_t currentTime = millis();
        rrInterval = currentTime - lastQRS;
        lastQRS = currentTime;
      }

      // 데이터 서버로 전송
      sendDataToServer(ecgFilterout, globalHeartRate, rrInterval);
    } else {
      ecgFilterout = 0;
    }
  }
}

void sendDataToServer(int16_t ecg, uint8_t heartRate, uint32_t rrInterval) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/json");

    char payload[150];
    sprintf(payload, "{\"ecg\": %d, \"heartRate\": %d, \"rrInterval\": %d}", ecg, heartRate, rrInterval);

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
