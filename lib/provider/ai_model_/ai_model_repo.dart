import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:inangreji_flutter/models/ai_question_model/swipe_question_model.dart';
import 'package:inangreji_flutter/models/request_model/grammer_fill_blank.dart';
import 'package:inangreji_flutter/models/request_model/swipe_question_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request_model/card_swipe_request_model.dart';
import '../../models/request_model/daily_question_request_model.dart';
import '../../models/request_model/grammar_rule_request_model.dart';
import '../../models/request_model/grammer_request_model.dart';
import '../../models/request_model/quize_request_model.dart';
import '../../models/request_model/send_voc_model.dart';
import '../../models/request_model/speaking_practice_request_model.dart';
import '../../models/request_model/speaking_question_request_model.dart';
import '../../models/request_model/word_listen_request_model.dart';
import '../../models/request_model/word_requesti_model.dart';
import '../../models/speaking_question_response_model.dart';
import '../../screens/dailyLessonScreen/listen_and_select_screen.dart';
import '../../services/api_client.dart';
import '../../models/ai_question_model/vocabulary_questions_model.dart';

class AIModelRepo extends ChangeNotifier {
      //  AIModelRepo();

  ApiClient apiClient = ApiClient();


   Future<dynamic> fetchAIModels(String token) async {
    try {
      final response = await ApiClient.getRequestWithAuth('/ai-models', token);
      return response;
    } catch (e) {
      debugPrint('Error fetching AI models: $e');
      rethrow;
    }


  }




static Future<dynamic> sendWordListenApi(
    List<WordListenPayload> questions,
  ) async {

    debugPrint("📤 Word Listen Questions: $questions");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception("Auth token not found");
    }

    // ✅ Convert payload to RAW JSON ARRAY
    final data = questions.map((e) => e.toJson()).toList();

    debugPrint("➡️ POST: /word-listen");
    debugPrint("➡️ BODY(JSON): $data");
    debugPrint("➡️ TOKEN: $token");

    final dio = Dio();

    final response = await dio.request(
      'https://admin.inangreji.in/api/word-listen',
      options: Options(
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: data, // ✅ IMPORTANT: pass LIST directly
    );

    if (response.statusCode == 200) {
      debugPrint("✅ Word Listen API Success");
      return response.data;
    } else {
      debugPrint("❌ Word Listen API Failed: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }
// static Future<dynamic> sendWordListenApi(
//   List<WordListenPayload>? questions,
// ) async {
//  final List<Map<String, dynamic>> body =
//       questions!.map((e) => e.toJson()).toList();
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');
//     debugPrint("✅ Word Listen Result Sent$questions $token");
//         debugPrint("✅ Word Listen Result token $token");

//   if (token == null) {
//     debugPrint("❌ No auth token found");
//     return null;
//   }

//     try {
//       // Use the raw variant to allow sending a JSON array as the request body
//       final response = await ApiClient.postAiRequestWithAuthRaw(
//         '/word-listen',
//         body, // ✅ LIST (JSON array)
//         token,
//       );

//       debugPrint("✅ Word Listen Result Sent");
//       return response;
//     } catch (e) {
//       debugPrint('❌ Word Listen API Error: $e');
//       rethrow;
//     }
// }


static Future<dynamic> sendCardSwipeApi({
    required CardSwipeRequest request,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        debugPrint("❌ No auth token found");
        return null;
      }

      final jsonBody = request.toJson();

      debugPrint("📤 Card Swipe Request: $jsonBody");

      final response = await ApiClient.postAiRequestWithAuth(
        '/card-swipe',
        jsonBody  ,
        token,
      );

      debugPrint("📥 Card Swipe Response: $response");
      return response;
    } catch (e) {
      debugPrint("❌ Card Swipe API Error: $e");
      rethrow;
    }
  }





  /// 🎤 Speaking Practice API
  static Future<dynamic> sendSpeakingPracticeApi({
    required SpeakingPracticeRequest request,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        debugPrint("❌ No auth token found");
        return null;
      }

            // final jsonBody = speakingPracticeRequestToJson(request);
      final jsonBody = request.toJson();
      debugPrint("📤 Speaking Practice Request: $jsonBody");

      final response = await ApiClient.postAiRequestWithAuth(
        '/speaking-practice',
        jsonBody ,
        token,
      );

      debugPrint("📥 Speaking Practice Response: $response");
      return response;
    } catch (e) {
      debugPrint("❌ Speaking Practice API Error: $e");
      rethrow;
    }
  }



static Future<dynamic> submitGrammarArrangeAnswers({
  required GrammarArrangeSubmitRequest request,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint("❌ No auth token");
      return null;
    }

    final body = request.toJson();

    debugPrint("📤 Grammar Arrange Submit: ${body}");

    final response = await ApiClient.postAiRequestWithAuth(
      '/grammar-rule',
      body,
      token,
    );

    debugPrint("✅ Grammar Result Saved");
    return response;
  } catch (e) {
    debugPrint("❌ Grammar Submit Error: $e");
    rethrow;
  }
}




static Future<dynamic> sendGrammarLessonApi({
    required GrammarLessonRequestFill request,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        debugPrint("❌ No auth token found");
        return null;
      }

      final jsonBody = request.toJson();

      debugPrint("📤 Grammar Lesson Request: $jsonBody");

      final response = await ApiClient.postAiRequestWithAuth(
        '/grammar-lesson',
        jsonBody ,
        token,
      );

      debugPrint("📥 Grammar Lesson Response: $response");
      return response;
    } catch (e) {
      debugPrint("❌ Grammar Lesson API Error: $e");
      rethrow;
    }
  }

