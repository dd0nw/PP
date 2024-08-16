#include <ArduinoBLE.h>
#include "secrets.h" // secrets.h 파일 포함

const int ecgSensorPin = 0; // AD8232 센서가 연결된 핀
BLEService ecgSensorService("4fafc201-1fb5-459e-8fcc-c5c9c331914b"); // 서비스 UUID
BLEByteCharacteristic ecgSensorCharacteristic("beb5483e-36e1-4688-b7f5-ea07361b26a8", BLERead | BLENotify); // 특성 UUID
int i = 0;
int k = 0;
void setup() {
  Serial.begin(115200); // 시리얼 통신 속도 설정
  analogReadResolution(10); //10비트로
  pinMode(ecgSensorPin, INPUT); // AD8232 센서 핀을 입력으로 설정

  // Initialize BLE
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setDeviceName("ECG_BT");
  BLE.setLocalName("ECG_BT");
  BLE.setAdvertisedService(ecgSensorService);

  ecgSensorService.addCharacteristic(ecgSensorCharacteristic);
  BLE.addService(ecgSensorService);

  ecgSensorCharacteristic.writeValue(0);

  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  // listen for BLE peripherals to connect
  BLEDevice central = BLE.central();

  // if a central is connected to peripheral:
  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());

    // while the central is still connected to peripheral:
    while (central.connected()) {
      int ecgValue = analogRead(ecgSensorPin); // 원시 신호 값을 읽음
      
      uint8_t scaledValue = map(ecgValue, 0, 1024, 0, 255); // 값을 0-255 범위로 스케일링

      // Update the characteristic value with scaled signal
      ecgSensorCharacteristic.writeValue(scaledValue);

      Serial.print("ECG Sensor Value: ");
      Serial.println(scaledValue);
      

      delay(16); // 60Hz 속도로 읽기 (1초에 60번 읽기 위해 1000ms / 120 ≈ 16ms)
    }

    // when the central disconnects, print it out:
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());

  }
}
