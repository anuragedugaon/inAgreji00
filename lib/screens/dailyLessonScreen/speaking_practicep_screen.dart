
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:inangreji_flutter/provider/ai_model_/ai_model_repo.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionStatusGetters;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../models/request_model/speaking_practice_request_model.dart';
import '../../models/request_model/speaking_question_request_model.dart';
import '../../models/speaking_question_response_model.dart';
import '../../provider/app_provider.dart';
import '../ai_teacher/ai_service.dart';
import 'openai_service.dart';
import 'swipeable_cards_screen.dart';

// ==================== CELEBRATION SCREEN ====================
class CelebrationScreenIn extends StatefulWidget {

  const CelebrationScreenIn({
    super.key,
  });

  @override
  State<CelebrationScreenIn> createState() => _CelebrationScreenInState();
}



/// ==================== CELEBRATION SCREEN STATE ====================


class _CelebrationScreenInState extends State<CelebrationScreenIn>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }
  static const Color accent = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 🎉 CONFETTI
            ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              gravity: 0.25,
              emissionFrequency: 0.04,
              numberOfParticles: 45,
              colors: const [
                Colors.green,
                Colors.orange,
                Colors.blue,
                Colors.pink,
                Colors.purple,
                Colors.yellow,
              ],
            ),
      
            // 🎯 CONTENT
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🏆 ICON
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber.withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.6),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 110,
                      color: Colors.amber,
                    ),
                  ),
      
                  const SizedBox(height: 30),
      
                  // 🎉 TITLE
                  const Text(
                    "Lesson Completed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      
                  const SizedBox(height: 12),
      
                  // // 📊 SCORE
                  // Text(
                  //   "Accuracy: ${widget.summary.accuracy.toInt()}%",
                  //   style: const TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 18,
                  //   ),
                  // ),
      
                  const SizedBox(height: 40),
      
                  // ▶️ CONTINUE BUTTON
                  SizedBox(
                    width: 260,
                    height: 56,
                  
                  
                  ),
      
                  const SizedBox(height: 16),
      
                  // 🆕 NEW LESSON BUTTON
                  SizedBox(
                    width: 260,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: accent, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.popUntil(context, (route) => route.isFirst);
      
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SwipeableCardsScreen(),
                          ),
                        );  
                        // 🔥 yahan New Lesson Screen push kar sakta hai
                      },
                      child: const Text(
                        "NEW LESSON",
                        style: TextStyle(
                          color: accent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ==================== CELEBRATION SCREEN END





/// ==================== SPEAKING PRACTICE SCREEN ====================

final List<String> speakPracticeOthersTopics = [
  "Daily conversation",
  "Greetings and introductions",
  "Talking about yourself",
  "Talking about family",
  "Talking about friends",
  "Talking about hobbies",
  "Talking about school",
  "Talking about work",
  "Asking for directions",
  "Restaurant conversation",
  "Shopping conversation",
  "Travel conversation",
  "Hotel conversation",
  "Airport conversation",
  "Doctor / hospital conversation",
  "Emergency situation",
  "Weather conversation",
  "Phone call conversation",
  "Polite requests",
  "Apologies and thanking",
  "Giving opinions",
  "Making plans",
];
Future<String> getRandomUniqueOthersTopic(SharedPreferences prefs) async {
  const key = "used_speak_practice_others_topics";

  final usedString = prefs.getString(key);
  final usedTopics = usedString != null
      ? Set<String>.from(jsonDecode(usedString))
      : <String>{};

  // Reset if all topics used
  if (usedTopics.length >= speakPracticeOthersTopics.length) {
    usedTopics.clear();
  }

  final unusedTopics = speakPracticeOthersTopics
      .where((topic) => !usedTopics.contains(topic))
      .toList();

  final randomTopic = unusedTopics[Random().nextInt(unusedTopics.length)];

  usedTopics.add(randomTopic);
  await prefs.setString(key, jsonEncode(usedTopics.toList()));

  return randomTopic;
}

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  State<SpeakingPracticeScreen> createState() =>
      _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen>
    with TickerProviderStateMixin {
  // ================= SERVICES =================
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AIService _tts = AIService();
  final AIModelRepo aiModelRepo = AIModelRepo();
  final AppProvider appProvider = AppProvider();

  // ================= UI COLORS =================
  static const Color bg = Color(0xFF041F1F);
  static const Color accent = Colors.cyanAccent;
  static const Color successColor = Color(0xFF0E5F3B);
  static const Color errorColor = Color(0xFF6A0F0F);
final List<SpeakingPracticeQuestion> payloadQuestions = [];

  // ================= QUESTIONS =================
  List<SpeakingQuestion> questions = [];
  int _index = 0;
  bool _loading = true;

  // ================= MIC STATE =================
  bool _engineReady = false;
  bool _engineListening = false;
  bool _sessionEnded = false;
  bool _resultShown = false;

  String _recognized = "";
  double _accuracy = 0;

  // ================= ANIMATION =================
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    _initMic();
    _loadQuestions();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim =
        Tween<double>(begin: 1, end: 1.15).animate(_pulse);
  }

  // ================= MIC INIT =================
  Future<void> _initMic() async {
    final perm = await Permission.microphone.request();
    if (!perm.isGranted) return;

    _engineReady = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() => _engineListening = status == "listening");
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _engineListening = false);
      },
    );
  }

  // ================= LOAD QUESTIONS =================
  Future<void> _loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
