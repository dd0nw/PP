import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../dart2Page.dart';

class UserinfoSocial extends StatefulWidget {
  const UserinfoSocial({super.key});

  @override
  State<UserinfoSocial> createState() => _UserinfoSocialState();
}

enum Gender { man, woman }

class _UserinfoSocialState extends State<UserinfoSocial> {
  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  final birthCon = TextEditingController();
  final heightCon = TextEditingController();
  final weightCon = TextEditingController();

  Gender g = Gender.man;

  final String baseUrl = 'http://192.168.27.113:3000'; // Android 에뮬레이터 주소
  final storage = FlutterSecureStorage();

  Future<String?> getTokenFromSession() async {
    // 세션 스토리지에서 직접 토큰을 가져오는 메서드
    return await storage.read(key: 'jwtToken');
  }

  Future<bool> isTokenValid(String token) async {
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      print('Token decoding error: $e');
      return false;
    }
  }

  Future<void> _submitInfo() async {
    String? token = await getTokenFromSession();

    if (token == null || !(await isTokenValid(token))) {
      print('Error: Token is not valid or not found');
      return;
    }

    final headers = {'Authorization': 'Bearer $token'};
    final body = jsonEncode({
      'birth': birthCon.text,
      'height': heightCon.text,
      'weight': weightCon.text,
      'gender': g.toString().split('.').last
    });

    final response = await http.post(
      Uri.parse('$baseUrl/user/infoUpdateSocial'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('Submission successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  dashPage(), // SuccessPage 대신 Dash2Page로 이동
        ),
      );
    } else {
      print('Failed to submit data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          if (isLastStep) {
            _submitInfo();
          } else {
            setState(() => currentStep += 1);
          }
        },
        onStepCancel: () {
          if (isFirstStep) {
            Navigator.pop(context);
          } else {
            setState(() => currentStep -= 1);
          }
        },
        steps: steps(),
      ),
    );
  }

  List<Step> steps() => [
    Step(
      title: const Text('Personal Info'),
      content: Column(
        children: [
          TextFormField(
            controller: birthCon,
            decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
          ),
          TextFormField(
            controller: heightCon,
            decoration: const InputDecoration(labelText: 'Height (cm)'),
          ),
          TextFormField(
            controller: weightCon,
            decoration: const InputDecoration(labelText: 'Weight (kg)'),
          ),
          ListTile(
            title: const Text('Male'),
            leading: Radio(
              value: Gender.man,
              groupValue: g,
              onChanged: (Gender? value) {
                setState(() {
                  g = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Female'),
            leading: Radio(
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
    ),
  ];
}


