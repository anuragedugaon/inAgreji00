class SwipeQuestionResponse {
  final bool success;
  final int count;
  final List<SwipeQuestion> data;

  SwipeQuestionResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SwipeQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SwipeQuestionResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => SwipeQuestion.fromJson(e))
          .toList(),
    );
  }
}

class SwipeQuestion {
  final String sessionId;
  final String sentenceEn;
  final String sentenceLocal;
  final String correct;
  final String wrong;
  final String languageName;
  final String languageCode;
  final String level;
  final String stage;
  final int id;

  SwipeQuestion({
    required this.sessionId,
    required this.sentenceEn,
    required this.sentenceLocal,
    required this.correct,
    required this.wrong,
    required this.languageName,
    required this.languageCode,
    required this.level,
    required this.stage,
    required this.id,
  });

  factory SwipeQuestion.fromJson(Map<String, dynamic> json) {
    return SwipeQuestion(
      sessionId: json['session_id'] ?? '',
      sentenceEn: json['sentence_en'] ?? '',
      sentenceLocal: json['sentence_local'] ?? '',
      correct: json['correct'] ?? '',
      wrong: json['wrong'] ?? '',
      languageName: json['language_name'] ?? '',
      languageCode: json['language_code'] ?? '',
      level: json['level'] ?? '',
      stage: json['stage'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}