final randomOthersTopic = await getRandomUniqueOthersTopic(prefs);

    try {
      final response =
          await AIModelRepo.generateSpeakingQuestions(
        request: SpeakingQuestionRequest(
          selectedTopic: randomOthersTopic,
          selectedLanguageName:
              prefs.getString('selected_language') ?? "English",
          selectedLanguageCode:
              prefs.getString("selected_language_code") ?? "en",
          userLevel:
              appProvider.userDetails.data?.level?.name ?? "beginner",
          stage: prefs.getString("stage") ?? "Speaking Basics",
          forbiddenSentences: const [
            "I am hungry",
            "I eat rice",
          ],
        ),
      );

      if (!mounted) return;

      questions = response?.questions ?? [];

      setState(() => _loading = false);

      if (questions.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _startFlow();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // ================= GET CURRENT SENTENCE =================
  String get sentence => questions[_index].sentence;

  // ================= NORMALIZE =================
  String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ================= FLOW =================
  Future<void> _startFlow() async {
    if (_sessionEnded || questions.isEmpty) return;

    _recognized = "";
    _accuracy = 0;
    _resultShown = false;

    await _tts.stop();
    await _tts.speakText(sentence);

    await Future.delayed(const Duration(milliseconds: 500));
    _startListening();
  }

  // ================= MIC START =================
  Future<void> _startListening() async {
    if (!_engineReady ||
        _engineListening ||
        _resultShown ||
        _sessionEnded) return;

    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 200));

    await _speech.listen(
      partialResults: true,
      pauseFor: const Duration(seconds: 5),
      listenFor: const Duration(minutes: 1),
      onResult: (r) {
        if (_resultShown || _sessionEnded) return;
        _recognized = r.recognizedWords;
        _checkMatch();
        if (mounted) setState(() {});
      },
    );
  }

  // ================= MATCH LOGIC =================
  Future<void> _checkMatch() async {
    final target = normalize(sentence).split(" ");
    final spoken = normalize(_recognized).split(" ");

    int matched = 0;
    for (final w in target) {
      if (spoken.contains(w)) matched++;
    }
final payload = SpeakingPracticeRequest(
  questions: [
    SpeakingPracticeQuestion(
      prompt: questions[_index].prompt,
      sentence: sentence,
      hint: spoken.join(" "),
      meaning: questions[_index].meaning,
    ),
  ],
);

    _accuracy = (matched / target.length) * 100;

    if (!_engineListening && _accuracy > 35) {
      _resultShown = true;
      _speech.stop();
      _showResultScreen(_accuracy >= 50);
      await AIModelRepo.sendSpeakingPracticeApi(
  request: payload,
);

    }
  }

  // ================= RESULT SCREEN =================
  void _showResultScreen(bool success) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor:
              success ? successColor : errorColor,
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  success
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 140,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  success ? "CORRECT!" : "TRY AGAIN",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${_accuracy.toInt()}% matched",
                  style: const TextStyle(
                      color: Colors.white70),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        if (_index <
                            questions.length - 1) {
                          setState(() => _index++);
                          _startFlow();
                        } else {
                          _sessionEnded = true;
                          _goNextPage();
                        }
                      },
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: success
                              ? Colors.green
                              : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  // ================= FINAL PAGE =================
  void _goNextPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CelebrationScreenIn(),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: bg,
        body: Center(
          child: CircularProgressIndicator(color: accent),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Text(
            "No speaking questions found",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, "/home"),
        ),
      ),
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Speak the Sentence",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius:
                        BorderRadius.circular(28),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 14,
                    children:
                        normalize(sentence).split(" ").map((w) {
                      final ok = normalize(_recognized)
                          .split(" ")
                          .contains(w);
                      return Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: ok
                              ? Colors.green
                                  .withOpacity(.9)
                              : Colors.white
                                  .withOpacity(.08),
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: ok
                                ? Colors.greenAccent
                                : Colors.white24,
                          ),
                        ),
                        child: Text(
                          w,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _startListening,
              child: ScaleTransition(
                scale: _engineListening
                    ? _pulseAnim
                    : const AlwaysStoppedAnimation(1),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _engineListening
                        ? Colors.red
                        : Colors.grey.shade900,
                    border:
                        Border.all(color: accent, width: 3),
                  ),
                  child: const Icon(Icons.mic,
                      color: Colors.white, size: 44),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _engineListening
                  ? "🎙️ Listening..."
                  : "Tap mic to start",
              style: const TextStyle(
                  color: Colors.white70),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    _pulse.dispose();
    super.dispose();
  }
}

