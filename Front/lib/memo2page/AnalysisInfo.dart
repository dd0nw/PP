// analysis_info.dart

class AnalysisInfo {
  final String analysisId; // 분석 ID

  AnalysisInfo({required this.analysisId});

  // Json 데이터 -> AnalysisInfo 객체 변환
  factory AnalysisInfo.fromJson(Map<String, dynamic> json) {
    return AnalysisInfo(
      analysisId: json['ANALYSIS_IDX'] ?? 'default',
    );
  }

  // AnalysisInfo 객체 -> Json 형태 변환
  Map<String, dynamic> toJson() => {
    'ANALYSIS_IDX': analysisId,
  };
}
