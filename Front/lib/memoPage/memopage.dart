import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'memo.dart';
import 'memo_provider.dart';

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _memoController = TextEditingController();
  Memo? _currentMemo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('메모:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 5,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String content = _memoController.text;
                    if (content.isNotEmpty) {
                      Memo newMemo = Memo(
                        id: _currentMemo?.id ?? 'djf',
                        content: content,
                      );
                      // 반환값을 사용하지 않도록 수정
                      Provider.of<MemoProvider>(context, listen: false)
                          .addOrUpdateMemo(newMemo);
                      _memoController.clear();
                      setState(() {
                        _currentMemo = null;
                      });
                    }
                  },
                  child: Text('저장'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentMemo != null) {
                      _memoController.text = _currentMemo!.content;
                    }
                  },
                  child: Text('수정'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}