// class SpeakingPracticeScreen extends StatefulWidget {
//   const SpeakingPracticeScreen({super.key});

//   @override
//   State<SpeakingPracticeScreen> createState() =>
//       _SpeakingPracticeScreenState();
// }

// class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen>
//     with TickerProviderStateMixin {
//   // ================= SERVICES =================
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   final AIService _tts = AIService();
//   final OpenAIService _ai = OpenAIService();
//   AIModelRepo aiModelRepo = AIModelRepo();

//   // ================= UI COLORS =================
//   static const Color bg = Color(0xFF041F1F);
//   static const Color accent = Colors.cyanAccent;
//   static const Color successColor = Color(0xFF0E5F3B);
//   static const Color errorColor = Color(0xFF6A0F0F);

//   // ================= QUESTIONS =================
//     late final List<SpeakingQuestion> questions;

//   int _index = 0;
//   bool _loading = true;

//   // ================= MIC STATE =================
//   bool _engineReady = false;
//   bool _engineListening = false; // 🔥 real STT state
//   bool _sessionEnded = false;
//   bool _resultShown = false;

//   String _recognized = "";
//   double _accuracy = 0;

//   // ================= ANIMATION =================
//   late AnimationController _pulse;
//   late Animation<double> _pulseAnim;

//   // ================= INIT =================
//   @override
//   void initState() {
//     super.initState();
//     _initMic();
//     _loadQuestions();

//     _pulse = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);

//     _pulseAnim =
//         Tween<double>(begin: 1, end: 1.15).animate(_pulse);
//   }

//   // ================= MIC INIT =================
//   Future<void> _initMic() async {
//     final perm = await Permission.microphone.request();
//     if (!perm.isGranted) return;

