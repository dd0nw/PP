import 'package:flutter/material.dart';

class ExLogin extends StatefulWidget {
  const ExLogin({super.key});

  @override
  State<ExLogin> createState() => _ExLoginState();
}

class _ExLoginState extends State<ExLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),

      backgroundColor: Colors.white,

      body:GestureDetector(
        onTap:(){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            color: Colors.white,
           child: Column(
             children:[
           Image.asset('images/logo.png', width: 170,
               height: 170),





           SizedBox(height:30),
           Container(
              child: Flexible(
               child: TextField(
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecoration(
               enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Colors.grey),
               ),
               hintText: '아이디',
               hintStyle: TextStyle(color: Colors.grey[500]),
             ),
             ),
           ),
             width: 273,
          ),


          Container(
          child: Flexible(
          child: TextField(
             obscureText: true,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecoration(
               enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Colors.grey),
               ),
               hintText: '비밀번호',
               hintStyle: TextStyle(color: Colors.grey[500],),
             ),
            ),
           ),
            width: 273,
          ),


           SizedBox(height: 30),
           ElevatedButton(
              onPressed: (){},
               style: ElevatedButton.styleFrom(
                 minimumSize: Size(284,40),
                 backgroundColor: Colors.red[900],
                 foregroundColor: Colors.white,
               ),
               child: Text('로그인',
                 style: TextStyle(fontWeight: FontWeight.bold,
                 ),),),

           SizedBox(height: 30),
           ElevatedButton(
             onPressed: (){},
            style: ElevatedButton.styleFrom(
             side: BorderSide(
             color: Colors.grey, width: 1.0,  ),
               backgroundColor: Colors.white,
               fixedSize: Size(284,40),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),

            ),

          ),


             child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                   Image.asset('images/google.png', width: 30,
                       height: 30),
                 SizedBox(width: 40),
                     Text('구글로 계속하기',
                   style: TextStyle(color: Colors.black, fontSize: 16,
                       ),
               ),
            ],
          ),
           ),


           SizedBox(height: 5),
           ElevatedButton(
              onPressed: (){},
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.yellow,
                 foregroundColor: Colors.black,
                 fixedSize: Size(284,40),
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(6)
               ),
               ),
             child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                 Image.asset('images/kakao1.png', width: 30,
                     height: 30),
                   SizedBox(width: 40),
              Text('카카오로 계속하기',
               style: TextStyle(color: Colors.black, fontSize: 16, ),
               ),
               ],
             ),
           ),

        SizedBox(height: 20),
        Center(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: (){},child:
                       Text('회원가입',style: TextStyle(color: Colors.grey[700]),),),
              TextButton(onPressed: (){},child:
                        Text('비밀번호 찾기',style: TextStyle(color: Colors.grey[700]),),),
            ],
           ),
        ),


        ],
           ),
         ),
        ),
      ),
    );
  }
}
