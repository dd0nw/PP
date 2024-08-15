import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController idCon = TextEditingController();
  TextEditingController pwCon = TextEditingController();
  String _message = '';

  // Future<void> _login() async {
  //   final response = await http.post(
  //     Uri.parse('http://localhost:3000/login'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'id': idCon.text,
  //       'pw': pwCon.text,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     setState(() {
  //       _message = 'Login successful! Token: ${data['token']}';
  //     });
  //     // Navigate to main page
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => MainPage()),
  //     );
  //   } else {
  //     setState(() {
  //       _message = 'Login failed: ${response.body}';
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('로그인을 다시 시도하세요.')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                children: [
                  Image.asset('images/Logo1.png', width: 30, height: 30,),
                  SizedBox(height: 20),
                  TextField(
                    controller: idCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '아이디',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: pwCon,
                    obscureText: true, // 입력한값 *
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '비밀번호',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: (){}, //_login
                    child: Text('로그인', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.grey[200]
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('회원가입', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.blue)
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print('kakao Button');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 25, height: 25,
                          child: Image.asset('images/chat.png', fit: BoxFit.fitHeight),
                        ),
                        Text(
                          '카카오 로그인', style: TextStyle(color: Colors.black87, fontSize: 15.0),
                        ),
                        Opacity(
                          opacity: 0.0,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset('images/chat.png'),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFEE500),
                      minimumSize: Size.fromHeight(50),  // 높이를 70으로 설정
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      print('google Button');
                    },
                    child: Row(
                      //spaceEvenly: 요소들을 균등하게 배치하는 속성
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('images/glogo.png'),
                        Text('구글 로그인',
                          style: TextStyle(color: Colors.black87, fontSize: 15.0),
                        ),
                        Opacity(
                          opacity: 0.0,
                          child: Image.asset('images/glogo.png'),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      //shadowColor: Colors.black, 그림자 추가하는 속성
                      minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      print('비밀번호찾기');
                    },
                    child: Text('비밀번호 찾기'),
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