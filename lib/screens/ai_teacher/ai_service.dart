import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

import '../../config/openai_config.dart';
import '../../services/video_player.dart';
import '../ai/ai_chat_screen.dart';
ValueNotifier<bool> isSpeakingNotifier = ValueNotifier<bool>(false);

// 🌍 Language Configuration
class LanguageConfig {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  LanguageConfig({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

// 📚 All Indian Languages
class IndianLanguages {
  static final List<LanguageConfig> allLanguages = [
    // South Indian Languages
    LanguageConfig(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flag: '🇮🇳'),
    LanguageConfig(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳'),
    LanguageConfig(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳'),
    LanguageConfig(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳'),
    
    // North Indian Languages
    LanguageConfig(code: 'hi', name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳'),
    LanguageConfig(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇮🇳'),
    LanguageConfig(code: 'mr', name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳'),
    LanguageConfig(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳'),
    LanguageConfig(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳'),
    LanguageConfig(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', flag: '🇮🇳'),
    LanguageConfig(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', flag: '🇮🇳'),
    LanguageConfig(code: 'ur', name: 'Urdu', nativeName: 'اردو', flag: '🇮🇳'),
    
    // English
    LanguageConfig(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
  ];

  static LanguageConfig getByCode(String code) {
    return allLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => allLanguages.last, // Default to English
    );
  }
}
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  final stt.SpeechToText speech = stt.SpeechToText();
   String  aiModual ="";

  AIService._internal() {
    _initTts();
  }

  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  final FlutterTts _tts = FlutterTts();
  double ttsRate = 0.5;  // Increased from 0.45 for clearer speech
  double ttsPitch = 1.1;  // Slightly higher pitch for clarity
  ValueNotifier<int> currentWordIndex = ValueNotifier<int>(0);

  
  Future<void> stop() async {
    await _tts.stop();        // 🔇 instant stop
  }
 Future<void> _initTts() async {
  try {
    final voices = await _tts.getVoices;
    Map<String, String>? indianVoice;

    if (voices != null) {
      for (final v in voices) {
        if (v is Map) {
          final locale = (v['locale'] ?? '').toString();

          // 🇮🇳 STRICT Indian voices only
          if (locale == 'en-IN' || locale == 'hi-IN') {
            indianVoice = {
              'name': v['name'].toString(),
              'locale': locale,
            };
            break;
          }
        }
      }
    }

    // 🎯 Apply voice if found
    if (indianVoice != null) {
      await _tts.setVoice(indianVoice);
      debugPrint(
          "🗣️ Indian voice selected: ${indianVoice['name']} (${indianVoice['locale']})");
    } else {
      debugPrint("⚠️ Indian voice not found, using language fallback");
    }

    // 🇮🇳 Force Indian locale
    await _tts.setLanguage('en-IN');

    // 🎧 Indian teacher tuning
    await _tts.setSpeechRate(0.42); // slow
    await _tts.setPitch(0.95);      // warm teacher
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);

    debugPrint("🗣️ TTS initialized with Indian tone");
  } catch (e) {
    debugPrint("❌ TTS init error: $e");
  }
}

// StreamSubscription? _lipSub;

// void startLipSync() {
//   final mouths = ["A", "E", "O", "M", "F", "S", "CH", "rest"];
//   int i = 0;

//   _lipSub?.cancel(); // ✅ stop old one
//   isSpeakingNotifier.value = true;

//   _lipSub = Stream.periodic(const Duration(milliseconds: 120)).listen((_) {
//     if (!isSpeakingNotifier.value) return;
//     mouthNotifier.value = mouths[i % mouths.length];
//     i++;
//   });
// }

// void stopLipSync() {
//   isSpeakingNotifier.value = false;
//   mouthNotifier.value = "rest";
//   _lipSub?.cancel();     // ✅ stop stream
//   _lipSub = null;
// }
// // }

// // void stopLipSync() {
// //   isSpeakingNotifier.value = false;
// //   mouthNotifier.value = "rest";
// // }

// Future<void> readAloud(String text) async {
//   if (text.trim().isEmpty) return;

//   try {
//     await _initTts();

//     final cleanText = _cleanTextForSpeech(text);
//     if (cleanText.isEmpty) return;

//     // ✅ Start Handler
//     _tts.setStartHandler(() {
//       isSpeakingNotifier.value = true;
//       startLipSync(); // 👄 START LIPS
//     });

//     // ✅ Completion Handler
//     _tts.setCompletionHandler(() {
//       stopLipSync(); // 👄 STOP LIPS
//     });

//     // ✅ Error Handler
//     _tts.setErrorHandler((_) {
//       stopLipSync(); // 👄 STOP LIPS
//     });

//     // speed + pitch
//     final len = cleanText.length;
//     double rate = len <= 30 ? 0.40 : len <= 80 ? 0.44 : 0.50;
//     double pitch = len <= 30 ? 0.94 : len <= 80 ? 0.96 : 0.99;

//     await _tts.setSpeechRate(rate);
//     await _tts.setPitch(pitch);
//     await _tts.setVolume(1.0);

//     await _tts.stop();
//     await _tts.speak(cleanText);
//   } catch (e) {
//     stopLipSync();
//   }
// }
  static StreamSubscription? _lipSub;


// ========================================
  // LIP SYNC METHODS
  // ========================================
  static void startLipSync() {
    final mouths = ["A", "E", "O", "M", "F", "S", "CH", "rest"];
    int i = 0;

    _lipSub?.cancel();
    isSpeakingNotifier.value = true;

    _lipSub = Stream.periodic(const Duration(milliseconds: 120)).listen((_) {
      if (!isSpeakingNotifier.value) {
        _lipSub?.cancel();
        return;
      }
      mouthNotifier.value = mouths[i % mouths.length];
      debugPrint("👄 Mouth: ${mouths[i % mouths.length]}");
      i++;
    });
  }

  static void stopLipSync() {
    isSpeakingNotifier.value = false;
    mouthNotifier.value = "rest";
    _lipSub?.cancel();
    _lipSub = null;
    debugPrint("🛑 Lip sync stopped");
  }

  // ========================================
  // READ ALOUD - NOW WITHOUT TTS PARAMETER!
  // ========================================
  Future<void> readAloud(String text) async {
    if (text.trim().isEmpty) return;

    try {
      // await initTts(); // Initialize if not already done

      final cleanText = _cleanTextForSpeech(text);
      if (cleanText.isEmpty) return;

      // ✅ Start Handler
      _tts.setStartHandler(() {
        isSpeakingNotifier.value = true;
        AIService.startLipSync();
        debugPrint("🗣️ TTS Started - Lip Sync ON");
      });

      // ✅ Completion Handler
      _tts.setCompletionHandler(() {
        AIService.stopLipSync();
        debugPrint("✅ TTS Completed - Lip Sync OFF");
      });

      // ✅ Error Handler
      _tts.setErrorHandler((msg) {
        AIService.stopLipSync();
        debugPrint("❌ TTS Error: $msg");
      });

      // ✅ Speed + Pitch based on text length
      final len = cleanText.length;
      double rate = len <= 30 ? 0.40 : len <= 80 ? 0.44 : 0.50;
      double pitch = len <= 30 ? 0.94 : len <= 80 ? 0.96 : 0.99;

      await _tts.setSpeechRate(rate);
      await _tts.setPitch(pitch);
      await _tts.setVolume(1.0);

      await _tts.stop();
      await _tts.speak(cleanText);

      debugPrint("🗣️ Speaking: $cleanText");
    } catch (e) {
      AIService.stopLipSync();
      debugPrint("❌ Read Aloud Error: $e");
    }
  }



// Future<void> readAloud(String text) async {
//   if (text.trim().isEmpty) return;

//   try {
//     await _initTts();

//     final cleanText = _cleanTextForSpeech(text);
//     if (cleanText.isEmpty) return;

//     // 👄 START LIP-SYNC
//     isSpeakingNotifier.value = true;

//     _tts.setStartHandler(() {
//       isSpeakingNotifier.value = true;
//     });

//     _tts.setCompletionHandler(() {
//       isSpeakingNotifier.value = false;
//     });

//     _tts.setErrorHandler((_) {
//       isSpeakingNotifier.value = false;
//     });

//     // speed + pitch (same as before)
//     final len = cleanText.length;
//     double rate = len <= 30 ? 0.40 : len <= 80 ? 0.44 : 0.50;
//     double pitch = len <= 30 ? 0.94 : len <= 80 ? 0.96 : 0.99;

//     await _tts.setSpeechRate(rate);
//     await _tts.setPitch(pitch);
//     await _tts.setVolume(1.0);

//     await _tts.stop();
//     await _tts.speak(cleanText);
//   } catch (e) {
//     isSpeakingNotifier.value = false;
//   }
// }



String _cleanTextForSpeech(String input) {
  String text = input;

  // ❌ Remove blanks like ____ , ___ , ----
  text = text.replaceAll(RegExp(r'[_\-]{2,}'), '');

  // ❌ Remove score / ui words
  text = text.replaceAll(
    RegExp(r'\b(score|points|marks|level|attempts?)\b',
        caseSensitive: false),
    '',
  );

  // ❌ Remove numbers (10, 20, 1st, etc.)
  text = text.replaceAll(RegExp(r'\d+'), '');

  // ❌ Remove symbols, emojis, extra junk
  text = text.replaceAll(
    RegExp(r'[^\w\s\.\,\?\!]'),
    '',
  );

  // ❌ Remove extra spaces
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

  return text;
}



  Future<void> refreshVoice() async {
    await _initTts();
    debugPrint("🔁 Voice reloaded for new language");
  }




  /// 🌍 Map app language code → TTS voice locale (HINDI PRIORITY FOR INDIAN USERS)
  String _getVoiceLocale(String code) {
  switch (code) {

    // 🇮🇳 Hindi & related
    case 'hi':
      return 'hi-IN'; // Hindi

    // 🇮🇳 Bengali
    case 'bn':
      return 'bn-IN';

    // 🇮🇳 Marathi
    case 'mr':
      return 'mr-IN';

    // 🇮🇳 Gujarati
    case 'gu':
      return 'gu-IN';

    // 🇮🇳 Tamil
    case 'ta':
      return 'ta-IN';

    // 🇮🇳 Telugu
    case 'te':
      return 'te-IN';

    // 🇮🇳 Kannada
    case 'kn':
      return 'kn-IN';

    // 🇮🇳 Malayalam
    case 'ml':
      return 'ml-IN';

    // 🇮🇳 Punjabi
    case 'pa':
      return 'pa-IN';

    // 🇮🇳 Urdu (India)
    case 'ur':
      return 'ur-IN';

    // 🇮🇳 Odia (Oriya)
    case 'or':
    case 'od':
      return 'or-IN';

    // 🇮🇳 Assamese
    case 'as':
      return 'as-IN';

    // 🇮🇳 Nepali (used in India)
    case 'ne':
      return 'ne-IN';

    // 🇮🇳 Konkani
    case 'kok':
      return 'kok-IN';

    // 🇮🇳 Sindhi
    case 'sd':
      return 'sd-IN';

    // 🇮🇳 Sanskrit
    case 'sa':
      return 'sa-IN';

    // 🇮🇳 English (Indian accent)
    case 'en':
    default:
      return 'en-IN';
  }


  }


final List<String> _modelFallbacks = [
  "gpt-4o-mini",     // paid, fast, cheap fallback
  "o3-mini",         // strong reasoning fallback
  "gpt-4o",          // high-quality fallback
  "gpt-3.5-turbo",   // legacy fallback
];






  // 🌍 System prompt - Kisi bhi language ko English mein translate karo
  String _systemPrompt() {
    return '''You are Sia, a friendly AI language teacher.
You are a multilingual voice assistant.
- Keep replies short and conversational

YOUR JOB:
- User will speak/write in ANY Indian language (Hindi, Tamil, Telugu, Kannada, Malayalam, Bengali, Marathi, Gujarati, Punjabi, etc.)
- You MUST tell them how to say it in English
- Keep responses simple and clear

RESPONSE FORMAT:
In English, you say: "[English translation here]"

EXAMPLES:

User: "Mera naam Anurag hai"
You: In English, you say: "My name is Anurag"

User: "Aap kaise hain?"
You: In English, you say: "How are you?"

User: "Bharat ki rajdhani kya hai?"
You: In English, you say: "What is the capital of India?"

User: "Chennai yenna maanilam?"
You: In English, you say: "Which state is Chennai in?"

User: "Hyderabad ekkada undi?"
You: In English, you say: "Where is Hyderabad located?"

User: "Bangalore yava rajyadalli ide?"
You: In English, you say: "Which state is Bangalore in?"

User: "Kerala yude capital enthanu?"
You: In English, you say: "What is the capital of Kerala?"

User: "Ami tomake bhalobashi"
You: In English, you say: "I love you"

User: "Mi tula avadto"
You: In English, you say: "I like you"

User: "Main khana khata hoon"
You: In English, you say: "I eat food"

User: "Naan saapidu"
You: In English, you say: "I will eat"

User: "Nenu bhojanam chesthanu"
You: In English, you say: "I am eating"

IMPORTANT: Always start with "In English, you say:" followed by the translation.''';
  }

  // 🎯 Get English translation
  Future<String> getAnswer(String userInput) async {
    print('📝 User Input: $userInput');

    for (final model in _modelFallbacks) {
      try {
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
          },
          body: jsonEncode({
            'model': model,
            'messages': [
              {
                'role': 'system',
                'content': _systemPrompt(),
              },
              {
                'role': 'user',
                'content': userInput,
              }
            ],
        "temperature": 0.7,
        "presence_penalty": 0.6,
        "frequency_penalty": 0.4,
            'max_tokens': 150,
          }),
        );

        debugPrint(" ai answer ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          String answer = data['choices'][0]['message']['content']
              .toString()
              .trim();


          // Clean formatting
          answer = answer.replaceAll('**', '');
          answer = answer.replaceAll('*', '');

          print('✅ AI Response: $answer');
          return answer;

        } else if (response.statusCode == 429) {
          await Future.delayed(const Duration(seconds: 2));
          continue;

        } else {
          print('❌ API Error: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error with $model: $e');
        continue;
      }
    }

    return 'Sorry, I could not translate. Please try again.';
  }


  /// 🎯 Language-specific instruction for AI with clear voice output - HINDI PREFERRED
  String _getLanguageInstruction(String code) {
    switch (code) {
      case 'hi':
        return 'आप एक हिंदी व्याकरण और अंग्रेजी शिक्षक हैं। हमेशा केवल हिंदी में जवाब दें। सरल हिंदी का उपयोग करें रोमन ट्रांसलिटरेशन के साथ जहां सहायक हो। अंग्रेजी शब्दों की व्याख्या करते समय हिंदी में अनुवाद करें। वाक्यों को छोटा और स्पष्ट रखें ताकि आवाज उत्पादन आसान हो। प्रोत्साहित करने वाले और सकारात्मक हों। आप एक असली शिक्षक की तरह बोलें।';
      case 'bn':
        return 'আপনি একজন বাংলা ব্যাকরণ এবং ইংরেজি শিক্ষক। সর্বদা শুধুমাত্র বাংলায় উত্তর দিন। সহজ বাংলা ব্যবহার করুন। ইংরেজি শব্দের ব্যাখ্যা করার সময় বাংলায় অনুবাদ করুন। বাক্যগুলি সংক্ষিপ্ত এবং স্পষ্ট রাখুন। উৎসাহব্যঞ্জক থাকুন।';
      case 'en':
      default:
        return 'You are a friendly AI English teacher for Indian students. Respond in clear, simple English. Use short sentences with Hindi explanations where helpful. Be encouraging and positive. Speak slowly and clearly like a real teacher. Perfect for voice output.';
    }
  }

Future<void> speakText(
  String text, {
  VoidCallback? onStart,
  VoidCallback? onComplete,
}) async {
  if (text.trim().isEmpty) return;

  await _initTts();

  final prefs = await SharedPreferences.getInstance();
  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';

  // 🔥 Indian-style config (slow + soft)
  final _TtsConfig config =
      _getIndianTtsConfig(selectedLangCode, text);

  // ✅ Apply TTS config
  await _tts.setLanguage(config.locale);
  await _tts.setSpeechRate(config.rate);
  await _tts.setPitch(config.pitch);
  await _tts.setVolume(1.0);

  // 👄 LIP-SYNC START / STOP
  _tts.setStartHandler(() {
    debugPrint(
        '🎙️ TTS started | ${config.locale} | rate=${config.rate} | pitch=${config.pitch}');
    isSpeakingNotifier.value = true; // 🔥 START video
    onStart?.call();
  });

  _tts.setCompletionHandler(() {
    debugPrint('✅ TTS completed');
    isSpeakingNotifier.value = false; // 🔥 STOP video
    onComplete?.call();
  });

  _tts.setErrorHandler((msg) {
    debugPrint('❌ TTS error: $msg');
    isSpeakingNotifier.value = false; // 🔥 STOP video
    onComplete?.call();
  });

  await _tts.stop();

  try {
    final cleanText =
        text.trim().replaceAll(RegExp(r'\s+'), ' ');
    debugPrint('🗣️ Speaking: $cleanText');

    // safety: agar speak start hone se pehle handler miss ho jaye
    isSpeakingNotifier.value = true;

    await _tts.speak(cleanText);
  } catch (e) {
    debugPrint('⚠️ Speak error: $e');
    isSpeakingNotifier.value = false;
    onComplete?.call();
  }
}




  Future<void> stopSpeaking() async => _tts.stop();
  void dispose() => _tts.stop();

  // 🎤 FIXED: Listen to voice in ANY Indian language
  // 🎤 FIXED: Listen to voice in ANY Indian language
  
  
  ChatSession chatSession = ChatSession();
Future<String> listenVoice() async {
  String finalText = "";
  DateTime? lastSpokenTime;

  try {
    final available = await speech.initialize(
      onError: (e) => debugPrint("❌ Speech error: ${e.errorMsg}"),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          debugPrint("🎤 Status ended");
        }
      },
    );

    if (!available) return "";
final SpeechToText _speech = SpeechToText();

    final localeId = await getBestIndianLocale(speech);

    await speech.listen(
      localeId: localeId,
      partialResults: true,
      listenMode: stt.ListenMode.dictation,
      pauseFor: const Duration(seconds: 3),
      onResult: (result) {
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          finalText = result.recognizedWords;
          lastSpokenTime = DateTime.now();
        }
      },
    );

    // 🔕 Silence wait
    while (speech.isListening) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (lastSpokenTime != null &&
          DateTime.now().difference(lastSpokenTime!).inMilliseconds > 3000) {
        break;
      }
    }
  } catch (e) {
    debugPrint("❌ listenVoice crash: $e");
  } finally {
    if (speech.isListening) await speech.stop();
  }

  return finalText.trim();
}


Future<String> getBestIndianLocale(SpeechToText speech) async {
  final locales = await speech.locales();

  // 1️⃣ Filter only Indian locales (-IN)
  final indianLocales = locales
      .where(
        (l) => l.localeId.toUpperCase().endsWith('-IN'),
      )
      .toList();

  // 🔁 If no Indian locale found
  if (indianLocales.isEmpty) {
    return 'en-IN';
  }

  // 2️⃣ Priority languages (most spoken in India)
  const priority = [
    'hi-IN', // Hindi
    'en-IN', // English (India)
    'bn-IN', // Bengali
    'te-IN', // Telugu
    'mr-IN', // Marathi
    'ta-IN', // Tamil
    'ur-IN', // Urdu
    'gu-IN', // Gujarati
    'kn-IN', // Kannada
    'ml-IN', // Malayalam
    'pa-IN', // Punjabi
    'or-IN', // Odia
    'as-IN', // Assamese
    'sd-IN', // Sindhi
    'kok-IN', // Konkani
    'ne-IN', // Nepali
    'mai-IN', // Maithili
    'sa-IN', // Sanskrit
    'ks-IN', // Kashmiri
    'mni-IN', // Manipuri
    'doi-IN', // Dogri
    'brx-IN', // Bodo
    'sat-IN', // Santali
  ];

  // 3️⃣ Pick highest-priority available locale
for (final p in priority) {
  if (indianLocales.any(
        (l) => l.localeId.toLowerCase() == p.toLowerCase(),
      )) {
    return indianLocales.firstWhere(
      (l) => l.localeId.toLowerCase() == p.toLowerCase(),
    ).localeId;
  }
}


  // 4️⃣ Final fallback → first available Indian locale
  return indianLocales.first.localeId;
}


  // 🌍 Get device's default locale or fallback to English
  String _getDeviceLocale() {
    // Try to get system locale, fallback to English
    // You can also make this dynamic based on user selection
    return 'en-IN'; 

    // English (India) - works for most Indian languages
    // OR use specific locales:
    // 'hi-IN' - Hindi
    // 'ta-IN' - Tamil
    // 'te-IN' - Telugu
    // 'kn-IN' - Kannada
    // 'ml-IN' - Malayalam
    // 'bn-IN' - Bengali
    // 'mr-IN' - Marathi
    // 'gu-IN' - Gujarati
    // 'pa-IN' - Punjabi
  }

  // 🎤 Alternative: Listen with specific language
  Future<String> listenVoiceWithLanguage(String languageCode) async {
    String finalText = "";
    bool isListening = true;
    DateTime? lastSpokenTime;

    try {
      bool available = await speech.initialize(
        onError: (error) => debugPrint("❌ Error: ${error.errorMsg}"),
        onStatus: (status) {
          debugPrint("🎤 Status: $status");
          if (status == 'notListening' || status == 'done') {
            isListening = false;
          }
        },
      );

      if (!available) return "";

      // Start listening with specific language
      await speech.listen(
        localeId: languageCode, // e.g., 'hi-IN', 'ta-IN', etc.
        partialResults: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            finalText = result.recognizedWords;
            lastSpokenTime = DateTime.now();
            debugPrint("🗣️ Recognized: $finalText");
          }
        },
      );

      // Silence detection
      int checkCount = 0;
      while (isListening && checkCount < 100) {
        await Future.delayed(const Duration(milliseconds: 300));
        checkCount++;

        if (lastSpokenTime != null) {
          final silence = DateTime.now().difference(lastSpokenTime!);
          if (silence.inMilliseconds > 2000) break;
        }
        if (!speech.isListening) break;
      }

    } catch (e) {
      debugPrint("❌ Error: $e");
    } finally {
      if (speech.isListening) await speech.stop();
    }

    return finalText.trim();
  }



  // 🌍 Get list of supported Indian languages
  Future<List<Map<String, String>>> getSupportedLanguages() async {
    await speech.initialize();
    
    final locales = await speech.locales();
    
    List<Map<String, String>> indianLanguages = [];
    
    for (var locale in locales) {
      if (locale.localeId.contains('IN')) {
        indianLanguages.add({
          'code': locale.localeId,
          'name': locale.name,
        });
      }
    }
    
    debugPrint("🇮🇳 Supported Indian languages: ${indianLanguages.length}");
    return indianLanguages;
  }



Future<List<dynamic>> getCachedDailyQuestions(
    String topic, String extraContext) async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toString().substring(0, 10);

  final savedDate = prefs.getString("daily_date");
  final savedQuestions = prefs.getString("daily_questions");

  // 🎯 Same day → same questions
  if (savedDate == today && savedQuestions != null) {
    return jsonDecode(savedQuestions);
  }

  // 🔥 GLOBAL PROGRESSION
  final progress = await LearningProgression.today();

  final fresh = await getDailyQuestions(
    topic: topic,
    extraContext: extraContext,
    progress: progress,
  );

  prefs.setString("daily_date", today);
  prefs.setString("daily_questions", jsonEncode(fresh));

  return fresh;
}


Future<List<dynamic>> getDailyQuestions({
  String? topic,
  String? extraContext,
  required ProgressData progress,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final selectedLangName =
      prefs.getString('selected_language') ?? 'English';
  final userLevel = prefs.getString('selected_level') ?? 'beginner';

  debugPrint(
      "📚 Daily Quiz | Day ${progress.day} | Stage ${progress.stage} | Level $userLevel");

  String? _extractJsonArray(String text) {
    var s = text.replaceAll("```json", "").replaceAll("```", "").trim();
    final start = s.indexOf('[');
    final end = s.lastIndexOf(']');
    if (start == -1) return null;
    return s.substring(start, end != -1 ? end + 1 : s.length);
  }

  dynamic _safeJsonDecode(String jsonStr) {
    try {
      return jsonDecode(jsonStr);
    } catch (_) {
      return null;
    }
  }

  for (final modelName in _modelFallbacks) {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
        },
        body: jsonEncode({
          "model": modelName,
           "temperature": 0.7,
        "presence_penalty": 0.6,
        "frequency_penalty": 0.4,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an English tutor AI. "
                  "Always respond ONLY in English. "
                  "Return ONLY a valid JSON array."
            },
            {
              "role": "user",
              "content":
                  "You are teaching a $userLevel English learner. "
                  "Day ${progress.day} of learning. "
                  "Difficulty stage ${progress.stage}. "
                  "${progress.difficultyHint} "
                  "${extraContext!.isNotEmpty ? "Student context: $extraContext. " : ""}"
                  "Generate exactly ${progress.questionCount} multiple-choice questions "
                  "for topic '${topic ?? ""}'. "
                  "Format strictly as JSON array: "
                  "[{\"question\":\"\",\"options\":[\"\",\"\",\"\",\"\"],"
                  "\"answer\":\"\",\"explanation\":\"\"}]."
            }
          ],
          "max_tokens": 1200,
          "temperature": 0.2,
        }),
      );

      if (response.statusCode != 200) continue;

      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];

      final extracted = _extractJsonArray(content);
      if (extracted == null) continue;

      final parsed = _safeJsonDecode(extracted);
      if (parsed is List && parsed.isNotEmpty) {
        debugPrint(
            "✅ Daily quiz generated: ${parsed.length} questions (Stage ${progress.stage})");
        return parsed;
      }
    } catch (_) {}
  }

  debugPrint("❌ Daily questions failed");
  return [];
}



