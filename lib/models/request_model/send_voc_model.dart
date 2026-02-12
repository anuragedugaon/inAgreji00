class WordListenRequest {
  final String selectedCategory;
  final String selectedLanguageName;
  final String selectedLanguageCode;
  final String userLevel;
  final List<String> avoidWords;

  WordListenRequest({
    required this.selectedCategory,
    required this.selectedLanguageName,
    required this.selectedLanguageCode,
    required this.userLevel,
    required this.avoidWords,
  });

  Map<String, dynamic> toJson() {
    return {
      "selected_category": selectedCategory,
      "selected_language_name": selectedLanguageName,
      "selected_language_code": selectedLanguageCode,
      "user_level": userLevel,
      "avoid_words": avoidWords,
    };
  }

  factory WordListenRequest.fromJson(Map<String, dynamic> json) {
    return WordListenRequest(
      selectedCategory: json["selected_category"] ?? "",
      selectedLanguageName: json["selected_language_name"] ?? "",
      selectedLanguageCode: json["selected_language_code"] ?? "",
      userLevel: json["user_level"] ?? "",
      avoidWords: List<String>.from(json["avoid_words"] ?? []),
    );
  }
}
