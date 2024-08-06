class Memo {
  final String id;
  final String content;

  Memo({
    required this.id,
    required this.content,
  });

  // Json데이터 -> memo객체 생성
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['ID'],
      content: json['ANALISYS_ETC'],
    );
  }

  // memo객체 -> Json변환
  Map<String, dynamic> toJson() => {
    'ID': id,
    'ANALISYS_ETC': content,
  };
}