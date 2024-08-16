import 'package:flutter/material.dart';
import 'package:front/dart2Page.dart';
import 'package:front/reportPage/reportPage.dart';
import 'package:front/setting.dart';
import 'package:front/setting2.dart';
import 'package:front/userinfo_birth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'LoginPage.dart';
import 'alarm.dart';
import 'api_service.dart'; // ApiService 정의된 파일 import
import 'bottomPage.dart';
import 'bt.dart';
import 'dashPage.dart';
import 'ecg_chart.dart';
import 'ecg_graph.dart';

import 'ex.dart';
import 'ex01_login.dart';
import 'hosipitalmap.dart';
import 'join.dart';
import 'joinPage.dart';
import 'map.dart';
import 'memo2page/memo2Page.dart';
import 'package:flutter_config/flutter_config.dart';
import 'profile/profile.dart';
import 'password/passwordPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PasswordCh(),
      // routes: {
      //   '/report': (context) => const ReportPage(),
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  String _text = '변경되기 전!';
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Future<void> _fetchData() async {
  //   try {
  //     // Assuming fetchData is a method in ApiService that fetches some data
  //     String data = await apiService.fetchData();
  //     setState(() {
  //       _text = data;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(_text), // 서버에서 가져온 데이터를 표시
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
    );
  }
}


//
//
// import 'package:flutter/material.dart';
// import 'authservice.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Demo',
//       home: LoginPage(),
//     );
//   }
// }
//
// class LoginPage extends StatelessWidget {
//   final AuthService _authService = AuthService();
//
//   void _loginWithKakao(BuildContext context) {
//     _authService.loginWithKakao();
//   }
//
//   void _loginWithGoogle(BuildContext context) {
//     _authService.loginWithGoogle();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login Demo')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () => _loginWithKakao(context),
//               child: Text('Login with Kakao'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _loginWithGoogle(context),
//               child: Text('Login with Google'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//
//
// import 'package:flutter/material.dart';
// import 'authservice.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Demo',
//       home: LoginPage(),
//     );
//   }
// }
//
// class LoginPage extends StatelessWidget {
//   final AuthService _authService = AuthService();
//
//   void _loginWithKakao(BuildContext context) {
//     _authService.loginWithKakao();
//   }
//
//   void _loginWithGoogle(BuildContext context) {
//     _authService.loginWithGoogle();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login Demo')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () => _loginWithKakao(context),
//               child: Text('Login with Kakao'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _loginWithGoogle(context),
//               child: Text('Login with Google'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