//     _engineReady = await _speech.initialize(
//       onStatus: (status) {
//         if (!mounted) return;

//         setState(() {
//           _engineListening = status == "listening";
//         });
//       },
//       onError: (_) {
//         setState(() {
//           _engineListening = false;
//         });
//       },
//     );
//   }
// Future<void> onSpeakingCorrect() async {
//   final prefs = await SharedPreferences.getInstance();
//   int correct =
//       (prefs.getInt("speaking_correct_today") ?? 0) + 1;
//   await prefs.setInt("speaking_correct_today", correct);
// }
// AppProvider appProvider = AppProvider();
//   // final List<SpeakingQuestion> questions;

//   // ================= LOAD QUESTIONS =================
  
  
//   // Future<void> _loadQuestions() async {
//           // final prefs = await SharedPreferences.getInstance();

//   //   final data = await AIModelRepo.generateSpeakingQuestions(request:   
//   //     SpeakingQuestionRequest(
//   //       selectedTopic: 'others',
//   //      selectedLanguageName: prefs.getString('selected_language') ?? 'English', 
//   //      selectedLanguageCode: prefs.getString("selected_language_code") ?? 'en',
//   //        userLevel: appProvider.userDetails.data?.level?.name  ?? "beginner",     
//   //            stage: prefs.getString("stage") ?? 'Speaking Basics',
//   //         forbiddenSentences: [
//   //           "I am hungry",
//   //   "I eat rice"
//   //         ]
      
//   //     ),
//   //   ).then( (value) {
//   //     questions = value?.questions ?? [];
//   //     setState(() {_loading = false;  });
//   //   },);

//   //   // setState(() {
//   //   //   _questions = data;
//   //   //   _loading = false;
//   //   // });

//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     _startFlow();
//   //   });
//   // }

// Future<void> _loadQuestions() async {
//             final prefs = await SharedPreferences.getInstance();

//   final value = await AIModelRepo.generateSpeakingQuestions(
//     request: SpeakingQuestionRequest(
//       selectedTopic: 'others',
//       selectedLanguageName: prefs.getString('selected_language') ?? 'English', 
//       selectedLanguageCode: prefs.getString("selected_language_code") ?? 'en',
//       userLevel: appProvider.userDetails.data?.level?.name  ?? "beginner",
//       stage: prefs.getString("stage") ?? 'Speaking Basics',
//       forbiddenSentences: const [
//         "I am hungry",
//         "I eat rice",
//       ],
//     ),
//   );

//   if (!mounted) return; // 🔥 FIX

//   questions = value?.questions ?? [];
//   debugPrint("✅ Loaded ${questions.length} speaking questions");

//   setState(() {
//     _loading = false;
//   });

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (mounted) _startFlow();
//   });
// }

//   String get sentence => questions[_index].question;

//   // ================= NORMALIZE =================
//   String normalize(String text) {
//     return text
//         .toLowerCase()
//         .replaceAll(RegExp(r'[^\w\s]'), '')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }

//   // ================= FLOW =================
//   Future<void> _startFlow() async {
//     if (_sessionEnded) return;

//     _recognized = "";
//     _accuracy = 0;
//     _resultShown = false;

//     await _tts.stop();
//     await _tts.speakText(sentence);

//     await Future.delayed(const Duration(milliseconds: 500));
//     _startListening();
//   }

//   // ================= MIC START =================
//   Future<void> _startListening() async {
//     if (!_engineReady || _engineListening || _resultShown || _sessionEnded) {
//       return;
//     }

//     await _speech.stop();
//     await Future.delayed(const Duration(milliseconds: 200));

//     await _speech.listen(
//       partialResults: true,
//       pauseFor: const Duration(seconds: 5),
//       listenFor: const Duration(minutes: 1),
//       onResult: (r) {
//         if (_resultShown || _sessionEnded) return;

//         _recognized = r.recognizedWords;
//         _checkMatch();
//         setState(() {});
//       },
//     );
//   }



