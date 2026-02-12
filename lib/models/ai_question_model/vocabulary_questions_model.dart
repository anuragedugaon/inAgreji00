// vocabulary_questions_model.dart

/// ===============================
/// 📘 Vocabulary Questions Response
/// ===============================
class VocabularyQuestions {
  final bool success;
  final int setId;
  final int totalQuestions;
  final List<VocabularyQuestion> questions;

  VocabularyQuestions({
    required this.success,
    required this.setId,
    required this.totalQuestions,
    required this.questions, required String level,
  });

  factory VocabularyQuestions.fromJson(Map<String, dynamic> json) {
    return VocabularyQuestions(
      success: json['success'] ?? false,
      setId: json['set_id'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      questions: (json['data']?['questions'] as List? ?? [])
          .map((e) => VocabularyQuestion.fromJson(e))
          .toList(), level: json['level'] ?? '',
    );
  }
}

/// ===============================
/// 📘 Single Vocabulary Question
/// ===============================
class VocabularyQuestion {
  final VocabularyWord correct;
  final VocabularyWord wrong;

  VocabularyQuestion({
    required this.correct,
    required this.wrong,
  });

  factory VocabularyQuestion.fromJson(Map<String, dynamic> json) {
    return VocabularyQuestion(
      correct: VocabularyWord.fromJson(json['correct'] ?? {}),
      wrong: VocabularyWord.fromJson(json['wrong'] ?? {}),
    );
  }
}

/// ===============================
/// 📘 Vocabulary Word Model
/// ===============================
class VocabularyWord {
  final String word;
  final String localWord;
  final String type;
  final String meaning;

  VocabularyWord({
    required this.word,
    required this.localWord,
    required this.type,
    required this.meaning,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      word: json['word'] ?? '',
      localWord: json['local_word'] ?? '',
      type: json['type'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }
}
