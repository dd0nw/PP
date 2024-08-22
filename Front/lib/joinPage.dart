//회원가입페이지
import 'package:flutter/material.dart';
import 'package:front/userinfo/userinfo_birth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  final emailCon = TextEditingController();
  final authnumCon = TextEditingController();
  final pwCon = TextEditingController();
  final pwConfirmCon = TextEditingController(); // 비밀번호 확인 필드
  final nameCon = TextEditingController();

  bool isComplete = false;
  bool _isVerified = false;

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  //////////////////////////////이메일/////////////////////
  Future<void> _checkId() async {
    final String email = emailCon.text;

    print("요청보낸이메일: $email");

    final response = await http.post(
      //Uri.parse('http://10.0.2.2:3000/user/checkId'),
      Uri.parse('http://192.168.219.228:3000/user/checkId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    // print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('response.body: $data');
        final message = data['message'] ?? '알 수 없는 오류';
        final emailResponse = data['response'] ?? '';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        print("서버 응답: $emailResponse");

      } catch (e) {
        print("응답 처리 오류: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('응답 처리 중 오류 발생')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 존재하는 이메일 입니다.')),
      );
    }
  }

  Future<void> _verifyCode() async {
    final String code = authnumCon.text;
    final String email = emailCon.text;

    final response = await http.post(
      //Uri.parse('http://10.0.2.2:3000/user/verifyCode'),
      Uri.parse('http://192.168.219.228:3000/user/verifyCode'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증이 완료되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증에 실패하였습니다.')),
      );
    }
  }

  Future<void> _register() async {
    if (!_isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증이 완료되지 않았습니다.')),
      );
      return;
    }

    final String email = emailCon.text;
    final String pw = pwCon.text;
    final String name = nameCon.text;

    if (!_isPasswordValid(pw)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호는 8자리 이상이어야 합니다.')),
      );
      return;
    }

    final response = await http.post(
      //Uri.parse('http://10.0.2.2:3000/user/register'),
      Uri.parse('http://192.168.27.113/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': email,
        'pw': pw,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['auth'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입이 완료되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패하였습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 요청이 실패하였습니다.')),
      );
    }
  }


  void _onStepContinue() {
    if (isLastStep) {
      if (!_isVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증이 완료되지 않았습니다.')),
        );
        return;
      }
      final String email = emailCon.text;
      final String pw = pwCon.text;
      final String name = nameCon.text;

      _register().then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(
              email: email,
              password: pw,
              name: name,
            ),
          ),
        );
      });
    } else {
      if (currentStep == 1) {
        final pw = pwCon.text;
        final pwConfirm = pwConfirmCon.text;
        if (pw != pwConfirm) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
          );
        } else if (!_isPasswordValid(pw)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호는 8자리 이상이어야 합니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호가 일치합니다.')),
          );
          setState(() => currentStep += 1);
        }
      } else {
        setState(() => currentStep += 1);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          //title: Text('회원가입', style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("  회원가입", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
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
                        _onStepContinue();
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
                                child: Text('취소'),
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
      title: const Text('이메일',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("회원 정보 조회시 사용됩니다",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "이메일을 입력해주세요",
                    hintStyle: TextStyle(fontSize: 14),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailCon,
                ),
              ),
              SizedBox(width: 0),
              ElevatedButton(
                onPressed: () {
                  _checkId();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(45, 36),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    textStyle: TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black12)
                    )
                ),
                child: Text('중복확인', style: TextStyle(color: Colors.pink),),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "인증번호를 입력해주세요",
                    hintStyle: TextStyle(fontSize: 14),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  controller: authnumCon,
                ),
              ),
              //SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _verifyCode();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(50, 36),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    textStyle: TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black12)
                    )
                ),
                child: Text('인증확인', style: TextStyle(color: Colors.pink),),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('비밀번호',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("최소 8자리를 입력하세요",style: TextStyle(fontSize: 17),),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "비밀번호를 입력해주세요 :)",
              hintStyle: TextStyle(fontSize: 14),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: pwCon,
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "비밀번호를 다시한번 입력해주세요",
              hintStyle: TextStyle(fontSize: 14),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: pwConfirmCon,
          ),
        ],
      ),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('이름',style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20),),
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: "사용자 이름을 입력해주세요 :)",
              hintStyle: TextStyle(fontSize: 14),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: nameCon,
          ),
        ],
      ),
    ),
  ];
}
