// 메모 모델 생성

class Memo {
  final String title; // 메모 제목
  final String content; // 메모 내용
  final DateTime timestamp; // 메모 생성 시간

  Memo({required this.title, required this.content, required this.timestamp});

  // Json 데이터 -> memo객체 변환
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      title: json['title'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // memo객체 -> Json형태 변환
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
}