//   // ================= MATCH LOGIC =================
//   void _checkMatch() {
//     final target = normalize(sentence).split(" ");
//     final spoken = normalize(_recognized).split(" ");

//     int matched = 0;
//     for (final w in target) {
//       if (spoken.contains(w)) matched++;
//     }

//     _accuracy = (matched / target.length) * 100;

//     if (matched <= target.length&&matched>=1  &&_engineListening==false  && _accuracy>35) {
//       _resultShown = true;
//       _speech.stop();
//       _showResultScreen(_accuracy >= 50);
//     }
//     // else if(matched >= 1 && _engineListening){
//     //    _resultShown = true;
//     //   _speech.stop();
//     //   _showResultScreen(_accuracy >= 50);

//     // }
//   }



//   // ================= RESULT SCREEN =================
//   void _showResultScreen(bool success) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (_, __, ___) {
//         return Scaffold(
//           backgroundColor: success ? successColor : errorColor,
//           body: SafeArea(
//             child: Column(
//               children: [
//                 const Spacer(),
//                 Icon(
//                   success ? Icons.check_circle : Icons.cancel,
//                   size: 140,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   success ? "CORRECT!" : "TRY AGAIN",
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "${_accuracy.toInt()}% matched",
//                   style: const TextStyle(
//                       color: Colors.white70, fontSize: 18),
//                 ),
//                 const Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);

//                         if (_index < questions.length - 1) {
//                           setState(() => _index++);
//                           _startFlow();
//                         } else {
//                           _sessionEnded = true;
//                           _goNextPage();
//                         }
//                       },
//                       child: Text(
//                         "CONTINUE",
//                         style: TextStyle(
//                           color: success ? Colors.green : Colors.red,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (_, anim, __, child) {
//         return SlideTransition(
//           position:
//               Tween(begin: const Offset(0, 1), end: Offset.zero)
//                   .animate(anim),
//           child: child,
//         );
//       },
//     );
//   }

//   // ================= FINAL PAGE =================
//   void _goNextPage() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CelebrationScreenIn(),
//       ),
//     );
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         backgroundColor: bg,
//         body: Center(
//           child: CircularProgressIndicator(color: accent),
//         ),
//       );
//     }

//     return Scaffold(
//        appBar: AppBar(
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pushReplacementNamed(context, '/home');
//         },
//       ),
//     ),
//       backgroundColor: bg,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Speak the Sentence",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),

//             Expanded(
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(28),
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(.05),
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                   child: Wrap(
//                     alignment: WrapAlignment.center,
//                     spacing: 12,
//                     runSpacing: 14,
//                     children: normalize(sentence)
//                         .split(" ")
//                         .map((w) {
//                       final ok =
//                           normalize(_recognized).split(" ").contains(w);
//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 18, vertical: 12),
//                         decoration: BoxDecoration(
//                           color: ok
//                               ? Colors.green.withOpacity(.9)
//                               : Colors.white.withOpacity(.08),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color:
//                                 ok ? Colors.greenAccent : Colors.white24,
//                           ),
//                         ),
//                         child: Text(
//                           w,
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 20),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),

//             GestureDetector(
//               onTap: _startListening,
//               child: ScaleTransition(
//                 scale: _engineListening
//                     ? _pulseAnim
//                     : const AlwaysStoppedAnimation(1),
//                 child: Container(
//                   width: 96,
//                   height: 96,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _engineListening
//                         ? Colors.red
//                         : Colors.grey.shade900,
//                     border: Border.all(color: accent, width: 3),
//                   ),
//                   child: const Icon(Icons.mic,
//                       color: Colors.white, size: 44),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),
//             Text(
//               _engineListening
//                   ? "🎙️ Listening..."
//                   : "Tap mic to start",
//               style:
//                   const TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     _tts.stop();
//     _pulse.dispose();
//     super.dispose();
//   }
// }


