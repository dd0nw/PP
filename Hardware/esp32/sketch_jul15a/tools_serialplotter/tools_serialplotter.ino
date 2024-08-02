#include <SPI.h>
#include "protocentral_ads1292r.h"
#include "ecgRespirationAlgo.h"

// ADS1292R 핀 설정
const int ADS1292_DRDY_PIN = 6;
const int ADS1292_CS_PIN = 7;
const int ADS1292_START_PIN = 5;
const int ADS1292_PWDN_PIN = 4;

// 글로벌 변수
volatile uint8_t globalHeartRate = 0;
volatile uint8_t globalRespirationRate = 0;
int16_t ecgWaveBuff, ecgFilterout;
int16_t resWaveBuff, respFilterout;

// ADS1292R 및 알고리즘 객체 생성
ads1292r ADS1292R;
ecg_respiration_algorithm ECG_RESPIRATION_ALGORITHM;

void setup() {
  Serial.begin(115200);
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
    ecgWaveBuff = (int16_t)(ecgRespirationValues.sDaqVals[1] >> 8);  // 24비트 중 하위 8비트를 무시
    resWaveBuff = (int16_t)(ecgRespirationValues.sresultTempResp >> 8);

    if (!ecgRespirationValues.leadoffDetected) {
      ECG_RESPIRATION_ALGORITHM.ECG_ProcessCurrSample(&ecgWaveBuff, &ecgFilterout);   // 필터링
      ECG_RESPIRATION_ALGORITHM.QRS_Algorithm_Interface(ecgFilterout, &globalHeartRate); // QRS 복합파 분석
      
      Serial.println(ecgFilterout);  // 시리얼 플로터에 출력
    } else {
      ecgFilterout = 0;
      respFilterout = 0;
    }
  }
}
