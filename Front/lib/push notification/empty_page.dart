// 기본 페이지로 푸시 알림을 수신하지 않은 경우 표시.

import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea
      (child: Scaffold(
      body: Center(
        child: Container(
          child: Text("Push Notification"),
        ),
      ),
    ));
  }
}
