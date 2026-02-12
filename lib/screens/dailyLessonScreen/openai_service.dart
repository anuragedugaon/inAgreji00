import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import '../../config/openai_config.dart';
import '../ai_teacher/ai_service.dart';

class OpenAIService {

  

final List<String> _modelFallbacks = [
  "gpt-4o-mini",     // paid, fast, cheap fallback
  "o3-mini",         // strong reasoning fallback
  "gpt-4o",          // high-quality fallback
  "gpt-3.5-turbo",   // legacy fallback
];
static const String _apiUrl = "https://api.openai.com/v1/chat/completions";


// Helper: Check similarity between words
bool _isWordSimilar(String word1, String word2) {
  if (word1 == word2) return true;
  
  // Check if words share 70% or more characters
  final chars1 = word1.split('').toSet();
  final chars2 = word2.split('').toSet();
  final common = chars1.intersection(chars2).length;
  final total = max(chars1.length, chars2.length);
  
  return (common / total) >= 0.7;
}

// Helper: Sanitize JSON
String sanitizeJson(String text) {
  return text
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .replaceAll(""", '"')
      .replaceAll(""", '"')
      .replaceAll("'", "'")
      .replaceAll("'", "'")
      .replaceAll("\n", " ")
      .replaceAll("\r", " ")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

// ===================== LISTEN & SELECT (FIXED & STABLE) =====================

// // Helper: Check similarity between words
// bool _isWordSimilar(String word1, String word2) {
//   if (word1 == word2) return true;
  
//   // Check if words share 70% or more characters
//   final chars1 = word1.split('').toSet();
//   final chars2 = word2.split('').toSet();
//   final common = chars1.intersection(chars2).length;
//   final total = max(chars1.length, chars2.length);
  
//   return (common / total) >= 0.7;
// }

// // Helper: Sanitize JSON
// String sanitizeJson(String text) {
//   return text
//       .replaceAll("```json", "")
//       .replaceAll("```", "")
//       .replaceAll(""", '"')
//       .replaceAll(""", '"')
//       .replaceAll("'", "'")
//       .replaceAll("'", "'")
//       .replaceAll("\n", " ")
//       .replaceAll("\r", " ")
//       .replaceAll(RegExp(r'\s+'), ' ')
//       .trim();
// }

// ===================== LISTEN & SELECT (FIXED & STABLE) =====================

Future<List<Map<String, dynamic>>> getListenSelectQuestions() async {
  print("\n════════════════════════════════════════");
  print("🎧 LISTEN & SELECT - START");
  print("════════════════════════════════════════");

  final prefs = await SharedPreferences.getInstance();

  final userLevel = prefs.getString('selected_level') ?? 'beginner';
  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'ml';
  final selectedLangName =
      prefs.getString('selected_language') ?? 'Malayalam';

  final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  final randomSeed = Random().nextInt(10000);

  print("📘 Language: $selectedLangName ($selectedLangCode)");
  print("🆔 Session: $sessionId");
  print("🎲 Seed: $randomSeed");

  // ─────────────────────────────
  // USED WORDS (WITH AUTO-RESET)
  // ─────────────────────────────
  final usedCorrectWords =
      prefs.getStringList("used_listen_correct_words") ?? [];
  final usedWrongWords =
      prefs.getStringList("used_listen_wrong_words") ?? [];

  // 🔥 AUTO-RESET: If too many words used (>50), clear old ones
  if (usedCorrectWords.length > 50) {
    print("🔄 Too many used words (${usedCorrectWords.length}), clearing to prevent exhaustion");
    final recentCorrect = usedCorrectWords.skip(usedCorrectWords.length - 25).toList();
    final recentWrong = usedWrongWords.skip(usedWrongWords.length - 25).toList();
    await prefs.setStringList("used_listen_correct_words", recentCorrect);
    await prefs.setStringList("used_listen_wrong_words", recentWrong);
  }

  final usedWords = {
    ...usedCorrectWords.map((e) => e.toLowerCase()),
    ...usedWrongWords.map((e) => e.toLowerCase()),
  };
  
  print("📊 Currently used words: ${usedWords.length}");

  // ─────────────────────────────
  // CATEGORY
  // ─────────────────────────────
  final categories = [
    "family members",
    "household items",
    "school objects",
    "daily food items",
    "animals",
    "body parts",
    "vehicles",
  ];

  final selectedCategory = categories[randomSeed % categories.length];
  print("🎯 Category: $selectedCategory");

  // ─────────────────────────────
  // MODELS (SAFE ORDER)
  // ─────────────────────────────
  final models = [
    "gpt-4o-mini",      // 🔥 Most reliable
    "gpt-4o",
    "gpt-4-turbo",
    "gpt-3.5-turbo",
  ];

  for (int attempt = 0; attempt < models.length; attempt++) {
    final model = models[attempt];
    print("\n🔄 Attempt ${attempt + 1}/${models.length}");
    print("📡 Model: $model");

    try {
      // 🔥 Tell AI which words to avoid (limit to last 20 for better results)
      String avoidWordsPrompt = "";
      if (usedWords.isNotEmpty) {
        final recentUsed = usedWords.take(20).join(', ');
        avoidWordsPrompt = "\n\nIMPORTANT: DO NOT use these words (already taught): $recentUsed\nGenerate COMPLETELY DIFFERENT words.";
      }

      // 🔥 BUILD REQUEST BODY
      final body = {
        "model": model,
        "temperature": 0.4,  // Lower = more consistent
        "max_tokens": 2500,  // 🔥 INCREASED TOKEN LIMIT
        "messages": [
          {
            "role": "system",
            "content": """You are a vocabulary question generator. Output ONLY valid JSON.

CATEGORY: $selectedCategory (simple $userLevel level words)
TARGET LANGUAGE: $selectedLangName

Generate 5 question pairs with COMPLETELY UNIQUE, FRESH words.

CRITICAL RULES:
- Use simple English nouns ONLY
- Generate DIVERSE words (not common/obvious ones)
- Each word pair must be from DIFFERENT semantic categories
- "meaning" must be 2-3 SHORT sentences (under 8 words each)
- NO markdown, NO explanations
- correct.word ≠ wrong.word (completely unrelated items)$avoidWordsPrompt

EXAMPLE OUTPUT:
{
  "questions": [
    {
      "correct": {
        "word": "mango",
        "local_word": "മാങ്ങ",
        "type": "noun",
        "meaning": "A yellow fruit. It is juicy. Grows on trees."
      },
      "wrong": {
        "word": "umbrella",
        "local_word": "കുട",
        "type": "noun",
        "meaning": "Protects from rain. Opens and closes. Held by hand."
      }
    }
  ]
}"""
          },
          {
            "role": "user",
            "content": "Generate 5 questions with fresh unique words. Output ONLY the JSON object:"
          }
        ],
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        print("❌ API ERROR: ${response.statusCode}");
        print("Response: ${response.body}");
        continue;
      }

      final responseData = jsonDecode(response.body);
      final raw = responseData["choices"]?[0]?["message"]?["content"];

      if (raw == null || raw.toString().trim().isEmpty) {
        print("❌ Empty response");
        continue;
      }

      print("📥 RAW RESPONSE (${raw.toString().length} chars):");
      print(raw.toString().substring(0, min(500, raw.toString().length)));

      // 🔥 CLEAN & PARSE JSON
      String cleanJson = sanitizeJson(raw.toString());
      
      // Extract JSON object
      final startIdx = cleanJson.indexOf('{');
      final endIdx = cleanJson.lastIndexOf('}');
      
      if (startIdx == -1 || endIdx == -1) {
        print("❌ No JSON found in response");
        continue;
      }
      
      cleanJson = cleanJson.substring(startIdx, endIdx + 1);

      // 🔥 REPAIR INCOMPLETE JSON
      // Count braces
      int openBraces = '{'.allMatches(cleanJson).length;
      int closeBraces = '}'.allMatches(cleanJson).length;
      
      if (openBraces > closeBraces) {
        print("⚠️ Incomplete JSON - adding ${openBraces - closeBraces} closing braces");
        cleanJson += '}' * (openBraces - closeBraces);
      }

      // Count brackets
      int openBrackets = '['.allMatches(cleanJson).length;
      int closeBrackets = ']'.allMatches(cleanJson).length;
      
      if (openBrackets > closeBrackets) {
        print("⚠️ Incomplete JSON - adding ${openBrackets - closeBrackets} closing brackets");
        // Insert before final brace
        cleanJson = cleanJson.substring(0, cleanJson.length - 1) + 
                   ']' * (openBrackets - closeBrackets) + 
                   cleanJson.substring(cleanJson.length - 1);
      }

      Map<String, dynamic> decoded;
      try {
        decoded = jsonDecode(cleanJson);
      } catch (e) {
        print("❌ JSON parse failed: $e");
        print("🔍 Attempted JSON: ${cleanJson.substring(0, min(300, cleanJson.length))}");
        continue;
      }

      final List questions = decoded["questions"] ?? [];
      if (questions.isEmpty) {
        print("❌ No questions in response");
        continue;
      }

      print("✅ Parsed ${questions.length} questions");

      final List<Map<String, dynamic>> result = [];
      final Set<String> batchWords = {};

      for (final q in questions) {
        try {
          final c = q["correct"];
          final w = q["wrong"];
          if (c == null || w == null) continue;

          final cWord = (c["word"] ?? "").toString().toLowerCase().trim();
          final wWord = (w["word"] ?? "").toString().toLowerCase().trim();

          // 🔥 VALIDATION
          if (cWord.isEmpty || wWord.isEmpty) {
            print("⚠️ Skipping: empty word");
            continue;
          }

          if (cWord == wWord) {
            print("⚠️ Skipping: same word ($cWord)");
            continue;
          }

          if (_isWordSimilar(cWord, wWord)) {
            print("⚠️ Skipping: similar words ($cWord, $wWord)");
            continue;
          }

          if (usedWords.contains(cWord) || usedWords.contains(wWord)) {
            print("⚠️ Skipping: already used ($cWord or $wWord)");
            continue;
          }

          if (batchWords.contains(cWord) || batchWords.contains(wWord)) {
            print("⚠️ Skipping: duplicate in batch ($cWord or $wWord)");
            continue;
          }

          // Validate meaning exists and is not incomplete
          final cMeaning = (c["meaning"] ?? "").toString().trim();
          final wMeaning = (w["meaning"] ?? "").toString().trim();
          
          if (cMeaning.isEmpty || wMeaning.isEmpty || 
              cMeaning.length < 15 || wMeaning.length < 15) {
            print("⚠️ Skipping: incomplete meaning");
            continue;
          }

          batchWords.add(cWord);
          batchWords.add(wWord);

          result.add({
            "correct": {
              "word": cWord,
              "local_word": c["local_word"] ?? cWord,
              "type": "noun",
              "meaning": cMeaning,
            },
            "wrong": {
              "word": wWord,
              "local_word": w["local_word"] ?? wWord,
              "type": "noun",
              "meaning": wMeaning,
            },
          });

          print("✅ Added: $cWord vs $wWord");
        } catch (e) {
          print("⚠️ Error processing question: $e");
          continue;
        }
      }

      // 🔥 Accept if we have at least 3 valid questions
      if (result.length >= 3) {
        // Save used words
        await prefs.setStringList(
            "used_listen_correct_words",
            [...usedCorrectWords, ...result.map((e) => e["correct"]["word"].toString())]);
        await prefs.setStringList(
            "used_listen_wrong_words",
            [...usedWrongWords, ...result.map((e) => e["wrong"]["word"].toString())]);

        print("\n🎉 SUCCESS: ${result.length} questions generated");
        
        // If we got less than 5, pad with fallback
        while (result.length < 5) {
          result.add({
            "correct": {
              "word": "water",
              "local_word": selectedLangName == "Malayalam" ? "വെള്ളം" : "water",
              "type": "noun",
              "meaning": "A clear liquid. People drink it. It is essential.",
            },
            "wrong": {
              "word": "sun",
              "local_word": selectedLangName == "Malayalam" ? "സൂര്യൻ" : "sun",
              "type": "noun",
              "meaning": "A bright star. It gives light. It is hot.",
            },
          });
        }
        
        return result.take(5).toList();
      } else {
        print("⚠️ Not enough valid questions: ${result.length}/5");
      }
    } catch (e, stackTrace) {
      print("❌ ERROR: $e");
      print("Stack: $stackTrace");
    }
  }

  // ─────────────────────────────
  // FALLBACK (100% SAFE)
  // ─────────────────────────────
  print("\n⚠️ All models failed - checking if word pool exhausted");
  
  // 🔥 If all models failed because word pool is exhausted, clear and retry ONCE
  if (usedWords.length > 40) {
    print("🔄 Word pool exhausted (${usedWords.length} words), clearing and retrying...");
    await prefs.remove("used_listen_correct_words");
    await prefs.remove("used_listen_wrong_words");
    
    // Retry with cleared words (only once)
    return getListenSelectQuestions();
  }

  print("\n⚠️ Using fallback questions");

  return [
    {
      "correct": {
        "word": "apple",
        "local_word": selectedLangName == "Malayalam" ? "ആപ്പിൾ" : "apple",
        "type": "noun",
        "meaning": "A round fruit. It is sweet. People eat it.",
      },
      "wrong": {
        "word": "chair",
        "local_word": selectedLangName == "Malayalam" ? "കസേര" : "chair",
        "type": "noun",
        "meaning": "A seat with legs. People sit on it.",
      }
    },
    {
      "correct": {
        "word": "water",
        "local_word": selectedLangName == "Malayalam" ? "വെള്ളം" : "water",
        "type": "noun",
        "meaning": "A clear liquid. People drink it. It is essential.",
      },
      "wrong": {
        "word": "sun",
        "local_word": selectedLangName == "Malayalam" ? "സൂര്യൻ" : "sun",
        "type": "noun",
        "meaning": "A bright star. It gives light. It is hot.",
      }
    }
  ];
}


// ===================== JSON SANITIZER =====================
String _sanitizeJson(String input) {
  return input
      .replaceAll("```json", "")
      .replaceAll("```", "")
      .replaceAll("'", '"')
      .replaceAll(RegExp(r'(\w+)\s*:'), '"1":')
      .replaceAll(RegExp(r',\s*}'), '}')
      .replaceAll(RegExp(r',\s*]'), ']')
      .trim();
}




Future<List<Map<String, dynamic>>> getSwipeCardQuestions() async {
  final prefs = await SharedPreferences.getInstance();

  final userLevel = prefs.getString('selected_level') ?? 'beginner';
  final progress = await LearningProgression.today();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final selectedLangName =
      prefs.getString('selected_language') ?? 'English';

  final String sessionId =
      DateTime.now().millisecondsSinceEpoch.toString();

  for (final modelName in _modelFallbacks) {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": modelName,
//           "temperature": 0.85,
// "presence_penalty": 0.8,
// "frequency_penalty": 0.6,

          "messages": [
            {
              "role": "system",
              "content": """
Return ONLY valid JSON.
No markdown. No explanation.

SESSION_ID: $sessionId

IMPORTANT:
- This is a COMPLETELY NEW session.
- Ignore all previous outputs.
- Do NOT reuse any sentence or answers from earlier sessions.

LANGUAGE RULES:
- sentence_en MUST be in English.
- sentence_local MUST be in the selected app language.
- Selected language: $selectedLangName ($selectedLangCode)

LEVEL:
- Student level: $userLevel
- Difficulty stage: ${progress.stage}

HARD RULES:
- Use very simple spoken English.
- Only ONE blank (____) per sentence.
- correct and wrong must be DIFFERENT.
- Wrong option must sound realistic but be incorrect.
- No repetition inside this response.

FORMAT:
{
  "questions": [
    {
      "sentence_en": "Nice ____ meet you.",
      "sentence_local": "<same sentence meaning in $selectedLangName with ____ >",
      "correct": "to",
      "wrong": "in"
    }
  ]
}
"""
            },
            {
              "role": "user",
              "content": """
Generate 5 NEW swipe card questions.
"""
            }
          ],
          "temperature": 0.6,
          "max_tokens": 600,
        }),
      );

