import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('실시간 데이터'),
          actions: [
            Icon(Icons.notifications),
            Icon(Icons.notifications_none),
          ],
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DataCard(
                icon: Icons.favorite,
                value: '68 BPM',
                label: '심박수',
              ),
              DataCard(
                icon: Icons.opacity,
                value: '98%',
                label: '산소포화도',
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            height: 100,
            color: Colors.black12,
            child: Center(
              child: Text('ECG Graph'),
            ),
          ),
          SizedBox(height: 16.0),
          DateSelector(),
          SizedBox(height: 16.0),
          RecordList(),
        ],
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  DataCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 50),
        Text(value, style: TextStyle(fontSize: 20)),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class DateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.arrow_back),
        Text('7.25(목)'),
        Icon(Icons.arrow_forward),
      ],
    );
  }
}

class RecordList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecordItem(
          color: Colors.red,
          title: '심방세동',
          time: '오후 8:47',
        ),
        RecordItem(
          color: Colors.pink,
          title: '심실빈맥',
          time: '오후 8:47',
        ),
        RecordItem(
          color: Colors.black,
          title: '서맥',
          time: '오후 8:47',
        ),
      ],
    );
  }
}

class RecordItem extends StatelessWidget {
  final Color color;
  final String title;
  final String time;

  RecordItem({required this.color, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.2),
      child: ListTile(
        leading: Icon(Icons.favorite, color: color),
        title: Text(title),
        trailing: Text(time),
        onTap: () {
          // Implement navigation to details page
        },
      ),
    );
  }
}