/// 📚 Fetch a LIST of idioms (15–20) in simple English (always English content)




Future<List<Map<String, dynamic>>> getIdiomPhrase() async {
  final prefs = await SharedPreferences.getInstance();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final selectedLangName =
      prefs.getString('selected_language') ?? 'English';
  final userLevel = prefs.getString('selected_level') ?? 'beginner';

  // 🔥 GLOBAL LEARNING PROGRESSION
  final progress = await LearningProgression.today();

  debugPrint(
      "🌐 Idiom fetch | Day ${progress.day} | Stage ${progress.stage} | Level $userLevel");

  // 🔥 TRACK USED IDIOMS
  final usedIdioms = prefs.getStringList("used_idioms") ?? [];
  
  // 🔥 AUTO-RESET: If too many used (>50), keep only recent 25
  if (usedIdioms.length > 50) {
    debugPrint("🔄 Too many used idioms (${usedIdioms.length}), clearing old ones");
    final recentIdioms = usedIdioms.skip(usedIdioms.length - 25).toList();
    await prefs.setStringList("used_idioms", recentIdioms);
  }

  final usedIdiomsSet = usedIdioms.map((e) => e.toLowerCase().trim()).toSet();
  debugPrint("📝 Previously used idioms: ${usedIdiomsSet.length}");

  // 🔥 Tell AI which idioms to avoid
  String avoidIdiomsPrompt = "";
  if (usedIdiomsSet.isNotEmpty && usedIdiomsSet.length <= 30) {
    avoidIdiomsPrompt = "\n\nDO NOT USE THESE IDIOMS (already taught): ${usedIdiomsSet.take(30).join(', ')}";
  }

  final modelFallbacks = ["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-3.5-turbo"];

  for (final modelName in modelFallbacks) {
    try {
      debugPrint("➡️ Trying model: $modelName");

      final res = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
        },
       
       
        body: jsonEncode({
          "model": modelName,
          "temperature": 0.4,  // Lower for consistency
          "messages": [
            {
              "role": "system",
              "content":
                  "You are an English idiom teacher. "
                  "Return ONLY a valid JSON array with NO markdown, NO explanations. "
                  "All content must be in English."
            },
            {
              "role": "user",
              "content": """
Generate exactly 5 UNIQUE English idioms for a $userLevel learner.

Learning progress:
- Day ${progress.day}
- Difficulty stage ${progress.stage}

${progress.difficultyHint}$avoidIdiomsPrompt

REQUIRED JSON FORMAT (array of objects):
[
  {
    "idiom": "break the ice",
    "meaning": "to make people feel comfortable",
    "example": "He told a joke to break the ice at the meeting",
    "explanation": "This means to start a conversation in a friendly way"
  }
]

STRICT RULES:
- Output ONLY the JSON array
- ALL fields must be in simple English
- Keep meanings and explanations SHORT (under 15 words each)
- Use FRESH idioms not in the avoid list
- NO markdown, NO code blocks
- Return exactly 5 idioms
"""
            }
          ],
          "max_tokens": 2000,
        }),
     
     
      );

      if (res.statusCode != 200) {
        debugPrint("⚠️ Model $modelName status: ${res.statusCode}");
        debugPrint("Response: ${res.body}");
        continue;
      }

      final result = jsonDecode(res.body);
      final raw = result["choices"]?[0]?["message"]?["content"];

      if (raw == null || raw.toString().trim().isEmpty) {
        debugPrint("⚠️ Empty response from $modelName");
        continue;
      }

      debugPrint("🧠 Idiom raw ($modelName, ${raw.toString().length} chars)");

      // 🧹 Clean response
      String cleaned = raw.toString()
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .replaceAll("\n", " ")
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      // 🔧 Extract JSON array
      final startIdx = cleaned.indexOf('[');
      final endIdx = cleaned.lastIndexOf(']');
      
      if (startIdx == -1 || endIdx == -1) {
        debugPrint("❌ No JSON array found");
        continue;
      }

      cleaned = cleaned.substring(startIdx, endIdx + 1);

      // 🔧 Repair incomplete JSON
      int openBrackets = '['.allMatches(cleaned).length;
      int closeBrackets = ']'.allMatches(cleaned).length;
      
      if (openBrackets > closeBrackets) {
        debugPrint("⚠️ Incomplete JSON - adding ${openBrackets - closeBrackets} closing brackets");
        cleaned += ']' * (openBrackets - closeBrackets);
      }

      int openBraces = '{'.allMatches(cleaned).length;
      int closeBraces = '}'.allMatches(cleaned).length;
      
      if (openBraces > closeBraces) {
        debugPrint("⚠️ Incomplete JSON - adding ${openBraces - closeBraces} closing braces");
        int insertPos = cleaned.lastIndexOf(']');
        if (insertPos > 0) {
          cleaned = cleaned.substring(0, insertPos) + 
                   '}' * (openBraces - closeBraces) + 
                   cleaned.substring(insertPos);
        }
      }

      // Remove trailing commas
      cleaned = cleaned.replaceAll(RegExp(r',\s*}'), '}');
      cleaned = cleaned.replaceAll(RegExp(r',\s*]'), ']');

      dynamic decoded;
      try {
        decoded = jsonDecode(cleaned);
      } catch (e) {
        debugPrint("❌ JSON parse error: $e");
        debugPrint("🔍 First 300 chars: ${cleaned.substring(0, cleaned.length > 300 ? 300 : cleaned.length)}");
        continue;
      }

      if (decoded is! List) {
        debugPrint("❌ Response is not a list");
        continue;
      }

      // 🔥 FILTER OUT USED IDIOMS
      final List<Map<String, dynamic>> validIdioms = [];
      final Set<String> newIdioms = {};

      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;

        // Check required fields
        if (!item.containsKey('idiom') || 
            !item.containsKey('meaning') || 
            !item.containsKey('example') ||
            !item.containsKey('explanation')) {
          debugPrint("⚠️ Skipping: missing required fields");
          continue;
        }

        final idiom = item['idiom'].toString().toLowerCase().trim();
        
        if (idiom.isEmpty) {
          debugPrint("⚠️ Skipping: empty idiom");
          continue;
        }

        // Check if already used
        if (usedIdiomsSet.contains(idiom)) {
          debugPrint("⚠️ Skipping: already used '$idiom'");
          continue;
        }

        // Check if duplicate in current batch
        if (newIdioms.contains(idiom)) {
          debugPrint("⚠️ Skipping: duplicate in batch '$idiom'");
          continue;
        }

        // Validate content is not too short
        if (item['meaning'].toString().length < 10 ||
            item['example'].toString().length < 10 ||
            item['explanation'].toString().length < 10) {
          debugPrint("⚠️ Skipping: content too short");
          continue;
        }

        newIdioms.add(idiom);
        validIdioms.add({
          'idiom': item['idiom'].toString().trim(),
          'meaning': item['meaning'].toString().trim(),
          'example': item['example'].toString().trim(),
          'explanation': item['explanation'].toString().trim(),
        });

        debugPrint("✅ Added: '${item['idiom']}'");
      }

      if (validIdioms.length >= 3) {
        // 🔥 SAVE USED IDIOMS
        final newIdiomsList = validIdioms.map((e) => e['idiom'].toString()).toList();
        await prefs.setStringList("used_idioms", [...usedIdioms, ...newIdiomsList]);

        debugPrint("✅ Idioms generated: ${validIdioms.length} (Stage ${progress.stage})");
        return validIdioms.take(5).toList();
      } else {
        debugPrint("⚠️ Not enough valid idioms: ${validIdioms.length}/5");
      }

    } catch (e, stackTrace) {
      debugPrint("❌ Idiom error ($modelName): $e");
      debugPrint("Stack: $stackTrace");
    }
  }

  debugPrint("❗ All models failed for idioms - using fallback");
  
  // 🆘 FALLBACK IDIOMS
  return [
    {
      "idiom": "piece of cake",
      "meaning": "very easy",
      "example": "The test was a piece of cake",
      "explanation": "This means something is very simple to do"
    },
    {
      "idiom": "break a leg",
      "meaning": "good luck",
      "example": "Break a leg in your exam today",
      "explanation": "This is a way to wish someone success"
    },
    {
      "idiom": "hit the books",
      "meaning": "to study",
      "example": "I need to hit the books for my test",
      "explanation": "This means to start studying seriously"
    }
  ];
}




