import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/openai_config.dart';
import 'ai_service.dart';

class DailyGrammarService {
  final String _apiUrl = "https://api.openai.com/v1/chat/completions";

  /// List of models to try (fallback order) — includes your paid gpt-5-nano
  final List<String> _modelFallbacks = [
    "gpt-4o-mini",     // paid, fast, cheap fallback
    "o3-mini",         // strong reasoning fallback
    "gpt-4o",          // high-quality fallback
    "gpt-3.5-turbo",   // legacy fallback
  ];

/// Helper: try to extract a JSON object substring from `text`.
String? _extractJsonString(String text) {
  final firstOpen = text.indexOf('{');
  if (firstOpen == -1) return null;

  int lastClose = text.lastIndexOf('}');
  if (lastClose == -1) lastClose = text.length - 1;

  String candidate = text.substring(firstOpen, lastClose + 1);

  int opens = 0, closes = 0;
  for (var c in candidate.split('')) {
    if (c == '{') opens++;
    if (c == '}') closes++;
  }

  if (opens > closes) {
    candidate += '}' * (opens - closes);
  }

  return candidate;
}

/// Helper: sanitize AI JSON response
String sanitizeAiJson(String text) {
  return text
      .replaceAll(""", '"')
      .replaceAll(""", '"')
      .replaceAll("'", "'")
      .replaceAll("'", "'")
      .replaceAll("\n", " ")
      .replaceAll("\r", " ")
      .replaceAll("\t", " ")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

/// 🔥 Aggressive JSON repair
String repairJson(String json) {
  String repaired = json;
  
  // Remove trailing commas
  repaired = repaired.replaceAll(RegExp(r',\s*}'), '}');
  repaired = repaired.replaceAll(RegExp(r',\s*]'), ']');
  
  // Fix missing quotes around keys
  repaired = repaired.replaceAll(RegExp(r'(\w+):'), r'"\1":');
  
  // Fix empty string arrays like "", ""
  repaired = repaired.replaceAll(RegExp(r'"\s*",\s*""'), '');
  repaired = repaired.replaceAll(RegExp(r'",\s*""\s*]'), '"]');
  
  // Remove extra brackets
  repaired = repaired.replaceAll(RegExp(r'\]\s*,\s*\]'), ']');
  repaired = repaired.replaceAll(RegExp(r'\[\s*,'), '[');
  repaired = repaired.replaceAll(RegExp(r',\s*,'), ',');
  
  // Fix double quotes issues
  repaired = repaired.replaceAll(RegExp(r'"+'), '"');
  
  // Remove extra spaces
  repaired = repaired.replaceAll(RegExp(r'\s+'), ' ');
  
  return repaired;
}

/// 🔥 Daily lesson + arrange + fill (WITH LearningProgression)
Future<Map<String, dynamic>> getDailyLessonWithQuestions({
  String? extraContext,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final selectedLangName =
      prefs.getString('selected_language') ?? 'English';
  final userLevel = prefs.getString('selected_level') ?? 'beginner';

  // 🔥 GLOBAL LEARNING PROGRESSION
  final progress = await LearningProgression.today();

  debugPrint(
      "📘 Daily Lesson | Day ${progress.day} | Stage ${progress.stage} | Level $userLevel");

  final systemPrompt =
      "You are a JSON-generating English tutor AI. "
      "You MUST output ONLY valid JSON with NO explanations, NO markdown, NO text outside the JSON object. "
      "Level: $userLevel. Day ${progress.day}. Stage ${progress.stage}. "
      "${progress.difficultyHint}";

  final int arrangeCount = progress.stage <= 1 ? 6 : progress.stage == 2 ? 8 : 10;
  final int fillCount = progress.stage <= 1 ? 6 : progress.stage == 2 ? 8 : 10;

  String userPrompt = """
Generate VALID JSON ONLY (no markdown, no explanations):

{
  "lesson": "Short grammar lesson in one sentence",
  "arrange_questions": [
    {
      "sentence": "Complete English sentence",
      "meaning": "Translation in $selectedLangName",
      "words": ["word1", "word2", "word3"],
      "answer": ["word1", "word2", "word3"],
      "explanation": "Brief explanation"
    }
  ],
  "fill_questions": [
    {
      "question": "Sentence with one ___ blank",
      "meaning": "Translation in $selectedLangName with ___",
      "wordList": ["option1", "option2", "option3"],
      "answer": "correct_option"
    }
  ]
}

REQUIREMENTS:
- Create EXACTLY $arrangeCount arrange_questions
- Create EXACTLY $fillCount fill_questions
- All content in English (except meaning field in $selectedLangName)
- Simple $userLevel level sentences
- NO empty strings
- NO trailing commas
- NO line breaks in strings
- VALID JSON ONLY

Output the JSON now:""";



  if (extraContext != null && extraContext.isNotEmpty) {
    userPrompt += "\nContext: $extraContext";
  }

  for (final modelName in _modelFallbacks) {
    try {
      debugPrint("➡️ Trying model: $modelName");

      final body = {
        "model": modelName,
        "temperature": 0.3, // Lower temperature for more consistent JSON
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": userPrompt}
        ],
        // 🔥 Use correct parameter based on model
        if (modelName == "o3-mini")
          "max_completion_tokens": 3000
        else
          "max_tokens": 3000,
      };

      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode != 200) {
        debugPrint("⚠️ [$modelName] HTTP ${res.statusCode}, ${res.body}");
        continue;
      }

      final decoded = jsonDecode(res.body);
      final choice = decoded['choices']?[0];
      String? aiText = choice?['message']?['content'];

      if (aiText == null || aiText.trim().isEmpty) {
        debugPrint("⚠️ Empty response from $modelName");
        continue;
      }

      debugPrint("📄 Raw AI response length: ${aiText.length}");

      // 🔥 Clean up markdown and formatting
      aiText = aiText
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .replaceAll("\\n", " ")
          .replaceAll("\n", " ")
          .trim();

      // 🔥 Sanitize
      aiText = sanitizeAiJson(aiText);

      // 🔥 Extract JSON
      final extracted = _extractJsonString(aiText);
      if (extracted == null) {
        debugPrint("⚠️ Could not extract JSON from response");
        continue;
      }

      // 🔥 Repair JSON aggressively
      String repairedJson = repairJson(extracted);

      Map<String, dynamic> parsed;
      try {
        parsed = jsonDecode(repairedJson);
      } catch (parseError) {
        debugPrint("❌ JSON parse error: $parseError");
        debugPrint("🔍 First 500 chars of failed JSON: ${repairedJson.substring(0, repairedJson.length > 500 ? 500 : repairedJson.length)}");
        continue;
      }

      // 🔥 Validate structure
      if (!parsed.containsKey('lesson') ||
          !parsed.containsKey('arrange_questions') ||
          !parsed.containsKey('fill_questions')) {
        debugPrint("⚠️ Missing required keys in parsed JSON");
        continue;
      }

      final arrangeList = parsed['arrange_questions'] as List?;
      final fillList = parsed['fill_questions'] as List?;

      if (arrangeList == null || arrangeList.isEmpty) {
        debugPrint("⚠️ arrange_questions is empty");
        continue;
      }

      if (fillList == null || fillList.isEmpty) {
        debugPrint("⚠️ fill_questions is empty");
        continue;
      }

      debugPrint("✅ Daily lesson ready: ${arrangeList.length} arrange, ${fillList.length} fill questions");
      return parsed;
      
    } catch (e, stackTrace) {
      debugPrint("❌ Error ($modelName): $e");
      debugPrint("Stack: $stackTrace");
    }
  }

  debugPrint("❌ All models failed to generate valid daily lesson");
  return {
    "error": "All models failed to generate daily lesson"
  };
}}