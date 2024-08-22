import 'package:flutter/material.dart';

// import 'memo2Page/memo.dart';
// import 'memoPage/memo_service.dart';
import 'AnalysisInfo.dart';
import 'memo2_service.dart';
import 'memo2.dart';

class MemoPage extends StatefulWidget {
  final AnalysisInfo analysisInfo;
  const MemoPage({super.key, required this.analysisInfo});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final MemoService _memoService = MemoService();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    try {
      List<Memo> memos = await _memoService.fetchMemos();
      if (memos.isNotEmpty) {
        _controller.text = memos.first.content; // 첫 번째 메모 내용을 TextField에 로드
      }
    } catch (e) {
      print('Failed to load memos: $e');
    }
  }

  Future<void> _saveMemo() async {
    Memo newMemo = Memo(
        content: _controller.text,
      analysisId: widget.analysisInfo.analysisId, // 분석 ID 포함
    );
    try {
      await _memoService.createMemo(newMemo,widget.analysisInfo);
      print('Memo saved successfully!');
    } catch (e) {
      print('Failed to save memo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메모',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '메모를 입력하세요',
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                maxLines: null, // 여러 줄 입력 가능하게 설정
                expands: true, // TextField가 Container의 크기를 채우도록 설정
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMemo,
              child: Icon(Icons.save)

            ),
          ],
        ),
      ),
    );
  }
}
