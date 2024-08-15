import 'package:flutter/material.dart';

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
  final nameCon = TextEditingController();

  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green, // 기본 색상을 파란색으로 설정
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stepper(
            steps: steps(),
            type: StepperType.vertical,
            elevation: 0,
            currentStep: currentStep,
            onStepContinue: () {
              if (isLastStep) {
                setState(() => isComplete = true);
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isFirstStep ? null : details.onStepCancel,
                      child: const Text('뒤로가기'),
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
      title: const Text('이메일'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("이메일을 입력해주세요"),
          Text("회원 정보 조회시 사용됩니다."),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "이메일을 입력해주세요 :)",
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
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "인증번호를 입력해주세요",
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
              ElevatedButton(
                onPressed: () {
                  // 인증번호 발송 로직을 여기에 추가합니다.
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(50, 36),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  textStyle: TextStyle(fontSize: 14),
                ),
                child: Text('인증요청'),
              ),
            ],
          ),
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 1,
      title: const Text('비밀번호'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("최소 8자리를 입력하세요"),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              hintText: "비밀번호를 입력해주세요 :)",
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: pwCon,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "비밀번호를 다시한번 입력해주세요 :)",
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            keyboardType: TextInputType.text,
            controller: pwCon,
          ),
        ],
      ),
    ),
    Step(
      isActive: currentStep >= 2,
      title: const Text('이름'),
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: "사용자 이름을 입력해주세요 :)",
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