// Future<List<VocabularyWord>> getVocabularyWithImages({
//   required List<String> excludeWords,
// }) async {
//   final prefs = await SharedPreferences.getInstance();

//   final selectedLangName =
//       prefs.getString('selected_language') ?? 'Hindi';
//       final selectedLangCode =
//       prefs.getString('selected_language_code')?.toLowerCase() ;
//   final userLevel = prefs.getString('selected_level') ?? 'beginner';

//   for (final modelName in _modelFallbacks) {
//     try {
//       final res = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${OpenAIConfig.apiKey}",
//         },


// body: jsonEncode({
//   "model": modelName,
//    "temperature": 0.7,
//         "presence_penalty": 0.6,
//         "frequency_penalty": 0.4,
//   "messages": [
//     {
//       "role": "system",
//       "content": """
// You are a strict multilingual vocabulary generator.

// You MUST follow language instructions EXACTLY.
// If you violate them, the output is INVALID.

// Return ONLY a raw JSON array.
// No explanation. No markdown. No extra text.
// """
//     },
//     {
//       "role": "user",
//       "content": """
// APP LANGUAGE SETTINGS:
// - Selected language name: "$selectedLangName"
// - Selected language code: "$selectedLangCode"

// VERY IMPORTANT LANGUAGE RULES (NO EXCEPTIONS):
// - "word" MUST ALWAYS be in English
// - "meaning" MUST be written ONLY in the selected language
// - DO NOT use Hindi unless selected language is Hindi
// - DO NOT assume Hindi for India
// - India has many languages (Tamil, Bengali, Marathi, Telugu, etc.)

