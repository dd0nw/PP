#include <Wire.h>
#include "MAX30105.h"
#include <ArduinoBLE.h>

// UUIDs for the BLE service and characteristics
const char* serviceUUID = serviceUUID
const char* heartRateCharUUID = heartRateCharUUID; // Heart rate characteristic UUID
const char* spo2CharUUID = spo2CharUUID; // SpO2 characteristic UUID

const int I2C_SDA_PIN = 18; // SDA 핀을 GPIO 18로 설정
const int I2C_SCL_PIN = 19; // SCL 핀을 GPIO 19로 설정

MAX30105 particleSensor;

const int sampleRate = 50; // 50Hz
const int sampleTimeMs = 1000; // 1 second
const int numSamples = sampleRate * (sampleTimeMs / 1000);

uint32_t redBuffer[numSamples];
uint32_t irBuffer[numSamples];
uint8_t compressedHeartRateData[25]; // 50 samples, each 4-bit, total 200 bits = 25 bytes
uint8_t compressedSpO2Data[25];      // Same as above for SpO2

// BLE Service and Characteristics
BLEService sensorService(serviceUUID);
BLECharacteristic heartRateCharacteristic(heartRateCharUUID, BLERead | BLENotify, sizeof(compressedHeartRateData)); // 최대 25바이트의 데이터 전송
BLECharacteristic spo2Characteristic(spo2CharUUID, BLERead | BLENotify, sizeof(compressedSpO2Data)); // 최대 25바이트의 데이터 전송

void setup()
{
  Serial.begin(115200);
  Wire.begin(I2C_SDA_PIN, I2C_SCL_PIN);

  Serial.println("MAX30105 Heart Rate and SpO2 Estimation");

  // Initialize sensor
  if (!particleSensor.begin())
  {
    Serial.println("MAX30105 was not found. Please check wiring/power.");
    while (1);
  }
  particleSensor.setup(); // Configure sensor. Use 6.4mA for LED drive

  // Initialize BLE
  if (!BLE.begin()) {
    Serial.println("Failed to start BLE");
    while (1);
  }

  BLE.setDeviceName("PPG_BT");
  BLE.setLocalName("PPG_BT");
  BLE.setAdvertisedService(sensorService);

  sensorService.addCharacteristic(heartRateCharacteristic);
  sensorService.addCharacteristic(spo2Characteristic);
  BLE.addService(sensorService);

  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop()
{
  BLEDevice central = BLE.central();

  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());

    while (central.connected()) {
      // 데이터를 계속해서 수집하고, 계산 후 BLE로 전송
      collectAndSendData();
      delay(2000); // 2초마다 데이터 전송
    }

    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}

void collectAndSendData() {
  // 1초간 50Hz로 데이터 수집
  for (int i = 0; i < numSamples; i++)
  {
    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    delay(1000 / sampleRate); // 50Hz 샘플링 속도 유지
  }

  // 심박수와 SpO2 계산
  float heartRate = calculateHeartRate(irBuffer, numSamples);
  float SpO2 = calculateSpO2(redBuffer, irBuffer, numSamples);

  // 심박수와 SpO2 값을 4비트로 압축
  uint8_t hrValue = map(heartRate, 0, 150, 0, 15); // 0-150 BPM을 4비트(0-15)로 압축
  uint8_t spo2Value = map(SpO2, 70, 100, 0, 15); // 70-100% SpO2를 4비트(0-15)로 압축

  // 각각의 4비트 값을 25바이트 배열에 저장
  for (int i = 0; i < numSamples; i++) {
    if (i % 2 == 0) {
      compressedHeartRateData[i / 2] = (hrValue << 4) | (hrValue & 0x0F);  // 4비트 값을 압축하여 저장
      compressedSpO2Data[i / 2] = (spo2Value << 4) | (spo2Value & 0x0F);  // 4비트 값을 압축하여 저장
    }
  }

  // BLE를 통해 압축된 데이터 전송
  heartRateCharacteristic.writeValue(compressedHeartRateData, sizeof(compressedHeartRateData));
  spo2Characteristic.writeValue(compressedSpO2Data, sizeof(compressedSpO2Data));
  
  // 디버그용 출력
  Serial.print("Compressed Heart Rate Data Sent: ");
  for (int i = 0; i < sizeof(compressedHeartRateData); i++) {
    Serial.print(compressedHeartRateData[i], HEX);
    Serial.print(" ");
  }
  Serial.println();

  Serial.print("Compressed SpO2 Data Sent: ");
  for (int i = 0; i < sizeof(compressedSpO2Data); i++) {
    Serial.print(compressedSpO2Data[i], HEX);
    Serial.print(" ");
  }
  Serial.println();
}

// 심박수를 IR 데이터에서 계산
float calculateHeartRate(uint32_t *irBuffer, int numSamples)
{
  int peakCount = 0;

  for (int i = 1; i < numSamples - 1; i++)
  {
    if (irBuffer[i] > irBuffer[i - 1] && irBuffer[i] > irBuffer[i + 1] && irBuffer[i] > 50000)
    {
      peakCount++;
    }
  }

  float estimatedBPM = (peakCount * (60.0 / (sampleTimeMs / 1000.0)));

  // Normalization logic
  if (estimatedBPM == 0) {
    return 55; // Minimum heart rate
  } else if (estimatedBPM > 0 && estimatedBPM <= 1000) {
    return 55 + (34 * (estimatedBPM / 1000.0)); // Linearly map to 55-89
  } else if (estimatedBPM > 1000 && estimatedBPM <= 1600) {
    return 90 + (9 * ((estimatedBPM - 1000) / 600.0)); // Linearly map to 90-99
  } else if (estimatedBPM > 1600) {
    return 100 + (5 * ((estimatedBPM - 1600) / 600.0)); // Linearly map to 100-105
  } else {
    return estimatedBPM; // No normalization needed
  }
}

// 간단한 SpO2 계산 함수
float calculateSpO2(uint32_t *redBuffer, uint32_t *irBuffer, int numSamples)
{
  float sumRed = 0, sumIR = 0;

  for (int i = 0; i < numSamples; i++)
  {
    sumRed += redBuffer[i];
    sumIR += irBuffer[i];
  }

  float ratio = (sumRed / numSamples) / (sumIR / numSamples);
  float SpO2 = 104 - 17 * ratio; // Simplified estimation formula

  return SpO2;
}