/// 🗓️ Daily Question API (DIO)
static Future<dynamic> sendDailyQuestionApi({
  required List<DailyQuestionRequest> questions,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint("❌ No auth token found");
      return null;
    }

    // 🔥 IMPORTANT: wrap list inside key
    final body = {
      "questions": questions.map((e) => e.toJson()).toList(),
    };

    debugPrint("📤 Daily Question Request (DIO): $body");

    final dio = Dio();

    final response = await dio.post(
      'https://admin.inangreji.in/api/daily-question',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json', // 🔥 important for Laravel
        },
        validateStatus: (status) => true, // 🔥 prevent Dio crash
      ),
      data: body,
    );

    debugPrint("📥 Status Code: ${response.statusCode}");
    debugPrint("📥 Response: ${response.data}");

    if (response.statusCode != 200) {
      throw Exception("Server error ${response.statusCode}");
    }

    return response.data;
  } catch (e) {
    debugPrint("❌ Daily Question DIO Error: $e");
    rethrow;
  }
}



//   /// 🗓️ Daily Question API
// static Future<dynamic> sendDailyQuestionApi({
//   required List<DailyQuestionRequest> questions,
// }) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       debugPrint("❌ No auth token found");
//       return null;
//     }

//     // ✅ RAW JSON ARRAY (same as Postman)
//     final body = questions.map((e) => e.toJson()).toList();

//     debugPrint("📤 Daily Question Request: $body");

//     final response = await ApiClient.postAiRequestWithAuthRaw(
//       '/daily-question',
//       body, // ✅ LIST, NOT STRING
//       token,
//     );

//     debugPrint("📥 Daily Question Response: $response");
//     return response;
//   } catch (e) {
//     debugPrint("❌ Daily Question API Error: $e");
//     rethrow;
//   }
// }



// /// 📘 Generate Vocabulary Questions API
// static Future<VocabularyQuestions?> generateVocabularyQuestions({
//   required WordListenRequest request,
// }) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token == null) {
//       debugPrint("❌ No auth token found");
//       return null;
//     }

//     final jsonBody = wordListenRequestToJson(request);

//     debugPrint("📤 Vocabulary Request: $jsonBody");

//     final response = await ApiClient.postRequestWithAuth(
//       '/generate-vocabulary-questions', // ✅ CORRECT API NAME
//       jsonBody,
//       token,
//     );
//     debugPrint("📥 Vocabulary Response: $response");

//     return VocabularyQuestions.fromJson(  Map<String, dynamic>.from(response),
// );
//   } catch (e) {
//     debugPrint("❌ Vocabulary API Error: $e");
//     rethrow;
//   }
// }



