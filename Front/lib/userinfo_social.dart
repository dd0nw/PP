import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonEncode
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  bool isComplete = false;
  bool _isVerified = false;

  final String baseUrl = 'http://10.0.2.2:3000';
  final storage = FlutterSecureStorage();

  /////////////////////토큰/////////////////////////////////////
  Future<String> getToken() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/get-token'));
      print('Server response: ${response.body}'); // 서버 응답을 출력하여 디버깅
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        if (token == null || token.isEmpty) {
          throw Exception('Token not found');
        }
        await saveToken(token);
        print('Token fetched and saved: $token');
        return token;
      } else {
        print('Failed to get token with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load token');
      }
    } catch (e) {
      print('Error occurred while fetching token: $e');
      throw e;
    }
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
  }

  Future<bool> isTokenValid(String token) async {
    try {
      // 디코딩하여 토큰의 만료 시간을 확인
      final decodedToken = JwtDecoder.decode(token);
      final isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        print('Token is expired');
        return false;
      }

      print('Token is valid. Payload: $decodedToken');
      return true;
    } catch (e) {
      print('Failed to decode token: $e');
      return false;
    }
  }

  Future<void> _submitInfo() async {
    String? token = await storage.read(key: 'jwtToken');

    // 토큰이 없거나 유효하지 않으면 새로운 토큰을 요청
    if (token == null || !(await isTokenValid(token))) {
      print('Token not found or invalid, fetching new token');
      token = await getToken();
    } else {
      print('Token found and valid: $token');
    }

    final String apiUrl = '$baseUrl/user/infoUpdateSocial';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // JWT 토큰을 헤더에 추가
        },
        body: jsonEncode({
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
                width: 160,
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
          Text("성별을 선택해주세요"),
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
          Row(
            children: [
              Container(
                width: 120,
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.height),
                      hintStyle: TextStyle(fontSize: 15),
                      hintText:  "ex)163",
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      suffixText: "cm"
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
          Row(
            children: [
              Container(
                width: 120,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                    hintStyle: TextStyle(fontSize: 15),
                    hintText:  "ex) 50",
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    suffixText: "kg", // TextFormField 끝에 "kg" 추가
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
