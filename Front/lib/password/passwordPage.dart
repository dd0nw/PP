import 'package:flutter/material.dart';
import 'password_service.dart';

class PasswordCh extends StatefulWidget {
  const PasswordCh({super.key});

  @override
  _PasswordChState createState() => _PasswordChState();
}

class _PasswordChState extends State<PasswordCh> {
  final idController = TextEditingController();
  final forwardPwController = TextEditingController();
  final backwardPwController = TextEditingController();

  late final PasswordService passwordService; // PasswordService 필드를 추가

  @override
  void initState() {
    super.initState();
    passwordService = PasswordService(); // PasswordService 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6F6),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 34.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '비밀번호 변경',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF6F6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Icon(Icons.lock, size: 80,),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: idController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            label: Text('이메일을 입력해주세요', style: TextStyle(fontSize: 18),),
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: forwardPwController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            label: Text('현재 비밀번호를 입력해주세요', style: TextStyle(fontSize: 18),),
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextField(
                          controller: backwardPwController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            label: Text('새로운 비밀번호를 입력해주세요', style: TextStyle(fontSize: 18),),
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 170,),
                  ElevatedButton(
                    onPressed: () async {
                      final id = idController.text;
                      final forwardPw = forwardPwController.text;
                      final backwardPw = backwardPwController.text;

                      final message = await passwordService.changePassword(id, forwardPw, backwardPw);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(message),
                          );
                        },
                      );
                    },
                    child: Text("비밀번호 재설정", style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      fixedSize: Size(310, 41),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)
                      )
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
}
