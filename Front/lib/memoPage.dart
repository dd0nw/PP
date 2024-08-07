import 'package:flutter/material.dart';

import 'memoPage/memo.dart';
import 'memoPage/memo_service.dart';


class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final MemoService memoService = MemoService();
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    _fetchMemos();
  }

  Future<void> _fetchMemos() async {
    try {
      List<Memo> fetchedMemos = await memoService.fetchMemos();
      setState(() {
        memos = fetchedMemos;
      });
    } catch (e) {
      print('Failed to fetch memos: $e');
    }
  }

  Future<void> _addMemo(String content) async {
    try {
      Memo newMemo = Memo(content: content);
      await memoService.createMemo(newMemo);
      _fetchMemos(); // 메모 추가 후 목록을 다시 불러옵니다.
    } catch (e) {
      print('Failed to add memo: $e');
    }
  }

  void _showAddMemoDialog() {
    TextEditingController memoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Memo'),
          content: TextField(
            controller: memoController,
            decoration: InputDecoration(hintText: 'Enter memo content'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _addMemo(memoController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memos'),
      ),
      body: ListView.builder(
        itemCount: memos.length,
        itemBuilder: (context, index) {
          final memo = memos[index];
          return ListTile(
            title: Text(memo.content),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemoDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
