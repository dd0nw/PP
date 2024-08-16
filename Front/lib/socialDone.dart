import 'package:flutter/material.dart';

class TokenDisplayScreen extends StatelessWidget {
  final String token;

  TokenDisplayScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Token Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Received Token:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              token,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
