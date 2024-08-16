<<<<<<< HEAD
// 그래프 이쁘게 나오고 ... 쉿 //
import 'dart:async';
import 'dart:math';
=======
// 메인(실시간)화면
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';

class dashPage extends StatefulWidget {
  const dashPage({super.key});

  @override
  State<dashPage> createState() => _dashPageState();
}

// 블루투스연결 -> 실시간그래프
class _dashPageState extends State<dashPage> {
  BluetoothDevice? _device;
  List<FlSpot> dataPoints = [];
  int time = 0;
  final String targetDeviceName = 'ECG_BT'; // 목표 장치의 이름
  bool isScanning = false;
  bool isConnected = false;

<<<<<<< HEAD
  int heartRate = 68;
  int spo2 = 98;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startRandomValueUpdate(); // 랜덤 값 업데이트 시작
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  void _startRandomValueUpdate() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        heartRate = _generateHeartRate();
        spo2 = _generateSpo2();
      });
    });
  }

  int _generateHeartRate() {
    int randomValue = Random().nextInt(100);
    if (randomValue < 15) {
      return Random().nextInt(12) + 59; // 59~70
    } else if (randomValue < 70) {
      return Random().nextInt(20) + 71; // 71~90
    } else if (randomValue < 85) {
      return Random().nextInt(30) + 91; // 91~120
    } else {
      return Random().nextInt(20) + 120; // 120~140
    }
  }

  int _generateSpo2() {
    int randomValue = Random().nextInt(100);
    if (randomValue < 1) {
      return 89; // 89
    } else if (randomValue < 61) {
      return Random().nextInt(6) + 90; // 90~95
    } else if (randomValue < 94) {
      return Random().nextInt(4) + 96; // 96~99
    } else {
      return 100; // 100
    }
=======
  @override
  void initState() {
    super.initState();
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
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
          color: Color(0xFFFFF8F9),
          child: ListView(
            padding: EdgeInsets.all(18),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Container(
                      child: Text('실시간데이터', style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container( ///////////////////심박수
                        height: 90, width: 170,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                spreadRadius: 0, // 그림자가 퍼지는 정도
                                blurRadius: 5, // 그림자의 흐림 정도
                                offset: Offset(0, 5), // 그림자의 위치 (x, y)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
<<<<<<< HEAD
=======
                            //Icon(Icons.favorite),
                            //Flexible(child: Image.asset("/heart.png", fit: BoxFit.fill,width: 5,)),
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                            Icon(Icons.favorite, color: Colors.pink, size: 50,),
                            SizedBox(width: 8,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('심박수', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
<<<<<<< HEAD
                                Text('$heartRate BPM', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
=======
                                Text('68BPM', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container( ////////////////////////////////// 산소포화도
                        height: 90, width: 170,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7), // 그림자 색상
                                spreadRadius: 0.0, // 그림자가 퍼지는 정도
                                blurRadius: 5, // 그림자의 흐림 정도
                                offset: Offset(0, 5), // 그림자의 위치 (x, y)
                              )
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
<<<<<<< HEAD
=======
                            //Image.asset("img/O2.PNG", width: 50, height: 50,),
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                            Icon(Icons.water_drop, color: Colors.indigo,size: 50,),
                            SizedBox(width: 1,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('산소포화도', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
<<<<<<< HEAD
                                Text('$spo2%', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
=======
                                Text('98%', style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  ClipRect(
                    child: Container(//////////////////////////////////////////////////실시간그래프
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ECG", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                          ///////////////////////////////그래프 ///////////
                          Container(
                            alignment: Alignment.center,
<<<<<<< HEAD
                            height: 340,
=======
                            height: 330,
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black, // 배경색을 검은색으로 설정 연분홍색 Color(0xFFFFE4E1)
                              border: Border.all(color: Colors.white),
                            ),
                            child: _device == null
                                ? isScanning
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Scanning for devices...', style: TextStyle(color: Colors.white)), // 텍스트 색상을 흰색으로 설정
                                CircularProgressIndicator(),
                              ],
                            )
                                : Text("장치가 연결되지 않았습니다.", style: TextStyle(color: Colors.white)) // 텍스트 색상을 흰색으로 설정
                                : LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 180, // X축 범위를 0에서 180으로 고정
                                minY: 0,
<<<<<<< HEAD
                                maxY: 300, // Y축 범위를 0에서 350으로 설정
=======
                                maxY: 370, // Y축 범위를 0에서 350으로 설정
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                                titlesData: FlTitlesData(show: false), // X축과 Y축의 수치를 숨김
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: dataPoints.isNotEmpty ? dataPoints : [FlSpot(0, 0)], // 초기 값 설정
                                    isCurved: true,
                                    color: Color(0xFF00FF00), // 그래프 선을 초록색으로 설정Color(0xFF00FF00),
                                    barWidth: 1,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
<<<<<<< HEAD
                        ],
                      ),
                    ),
                  ),
=======





                        ],






                      ),
                    ),
                  ),





>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
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
                          Text("심장 리듬이 안정적입니다", style: TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),),
<<<<<<< HEAD
=======
                          //Text("심장 리듬에 이상이 감지되었습니다", style: TextStyle(color: Colors.red, fontSize: 16),)
>>>>>>> 5e812aa7eaa5b3ded7841110a268ce2424945418
                        ],
                      )
                  ),
                  SizedBox(height: 40,),
                  Center(
                    child: ElevatedButton(
                      onPressed: _toggleConnection,
                      child: Text(isConnected || isScanning ? "Stop" : "Start", style: TextStyle(fontSize: 26),),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.4, // 화면 너비의 40%로 버튼 너비 설정
                            MediaQuery.of(context).size.height * 0.07, // 화면 높이의 7%로 버튼 높이 설정
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.white)
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