// LANGUAGE BEHAVIOR:
// - If selected language = English → meaning = English definition
// - If selected language = Hindi → meaning = Hindi
// - If selected language = Tamil → meaning = Tamil
// - If selected language = Bengali → meaning = Bengali
// - If selected language = Marathi → meaning = Marathi

// STRICTLY FORBIDDEN:
// - Mixing languages
// - Using Hindi when selected language is NOT Hindi
// - Transliteration (English letters for Indian languages)

// TASK:
// Generate 15–25 English vocabulary words for a "$userLevel" learner.

// DO NOT REPEAT THESE WORDS:
// ${excludeWords.join(", ")}

// FORMAT (STRICT JSON ARRAY ONLY):
// [
//   {
//     "word": "apple",
//     "meaning": "<meaning written ONLY in $selectedLangName>",
//     "image": "https://example.com/apple.jpg"
//   }
// ]

// IMAGE RULES:
// - image URL must start with https
// - image URL must end with .jpg or .png
// """
//     }
//   ],
//   "temperature": 0.4,
//   "max_tokens": 1500,
// }),

     
//       );

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         final text = data["choices"][0]["message"]["content"];
//         final decoded = jsonDecode(text);

//         if (decoded is List && decoded.length >= 15) {
//           return decoded
//               .map<VocabularyWord>(
//                   (e) => VocabularyWord.fromJson(e))
//               .toList();
//         }
//       }
//     } catch (_) {}
//   }

