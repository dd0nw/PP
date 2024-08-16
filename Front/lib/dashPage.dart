//ecg ppg같이 시도했으나 ecg, ppg 각각 하나씩만 받아올 수 있는 화면;;
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';

class DashPage extends StatefulWidget {
   const DashPage({super.key});

   @override
   State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
   // ECG 관련 변수
   BluetoothDevice? _ecgDevice;
   List<FlSpot> ecgDataPoints = [];
   bool isEcgConnected = false;
   bool isEcgScanning = false;
   int time = 0;

   // PPG 관련 변수
   BluetoothDevice? _ppgDevice;
   bool isPpgConnected = false;
   bool isPpgScanning = false;
   double? _currentHeartRate; // 심박수 값을 위한 단일 변수
   double? _currentSpO2; // 산소포화도 값을 위한 단일 변수

   // 장치 이름 및 UUID
   final String ecgDeviceName = 'ECG_BT'; // ECG 장치 이름
   final String ppgDeviceName = 'PPG_BT'; // PPG 장치 이름

   final String ecgServiceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b'; // ECG 장치의 서비스 UUID
   final String ecgCharacteristicUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26a8'; // ECG 특성 UUID

   final String ppgServiceUUID = 'd9f7d2f4-0914-42c8-b238-e12ec8850d8d'; // PPG 장치의 서비스 UUID
   final String heartRateCharacteristicUUID = 'ee09d1ef-6a75-4f58-bd29-d98b70cbb5a2'; // 심박수 특성 UUID
   final String spo2CharacteristicUUID = 'b4b11c42-07b5-47b3-b6a0-6d5cb8c3d6e8'; // 산소포화도 특성 UUID


   @override
   void initState() {
      super.initState();
      _requestPermissions(); // 초기화 시 권한 요청 한 번만 실행
   }

   // 권한 요청을 한 번만 수행
   void _requestPermissions() async {
      Map<Permission, PermissionStatus> statuses = await [
         Permission.bluetooth,
         Permission.bluetoothScan,
         Permission.bluetoothConnect,
         Permission.location,
      ].request();

      if (!(statuses[Permission.bluetooth]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted &&
          statuses[Permission.location]!.isGranted)) {
         print("Permissions not granted. Bluetooth functionalities may not work.");
      }
   }

   // ECG 장치 스캔 시작
   void _startEcgScan() async {
      setState(() {
         isEcgScanning = true;
      });

      FlutterBluePlus.startScan(); // 타임아웃 없이 스캔 지속

      FlutterBluePlus.scanResults.listen((results) {
         for (ScanResult r in results) {
            if (r.device.name == ecgDeviceName && !isEcgConnected) {
               _connectEcgDevice(r.device);
               break; // 장치 연결 후 스캔 중단
            }
         }
      });
   }

   // ECG 장치 연결
   void _connectEcgDevice(BluetoothDevice device) async {
      try {
         await device.connect(autoConnect: false);
         setState(() {
            _ecgDevice = device;
            isEcgConnected = true;
            isEcgScanning = false;
            FlutterBluePlus.stopScan(); // 장치 연결 후 스캔 중단
         });
         _discoverEcgServices(device);
      } catch (e) {
         print("Failed to connect to ECG device: $e");
      }
   }

   // ECG 장치의 서비스 발견 및 데이터 수신
   void _discoverEcgServices(BluetoothDevice device) async {
      try {
         List<BluetoothService> services = await device.discoverServices();
         for (BluetoothService service in services) {
            if (service.uuid.toString() == ecgServiceUUID) {
               for (BluetoothCharacteristic characteristic in service.characteristics) {
                  if (characteristic.uuid.toString() == ecgCharacteristicUUID && characteristic.properties.notify) {
                     characteristic.value.listen((value) {
                        int data = _convertData(value);
                        _addEcgDataPoint(data);
                     });
                     await characteristic.setNotifyValue(true);
                     print("Notification set for ECG characteristic: ${characteristic.uuid}");
                  }
               }
            }
         }
      } catch (e) {
         print("Failed to discover ECG services: $e");
      }
   }

