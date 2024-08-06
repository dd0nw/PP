import 'package:flutter/material.dart';
import 'memo.dart';
import 'memo_service.dart'; // 서버와 통신

class MemoProvider with ChangeNotifier {
  List<Memo> _memos = []; // 메모 데이터
  MemoService _memoService = MemoService(); // 서버 통신

  List<Memo> get memos => _memos; // 외부에서 접근가능

  MemoProvider() {
    fetchMemos(); // 초기메모데이터를 서버에서 가져옴
  }

  // <메모 데이터 가져오기>
  //서버에서 메모 데이터를 가져와 로컬 리스트(_memos)에 저장
  void fetchMemos() async {
    _memos = await _memoService.fetchMemos();
    notifyListeners(); // 상태가 변경되었음을 알리고 관련 위젯들을 다시 빌드
  }

  // <메모 추가 및 업데이트>
  void addOrUpdateMemo(Memo memo) async {
    if (memo.id == 0) {
      await _memoService.createMemo(memo);
    } else {
      await _memoService.updateMemo(memo);
    }
    fetchMemos(); //최신메모데이터 가져와 리스트갱신
  }
}