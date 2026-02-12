import 'dart:convert';

/// Convert model to JSON string
String grammarLessonRequestToJson(GrammarLessonRequest data) =>
    jsonEncode(data.toJson());

class GrammarLessonRequest {
  final String lesson;
  final List<ArrangeQuestion> arrangeQuestions;
  final List<FillQuestion> fillQuestions;

  GrammarLessonRequest({
    required this.lesson,
    required this.arrangeQuestions,
    required this.fillQuestions,
  });

  Map<String, dynamic> toJson() => {
        "lesson": lesson,
        "arrange_questions":
            arrangeQuestions.map((q) => q.toJson()).toList(),
        "fill_questions":
            fillQuestions.map((q) => q.toJson()).toList(),
      };
}

/// 🔹 Arrange the words (sentence formation)
class ArrangeQuestion {
  final String sentence;
  final String meaning;
  final List<String> words;
  final List<String> answer;
  final String explanation;

  ArrangeQuestion({
    required this.sentence,
    required this.meaning,
    required this.words,
    required this.answer,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
        "sentence": sentence,
        "meaning": meaning,
        "words": words,
        "answer": answer,
        "explanation": explanation,
      };
}

/// 🔹 Fill in the blanks
class FillQuestion {
  final String question;
  final String meaning;
  final List<String> wordList;
  final String answer;

  FillQuestion({
    required this.question,
    required this.meaning,
    required this.wordList,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        "question": question,
        "meaning": meaning,
        "wordList": wordList,
        "answer": answer,
      };
}
