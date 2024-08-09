import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';

class dashPage extends StatefulWidget {
  const dashPage({super.key});

  @override
  State<dashPage> createState() => _dashPageState();
}

class _dashPageState extends State<dashPage> {
  BluetoothDevice? _device;
  List<FlSpot> dataPoints = [];
  int time = 0;
  final String targetDeviceName = 'ECG_BT'; // 목표 장치의 이름
  bool isScanning = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
  }

  void _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location
    ].request();

    if (statuses[Permission.bluetooth]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.bluetoothAdvertise]!.isGranted &&
        statuses[Permission.location]!.isGranted) {
      _startScan();
    } else {
      print("Permissions not granted. Cannot start Bluetooth scan.");
    }
  }

  void _startScan() {
    setState(() {
      isScanning = true;
    });

    print("Starting Bluetooth scan...");
    FlutterBluePlus.startScan(timeout: Duration(seconds: 30));

    FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received");
      if (results.isEmpty) {
        print("No devices found.");
      } else {
        for (ScanResult r in results) {
          print("Found device: ${r.device.name} with address: ${r.device.id}");
          if (r.device.name == targetDeviceName) {
            print("Found target device: ${r.device.name}");
            _connect(r.device);
            FlutterBluePlus.stopScan();
            break;
          }
        }
      }
    });
  }

  void _connect(BluetoothDevice device) async {
    print("Connecting to device...");
    try {
      await device.connect();
      print("Connected to device.");
      setState(() {
        _device = device;
        isConnected = true;
        isScanning = false;
      });
      _discoverServices(device);
    } catch (e) {
      print("Failed to connect: $e");
      Future.delayed(Duration(seconds: 5), () {
        _connect(device);
      });
    }
  }

  void _disconnect() async {
    if (_device != null) {
      await _device!.disconnect();
      setState(() {
        _device = null;
        isConnected = false;
        isScanning = false;
      });
      print("Disconnected from device.");
    }
  }

  void _discoverServices(BluetoothDevice device) async {
    print("Discovering services...");
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            characteristic.value.listen((value) {
              int data = _convertData(value);
              _addDataPoint(data);
            });
            await characteristic.setNotifyValue(true);
            print("Notification set for characteristic: ${characteristic.uuid}");
          }
        }
      }
    } catch (e) {
      print("Failed to discover services: $e");
    }
  }

  int _convertData(List<int> value) {
    return value.isNotEmpty ? value[0] : 0;
  }

  void _addDataPoint(int data) {
    setState(() {
      if (dataPoints.length >= 180) {
        dataPoints.removeAt(0);
      }

      dataPoints.add(FlSpot(time.toDouble(), data.toDouble()));

      for (int i = 0; i < dataPoints.length; i++) {
        dataPoints[i] = FlSpot(i.toDouble(), dataPoints[i].y);
      }
      time++;
    });
  }

  void _toggleConnection() {
    if (isConnected || isScanning) {
      _disconnect();
    } else {
      _requestPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Container(
                      child: Text('실시간데이터', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: 13,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container( ////////////////////////////////////////////////// 심박수
                        height: 80, width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                spreadRadius: 5, // 그림자가 퍼지는 정도
                                blurRadius: 7, // 그림자의 흐림 정도
                                offset: Offset(0, 3), // 그림자의 위치 (x, y)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('심박수', style: TextStyle(fontSize: 20),),
                                Text('68BPM', style: TextStyle(fontSize: 20),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container( /////////////////////////////////////////////////// 산소포화도
                        height: 80, width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7), // 그림자 색상
                                spreadRadius: 0.0, // 그림자가 퍼지는 정도
                                blurRadius: 5, // 그림자의 흐림 정도
                                offset: Offset(0, 10), // 그림자의 위치 (x, y)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('산소포화도', style: TextStyle(fontSize: 20),),
                                Text('98%', style: TextStyle(fontSize: 20),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(//////////////////////////////////////////////////실시간그래프
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ECG", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Container(
                          alignment: Alignment.center,
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                          ),
                          child: _device == null
                              ? isScanning
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Scanning for devices...'),
                              CircularProgressIndicator(),
                            ],
                          )
                              : Text("장치가 연결되지 않았습니다.")
                              : LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 180, // X축 범위를 0에서 180으로 고정
                              minY: 0,
                              maxY: 350, // Y축 범위를 0에서 350으로 설정
                              titlesData: FlTitlesData(show: false), // X축과 Y축의 수치를 숨김
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints.isNotEmpty ? dataPoints : [FlSpot(0, 0)], // 초기 값 설정
                                  isCurved: true,
                                  color: Colors.black,
                                  barWidth: 1,
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
                  SizedBox(height: 15,),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text("심장 리듬이 안정적입니다", style: TextStyle(color: Colors.green, fontSize: 15),),
                          //Text("심장 리듬에 이상이 감지되었습니다", style: TextStyle(color: Colors.red, fontSize: 16),)
                        ],
                      )
                  ),
                  SizedBox(height: 80,),
                  Center(
                    child: ElevatedButton(
                      onPressed: _toggleConnection,
                      child: Text(isConnected || isScanning ? "Stop" : "Start", style: TextStyle(fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200,50),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.grey)
                          )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
