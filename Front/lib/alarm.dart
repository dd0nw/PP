import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _notification = '';

  @override
  void initState() {
    super.initState();
    _listenForNotifications();
  }

  Future<void> _listenForNotifications() async {
    while (true) {
      try {
        final response = await http.get(Uri.parse('http://10.0.2.2:3000/notify'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['message'] == 'Data changed') {
            setState(() {
              _notification = 'Data has been updated!';
            });
          }
        } else {
          print('Failed to get notification');
        }
      } catch (e) {
        print('Error fetching notifications: $e');
      }

      // 1초 후 다시 요청을 시도
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_notification.isNotEmpty ? _notification : 'Waiting for notifications...'));
  }
}
