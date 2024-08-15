import 'package:flutter/material.dart';

class userBirth extends StatefulWidget {
  const userBirth({super.key});

  @override
  State<userBirth> createState() => _userBirthState();
}

class _userBirthState extends State<userBirth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("기본 정보 설정",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black
                    ),
                    child: Center(
                      child: Text("1",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15),),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                    ),
                    child: Center(
                      child: Text("2",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15),),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                    ),
                    child: Center(
                      child: Text("3",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text("생년월일을", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              Text("선택해주세요.", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)

            ],
          ),
        ),
      ),
    );
  }
}
