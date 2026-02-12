import 'dart:convert';

/// Convert model to JSON string
String speakingPracticeRequestToJson(SpeakingPracticeRequest data) =>
    jsonEncode(data.toJson());

class SpeakingPracticeRequest {
  final List<SpeakingPracticeQuestion> questions;

  SpeakingPracticeRequest({required this.questions});

  Map<String, dynamic> toJson() => {
        "questions": questions.map((q) => q.toJson()).toList(),
      };
}

class SpeakingPracticeQuestion {
  final String prompt;
  final String sentence;
  final String hint;
  final String meaning;

  SpeakingPracticeQuestion({
    required this.prompt,
    required this.sentence,
    required this.hint,
    required this.meaning,
  });

  Map<String, dynamic> toJson() => {
        "prompt": prompt,
        "sentence": sentence,
        "hint": hint,
        "meaning": meaning,
      };
}
