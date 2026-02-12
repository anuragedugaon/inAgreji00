import 'dart:convert';

/// ===============================
/// 📘 Grammar Lesson Response
/// ===============================
class GrammarLessonResponse {
  final bool success;
  final GrammarLessonData data;

  GrammarLessonResponse({
    required this.success,
    required this.data,
  });

  factory GrammarLessonResponse.fromJson(Map<String, dynamic> json) {
    return GrammarLessonResponse(
      success: json["success"] ?? false,
      data: GrammarLessonData.fromJson(json["data"] ?? {}),
    );
  }
}

/// ===============================
/// 📘 Grammar Lesson Data
/// ===============================
class GrammarLessonData {
  final String title;
  final String theory;
  final List<String> examples;
  final List<ArrangeQuestion> arrangeQuestions;
  final List<FillQuestion> fillQuestions;

  GrammarLessonData({
    required this.title,
    required this.theory,
    required this.examples,
    required this.arrangeQuestions,
    required this.fillQuestions,
  });

  factory GrammarLessonData.fromJson(Map<String, dynamic> json) {
    return GrammarLessonData(
      title: json["title"] ?? "",
      theory: json["theory"] ?? "",
      examples: List<String>.from(json["examples"] ?? []),
      arrangeQuestions: (json["arrange_questions"] as List? ?? [])
          .map((e) => ArrangeQuestion.fromJson(e))
          .toList(),
      fillQuestions: (json["fill_questions"] as List? ?? [])
          .map((e) => FillQuestion.fromJson(e))
          .toList(),
    );
  }
}

/// ===============================
/// 📘 Arrange Question Model
/// ===============================
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

  factory ArrangeQuestion.fromJson(Map<String, dynamic> json) {
    return ArrangeQuestion(
      sentence: json["sentence"] ?? "",
      meaning: json["meaning"] ?? "",
      words: List<String>.from(json["words"] ?? []),
      answer: List<String>.from(json["answer"] ?? []),
      explanation: json["explanation"] ?? "",
    );
  }
}

/// ===============================
/// 📘 Fill in the Blank Question
/// ===============================
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

  factory FillQuestion.fromJson(Map<String, dynamic> json) {
    return FillQuestion(
      question: json["question"] ?? "",
      meaning: json["meaning"] ?? "",
      wordList: List<String>.from(json["wordList"] ?? []),
      answer: json["answer"] ?? "",
    );
  }
}

/// ===============================
/// 📘 Grammar Lesson Request Model
/// ===============================
class GrammarLessonRequestSend {
  final String grammarRule;
  final String userLevel;
  final String selectedLanguage;

  GrammarLessonRequestSend({
    required this.grammarRule,
    required this.userLevel,
    required this.selectedLanguage,
  });

  Map<String, dynamic> toJson() => {
        "grammar_rule": grammarRule,
        "user_level": userLevel,
        "selected_language": selectedLanguage,
      };
}
