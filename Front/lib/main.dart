import 'package:firebase_messaging/firebase_messaging.dart'; // 알림★
import 'package:flutter/material.dart';
import 'package:front/dart2Page.dart';
import 'package:front/passwordchange.dart';
import 'package:front/push%20notification/home_screen.dart';
import 'package:front/push%20notification/notification_screen.dart';
import 'package:front/reportPage/reportPage.dart';
import 'package:front/setting.dart';
import 'package:front/setting2.dart';
import 'package:front/userinfo_birth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'FCM Token.dart';
import 'LoginPage.dart';
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
import 'push notification/home_page.dart';
import 'hosipitalmap.dart';
import 'join.dart';
import 'joinPage.dart';
import 'memo2page/memo2Page.dart';
import 'package:firebase_core/firebase_core.dart'; // 알림★
import 'package:flutter/material.dart';
import 'push notification/empty_page.dart';
import 'package:front/push%20notification/empty_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// 네비게이션 작업을 전역에서 관리
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화★
  await Firebase.initializeApp(); // Firebase를 초기화★

  // 현재 디바이스의 FCM 토큰을 가져옴. 이 토큰은 서버에서 메시지를 보낼 때 필요
  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken : $value");
  });

  // 앱이 백그라운드 상태에서 FCM 메시지를 클릭했을 때 호출되는 리스너입니다.
  // 클릭한 메시지와 함께 특정 페이지로 네비게이션
  FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        '/push-page',
        arguments: {"message": json.encode(message.data)},
      );
    },
  );

  // 앱이 종료된 상태에서 FCM 메시지를 클릭하여 시작될 때 호출
  // 이 경우도 특정 페이지로 네비게이션
  FirebaseMessaging.instance.getInitialMessage().then(
        (RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          '/push-page',
          arguments: {"message": json.encode(message.data)},
        );
      }
    },
  );

  // 앱이 백그라운드 또는 종료된 상태에서 메시지를 처리할 때 호출되는 핸들러
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("_firebaseMessagingBackgroundHandler : $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BottomPage(),
      // routes: {
      //   '/notification': (context) => NotificationScreen(),
      // navigatorKey: navigatorKey,
      // routes: {
      //   '/': (context) => const EmptyPage(), // 기본페이지
      //   '/push-page': (context) => const HomePage(), // 푸시 알림을 클릭했을때 이동할 페이지
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
