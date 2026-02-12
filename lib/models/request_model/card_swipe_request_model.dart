import 'dart:convert';

/// Convert model list to JSON string
String cardSwipeRequestToJson(CardSwipeRequest data) =>
    jsonEncode(data.toJson());

class CardSwipeRequest {
  final List<CardSwipeQuestion> questions;

  CardSwipeRequest({required this.questions});

  Map<String, dynamic> toJson() => {
        "questions": questions.map((q) => q.toJson()).toList(),
      };
}

class CardSwipeQuestion {
  final String sentenceEn;
  final String sentenceLocal;
  final String correct;
  final String wrong;

  CardSwipeQuestion({
    required this.sentenceEn,
    required this.sentenceLocal,
    required this.correct,
    required this.wrong,
  });

  Map<String, dynamic> toJson() => {
        "sentence_en": sentenceEn,
        "sentence_local": sentenceLocal,
        "correct": correct,
        "wrong": wrong,
      };
}
