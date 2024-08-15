import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uni_links2/uni_links.dart';

class AuthCallbackPage extends StatefulWidget {
  @override
  _AuthCallbackPageState createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  Future<void> _initUniLinks() async {
    try {
      // 앱이 처음 시작할 때 URI를 가져옵니다.
      final Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      // URI 스트림을 구독하여 추가적인 리디렉션을 처리합니다.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleUri(uri);
        }
      }, onError: (Object err) {
        print('Failed to handle URI stream: $err');
      });
    } catch (e) {
      print('Failed to handle URI: $e');
    }
  }

  void _handleUri(Uri uri) {
    final token = uri.queryParameters['token'];
    if (token != null) {
      print('Received token: $token');
      // 토큰을 사용하여 추가적인 작업을 수행합니다.
    } else {
      print('No token found in URI.');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Callback'),
      ),
      body: Center(
        child: Text('Processing authentication...'),
      ),
    );
  }
}
