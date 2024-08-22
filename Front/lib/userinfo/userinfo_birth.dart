// 추가입력정보

import 'package:flutter/material.dart';
import 'package:front/sensor/sensorattach.dart';
import 'package:front/sensor/sensorinfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bottomPage.dart';
import '../dart2Page.dart';
import '../ex01_login.dart'; // for jsonEncode

class UserInfoPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;

  const UserInfoPage({super.key, required this.email, required this.password, required this.name,});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

enum Gender { man, woman }

class _UserInfoPageState extends State<UserInfoPage> {
  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  final birthCon = TextEditingController();
  final heightCon = TextEditingController();
  final weightCon = TextEditingController();

  Gender g = Gender.man;

  bool isComplete = false;
  bool _isVerified = false;

  Future<void> _submitInfo() async {
    //final String apiUrl = 'http://10.0.2.2:3000/user/infoUpdatePP';
    final String apiUrl = 'http://192.168.27.113:3000/user/infoUpdatePP';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': widget.email,
          'password': widget.password,
          'name': widget.name,
          'birthdate': birthCon.text,
          'gender': g.toString().split('.').last,
          'height': heightCon.text,
          'weight': weightCon.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // 성공적으로 정보가 업데이트됨
        print('정보 업데이트 성공');
        setState(() {
          isComplete = true;
        });
        // Snackbar 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('추가입력정보에 성공하였습니다'),
            duration: Duration(seconds: 2), // Snackbar가 표시되는 시간
          ),
        );

        // 첫페이지로 이동
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),);
      } else {
        // 오류 발생
        print('정보 업데이트 실패');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('정보 업데이트 실패'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('예외 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('예외 발생: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green, // 기본 색상을 파란색으로 설정
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 34.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  추가입력정보", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  SizedBox(height: 15,),
                  Theme(
                    data: ThemeData(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Colors.pink,
                      ),
                    ),
                    child: Stepper(
                      steps: steps(),
                      type: StepperType.vertical,
                      elevation: 0,
                      currentStep: currentStep,
                      onStepContinue: () {
                        if (isFirstStep) {
                          if (birthCon.text.length != 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('생년월일을 8자리로 입력해주세요.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }
                        }

                        if (isLastStep) {
                          _submitInfo(); // 마지막 단계에서 정보 전송
                        } else {
                          setState(() => currentStep += 1);
                        }
                      },
                      onStepCancel: isFirstStep ? null : () => setState(() => currentStep -= 1),
                      onStepTapped: (step) => setState(() => currentStep = step),
                      controlsBuilder: (context, details) => Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: Text(isLastStep ? '확인' : '다음'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isFirstStep ? null : details.onStepCancel,
                                child: const Text('취소'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.pink
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Step> steps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text('생년월일',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("생년월일 8자리를 입력해주세요",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    hintText: "ex)19860203",
                    hintStyle: TextStyle(fontSize: 15),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: birthCon,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('성별',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("성별을 선택해주세요",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RadioListTile<Gender>(
                  title: Text('남성'),
                  value: Gender.man,
                  groupValue: g,
                  onChanged: (Gender? value) {
                    setState(() {
                      g = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<Gender>(
                  title: Text('여성'),
                  value: Gender.woman,
                  groupValue: g,
                  onChanged: (Gender? value) {
                    setState(() {
                      g = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('키',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("키(cm)를 입력해주세요",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 120,
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.height),
                      hintStyle: TextStyle(fontSize: 15),
                      hintText: "ex)163",
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    suffixText: "cm",
                  ),
                  keyboardType: TextInputType.number,
                  controller: heightCon,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 3 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 3,
      title: const Text('몸무게',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("몸무게(kg)를 입력해주세요",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 120,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                    hintStyle: TextStyle(fontSize: 15),
                    hintText: "ex) 50",
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color : Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    suffixText: "kg",
                  ),
                  keyboardType: TextInputType.number,
                  controller: weightCon,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}
