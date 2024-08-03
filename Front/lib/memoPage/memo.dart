class Memo {
  final String content; // 메모 내용

  Memo({required this.content});

  // Json 데이터 -> Memo 객체 변환
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      content: json['ANALISYS_ETC'],
    );
  }

  // Memo 객체 -> Json 형태 변환
  Map<String, dynamic> toJson() => {
    'ANALISYS_ETC': content,
  };
}
