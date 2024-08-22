class Memo {
  final String content; // 메모 내용
  final String analysisId; // 분석 ID 필드

  Memo({
    required this.content,
    required this.analysisId,
  });

  // JSON 데이터 -> Memo 객체 변환
  factory Memo.fromJson(Map<String, dynamic> json) {
    final contentField = json['ANALISYS_ETC'];
    final content = (contentField is List)
        ? contentField.join('')
        : contentField.toString();
    return Memo(
      content: content, // 'content'가 null인 경우 기본값 설정
      analysisId: json['ANALYSIS_IDX']?.toString() ?? 'default', // 'analysisId'가 null인 경우 기본값 설정
    );
  }

  // Memo 객체 -> JSON 형태 변환
  Map<String, dynamic> toJson() => {
    'ANALISYS_ETC': content,
    'ANALYSIS_IDX': analysisId,
  };
}