   // ECG 데이터 포인트 추가
   void _addEcgDataPoint(int data) {
      setState(() {
         if (ecgDataPoints.length >= 180) {
            ecgDataPoints.removeAt(0);
         }

         ecgDataPoints.add(FlSpot(time.toDouble(), data.toDouble()));

         for (int i = 0; i < ecgDataPoints.length; i++) {
            ecgDataPoints[i] = FlSpot(i.toDouble(), ecgDataPoints[i].y);
         }
         time++;
      });
   }

   // ECG 장치 연결 해제
   void _disconnectEcg() async {
      if (_ecgDevice != null) {
         try {
            await _ecgDevice!.disconnect();
            setState(() {
               _ecgDevice = null;
               isEcgConnected = false;
            });
            print("ECG device disconnected.");
         } catch (e) {
            print("Failed to disconnect ECG device: $e");
         }
      }
   }

   // ECG 연결 토글
   void _toggleEcgConnection() {
      if (isEcgConnected || isEcgScanning) {
         _disconnectEcg();
      } else {
         _startEcgScan();
      }
   }

   // PPG 장치 스캔 시작
   void _startPpgScan() async {
      setState(() {
         isPpgScanning = true;
      });

      FlutterBluePlus.startScan(); // 타임아웃 없이 스캔 지속

      FlutterBluePlus.scanResults.listen((results) {
         for (ScanResult r in results) {
            if (r.device.name == ppgDeviceName && !isPpgConnected) {
               _connectPpgDevice(r.device);
               break; // 장치 연결 후 스캔 중단
            }
         }
      });
   }

   // PPG 장치 연결
   void _connectPpgDevice(BluetoothDevice device) async {
      try {
         await device.connect(autoConnect: false);
         setState(() {
            _ppgDevice = device;
            isPpgConnected = true;
            isPpgScanning = false;
            FlutterBluePlus.stopScan(); // 장치 연결 후 스캔 중단
         });
         _discoverPpgServices(device);
      } catch (e) {
         print("Failed to connect to PPG device: $e");
      }
   }

   // PPG 장치의 서비스 발견 및 데이터 수신
   void _discoverPpgServices(BluetoothDevice device) async {
      try {
         List<BluetoothService> services = await device.discoverServices();
         for (BluetoothService service in services) {
            if (service.uuid.toString() == ppgServiceUUID) {
               for (BluetoothCharacteristic characteristic in service.characteristics) {
                  if (characteristic.uuid.toString() == heartRateCharacteristicUUID && characteristic.properties.notify) {
                     characteristic.value.listen((value) {
                        int data = _convertData(value);
                        setState(() {
                           _currentHeartRate = data.toDouble(); // 심박수 값을 최신 값으로 갱신
                        });
                     });
                     await characteristic.setNotifyValue(true);
                     print("Notification set for Heart Rate characteristic: ${characteristic.uuid}");
                  } else if (characteristic.uuid.toString() == spo2CharacteristicUUID && characteristic.properties.notify) {
                     characteristic.value.listen((value) {
                        int data = _convertData(value);
                        setState(() {
                           _currentSpO2 = data.toDouble(); // 산소포화도 값을 최신 값으로 갱신
                        });
                     });
                     await characteristic.setNotifyValue(true);
                     print("Notification set for SpO2 characteristic: ${characteristic.uuid}");
                  }
               }
            }
         }
      } catch (e) {
         print("Failed to discover PPG services: $e");
      }
   }

   // 데이터 변환
   int _convertData(List<int> value) {
      return value.isNotEmpty ? value[0] : 0;
   }

   // PPG 장치 연결 해제
   void _disconnectPpg() async {
      if (_ppgDevice != null) {
         try {
            await _ppgDevice!.disconnect();
            setState(() {
               _ppgDevice = null;
               isPpgConnected = false;
            });
            print("PPG device disconnected.");
         } catch (e) {
            print("Failed to disconnect PPG device: $e");
         }
      }
   }

