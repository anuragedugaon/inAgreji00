import 'dart:convert';

/// Convert model to JSON string
String grammarRuleRequestToJson(GrammarRuleRequest data) =>
    jsonEncode(data.toJson());

class GrammarRuleRequest {
  final String title;
  final String theory;
  final List<String> examples;
  final List<GrammarRuleArrangeQuestion> arrangeQuestions;

  GrammarRuleRequest({
    required this.title,
    required this.theory,
    required this.examples,
    required this.arrangeQuestions,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "theory": theory,
        "examples": examples,
        "arrange_questions":
            arrangeQuestions.map((e) => e.toJson()).toList(),
      };
}

class GrammarRuleArrangeQuestion {
  final String sentence;
  final String meaning;
  final List<String> words;
  final List<String> answer;

  GrammarRuleArrangeQuestion({
    required this.sentence,
    required this.meaning,
    required this.words,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        "sentence": sentence,
        "meaning": meaning,
        "words": words,
        "answer": answer,
      };
}



// recently edited files below class GrammarLessonData {
  




String grammarArrangeSubmitRequestToJson(
        GrammarArrangeSubmitRequest data) =>
    jsonEncode(data.toJson());

class GrammarArrangeSubmitRequest {
  final String grammarRule;
  final String userLevel;
  final String selectedLanguage;
  final List<GrammarArrangeResult> results;

  GrammarArrangeSubmitRequest({
    required this.grammarRule,
    required this.userLevel,
    required this.selectedLanguage,
    required this.results,
  });

  Map<String, dynamic> toJson() => {
        "grammar_rule": grammarRule,
        "user_level": userLevel,
        "selected_language": selectedLanguage,
        "results": results.map((e) => e.toJson()).toList(),
      };
}

class GrammarArrangeResult {
  final String sentence;
  final List<String> userAnswer;
  final List<String> correctAnswer;
  final bool isCorrect;

  GrammarArrangeResult({
    required this.sentence,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
        "sentence": sentence,
        "user_answer": userAnswer,
        "correct_answer": correctAnswer,
        "is_correct": isCorrect,
      };
}
