import 'dart:convert';

class DailyQuestionRequest {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  DailyQuestionRequest({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": options,
        "answer": answer,
        "explanation": explanation,
      };
}