   // PPG 연결 토글
   void _togglePpgConnection() {
      if (isPpgConnected || isPpgScanning) {
         _disconnectPpg();
      } else {
         _startPpgScan();
      }
   }

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         body: SafeArea(
            child: Container(
               color: Color(0xFFFFF8F9),
               child: ListView(
                  padding: EdgeInsets.all(18),
                  children: [
                     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(height: 15,),
                           Container(
                              child: Text('실시간데이터', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                           ),
                           SizedBox(height: 13,),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                 Container(
                                    height: 80, width: 140,
                                    decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.black12),
                                       borderRadius: BorderRadius.circular(15),
                                       boxShadow: [
                                          BoxShadow(
                                             color: Colors.grey.withOpacity(0.5),
                                             spreadRadius: 0,
                                             blurRadius: 5,
                                             offset: Offset(0, 5),
                                          ),
                                       ],
                                    ),
                                    child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                          Icon(Icons.favorite, color: Colors.pink, size: 40,),
                                          SizedBox(width: 1,),
                                          Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                                Text('심박수', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                                Text('${_currentHeartRate?.toStringAsFixed(0) ?? "--"} BPM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                             ],
                                          ),
                                       ],
                                    ),
                                 ),
                                 Container(
                                    height: 80, width: 150,
                                    decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.black12),
                                       borderRadius: BorderRadius.circular(15),
                                       boxShadow: [
                                          BoxShadow(
                                             color: Colors.grey.withOpacity(0.7),
                                             spreadRadius: 0.0,
                                             blurRadius: 5,
                                             offset: Offset(0, 5),
                                          ),
                                       ],
                                    ),
                                    child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                          Icon(Icons.water_drop, color: Colors.indigo, size: 40,),
                                          SizedBox(width: 1,),
                                          Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                                Text('산소포화도', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                                Text('${_currentSpO2?.toStringAsFixed(0) ?? "--"}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                             ],
                                          ),
                                       ],
                                    ),
                                 ),
                              ],
                           ),
                           SizedBox(height: 20,),
                           ClipRect(
                              child: Container(
                                 child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text("ECG", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                       Container(
                                          alignment: Alignment.center,
                                          height: 300,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                             color: Colors.black,
                                             border: Border.all(color: Colors.white),
                                          ),
                                          child: _ecgDevice == null
                                              ? isEcgScanning
                                              ? Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                                Text('Scanning for devices...', style: TextStyle(color: Colors.white)),
                                                CircularProgressIndicator(),
                                             ],
                                          )
                                              : Text("ECG 장치가 연결되지 않았습니다.", style: TextStyle(color: Colors.white))
                                              : LineChart(
                                             LineChartData(
                                                minX: 0,
                                                maxX: 180,
                                                minY: 0,
                                                maxY: 350, // 511까지 커버할 수 있도록 조정
                                                titlesData: FlTitlesData(show: false),
                                                lineBarsData: [
                                                   LineChartBarData(
                                                      spots: ecgDataPoints.isNotEmpty ? ecgDataPoints : [FlSpot(0, 0)],
                                                      isCurved: true,
                                                      color: Color(0xFF00FF00),
                                                      barWidth: 2,
                                                      isStrokeCapRound: true,
                                                      dotData: FlDotData(show: false),
                                                      belowBarData: BarAreaData(show: false),
                                                   ),
                                                ],
                                             ),
                                          ),
                                       ),
                                    ],
                                 ),
                              ),
                           ),
                           SizedBox(height: 15,),
                           Center(
                              child: ElevatedButton(
                                 onPressed: _toggleEcgConnection,
                                 child: Text(isEcgConnected || isEcgScanning ? "ECG Stop" : "ECG Start", style: TextStyle(fontSize: 20)),
                                 style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                       MediaQuery.of(context).size.width * 0.4,
                                       MediaQuery.of(context).size.height * 0.07,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(15),
                                       side: BorderSide(color: Colors.white),
                                    ),
                                 ),
                              ),
                           ),
                           SizedBox(height: 80,),
                           Center(
                              child: ElevatedButton(
                                 onPressed: _togglePpgConnection,
                                 child: Text(isPpgConnected || isPpgScanning ? "PPG Stop" : "PPG Start", style: TextStyle(fontSize: 20)),
                                 style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                       MediaQuery.of(context).size.width * 0.4,
                                       MediaQuery.of(context).size.height * 0.07,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(15),
                                       side: BorderSide(color: Colors.white),
                                    ),
                                 ),
                              ),
                           ),
                        ],
                     ),
                  ],
               ),
            ),
         ),
      );
   }
}
