import 'package:flutter/material.dart';
//import 'package:email_validator/email_validator.dart'; // 이메일 유효성 검사 라이브러리

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  int _currentStep = 0;
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> userIdFormKey = GlobalKey<FormState>();

  Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'userId': TextEditingController(),
    'name': TextEditingController(),
    'birth': TextEditingController(),
  };

  Map<String, dynamic> userInputData = {
    'email': '',
    'password': '',
    'userId': '',
    'name': '',
    'birth': '',
    'gender': '',
  };

  Map<String, bool> validation = {
    'email': true,
    'userId': true,
  };

  Future<bool> emailValidCheck() async {
    await emailDuplicateCheck();
    return emailFormKey.currentState!.validate();
  }

  Future<void> emailDuplicateCheck() async {
    // 이미 이메일이 등록되어 있는지 확인하는 로직을 구현하세요.
    // 예를 들어, 서버에 요청을 보내서 이메일 중복 여부를 확인합니다.
    validation['email'] = true; // 예시로 true 설정
  }

  bool passwordValidCheck() {
    return passwordFormKey.currentState!.validate();
  }

  bool passwordValidDoubleCheck() {
    // 비밀번호 이중 확인 로직
    return true; // 예시로 true 설정
  }

  Future<bool> userIdValidCheck() async {
    await userIdDuplicateCheck();
    return userIdFormKey.currentState!.validate();
  }

  Future<void> userIdDuplicateCheck() async {
    // 유저 아이디 중복 체크 로직을 구현하세요.
    validation['userId'] = true; // 예시로 true 설정
  }

  bool nameValidCheck() {
    return controllers['name']!.text.isNotEmpty;
  }

  bool birthValidCheck() {
    return controllers['birth']!.text.isNotEmpty;
  }

  bool genderValidCheck() {
    return userInputData['gender'].isNotEmpty;
  }

  List<Step> stepList() => [
    Step(
      title: const Text('이메일'),
      content: Form(
        key: emailFormKey,
        child: TextFormField(
          controller: controllers['email'],
          decoration: const InputDecoration(
            hintText: "이메일을 입력해주세요 :)",
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => userInputData['email'] = value,
          validator: (value) {
            // if (value == null || value.isEmpty) {
            //   return '이메일은 반드시 입력 해야 합니다!';
            // }
            // if (){//!EmailValidator.validate(value)) {
            //   return '유효한 이메일을 입력해 주세요!';
            // }
            // if (!validation['email']!) {
            //   return '이미 등록된 이메일 입니다!';
            // }
            // return null;
          },
        ),
      ),
      isActive: _currentStep >= 0,
    ),
    Step(
      title: const Text('비밀번호'),
      content: Form(
        key: passwordFormKey,
        child: TextFormField(
          controller: controllers['password'],
          decoration: const InputDecoration(
            hintText: "비밀번호를 입력해주세요",
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호는 반드시 입력해야 합니다!';
            }
            if (value.length < 6) {
              return '비밀번호는 최소 6자 이상이어야 합니다!';
            }
            return null;
          },
        ),
      ),
      isActive: _currentStep >= 1,
    ),
    Step(
      title: const Text('개인정보'),
      content: Form(
        key: userIdFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: controllers['userId'],
              decoration: const InputDecoration(
                hintText: "사용자 아이디를 입력해주세요",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '아이디는 반드시 입력해야 합니다!';
                }
                if (!validation['userId']!) {
                  return '이미 사용 중인 아이디입니다!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllers['name'],
              decoration: const InputDecoration(
                hintText: "이름을 입력해주세요",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름은 반드시 입력해야 합니다!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: controllers['birth'],
              decoration: const InputDecoration(
                hintText: "생년월일을 입력해주세요",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '생년월일은 반드시 입력해야 합니다!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stepper(
        steps: stepList(),
        type: StepperType.vertical,
        elevation: 0,
        currentStep: _currentStep,
        onStepTapped: (int index) {
          setState(() {
            _currentStep = index;
          });
        },
        onStepContinue: () {
          switch (_currentStep) {
            case 0:
              emailValidCheck().then((value) {
                if (value) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              });
              break;
            case 1:
              if (passwordValidCheck()) {
                if (passwordValidDoubleCheck()) {
                  userInputData['password'] = controllers['password']!.text;
                  setState(() {
                    _currentStep += 1;
                  });
                }
              }
              break;
            case 2:
              userIdValidCheck().then((value) {
                if (value) {
                  userInputData['userId'] = controllers['userId']!.text;
                  if (nameValidCheck() &&
                      birthValidCheck() &&
                      genderValidCheck()) {
                    // 여기서 유저 등록 로직 실행
                    print("회원가입 완료: $userInputData");
                    // 회원가입 후 다음 화면으로 이동하는 로직 추가
                  }
                }
              });
              break;
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
      ),
    );
  }
}