//   return [];
// }





/// Fetch translation, definition, examples and voice-chat prompt
/// 🔥 WITH LearningProgression (easy → daily increase)
Future<Map<String, dynamic>> fetchWordDetails() async {
  final prefs = await SharedPreferences.getInstance();

  final selectedLangCode =
      prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
  final userLevel = prefs.getString('selected_level') ?? 'beginner';

  final String languageInstruction =
      _getLanguageInstruction(selectedLangCode);

  // 🔥 GLOBAL LEARNING PROGRESSION
  final progress = await LearningProgression.today();

  debugPrint(
      "📗 Word Details | Day ${progress.day} | Stage ${progress.stage} | Level $userLevel");

  /// Stage-based difficulty for word selection
  String wordDifficultyHint;
  switch (progress.stage) {
    case 0:
      wordDifficultyHint =
          "Choose a very common, very easy English word used in daily life.";
      break;
    case 1:
      wordDifficultyHint =
          "Choose a simple and common English word used in daily conversation.";
      break;
    case 2:
      wordDifficultyHint =
          "Choose a slightly harder but still common English word.";
      break;
    default:
      wordDifficultyHint =
          "Choose a practical English word used in real-life situations.";
  }

  // 🔒 Strict JSON system prompt
  final systemPrompt =
      '$languageInstruction '
      'You are a concise language assistant for $userLevel level learners. '
      'Learning day ${progress.day}, difficulty stage ${progress.stage}. '
      '$wordDifficultyHint '
      'Reply ONLY with valid JSON. '
      'Return EXACTLY these keys:\n'
      '- "word": original English word\n'
      '- "hindi": Hindi translation (short)\n'
      '- "definition": short English definition (1–2 simple sentences)\n'
      '- "examples": array of 1–2 short English example sentences\n'
      '- "voice_prompt": a short user-facing prompt in the user\'s language '
      'for voice chat practice\n'
      'Do NOT add any explanations, markdown, or extra text.';

  for (final modelName in _modelFallbacks) {
    try {
      final body = jsonEncode({
        "model": modelName,
         "temperature": 0.7,
        "presence_penalty": 0.6,
        "frequency_penalty": 0.4,
        "messages": [
          {"role": "system", "content": systemPrompt},
          {
            "role": "user",
            "content":
                "Give ONLY ONE English vocabulary word suitable for this learning stage."
          }
        ],
        "temperature": 0.4,
        "max_tokens": 450,
      });

      final resp = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
        },
        body: body,
      );

      if (resp.statusCode != 200) {
        debugPrint(
            "⚠️ Word model $modelName failed: ${resp.statusCode}");
        continue;
      }

      final decoded = jsonDecode(resp.body);
      final content =
          decoded['choices']?[0]?['message']?['content'] as String?;

      if (content == null || content.trim().isEmpty) {
        debugPrint("⚠️ [$modelName] Empty content");
        continue;
      }

      final cleaned = _stripCodeFence(content.trim());
      final parsed = jsonDecode(cleaned) as Map<String, dynamic>;

      // ✅ minimal validation
      if (!parsed.containsKey('word') ||
          !parsed.containsKey('definition') ||
          !parsed.containsKey('examples') ||
          !parsed.containsKey('voice_prompt')) {
        debugPrint(
            "⚠️ [$modelName] Missing required keys: ${parsed.keys}");
        continue;
      }

      debugPrint(
          "✅ Word generated (${parsed['word']}) | Stage ${progress.stage}");
      return parsed;
    } catch (e) {
      debugPrint("❌ Word error ($modelName): $e");
    }
  }

  debugPrint("❗ All models failed to fetch word details");
  throw Exception('Failed to fetch word details');
}



  String _stripCodeFence(String s) {
    if (s.startsWith('```')) {
      final idx = s.indexOf('\n');
      if (idx >= 0) {
        // remove first fence line and last fence
        final withoutFirst = s.substring(idx + 1);
        final lastFence = withoutFirst.lastIndexOf('```');
        if (lastFence >= 0) return withoutFirst.substring(0, lastFence).trim();
      }
    }
    return s;
  }

