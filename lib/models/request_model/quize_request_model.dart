import 'dart:convert';

/// ===============================
/// 📘 Single Quiz Question Model
/// ===============================
class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String category;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // ✅ options can come as STRING or LIST
    List<String> optionsList = [];

    if (json['options'] is String) {
      try {
        optionsList = List<String>.from(jsonDecode(json['options']));
      } catch (_) {
        optionsList = [];
      }
    } else if (json['options'] is List) {
      optionsList = List<String>.from(json['options']);
    }

    return QuizQuestion(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: optionsList,
      correctAnswer: json['correct_answer'] ?? '',
      difficulty: json['difficulty'] ?? 'easy',
      category: json['category'] ?? 'vocabulary',
    );
  }
}

/// ===============================
/// 📘 Quiz API Response Model
/// ===============================
class QuizResponse {
  final bool success;
  final String quizType;
  final int totalQuestions;
  final List<QuizQuestion> questions;

  QuizResponse({
    required this.success,
    required this.quizType,
    required this.totalQuestions,
    required this.questions,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      success: json['success'] ?? false,
      quizType: json['quiz_type'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      questions: (json['saved_questions'] as List? ?? [])
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
    );
  }
}
