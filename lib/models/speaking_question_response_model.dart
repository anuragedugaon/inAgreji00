/// ===============================
/// SPEAKING QUESTION RESPONSE MODEL
/// ===============================

class SpeakingQuestionResponse {
  final int sessionId;
  final List<SpeakingQuestion> questions;

  SpeakingQuestionResponse({
    required this.sessionId,
    required this.questions,
  });

  factory SpeakingQuestionResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingQuestionResponse(
      sessionId: json['session_id'] ?? 0,
      questions: (json['questions'] as List? ?? [])
          .map((e) => SpeakingQuestion.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}

/// ===============================
/// SINGLE SPEAKING QUESTION MODEL
/// ===============================

class SpeakingQuestion {
  final String prompt;
  final String sentence;
  final String hint;
  final String meaning;

  SpeakingQuestion({
    required this.prompt,
    required this.sentence,
    required this.hint,
    required this.meaning,
  });

  factory SpeakingQuestion.fromJson(Map<String, dynamic> json) {
    return SpeakingQuestion(
      prompt: json['prompt'] ?? '',
      sentence: json['sentence'] ?? '',
      hint: json['hint'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'sentence': sentence,
      'hint': hint,
      'meaning': meaning,
    };
  }
}
