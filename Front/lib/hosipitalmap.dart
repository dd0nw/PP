import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';

class Hosipitalmap extends StatefulWidget {
  const Hosipitalmap({super.key});

  // 위치 정보에 대한 기능을 수행하는 메소드
  // void geoLocation() async{
  //   await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(position);
  //
  // }

  @override
  State<Hosipitalmap> createState() => _HosipitalmapState();
}

class _HosipitalmapState extends State<Hosipitalmap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: ElevatedButton(onPressed: (){

      }, child: Text('내위치')),
      ),
    );
  }
}