// 🔧 JSON Repair Functions
String _ultraRepairJson(String json) {
  String repaired = json
      .replaceAll(""", '"')
      .replaceAll(""", '"')
      .replaceAll("'", "'")
      .replaceAll("'", "'")
      .replaceAll("\n", " ")
      .replaceAll("\r", " ")
      .replaceAll("\t", " ")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  // Remove trailing commas
  repaired = repaired.replaceAll(RegExp(r',\s*}'), '}');
  repaired = repaired.replaceAll(RegExp(r',\s*]'), ']');
  
  // Fix incomplete JSON
  int openBraces = '{'.allMatches(repaired).length;
  int closeBraces = '}'.allMatches(repaired).length;
  
  if (openBraces > closeBraces) {
    repaired += '}' * (openBraces - closeBraces);
  }

  int openBrackets = '['.allMatches(repaired).length;
  int closeBrackets = ']'.allMatches(repaired).length;
  
  if (openBrackets > closeBrackets) {
    int insertPos = repaired.lastIndexOf('}');
    if (insertPos > 0) {
      repaired = repaired.substring(0, insertPos) + 
                ']' * (openBrackets - closeBrackets) + 
                repaired.substring(insertPos);
    }
  }

  return repaired;
}

// ✅ Validate Grammar Structure
bool _validateGrammarStructure(Map<String, dynamic> data) {
  try {
    // Check required top-level keys
    if (!data.containsKey('title') || 
        !data.containsKey('theory') || 
        !data.containsKey('examples') ||
        !data.containsKey('arrange_questions')) {
      debugPrint("❌ Missing required keys");
      return false;
    }

    // Check title and theory are not empty
    if (data['title'].toString().trim().isEmpty || 
        data['theory'].toString().trim().isEmpty) {
      debugPrint("❌ Empty title or theory");
      return false;
    }

    // Check examples is a list with at least 1 item
    final examples = data['examples'];
    if (examples is! List || examples.isEmpty) {
      debugPrint("❌ Examples missing or empty");
      return false;
    }

    // Check arrange_questions is a list with at least 3 items
    final questions = data['arrange_questions'];
    if (questions is! List || questions.length < 3) {
      debugPrint("❌ Need at least 3 arrange questions, got ${questions is List ? questions.length : 0}");
      return false;
    }

    // Validate first question structure
    final firstQ = questions[0];
    if (!firstQ.containsKey('sentence') || 
        !firstQ.containsKey('meaning') ||
        !firstQ.containsKey('words') ||
        !firstQ.containsKey('answer')) {
      debugPrint("❌ Question missing required fields");
      return false;
    }

    return true;
  } catch (e) {
    debugPrint("❌ Validation error: $e");
    return false;
  }
}

// 🆘 Fallback Grammar
Map<String, dynamic> _getFallbackGrammar(String langName) {
  return {
    "title": "Simple Present Tense",
    "theory": "We use the simple present tense to talk about things we do regularly.",
    "examples": [
      "I eat breakfast every day",
      "She reads books",
      "They play games"
    ],
    "arrange_questions": [
      {
        "sentence": "I eat rice",
        "meaning": langName == "Malayalam" ? "ഞാൻ ചോറ് കഴിക്കുന്നു" : "I eat rice",
        "words": ["I", "eat", "rice"],
        "answer": ["I", "eat", "rice"]
      },
      {
        "sentence": "She drinks water",
        "meaning": langName == "Malayalam" ? "അവൾ വെള്ളം കുടിക്കുന്നു" : "She drinks water",
        "words": ["She", "drinks", "water"],
        "answer": ["She", "drinks", "water"]
      },
      {
        "sentence": "He plays games",
        "meaning": langName == "Malayalam" ? "അവൻ കളികൾ കളിക്കുന്നു" : "He plays games",
        "words": ["He", "plays", "games"],
        "answer": ["He", "plays", "games"]
      }
    ]
  };
}




// // 🔥 Main Function
// Future<Map<String, dynamic>> fetchGrammarRuleWithExample() async {
//   final prefs = await SharedPreferences.getInstance();

//   final selectedLangCode =
//       prefs.getString('selected_language_code')?.toLowerCase() ?? 'en';
//   final selectedLangName =
//       prefs.getString('selected_language') ?? 'English';
//   final userLevel = prefs.getString('selected_level') ?? 'beginner';

//   // 🔥 GLOBAL LEARNING PROGRESSION
//   final progress = await LearningProgression.today();

//   debugPrint(
//       "📘 Grammar | Day ${progress.day} | Stage ${progress.stage} | Level $userLevel");

//   final systemPrompt = """You are a JSON-only API that generates English grammar lessons.
// You MUST return ONLY valid JSON. No markdown, no comments, no explanations.

// CRITICAL JSON RULES:
// - Use double quotes (") only, never single quotes (')
// - No trailing commas in arrays or objects
// - No line breaks inside strings
// - No punctuation inside word arrays
// - Complete all arrays and objects
// - Every string must be on one line""";

//   final questionCount = progress.stage < 2 ? 8 : 12;

//   final userPrompt = """Generate ONE English grammar rule for $userLevel learner (day ${progress.day}, stage ${progress.stage}).

// ${progress.difficultyHint}

// Output ONLY this exact JSON structure (COMPLETE ALL FIELDS):
// {
//   "title": "Grammar rule name",
//   "theory": "Short explanation in simple English (one sentence)",
//   "examples": [
//     "Example sentence 1",
//     "Example sentence 2",
//     "Example sentence 3"
//   ],
//   "arrange_questions": [
//     {
//       "sentence": "He drinks water",
//       "meaning": "Translation in $selectedLangName",
//       "words": ["He", "drinks", "water"],
//       "answer": ["He", "drinks", "water"]
//     }
//   ]
// }

// REQUIREMENTS:
// - Create EXACTLY $questionCount arrange questions
// - Keep sentences very simple for stage ${progress.stage}
// - sentence in English, meaning in $selectedLangName
// - NO punctuation in word arrays (wrong: ["He,"], correct: ["He"])
// - Use double quotes everywhere
// - COMPLETE all $questionCount questions (no truncation)
// - Each question must have all 4 fields: sentence, meaning, words, answer""";

//   // 🔥 Model list (removed problematic ones)
//   final modelFallbacks = ["gpt-4o-mini", "gpt-4o", "gpt-4-turbo", "gpt-3.5-turbo"];

//   for (final modelName in modelFallbacks) {
//     try {
//       debugPrint("➡️ Trying model: $modelName");

//       final body = {
//         "model": modelName,
//         "temperature": 0.3,  // Lower for consistency
//         "response_format": {"type": "json_object"}, // 🔥 Force JSON mode
//         "messages": [
//           {"role": "system", "content": systemPrompt},
//           {"role": "user", "content": userPrompt}
//         ],
//         "max_tokens": 3000,  // 🔥 Increased for complete response
//       };

//       final resp = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer ${OpenAIConfig.apiKey}",
//         },
//         body: jsonEncode(body),
//       );

//       if (resp.statusCode != 200) {
//         debugPrint("⚠️ Model $modelName failed: ${resp.statusCode}");
//         debugPrint("Response: ${resp.body}");
//         continue;
//       }

//       final responseData = jsonDecode(resp.body);
//       final content = responseData['choices']?[0]?['message']?['content'];
      
//       if (content == null || content.toString().trim().isEmpty) {
//         debugPrint("⚠️ Empty response from $modelName");
//         continue;
//       }

//       // 🧹 Clean markdown
//       String jsonString = content.toString()
//           .replaceAll("```json", "")
//           .replaceAll("```", "")
//           .trim();

//       debugPrint("🧠 Grammar raw ($modelName, ${jsonString.length} chars):");
//       debugPrint(jsonString.substring(0, jsonString.length > 300 ? 300 : jsonString.length));

//       // 🔧 Ultra repair
//       jsonString = _ultraRepairJson(jsonString);

//       Map<String, dynamic> decoded;
//       try {
//         decoded = jsonDecode(jsonString);
//       } catch (e) {
//         debugPrint("❌ JSON parse error ($modelName): $e");
//         debugPrint("📝 First 500 chars: ${jsonString.substring(0, jsonString.length > 500 ? 500 : jsonString.length)}");
//         continue;
//       }

//       // ✅ Validate structure
//       if (!_validateGrammarStructure(decoded)) {
//         debugPrint("⚠️ Invalid structure from $modelName");
//         debugPrint("Keys present: ${decoded.keys.toList()}");
//         if (decoded.containsKey('arrange_questions')) {
//           final questions = decoded['arrange_questions'];
//           debugPrint("Questions count: ${questions is List ? questions.length : 'not a list'}");
//         }
//         continue;
//       }

//       debugPrint("✅ Grammar generated successfully (Stage ${progress.stage}, ${(decoded['arrange_questions'] as List).length} questions)");
//       return decoded;
      
