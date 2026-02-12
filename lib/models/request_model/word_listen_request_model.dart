import 'dart:convert';

// String wordListenRequestToJson(WordListenRequest data) =>
//     jsonEncode(data.toJson());
class WordListenPayload {
  final VocabularyWordSent correct;
  final VocabularyWordSent wrong;

  WordListenPayload({
    required this.correct,
    required this.wrong,
  });

  Map<String, dynamic> toJson() {
    return {
      "correct": correct.toJson(),
      "wrong": wrong.toJson(),
    };
  }
}
class VocabularyWordSent {
  final String word;
  final String localWord;
  final String type;
  final String meaning;
  final String image;

  VocabularyWordSent({
    required this.word,
    required this.localWord,
    required this.type,
    required this.meaning,
    required this.image,
  });

  factory VocabularyWordSent.fromJson(Map<String, dynamic> json) {
    return VocabularyWordSent(
      word: json['word'] as String,
      localWord: json['local_word'] as String,
      type: json['type'] as String,
      meaning: json['meaning'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "word": word,
      "local_word": localWord,
      "type": type,
      "meaning": meaning,
      "image": image,
    };
  }
}

extension WordListenPayloadFromJson on WordListenPayload {
  static WordListenPayload fromJson(Map<String, dynamic> json) {
    return WordListenPayload(
      correct: VocabularyWordSent.fromJson(json['correct'] as Map<String, dynamic>),
      wrong: VocabularyWordSent.fromJson(json['wrong'] as Map<String, dynamic>),
    );
  }
}
