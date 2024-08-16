import 'package:flutter/material.dart';

////// 이 알림이 떠야함 //////

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic> ?? {};

    final String title = arguments['title'] ?? 'No Title';
    final String body = arguments['body'] ?? 'No Body';
    final String style = arguments['style'] ?? 'No Style';

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title: $title', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Body: $body', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Style: $style', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