//     } catch (e, stackTrace) {
//       debugPrint("❌ Grammar error ($modelName): $e");
//       debugPrint("Stack: $stackTrace");
//     }
//   }

//   debugPrint("❗ All models failed for grammar - using fallback");
  
//   // 🆘 Fallback: Return basic grammar lesson
//   return _getFallbackGrammar(selectedLangName);
// }}




/// ================= MAIN FUNCTION =================
/// ================= DAILY GRAMMAR SYLLABUS =================
/// 👉 ONE RULE PER DAY (ROTATES)

 final List<String> _dailyGrammarRules = [

  // 🔰 BEGINNER (Days 1–15)
  "simple present tense",
  "is and are usage",
  "this and that",
  "these and those",
  "a and an articles",
  "plural nouns",
  "subject pronouns",
  "object pronouns",
  "can for ability",
  "can for permission",
  "there is and there are",
  "basic adjectives",
  "basic prepositions (in on at)",
  "possessive adjectives (my your)",
  "imperative sentences",

  // 🟡 ELEMENTARY (Days 16–30)
  "simple past tense",
  "regular past verbs",
  "irregular past verbs",
  "past tense negative sentences",
  "past tense questions",
  "future with will",
  "future with going to",
  "present continuous tense",
  "present continuous questions",
  "present continuous negative",
  "countable and uncountable nouns",
  "some and any",
  "much and many",
  "how much and how many",
  "basic conjunctions (and but because)",

  // 🟢 PRE-INTERMEDIATE (Days 31–45)
  "comparative adjectives",
  "superlative adjectives",
  "adverbs of frequency",
  "order of adjectives",
  "prepositions of time",
  "prepositions of place",
  "simple questions with do and does",
  "wh questions",
  "whose what where when why",
  "possessive nouns",
  "have and has",
  "have got usage",
  "like love hate with verb ing",
  "gerund as subject",
  "infinitive with to",

  // 🔵 INTERMEDIATE (Days 46–60)
  "present perfect tense",
  "present perfect with ever never",
  "present perfect vs past simple",
  "since and for",
  "already yet just",
  "modal verbs should must",
  "modal verbs may might",
  "comparisons with as as",
  "too and enough",
  "question tags",
  "passive voice simple present",
  "passive voice simple past",
  "reported speech statements",
  "reported speech questions",
  "relative pronouns who which that",

  // 🟣 ADVANCED (Days 61–75)
  "past continuous tense",
  "past continuous vs past simple",
  "future continuous tense",
  "future perfect tense",
  "conditionals zero conditional",
  "conditionals first conditional",
  "conditionals second conditional",
  "conditionals third conditional",
  "mixed conditionals",
  "passive voice present perfect",
  "passive voice future",
  "reported speech commands",
  "indirect questions",
  "causative have get",
  "used to and would",

  // 🔴 SPEAKING & REAL LIFE (Days 76–90)
  "polite requests",
  "asking for permission",
  "giving advice",
  "making suggestions",
  "agreeing and disagreeing",
  "expressing opinions",
  "talking about habits",
  "describing daily routine",
  "talking about past experiences",
  "talking about future plans",
  "giving directions",
  "ordering food sentences",
  "shopping conversations",
  "phone conversation grammar",
  "formal vs informal sentences",
];

/// ================= MAIN FUNCTION =================
String cleanJson(String s) {
  return s
      .replaceAll("\n", " ")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

Future<Map<String, dynamic>> fetchGrammarRuleWithExample() async {
  final prefs = await SharedPreferences.getInstance();

  final selectedLangName =
      prefs.getString('selected_language') ?? 'English';
  final userLevel = prefs.getString('selected_level') ?? 'beginner';

  /// 🔥 DAY NUMBER (GLOBAL & STABLE)
  final int todayDay =
      DateTime.now().difference(DateTime(2024, 1, 1)).inDays;

  /// 🔥 PICK TODAY'S GRAMMAR RULE
  final String grammarRule =
      _dailyGrammarRules[todayDay % _dailyGrammarRules.length];

  /// 🔥 USED PATTERNS (BLOCK REPEAT)
  final List<String> usedPatterns =
      (prefs.getStringList("used_grammar_patterns") ?? const <String>[])
          .map((e) => e.toString())
          .toList();

  debugPrint("📘 Daily Grammar: $grammarRule");
  debugPrint("📦 Used patterns: ${usedPatterns.length}");


  final systemPrompt = """
You are a JSON-only API that generates English grammar lessons.

CRITICAL RULES:
- Return ONLY valid JSON
- Use double quotes only
- No markdown, no comments
- No trailing commas
- No punctuation in word arrays

STRICT RULES:
- Generate ONLY ONE grammar rule
- Follow the given grammar topic exactly
- Sentences must be very simple
- Do NOT reuse sentence patterns

SESSION_DAY: $todayDay
""";

  final userPrompt = """
Generate ONE English grammar lesson for a $userLevel learner.

GRAMMAR TOPIC:
$grammarRule

Output EXACTLY this JSON:
{
  "title": "Grammar rule name",
  "theory": "One simple sentence explanation",
  "examples": [
    "Example sentence 1",
    "Example sentence 2",
    "Example sentence 3"
  ],
  "arrange_questions": [
    {
      "sentence": "He drinks water",
      "meaning": "Translation in $selectedLangName",
      "words": ["He","drinks","water"],
      "answer": ["He","drinks","water"]
    }
  ]
}

REQUIREMENTS:
- Create EXACTLY 5 arrange questions
- sentence in English
- meaning in $selectedLangName
- No punctuation in word arrays
- Use different sentence patterns
""";



  final models = [
    "gpt-4o-mini",
    "gpt-4o",
    "gpt-4-turbo",
  ];

  for (final model in models) {
    try {
      final resp = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${OpenAIConfig.apiKey}",
        },
        body: jsonEncode({
          "model": model,
          "temperature": 0.5,
          "max_tokens": 2500,
          "response_format": {"type": "json_object"},
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": userPrompt},
          ],
        }),
      );

      if (resp.statusCode != 200) continue;

      final content =
          jsonDecode(resp.body)['choices']?[0]?['message']?['content'];

      if (content == null) continue;

      final decoded = jsonDecode(content.toString());

      if (!_validateGrammarStructure(decoded)) continue;
/// 🔥 Convert sentence → pattern (blocks repeats)
String _toPattern(String sentence) {
  return sentence
      .toLowerCase()
      .replaceAll(RegExp(r'\b(i|you|we|they|he|she|it)\b'), 'S')
      .replaceAll(RegExp(r'\b[a-z]+\b'), 'V');
}

      /// 🔥 PATTERN BLOCK
      final List<String> newPatterns = decoded['arrange_questions']
          .map<String>((q) => _toPattern(q['sentence']))
          .toList();

      if (newPatterns.any((p) => usedPatterns.contains(p))) {
        debugPrint("♻️ Pattern repeat detected → retry");
        continue;
      }

      /// 🔥 SAVE PATTERNS
      final mergedPatterns = <String>{
        ...usedPatterns,
        ...newPatterns,
      }.toList();

      await prefs.setStringList(
          "used_grammar_patterns", mergedPatterns);

      debugPrint("✅ Daily grammar generated successfully");
      return decoded;
    } catch (e) {
      debugPrint("❌ Model error: $e");
    }
  }

  /// 🆘 FALLBACK
  return _fallbackGrammar(selectedLangName, grammarRule);
}



/// ================= HELPERS =================

/// ================= HELPERS =================

Map<String, dynamic> _fallbackGrammar(
    String lang, String rule) {
  return {
    "title": rule,
    "theory": "This rule helps you make simple sentences.",
    "examples": [
      "I like tea",
      "She plays games",
      "They go home"
    ],
    "arrange_questions": [
      {
        "sentence": "I like tea",
        "meaning": "Simple sentence in $lang",
        "words": ["I","like","tea"],
        "answer": ["I","like","tea"]
      }
    ]
  };
}

bool _hasDuplicateSentences(List questions) {
  final seen = <String>{};
  for (final q in questions) {
    final s = q['sentence'].toString().toLowerCase().trim();
    if (seen.contains(s)) return true;
    seen.add(s);
  }
  return false;
}
bool _containsUsedSentence(List questions, List<String> used) {
  for (final q in questions) {
    final s = q['sentence'].toString().toLowerCase();
    if (used.contains(s)) return true;
  }
  return false;
}

