import 'package:flutter/material.dart';

class Ecgchart extends StatefulWidget {
  const Ecgchart({super.key});

  @override
  State<Ecgchart> createState() => _EcgchartState();
}

class _EcgchartState extends State<Ecgchart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text("ECG그래프나오는화면"),
      ),
    );
  }
}