      if (response.statusCode != 200) continue;

      final raw =
          jsonDecode(response.body)["choices"][0]["message"]["content"];

      final decoded = jsonDecode(raw);
      final List questions = decoded["questions"] ?? [];

      final Set<String> usedSentences = {};
      final Set<String> usedWords = {};
      final List<Map<String, dynamic>> result = [];

      for (final q in questions) {
        final sentenceEn = q["sentence_en"]?.toString().trim() ?? "";
        final sentenceLocal = q["sentence_local"]?.toString().trim() ?? "";
        final correct = q["correct"]?.toString().trim() ?? "";
        final wrong = q["wrong"]?.toString().trim() ?? "";

        // ❌ basic validation
        if (sentenceEn.isEmpty ||
            sentenceLocal.isEmpty ||
            correct.isEmpty ||
            wrong.isEmpty) continue;

        // ❌ must contain one blank
        if (!sentenceEn.contains("____") ||
            !sentenceLocal.contains("____")) continue;

        // ❌ same option
        if (correct.toLowerCase() == wrong.toLowerCase()) continue;

        final sentenceKey = sentenceEn.toLowerCase();
        final correctKey = correct.toLowerCase();
        final wrongKey = wrong.toLowerCase();

        // ❌ duplicates
        if (usedSentences.contains(sentenceKey) ||
            usedWords.contains(correctKey) ||
            usedWords.contains(wrongKey)) continue;

        usedSentences.add(sentenceKey);
        usedWords.add(correctKey);
        usedWords.add(wrongKey);

        result.add({
          "sentence_en": sentenceEn,
          "sentence_local": sentenceLocal,
          "correct": correct,
          "wrong": wrong,
        });
      }