// bool _validateGrammarStructure(Map<String, dynamic> data) {
//   if (!data.containsKey('title') ||
//       !data.containsKey('theory') ||
//       !data.containsKey('examples') ||
//       !data.containsKey('arrange_questions')) return false;

//   final questions = data['arrange_questions'];
//   if (questions is! List || questions.isEmpty) return false;

//   for (final q in questions) {
//     if (!(q is Map &&
//         q.containsKey('sentence') &&
//         q.containsKey('meaning') &&
//         q.containsKey('words') &&
//         q.containsKey('answer'))) {
//       return false;
//     }
//   }
//   return true;
// }

// // 🔧 ULTRA JSON REPAIR
// String _ultraRepairJson(String text) {
//   // 1. Fix all quote types
//   text = text
//       .replaceAll(""", '"')
//       .replaceAll(""", '"')
//       .replaceAll("'", '"')
//       .replaceAll("'", '"');

//   // 2. Remove line breaks
//   text = text
//       .replaceAll('\n', ' ')
//       .replaceAll('\r', ' ')
//       .replaceAll(RegExp(r'\s+'), ' ')
//       .trim();

//   // 3. Fix unquoted keys
//   text = text.replaceAll(RegExp(r'(\w+):\s*'), '"1":');

//   // 4. Fix empty array elements
//   text = text.replaceAll(RegExp(r'\[\s*,'), '[');
//   text = text.replaceAll(RegExp(r',\s*,+'), ',');

//   // 5. Remove punctuation from array elements
//   text = text.replaceAll(RegExp(r'"([.,!?;]+)(\w+)([.,!?;]*)"'), '"2"');
//   text = text.replaceAll(RegExp(r'"(\w+)([.,!?;]+)"'), '"1"');

//   // 6. Fix trailing commas
//   text = text.replaceAll(RegExp(r',\s*\]'), ']');
//   text = text.replaceAll(RegExp(r',\s*}'), '}');

//   // 7. Fix missing commas
//   text = text.replaceAll(RegExp(r'"\s+"'), '","');
//   text = text.replaceAll(RegExp(r']\s*\['), '],[');
//   text = text.replaceAll(RegExp(r'}\s*{'), '},{');
//   text = text.replaceAll(RegExp(r']\s*"'), '],"');
//   text = text.replaceAll(RegExp(r'}\s*"'), '},"');

//   // 8. Fix double commas
//   text = text.replaceAll(RegExp(r',+'), ',');

//   // 9. Extract main JSON
//   final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
//   if (match != null) {
//     text = match.group(0)!;
//   }

//   return text;
// }


}
// // ✅ Validate grammar structure
// bool _validateGrammarStructure(Map<String, dynamic> data) {
//   if (!data.containsKey('title') || 
//       !data.containsKey('theory') || 
//       !data.containsKey('examples') ||
//       !data.containsKey('arrange_questions')) {
//     return false;
//   }

//   final examples = data['examples'];
//   final questions = data['arrange_questions'];

//   if (examples is! List || questions is! List) return false;
//   if (examples.isEmpty || questions.isEmpty) return false;

//   // Validate arrange questions structure
//   for (final q in questions) {
//     if (q is! Map) return false;
//     if (!q.containsKey('sentence') || 
//         !q.containsKey('words') || 
//         !q.containsKey('answer')) {
//       return false;
//     }
//   }

//   return true;
// }

// 🆘 Fallback grammar when all models fail
Map<String, dynamic> _getFallbackGrammar(String langName) {
  return {
    "title": "Question nai duga",
    "theory": "We use simple present tense for daily habits and facts. Add 's' or 'es' for he, she, it.",
    "examples": [
      "I eat breakfast every day.",
      "She goes to school.",
      "They play football."
    ],
    "arrange_questions": [
      {
        "sentence": "I like apples",
        "meaning": langName == "Hindi" ? "मुझे सेब पसंद हैं" : "I like apples",
        "words": ["I", "like", "apples"],
        "answer": ["I", "like", "apples"]
      },
      {
        "sentence": "She reads books",
        "meaning": langName == "Hindi" ? "वह किताबें पढ़ती है" : "She reads books",
        "words": ["She", "reads", "books"],
        "answer": ["She", "reads", "books"]
      }
    ]
  };
}



/// Model class to hold a vocabulary word and its image
_TtsConfig _getIndianTtsConfig(String code, String text) {
  double rate;
  double pitch;
  String locale;

  // 🇮🇳 Indian accent base
  switch (code) {
    case 'hi':
      locale = 'hi-IN';
      rate = 0.42;   // very slow Hindi
      pitch = 0.95;  // soft female-teacher tone
      break;

    default:
      locale = 'en-IN';
      rate = 0.46;   // slow Indian English
      pitch = 1.0;
      break;
  }

  // 👶 Very small sentences → EXTRA slow (Day 1–3)
  if (text.length < 40) {
    rate -= 0.06;
  } else if (text.length < 80) {
    rate -= 0.03;
  }

  // Safety limits
  if (rate < 0.35) rate = 0.35;
  if (rate > 0.55) rate = 0.55;

  return _TtsConfig(
    rate: rate,
    pitch: pitch,
    locale: locale,
  );
}



class _TtsConfig {
  final double rate;
  final double pitch;
  final String locale;

  const _TtsConfig({
    required this.rate,
    required this.pitch,
    required this.locale,
  });
}

// class VocabularyWord {
//   final String word;        // English word
//   final String meaning;     // Meaning in selected app language
//   final String imageUrl;

//   VocabularyWord({
//     required this.word,
//     required this.meaning,
//     required this.imageUrl,
//   });

//   factory VocabularyWord.fromJson(Map<String, dynamic> json) {
//     return VocabularyWord(
//       word: json['word'] ?? '',
//       meaning: json['meaning'] ?? '',
//       imageUrl: json['image'] ?? '',
//     );
//   }
// }


/// 🔧 TTS config helper: alag-alag language ke liye alag rate/pitch/locale


_TtsConfig _getTtsConfigForLanguage(String code, String text) {
  final int len = text.length;

  // base values
  double rate;
  double pitch;
  String locale;

  switch (code) {
    case 'hi':
      locale = 'hi-IN';
      rate = 0.5;     // thoda slow, clear Hindi
      pitch = 1.0;
      break;
    case 'bn':
      locale = 'bn-IN';
      rate = 0.48;    // Bengali ke liye bhi slow
      pitch = 1.05;
      break;
    case 'en':
    default:
      locale = 'en-IN';
      rate = 0.55;    // English thoda fast chal sakta hai
      pitch = 1.1;
      break;
  }

  // 🔹 Agar text bahut lamba hai to aur slow kar do
  if (len > 250) {
    rate -= 0.08;
  } else if (len > 150) {
    rate -= 0.05;
  }

  // Limit range (0.3 – 0.8)
  if (rate < 0.3) rate = 0.3;
  if (rate > 0.8) rate = 0.8;

  return _TtsConfig(
    rate: rate,
    pitch: pitch,
    locale: locale,
  );
}



class LearningProgression {
  static const _dayKey = "lp_day";
  static const _stageKey = "lp_stage";
  static const _dateKey = "lp_date";

  static Future<ProgressData> today() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().substring(0, 10);

    int day = prefs.getInt(_dayKey) ?? 1;
    int stage = prefs.getInt(_stageKey) ?? 0;
    String? lastDate = prefs.getString(_dateKey);

    if (lastDate != today) {
      day++;

      // 🔼 every 2 days difficulty increase
      if (day % 2 == 0) stage++;

      await prefs.setInt(_dayKey, day);
      await prefs.setInt(_stageKey, stage);
      await prefs.setString(_dateKey, today);
    }

    return ProgressData(day: day, stage: stage);
  }
}

class ProgressData {
  final int day;
  final int stage;

  ProgressData({required this.day, required this.stage});

  String get difficultyHint {
    switch (stage) {
      case 0:
        return "Use extremely simple words and very short sentences.";
      case 1:
        return "Use simple daily spoken English sentences.";
      case 2:
        return "Use slightly longer sentences with basic meaning.";
      case 3:
        return "Include basic grammar and sentence structure.";
      default:
        return "Use mixed difficulty with practical real-life English.";
    }
  }

  int get questionCount {
    if (stage == 0) return 5;
    if (stage == 1) return 8;
    if (stage == 2) return 12;
    return 15;
  }

  double get ttsSlowFactor {
    if (stage <= 1) return 0.08; // beginners → very slow
    if (stage == 2) return 0.04;
    return 0.0;
  }
}
