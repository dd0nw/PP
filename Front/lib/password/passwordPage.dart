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
        leading: Icon(Icons.chevron_left),
        title: Text("비밀번호 변경"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30,),
                  Icon(Icons.lock, size: 80,),
                  SizedBox(height: 10,),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      label: Text('아이디', style: TextStyle(fontSize: 20),),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextField(
                    controller: forwardPwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text('현재 비밀번호', style: TextStyle(fontSize: 20),),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextField(
                    controller: backwardPwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text('새로운 비밀번호', style: TextStyle(fontSize: 20),),
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30,),
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
                    child: Text("비밀번호 재설정"),
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