      if (result.isNotEmpty) return result;
    } catch (e) {
      debugPrint("❌ SwipeCard AI error: $e");
    }
  }

  /// 🔴 SAFE FALLBACK
  return [
    {
      "sentence_en": "Nice ____ meet you.",
      "sentence_local": selectedLangName == "Hindi"
          ? "आपसे ____ मिलकर खुशी हुई।"
          : selectedLangName == "Kannada"
              ? "ನಿಮ್ಮನ್ನು ____ ಭೇಟಿ ಮಾಡಿದುದಕ್ಕೆ ಸಂತೋಷ."
              : "Nice ____ meet you.",
      "correct": "to",
      "wrong": "in"
    }
  ];
}









// ===================== SPEAKING PRACTICE =====================




// Helper function to check similarity between two strings
bool _isSimilar(String s1, String s2) {
  if (s1 == s2) return true;
  
  // Check if 70% or more words are same
  final words1 = s1.split(' ').toSet();
  final words2 = s2.split(' ').toSet();
  
  final common = words1.intersection(words2).length;
  final total = max(words1.length, words2.length);
  
  return (common / total) >= 0.7;
}

Future<List<Map<String, dynamic>>> getSpeakingPracticeQuestions() async {
  print("\n════════════════════════════════════════");
  print("🚀 SPEAKING PRACTICE QUESTIONS - START");
  print("════════════════════════════════════════");
  
  final prefs = await SharedPreferences.getInstance();

  final userLevel = prefs.getString('selected_level') ?? 'beginner';
  final progress = await LearningProgression.today();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final selectedLangName = prefs.getString('selected_language') ?? 'English';

  final String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  final randomSeed = Random().nextInt(10000);

  print("📋 User Level: $userLevel");
  print("🌍 Language: $selectedLangName ($selectedLangCode)");
  print("🆔 Session ID: $sessionId");
  print("🎲 Random Seed: $randomSeed");

  /// ─────────────────────────────
  /// 1️⃣ STREAK SYSTEM 🔥
  /// ─────────────────────────────
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastDate = prefs.getString("last_active_date");
  int streak = prefs.getInt("streak") ?? 0;

  if (lastDate == null) {
    streak = 1;
    print("🔥 New streak started: $streak");
  } else if (lastDate == today) {
    print("🔥 Same day - Streak: $streak");
  } else if (lastDate ==
      DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10)) {
    streak++;
    print("🔥 Streak increased: $streak");
  } else {
    streak = 1;
    print("🔥 Streak reset: $streak");
  }

  await prefs.setInt("streak", streak);
  await prefs.setString("last_active_date", today);

  /// ─────────────────────────────
  /// 2️⃣ LEVEL AUTO-INCREASE 📈
  /// ─────────────────────────────
  int level = prefs.getInt("speaking_level") ?? 1;
  int correctToday = prefs.getInt("speaking_correct_today") ?? 0;

  print("📊 Speaking Level: $level");
  print("✅ Correct Today: $correctToday/5");

  if (correctToday >= 5) {
    level++;
    correctToday = 0;
    await prefs.setInt("speaking_level", level);
    await prefs.setInt("speaking_correct_today", 0);
    print("🎉 Level UP! New level: $level");
  }

  /// ─────────────────────────────
  /// 3️⃣ CALL COUNTER
  /// ─────────────────────────────
  int callCount = (prefs.getInt("speaking_call_count") ?? 0) + 1;
  await prefs.setInt("speaking_call_count", callCount);
  print("📞 API Call Count: $callCount");

  /// ─────────────────────────────
  /// 4️⃣ LOAD USED QUESTIONS
  /// ─────────────────────────────
  final usedSentencesList = prefs.getStringList("used_speaking_sentences") ?? [];
  final usedPromptsList = prefs.getStringList("used_speaking_prompts") ?? [];
  
  final usedSentences = usedSentencesList.map((s) => s.toLowerCase()).toSet();
  final usedPrompts = usedPromptsList.map((s) => s.toLowerCase()).toSet();

  print("💾 Used Sentences Stored: ${usedSentencesList.length}");
  print("💾 Used Prompts Stored: ${usedPromptsList.length}");
  
  if (usedSentencesList.isNotEmpty) {
    print("📝 Last 5 used sentences:");
    for (var i = 0; i < min(5, usedSentencesList.length); i++) {
      print("   ${i + 1}. ${usedSentencesList.reversed.toList()[i]}");
    }
  }

  // Build strong avoid instructions
  String avoidInstructions = "";
  String explicitAvoidList = "";
  
  if (usedSentencesList.isNotEmpty) {
    final recentUsed = usedSentencesList.reversed.take(30).toList();
    explicitAvoidList = recentUsed.join('", "');
    
    avoidInstructions = """

⛔ CRITICAL: ALREADY USED - NEVER REPEAT:
${recentUsed.map((s) => "❌ \"$s\"").join("\n")}

STRICT RULES:
- Do NOT use ANY sentence from above list
- Do NOT use similar or rephrased versions
- Each sentence must be 100% NEW and DIFFERENT
- If you accidentally generate a duplicate, replace it immediately
""";
  }

  /// ─────────────────────────────
  /// 5️⃣ TOPIC CATEGORIES
  /// ─────────────────────────────
  final topics = [
    "greetings and introductions",
    "daily routines and activities", 
    "food and drinks",
    "time and dates",
    "directions and locations",
    "feelings and emotions",
    "weather and seasons",
    "shopping and money",
    "family and friends",
    "hobbies and interests",
  ];
  
  final selectedTopic = topics[randomSeed % topics.length];
  print("🎯 Selected Topic: $selectedTopic");

  /// ─────────────────────────────
  /// 6️⃣ AI CALL
  /// ─────────────────────────────
  print("\n─────────────────────────────────────");
  print("🤖 CALLING AI API");
  print("─────────────────────────────────────");

  for (int attempt = 0; attempt < _modelFallbacks.length; attempt++) {
    final modelName = _modelFallbacks[attempt];
    
    print("\n🔄 Attempt ${attempt + 1}/${_modelFallbacks.length}");
    print("📡 Model: $modelName");
    
    try {
      final requestBody = {
        "model": modelName,
       
       
        "messages": [
          {
            "role": "system",
            "content": """
You are a language learning question generator. Return ONLY valid JSON.

🎯 TOPIC: $selectedTopic
🔢 SESSION: #$callCount-$randomSeed  
📅 DATE: $today
🎚️ LEVEL: $userLevel (Stage: ${progress.stage})

LANGUAGE REQUIREMENTS:
• Sentence MUST be in ENGLISH
• Meaning MUST be in $selectedLangName
• Code: $selectedLangCode

SENTENCE RULES:
• Length: 3-6 words ONLY
• Simple beginner English
• Must be about: $selectedTopic
$avoidInstructions

⚠️ CRITICAL UNIQUENESS CHECK:
Before generating ANY sentence, verify it's NOT in this list:
FORBIDDEN: ["$explicitAvoidList"]

If you generate any sentence from the FORBIDDEN list, it will be REJECTED.
Generate only COMPLETELY NEW sentences.

JSON FORMAT:
{
  "questions": [
    {
      "prompt": "Ask about meal time",
      "sentence": "I am hungry",
      "hint": "I am ___",
      "meaning": "<$selectedLangName translation>"
    }
  ]
}

RESPONSE REQUIREMENT:
- Return exactly 5 questions
- All questions must be about: $selectedTopic
- Zero duplicates with FORBIDDEN list
- Each sentence 3-6 words
"""
          },
          {
            "role": "user",
            "content": """
Generate 5 NEW speaking practice questions.

TOPIC: $selectedTopic
SESSION: $sessionId
SEED: $randomSeed

IMPORTANT:
1. All sentences must be DIFFERENT from forbidden list
2. Focus on topic: $selectedTopic  
3. Keep it simple (3-6 words)
4. Be creative and unique

Start generating now.
"""
          }
        ],
        
        
        
        // "temperature": 0.9,
        // "max_tokens": 700,
        // "presence_penalty": 0.6,
        // "frequency_penalty": 0.6,
      };

      print("📤 Request Body Size: ${jsonEncode(requestBody).length} chars");
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("📬 Response Status: ${response.statusCode}");
      
      if (response.statusCode != 200) {
        print("❌ API Error Response:");
        print(response.body);
        continue;
      }

      final responseBody = jsonDecode(response.body);
      print("✅ Response received successfully");
      
      final raw = responseBody["choices"][0]["message"]["content"];
      
      print("\n📥 RAW AI RESPONSE:");
      print("─────────────────────────────────────");
      print(raw);
      print("─────────────────────────────────────\n");
      
      // Clean JSON
      String cleanJson = raw.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
        print("🧹 Removed ```json prefix");
      }
      if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3);
        print("🧹 Removed ``` prefix");
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
        print("🧹 Removed ``` suffix");
      }
      cleanJson = cleanJson.trim();

      print("🔍 Parsing JSON...");
      final decoded = jsonDecode(cleanJson);
      final List questions = decoded["questions"] ?? [];

      print("✅ Parsed successfully");
      print("📊 Questions received from AI: ${questions.length}");

      /// ─────────────────────────────
      /// 7️⃣ FILTER & VALIDATE
      /// ─────────────────────────────
      print("\n─────────────────────────────────────");
      print("🔍 FILTERING & VALIDATION");
      print("─────────────────────────────────────");
      
      final localUsed = <String>{};
      final newSentences = <String>[];
      final newPrompts = <String>[];
      final List<Map<String, dynamic>> result = [];

      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        print("\n📝 Question ${i + 1}:");
        
        final prompt = q["prompt"]?.toString().trim() ?? "";
        final sentence = q["sentence"]?.toString().trim() ?? "";
        final hint = q["hint"]?.toString().trim() ?? "";
        final meaning = q["meaning"]?.toString().trim() ?? "";

        print("   Prompt: $prompt");
        print("   Sentence: $sentence");
        print("   Hint: $hint");
        print("   Meaning: $meaning");

        if (prompt.isEmpty || sentence.isEmpty || hint.isEmpty || meaning.isEmpty) {
          print("   ❌ REJECTED: Empty field detected");
          continue;
        }

        final wc = sentence.split(" ").length;
        print("   Word count: $wc");
        
        if (wc < 3 || wc > 6) {
          print("   ❌ REJECTED: Word count must be 3-6");
          continue;
        }

        final sentenceKey = sentence.toLowerCase();
        final promptKey = prompt.toLowerCase();

        // Check exact match
        bool isDuplicate = false;
        
        if (usedSentences.contains(sentenceKey)) {
          print("   ❌ REJECTED: Exact sentence match in history");
          isDuplicate = true;
        }
        
        if (usedPrompts.contains(promptKey)) {
          print("   ❌ REJECTED: Exact prompt match in history");
          isDuplicate = true;
        }
        
        if (localUsed.contains(sentenceKey)) {
          print("   ❌ REJECTED: Duplicate in current batch");
          isDuplicate = true;
        }
        
        // Check similarity (Levenshtein distance)
        for (final used in usedSentences) {
          if (_isSimilar(sentenceKey, used)) {
            print("   ❌ REJECTED: Too similar to '$used'");
            isDuplicate = true;
            break;
          }
        }
        
        if (isDuplicate) continue;

        localUsed.add(sentenceKey);
        newSentences.add(sentence);
        newPrompts.add(prompt);

        result.add({
          "prompt": prompt,
          "sentence": sentence,
          "hint": hint,
          "meaning": meaning,
        });
        
        print("   ✅ ACCEPTED");
      }

      print("\n─────────────────────────────────────");
      print("📊 FILTERING RESULTS:");
      print("   Total received: ${questions.length}");
      print("   Accepted: ${result.length}");
      print("   Rejected: ${questions.length - result.length}");
      print("─────────────────────────────────────");

      /// ─────────────────────────────
      /// 8️⃣ SAVE IF SUCCESSFUL
      /// ─────────────────────────────
      if (result.isNotEmpty) {
        final updatedSentences = [...usedSentencesList, ...newSentences];
        final updatedPrompts = [...usedPromptsList, ...newPrompts];

        final sentencesToSave = updatedSentences.length > 150
            ? updatedSentences.sublist(updatedSentences.length - 150)
            : updatedSentences;
            
        final promptsToSave = updatedPrompts.length > 150
            ? updatedPrompts.sublist(updatedPrompts.length - 150)
            : updatedPrompts;

        await prefs.setStringList("used_speaking_sentences", sentencesToSave);
        await prefs.setStringList("used_speaking_prompts", promptsToSave);

        print("\n💾 Saved to storage:");
        print("   Sentences: ${sentencesToSave.length}");
        print("   Prompts: ${promptsToSave.length}");

        print("\n════════════════════════════════════════");
        print("🎉 SUCCESS! Returning ${result.length} questions");
        print("════════════════════════════════════════\n");
        
        return result;
      } else {
        print("\n⚠️ WARNING: No valid questions after filtering");
        print("   Trying next model...");
      }
      
    } catch (e, stackTrace) {
      print("\n❌ ERROR in attempt ${attempt + 1}:");
      print("   Error: $e");
      print("   Stack trace:");
      print(stackTrace.toString().split('\n').take(5).join('\n'));
      print("   Trying next model...");
    }
  }

  /// 🔥 FALLBACK
  print("\n⚠️⚠️⚠️ ALL AI ATTEMPTS FAILED ⚠️⚠️⚠️");
  print("Using fallback questions...");
  
  final fallbackIndex = callCount % 3;
  print("Fallback index: $fallbackIndex");
  
  final fallbacks = [
    {
      "prompt": "Greet someone politely",
      "sentence": "Nice to meet you",
      "hint": "Nice to ___ you",
      "meaning": selectedLangName == "Hindi"
          ? "आपसे मिलकर खुशी हुई"
          : selectedLangName == "Kannada"
              ? "ನಿಮ್ಮನ್ನು ಭೇಟಿ ಮಾಡಿದುದಕ್ಕೆ ಸಂತೋಷ"
              : "Nice to meet you"
    },
    {
      "prompt": "Ask about wellbeing",
      "sentence": "How are you",
      "hint": "How ___ you",
      "meaning": selectedLangName == "Hindi"
          ? "आप कैसे हैं"
          : selectedLangName == "Kannada"
              ? "ನೀವು ಹೇಗಿದ್ದೀರಿ"
              : "How are you"
    },
    {
      "prompt": "Express gratitude",
      "sentence": "Thank you very much",
      "hint": "Thank ___ very much",
      "meaning": selectedLangName == "Hindi"
          ? "बहुत धन्यवाद"
          : selectedLangName == "Kannada"
              ? "ತುಂಬಾ ಧನ್ಯವಾದ"
              : "Thank you very much"
    },
  ];
  
  print("\n════════════════════════════════════════");
  print("🔥 FALLBACK: Returning question #${fallbackIndex + 1}");
  print("════════════════════════════════════════\n");
  
  return [fallbacks[fallbackIndex]];
}





static Future<String> generateImage(String prompt) async {
  final response = await http.post(
    Uri.parse("https://api.openai.com/v1/images/generations"),
    headers: {
      "Authorization": "Bearer ${OpenAIConfig.apiKey}",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "model": "gpt-image-1",
      "prompt": prompt,
    }),
  );

  debugPrint("🖼️ Image response: ${response.body}");

  final decoded = jsonDecode(response.body);

  if (decoded["error"] != null) {
    debugPrint("❌ Image API Error: ${decoded["error"]["message"]}");
    return _placeholder();
  }

  if (decoded["data"] == null || decoded["data"].isEmpty) {
    return _placeholder();
  }

  final image = decoded["data"][0];

  // Most common response = base64
  if (image["b64_json"] != null) {
    final bytes = base64Decode(image["b64_json"]);
    return await _saveTempImage(bytes);
  }

  // Sometimes URL
  if (image["url"] != null) {
    return image["url"];
  }

  return _placeholder();
}


// 🔥 Save image locally & return path
static Future<String> _saveTempImage(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file =
      File('${dir.path}/ai_img_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(bytes);
  return file.path;
}

// fallback image
static String _placeholder() {
  return "https://via.placeholder.com/300?text=Image+Unavailable";
}


}
