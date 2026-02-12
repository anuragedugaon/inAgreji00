class SwipeQuestionRequest {
  final String sessionId;
  final String selectedLanguageName;
  final String selectedLanguageCode;
  final String userLevel;
  final String stage;

  SwipeQuestionRequest({
    required this.sessionId,
    required this.selectedLanguageName,
    required this.selectedLanguageCode,
    required this.userLevel,
    required this.stage,
  });

  Map<String, dynamic> toJson() {
    return {
      "session_id": sessionId,
      "selected_language_name": selectedLanguageName,
      "selected_language_code": selectedLanguageCode,
      "user_level": userLevel,
      "stage": stage,
    };
  }
}
