class SpeakingQuestionRequest {
  final String selectedTopic;
  final String selectedLanguageName;
  final String selectedLanguageCode;
  final String userLevel;
  final String stage;
  final List<String> forbiddenSentences;

  SpeakingQuestionRequest({
    required this.selectedTopic,
    required this.selectedLanguageName,
    required this.selectedLanguageCode,
    required this.userLevel,
    required this.stage,
    required this.forbiddenSentences,
  });

  Map<String, dynamic> toJson() {
    return {
      "selected_topic": selectedTopic,
      "selected_language_name": selectedLanguageName,
      "selected_language_code": selectedLanguageCode,
      "user_level": userLevel,
      "stage": stage,
      "forbidden_sentences": forbiddenSentences,
    };
  }
}
