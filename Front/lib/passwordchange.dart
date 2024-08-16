import 'package:flutter/material.dart';

class PasswordCh extends StatelessWidget {
  const PasswordCh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.chevron_left),
        title: Text("비밀번호변경"),
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
                  TextField( // 세번째, 비밀번호
                      //controller: pwCon, //위에서설정한contoll을 연결
                      obscureText: true, // 입력한값 *
                      keyboardType: TextInputType.text, // 기본값 없어도됌
                      decoration: InputDecoration(
                          label: Text('현재 비밀번호 ', style: TextStyle(fontSize: 20),),
                          hintText: '',
                          hintStyle: TextStyle(color: Colors.grey)
                      ),
                  ),
                  SizedBox(height: 30,),
                  TextField( // 세번째, 비밀번호
                    //controller: pwCon, //위에서설정한contoll을 연결
                    obscureText: true, // 입력한값 *
                    keyboardType: TextInputType.text, // 기본값 없어도됌
                    decoration: InputDecoration(
                        label: Text('새로운 비밀번호 ', style: TextStyle(fontSize: 20),),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 30,),
                  TextField( // 세번째, 비밀번호
                    //controller: pwCon, //위에서설정한contoll을 연결
                    obscureText: true, // 입력한값 *
                    keyboardType: TextInputType.text, // 기본값 없어도됌
                    decoration: InputDecoration(
                        label: Text('새로운 비밀번호 ', style: TextStyle(fontSize: 20),),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(onPressed: (){}, child: Text("비밀번호 재설정"),)
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
