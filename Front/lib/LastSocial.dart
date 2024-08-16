
import 'package:flutter/material.dart';
import 'OAuthWebview.dart';

class MyHomePagesocial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OAuth WebView Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OAuthWebView(oauthProvider: 'kakao'),
                  ),
                );

                if (result != null) {
                  // result는 OAuth 인증 후 받은 토큰입니다.
                  print('Kakao Login Token: $result');
                }
              },
              child: Text('Login with Kakao'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OAuthWebView(oauthProvider: 'google'),
                  ),
                );

                if (result != null) {
                  // result는 OAuth 인증 후 받은 토큰입니다.
                  print('Google Login Token: $result');
                }
              },
              child: Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}