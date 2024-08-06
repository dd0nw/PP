#include <ArduinoBLE.h>

const int lightSensorPin = 36; // 조도 센서가 연결된 핀
BLEService lightSensorService("4fafc201-1fb5-459e-8fcc-c5c9c331914b"); // 서비스 UUID
BLEIntCharacteristic lightSensorCharacteristic("beb5483e-36e1-4688-b7f5-ea07361b26a8", BLERead | BLENotify); // 특성 UUID

void setup() {
  Serial.begin(115200);
  while (!Serial);

  pinMode(lightSensorPin, INPUT);

  // Initialize BLE
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setDeviceName("ECG_BT");
  BLE.setLocalName("ECG_BT");
  BLE.setAdvertisedService(lightSensorService);

  lightSensorService.addCharacteristic(lightSensorCharacteristic);
  BLE.addService(lightSensorService);

  lightSensorCharacteristic.writeValue(0);

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
      int lightSensorValue = analogRead(lightSensorPin);

      // Update the characteristic value
      lightSensorCharacteristic.writeValue(lightSensorValue);

      Serial.print("Light Sensor Value: ");
      Serial.println(lightSensorValue);

      delay(16); // 1초마다 60hz속도로 데이터 전송
    }

    // when the central disconnects, print it out:
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}