static Future<VocabularyQuestions?> generateVocabularyQuestions({
  required WordListenRequest request,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint("❌ No auth token found");
      return null;
    }

    // final jsonBody = wordListenRequestToJson(request);

    final response = await ApiClient.postAiRequestWithAuth(
      '/generate-vocabulary-questions',
      request.toJson(), // ✅ Map<String, dynamic>
      token,
    );

    return VocabularyQuestions.fromJson(
      Map<String, dynamic>.from(response),
    );
  } catch (e) {
    debugPrint("❌ Vocabulary API Error: $e");
    rethrow;
  }
}



static Future<SpeakingQuestionResponse?> generateSpeakingQuestions({
  required SpeakingQuestionRequest request,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    debugPrint("❌ No auth token found");
    return null;
  }

  final response = await ApiClient.postAiRequestWithAuth(
    '/generate-speaking-questions',
    request.toJson(),
    token,
  );

  return SpeakingQuestionResponse.fromJson(
    Map<String, dynamic>.from(response),
  );
}


static Future<SwipeQuestionResponse?> generateSwipeQuestions({
  required SwipeQuestionRequest request,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) return null;

  final response = await ApiClient.postAiRequestWithAuth(
    '/generate-swipe-questions',
    request.toJson(), // 🔥 JSON BODY
    token,
  );

  return SwipeQuestionResponse.fromJson(
    Map<String, dynamic>.from(response),
  );
}




static Future<QuizResponse?> generateQuizeQuestions() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final lan= prefs.getString('selected_language') ;
final randomVocabTopic = await getRandomUniqueItem(
  prefs: prefs,
  storageKey: "used_vocab_topics",
  items: vocabularyTopics,
);

debugPrint("✅ Selected Language for Quiz: $lan");
debugPrint("✅ Selected Topic for Quiz: $randomVocabTopic");
var request = {
  'language': lan,
  'quiz_type': 'vocabulary',
};

  if (token == null) return null;

  final response = await ApiClient.postAiRequestWithAuth(
    '/generate-quiz',
    request, // 🔥 JSON BODY
    token,
  );
debugPrint("✅ Quiz Question Response: $response");
  return QuizResponse.fromJson(
    Map<String, dynamic>.from(response),
  );
}






Future<String?> getImageForWord(String word) async {
  final response = await http.get(
    Uri.parse(
      "https://api.pexels.com/v1/search?query=$word&per_page=1",
    ),
    headers: {
      "Authorization":
          "Z0HNmGdJGDvpJGRD7o6gfweKRLlILX7Wx8aIE4uE5aXSdy85haDyuHOt",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data["photos"] != null && data["photos"].isNotEmpty) {
      return data["photos"][0]["src"]["medium"];
    }
  }

  return null;
}


static Future<GrammarLessonResponse?> generateGrammarLesson({
  required GrammarLessonRequestSend request,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    if (token == null) {
      debugPrint("❌ No auth token found");
      return null;
    }

    final response = await ApiClient.postRequestWithAuth(
      "/generate-grammar-lesson",
      request.toJson(),
      token,
    );

    return GrammarLessonResponse.fromJson(
      Map<String, dynamic>.from(response),
    );
  } catch (e) {
    debugPrint("❌ Grammar Lesson API Error: $e");
    rethrow;
  }
}

// 🔹 Send grammar result directly as JSON (no complex model objects)
static Future<dynamic> sendGrammarResultDirect(Map<String, dynamic> resultData) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      debugPrint('❌ No auth token found');
      return null;
    }

    debugPrint('📤 Sending grammar results to API...');
    debugPrint('📦 Payload: ${jsonEncode(resultData)}');

    // Use raw API method to avoid model serialization issues
    final response = await ApiClient.postAiRequestWithAuthRaw(
      '/grammar-lesson',
      resultData,
      token,
    );

    debugPrint('✅ Grammar result sent: $response');
    return response;
  } catch (e) {
    debugPrint('❌ Grammar result API error: $e');
    rethrow;
  }
}


}