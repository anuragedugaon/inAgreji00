class GrammarLessonRequestFill {
  final String lesson;
  final List<ArrangeQuestion> arrangeQuestions;
  final List<FillQuestion> fillQuestions;

  GrammarLessonRequestFill({
    required this.lesson,
    required this.arrangeQuestions,
    required this.fillQuestions,
  });

  factory GrammarLessonRequestFill.fromJson(Map<String, dynamic> json) {
    return GrammarLessonRequestFill(
      lesson: json['lesson'] ?? '',
      arrangeQuestions: (json['arrange_questions'] as List? ?? [])
          .map((e) => ArrangeQuestion.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
      fillQuestions: (json['fill_questions'] as List? ?? [])
          .map((e) => FillQuestion.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lesson": lesson,
      "arrange_questions":
          arrangeQuestions.map((e) => e.toJson()).toList(),
      "fill_questions":
          fillQuestions.map((e) => e.toJson()).toList(),
    };
  }
}
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
      sentence: json['sentence'] ?? '',
      meaning: json['meaning'] ?? '',
      words: List<String>.from(json['words'] ?? []),
      answer: List<String>.from(json['answer'] ?? []),
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sentence": sentence,
      "meaning": meaning,
      "words": words,
      "answer": answer,
      "explanation": explanation,
    };
  }
}
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
      question: json['question'] ?? '',
      meaning: json['meaning'] ?? '',
      wordList: List<String>.from(json['wordList'] ?? []),
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "meaning": meaning,
      "wordList": wordList,
      "answer": answer,
    };
  }


  final request = GrammarLessonRequestFill(
  lesson: "Sentence Formation",
  arrangeQuestions: [
    ArrangeQuestion(
      sentence: "I am going home",
      meaning: "मैं घर जा रहा हूँ",
      words: ["I", "am", "going", "home"],
      answer: ["I", "am", "going", "home"],
      explanation: "Correct subject-verb order",
    ),
  ],
  fillQuestions: [
    FillQuestion(
      question: "She _ coffee",
      meaning: "वह कॉफी _",
      wordList: ["drink", "drinks", "drank"],
      answer: "drinks",
    ),
  ],
);



}
