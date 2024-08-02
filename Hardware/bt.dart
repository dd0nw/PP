import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothGraphPage extends StatefulWidget {
  @override
  _BluetoothGraphPageState createState() => _BluetoothGraphPageState();
}

class _BluetoothGraphPageState extends State<BluetoothGraphPage> {
  BluetoothDevice? _device;
  List<FlSpot> dataPoints = [];
  int time = 0;
  final String targetDeviceName = 'ECG_BT'; // 목표 장치의 이름

  @override
  void initState() {
    super.initState();
    _requestPermissions();
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
    print("Starting Bluetooth scan...");
    FlutterBluePlus.startScan(timeout: Duration(seconds: 30)); // 정적 메서드 호출

    FlutterBluePlus.scanResults.listen((results) {
      print("Scan results received");
      if (results.isEmpty) {
        print("No devices found.");
      } else {
        for (ScanResult r in results) {
          print("Found device: ${r.device.name} with address: ${r.device.id}");
          if (r.device.name == targetDeviceName) { // 장치 이름을 확인
            print("Found target device: ${r.device.name}");
            _connect(r.device);
            FlutterBluePlus.stopScan(); // 정적 메서드 호출
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
      });
      _discoverServices(device);
    } catch (e) {
      print("Failed to connect: $e");
      // 재시도 로직 추가
      Future.delayed(Duration(seconds: 5), () {
        _connect(device);
      });
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
    // Convert List<int> to integer value
    return value.isNotEmpty ? value[0] : 0; // 간단히 첫 번째 바이트를 사용
  }

  void _addDataPoint(int data) {
    setState(() {
      dataPoints.add(FlSpot(time.toDouble(), data.toDouble()));
      time++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Graph'),
      ),
      body: Center(
        child: _device == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scanning for devices...'),
            CircularProgressIndicator(),
          ],
        )
            : LineChart(
          LineChartData(
            minX: 0,
            maxX: time.toDouble() > 20 ? time.toDouble() : 20,
            minY: 0,
            maxY: 1024, // 조도 센서 값의 최대 범위
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints.isNotEmpty ? dataPoints : [FlSpot(0, 0)], // 초기 값 설정
                isCurved: true,
                color: Colors.blue, // colors를 color로 수정
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BluetoothGraphPage(),
  ));
}
