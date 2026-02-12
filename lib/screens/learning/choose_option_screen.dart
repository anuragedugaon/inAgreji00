import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/provider/ai_model_/ai_model_repo.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request_model/grammer_request_model.dart';
import '../../services/video_player.dart';
import '../../widgets/message_bubble.dart';
import '../ai_teacher/ai_service.dart';
import 'lessons/fill_the_blank_screen.dart';
class ChooseOptionScreen extends StatefulWidget {
  const ChooseOptionScreen({super.key});

  @override
  State<ChooseOptionScreen> createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreen>
    with SingleTickerProviderStateMixin {
  List<String> options = [];
  List<String> correctAnswer = [];
  String questionText = "Listen and arrange.";
  String meaning = "";

  String? lesson;

  bool _isLoading = true;
  bool isPage = false;

  List<int> selectedIndexes = [];

  List<Map<String, dynamic>> arrangeQuestions = [];
  List<Map<String, dynamic>> fillQuestions = [];
  int currentArrangeIndex = 0;

  int totalCorrect = 0;
  int totalQuestions = 0;

  final List<Map<String, dynamic>> reviewList = [];

  late AnimationController _controller;
  late Animation<Color?> _gradient1;
  late Animation<Color?> _gradient2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _gradient1 = ColorTween(
      begin: Colors.black,
      end: const Color(0xFF001F3F),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _gradient2 = ColorTween(
      begin: const Color(0xFF00BFFF),
      end: const Color(0xFF0077FF),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchQuestions();
    });
  }

  // ===============================
  // 🔥 API BASED DATA FETCH
  // ===============================
  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);

    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();

      final grammarRule = await getRandomGrammarRule(prefs);

      final QuestionResult = await AIModelRepo.generateGrammarLesson(
        request: GrammarLessonRequestSend(
          grammarRule: (grammarRule == null || grammarRule.isEmpty)
              ? "Future simple tense"
              : grammarRule,
          userLevel: appProvider.userDetails?.data?.level?.name ??
              prefs.getString("user_level") ??
              "beginner",
          selectedLanguage: prefs.getString('selected_language') ?? "Tamil",
        ),
      );

      if (QuestionResult == null) {
        throw Exception("No lesson data");
      }

      lesson =
          "${QuestionResult.data.title}\n\n${QuestionResult.data.theory}";

      arrangeQuestions = QuestionResult.data.arrangeQuestions.map((e) {
        return {
          "sentence": e.sentence,
          "meaning": e.meaning,
          "words": e.words,
          "answer": e.answer,
          "explanation": e.explanation,
        };
      }).toList();

      fillQuestions = QuestionResult.data.fillQuestions.map((e) {
        return {
          "question": e.question,
          "meaning": e.meaning,
          "wordList": e.wordList,
          "answer": e.answer,
        };
      }).toList();

      totalQuestions = arrangeQuestions.length + fillQuestions.length;

      if (arrangeQuestions.isNotEmpty) {
        _loadArrangeQuestion(0);
      }

      // ✅ Speak lesson after loading
      if (lesson != null && lesson!.isNotEmpty) {
        debugPrint("🗣️ Speaking lesson");
        AIService().readAloud(lesson!);
      }
    } catch (e) {
      debugPrint("❌ Error loading grammar lesson: $e");
      showResultSnackBar(
        context,
        "Error loading grammar lesson.",
        false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _loadArrangeQuestion(int index) {
    if (index < 0 || index >= arrangeQuestions.length) return;

    final q = arrangeQuestions[index];

    setState(() {
      questionText = q["sentence"];
      meaning = q["meaning"];
      options = List<String>.from(q["words"]);
      correctAnswer = List<String>.from(q["answer"]);
      selectedIndexes.clear();
    });

    // ✅ Speak question
    debugPrint("🗣️ Speaking question: $questionText");
    AIService().readAloud(questionText);
  }

  void _onWordTap(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
    debugPrint("📝 Selected indexes: $selectedIndexes");
  }

  void _onCheckArrange() {
    if (selectedIndexes.isEmpty) {
      showResultSnackBar(context, "Please select words first!", false);
      return;
    }

    final userWords = selectedIndexes.map((i) => options[i]).toList();
    final correctWords = List<String>.from(correctAnswer);

    String normalize(String s) =>
        s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

    final isCorrect = normalize(userWords.join(" ")) ==
        normalize(correctWords.join(" "));

    reviewList.add({
      "type": "arrange",
      "question": questionText,
      "correct": correctWords.join(" "),
      "user": userWords.join(" "),
      "isCorrect": isCorrect,
    });

    if (isCorrect) {
      totalCorrect++;
      showResultSnackBar(context, "🎉 Correct!", true);
      debugPrint("🎉 Correct answer!");
    } else {
      showResultSnackBar(
        context,
        "❌ Correct: ${correctWords.join(" ")}",
        false,
      );
      debugPrint("❌ Wrong. Correct: ${correctWords.join(" ")}");
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (currentArrangeIndex < arrangeQuestions.length - 1) {
        currentArrangeIndex++;
        _loadArrangeQuestion(currentArrangeIndex);
      } else {
        debugPrint("➡️ Moving to Fill The Blank screen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FillTheBlankScreen(
              questions: fillQuestions,
              initialCorrect: totalCorrect,
              totalQuestions: totalQuestions,
              reviewList: reviewList,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // ✅ Stop TTS when leaving screen
    AIService().stopSpeaking();
    debugPrint("🛑 ChooseOption screen disposed");
    super.dispose();
  }

  // ===============================
  // 🖼️ UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_gradient1.value!, _gradient2.value!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // ✅ Fixed header with back button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios,
                                        color: Colors.cyanAccent),
                                    onPressed: () {
                                      AIService().stopSpeaking();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: arrangeQuestions.isEmpty
                                          ? 0
                                          : (currentArrangeIndex + 1) /
                                              arrangeQuestions.length,
                                      backgroundColor: Colors.white12,
                                      color: Colors.orangeAccent,
                                      minHeight: 4,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isPage
                                    ? "Arrange the sentence"
                                    : "Grammar Lesson",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // ✅ Teacher Animation
                                SizedBox(
                                  height: 250,
                                  child: TeacherAnimation(),
                                ),
                                const SizedBox(height: 20),
                                isPage ? _wordArrange() : _grammarLesson(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _grammarLesson() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            lesson ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isPage = true;
                  });
                  debugPrint("▶️ Starting practice");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Colors.cyanAccent,
                      width: 1.5,
                    ),
                  ),
                  shadowColor: Colors.cyanAccent.withOpacity(0.6),
                ),
                child: const Text(
                  "Start Practice",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: () {
                if (lesson != null && lesson!.isNotEmpty) {
                  debugPrint("🔊 Replaying lesson");
                  AIService().readAloud(lesson!);
                }
              },
              icon: const Icon(Icons.volume_up, color: Colors.white70),
              label: const Text(
                "Listen",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _wordArrange() {
    return Column(
      children: [
        // ✅ Meaning/Hint
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            meaning,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ✅ Selected sentence box
        Container(
          constraints: const BoxConstraints(minHeight: 70),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.3),
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            selectedIndexes.isEmpty
                ? "Tap the words below to build the sentence"
                : selectedIndexes.map((i) => options[i]).join(" "),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // ✅ Word chips
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: List.generate(options.length, (index) {
            final selected = selectedIndexes.contains(index);
            return GestureDetector(
              onTap: () => _onWordTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.cyanAccent.withOpacity(0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? Colors.cyanAccent
                        : Colors.cyanAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: selected ? Colors.cyanAccent : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 30),

        // ✅ Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _onCheckArrange,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Colors.cyanAccent,
                      width: 1.5,
                    ),
                  ),
                  shadowColor: Colors.cyanAccent.withOpacity(0.6),
                ),
                child: const Text(
                  "CHECK",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: () {
                debugPrint("🔊 Replaying question");
                AIService().readAloud(questionText);
              },
              icon: const Icon(Icons.volume_up, color: Colors.white70),
              label: const Text(
                "Listen",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ===============================
// ✅ HELPER: Random Grammar Rule
// ===============================
// Future<String?> getRandomGrammarRule(SharedPreferences prefs) async {
//   // Your implementation here
//   return prefs.getString("selected_grammar_rule")?.trim();
// }








final List<String> allGrammarRules = [
  "Present simple tense",
  "Present continuous tense",
  "Present perfect tense",
  "Present perfect continuous tense",

  "Past simple tense",
  "Past continuous tense",
  "Past perfect tense",
  "Past perfect continuous tense",

  "Future simple tense",
  "Future continuous tense",
  "Future perfect tense",
  "Future perfect continuous tense",

  "Present simple tense",
  "Present continuous tense",
  "Present perfect tense",
  "Present perfect continuous tense",
  "Past simple tense",
  "Past continuous tense",
  "Past perfect tense",
  "Past perfect continuous tense",
  "Future simple tense",
  "Future continuous tense",
  "Future perfect tense",
  "Future perfect continuous tense",
  "Comparative and superlative adjectives",
  "Countable and uncountable nouns",
  "Modal verbs (can, could, may, might, must)",
  "Passive voice",
  "Conditionals (zero, first, second, third)",
  "Reported speech",
  "Relative clauses",
  "Gerunds and infinitives",
  "Articles (a, an, the)",
 "Affirmative sentences",
  "Negative sentences",
  "Interrogative sentences",
  "Wh-questions",
  "Yes/No questions",
  "Imperative sentences",
  "Exclamatory sentences",
  "Nouns",
  "Pronouns",
  "Verbs",
  "Adjectives",
  "Adverbs",
  "Prepositions",
  "Conjunctions",
  "Interjections",
  "Articles (a, an, the)",
  "Determiners",
  "Subject-verb agreement",
  "Modal verbs (can, could, should, must, may)",
  "Auxiliary verbs (do, does, did)",
  "Gerunds",
  "Infinitives",
  "Active voice",
  "Passive voice",
  "Direct and indirect speech",
  "Conditional sentences (0, 1st, 2nd, 3rd)",
  "Question tags",
  "Relative clauses",
  "Comparatives and superlatives",
  "Possessive forms",
  "Phrasal verbs",
  "Countable and uncountable nouns",
  "Quantifiers (some, any, much, many, few, little)",
  "Punctuation rules",
];
final List<String> sentenceRules = [
 
];



Future<String> getRandomGrammarRule(SharedPreferences prefs) async {
  final allRules = allGrammarRules;

  // previously used rules load
  final usedRulesString = prefs.getString("used_grammar_rules");
  final usedRules = usedRulesString != null
      ? Set<String>.from(jsonDecode(usedRulesString))
      : <String>{};

  // if all used then reset
  if (usedRules.length >= allRules.length) {
    usedRules.clear();
  }

  // pick random unused rule
  final unusedRules = allRules.where((rule) => !usedRules.contains(rule)).toList();
  final randomRule = unusedRules[Random().nextInt(unusedRules.length)];

  // save used rule
  usedRules.add(randomRule);
  await prefs.setString("used_grammar_rules", jsonEncode(usedRules.toList()));

  return randomRule;
}


// class ChooseOptionScreen extends StatefulWidget {
//   const ChooseOptionScreen({super.key});

//   @override
//   State<ChooseOptionScreen> createState() => _ChooseOptionScreenState();
// }

// class _ChooseOptionScreenState extends State<ChooseOptionScreen>
//     with SingleTickerProviderStateMixin {
//   // Current arrange question data
//   List<String> options = [];
//   List<String> correctAnswer = [];
//   String questionText = "Listen and arrange.";
//   String meaning="";

//   // Grammar lesson
//   String? lesson;

//   // State
//   bool _isSpeaking = false;
//   bool _isLoading = true;
//   bool isPage = false; // false = show lesson, true = show arrange

//   List<int> selectedIndexes = [];

//   // Full sets
//   List<Map<String, dynamic>> arrangeQuestions = [];
//   List<Map<String, dynamic>> fillQuestions = [];
//   int currentArrangeIndex = 0;

//   int totalCorrect = 0;
//   int totalQuestions = 0; // 10 arrange + 10 fill = 20 (expected)

//   // 🔴 NEW: review list (arrange + fill sab yahi store honge)
//   final List<Map<String, dynamic>> reviewList = [];

//   late AnimationController _controller;
//   late Animation<Color?> _gradient1;
//   late Animation<Color?> _gradient2;

//   final FlutterTts _flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat(reverse: true);

//     _gradient1 = ColorTween(begin: Colors.black, end: const Color(0xFF001F3F))
//         .animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//     _gradient2 = ColorTween(
//       begin: const Color(0xFF00BFFF),
//       end: const Color(0xFF0077FF),
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchQuestions();
//     });
//   }

//   Future<void> _fetchQuestions() async {
//     setState(() => _isLoading = true);
//     final service = DailyGrammarService();

//     try {
//       final result =
//           await service.getDailyLessonWithQuestions(extraContext: "Fluent");


//           debugPrint("===============================================$result");

//       if (result.isNotEmpty && result["error"] == null) {
//         final List<dynamic> arrangeRaw = result["arrange_questions"] ?? [];
//         final List<dynamic> fillRaw = result["fill_questions"] ?? [];

//         arrangeQuestions =
//             arrangeRaw.whereType<Map<String, dynamic>>().toList();
//         fillQuestions = fillRaw.whereType<Map<String, dynamic>>().toList();

//         lesson = result["lesson"] ?? "";
//             _speakText(lesson!); // Speak lesson when loaded


//         totalQuestions =
//             arrangeQuestions.length + fillQuestions.length; // usually 20

//         if (arrangeQuestions.isNotEmpty) {
//           _loadArrangeQuestion(0); // this will also speak the first question
//         }

//         // Speak the lesson once at the start
//         _speakLesson();
//       }
//     } catch (e) {
//       debugPrint("❌ API Error: $e");
//       showResultSnackBar(
//         context,
//         "Error loading questions. Please try again.",
//         true,
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// Load one arrange-sentence question by index
//   void _loadArrangeQuestion(int index) {
//     if (index < 0 || index >= arrangeQuestions.length) return;

//     final q = arrangeQuestions[index];

//     setState(() {
//       questionText = q["sentence"] ?? "Listen and arrange.";
//       meaning=q['meaning'];
//       options = List<String>.from(q["words"] ?? []);
//       correctAnswer = List<String>.from(q["answer"] ?? []);
//       selectedIndexes.clear();
//     });

//     // 👇 Har naya question load hone par TTS se sentence read karo
//     _speakText(questionText);
//   }

//   Future<void> _speakLesson() async {
//     if (lesson == null || lesson!.isEmpty) return;
//    AIService().readAloud( lesson!);

//     // await _flutterTts.setLanguage("en-IN");
//     // await _flutterTts.setPitch(1.0);
//     // await _flutterTts.setSpeechRate(0.55);
//     // await _flutterTts.setVolume(1.0);

//     // setState(() => _isSpeaking = true);
//     // await _flutterTts.speak(lesson!);
//     // _flutterTts.setCompletionHandler(() {
//     //   if (mounted) setState(() => _isSpeaking = false);
//     // });
//   }



//   Future<void> _speakText(String text) async {
//    AIService().readAloud( text);

//     // await _flutterTts.setLanguage("en-IN");
//     // await _flutterTts.setPitch(1.0);
//     // await _flutterTts.setSpeechRate(0.55);
//     // await _flutterTts.setVolume(1.0);

//     // setState(() => _isSpeaking = true);
//     // await _flutterTts.speak(text);
//     // _flutterTts.setCompletionHandler(() {
//     //   if (mounted) setState(() => _isSpeaking = false);
//     // });
//   }

//   void _onWordTap(int index) {
//     setState(() {
//       if (selectedIndexes.contains(index)) {
//         selectedIndexes.remove(index);
//       } else {
//         selectedIndexes.add(index);
//       }
//     });
//   }

//   /// ✅ Check arrange-sentence answer
//   void _onCheckArrange() {
//     if (selectedIndexes.isEmpty) {
//       showResultSnackBar(context, "Please select words first!", false);
//       return;
//     }

//     // 1️⃣ User sentence banao
//     final userWords = selectedIndexes.map((i) => options[i]).toList();
//     final correctWords = List<String>.from(correctAnswer);

//     String normalize(String s) =>
//         s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

//     final userSentence = normalize(userWords.join(" "));
//     final correctSentence = normalize(correctWords.join(" "));

//     final bool isCorrect = userSentence == correctSentence;

//     // 🔴 REVIEW ENTRY ADD (arrange)
//     reviewList.add({
//       "type": "arrange",
//       "question": questionText,
//       "correct": correctWords.join(" "),
//       "user": userWords.join(" "),
//       "isCorrect": isCorrect,
//     });

//     // 2️⃣ Score update sirf correct pe
//     if (isCorrect) {
//       totalCorrect++;
//       showResultSnackBar(context, "🎉 Great! Correct Sentence!", true);
//     } else {
//       showResultSnackBar(
//         context,
//         "❌ Incorrect! Correct: ${correctWords.join(" ")}",
//         false,
//       );
//     }

//     // 3️⃣ Hamesha next question pe jao (right ya wrong)
//     Future.delayed(const Duration(milliseconds: 800), () {
//       if (!mounted) return;

//       if (currentArrangeIndex < arrangeQuestions.length - 1) {
//         setState(() {
//           currentArrangeIndex++;
//         });
//         _loadArrangeQuestion(currentArrangeIndex);
//       } else {
//         // Arrange khatam → Fill in the blanks flow
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FillTheBlankScreen(
//               questions: fillQuestions,
//               initialCorrect: totalCorrect,
//               totalQuestions: totalQuestions,
//               reviewList: reviewList, // 👈 yahan pass kiya
//             ),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Colors.cyanAccent),
//             )
//           : AnimatedBuilder(
//               animation: _controller,
//               builder: (context, _) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [_gradient1.value!, _gradient2.value!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Approx progress (arrange only)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10.0),
//                               child: LinearProgressIndicator(
//                                 value: arrangeQuestions.isEmpty
//                                     ? 0
//                                     : (currentArrangeIndex + 1) /
//                                         (arrangeQuestions.length.toDouble()),
//                                 backgroundColor: Colors.white12,
//                                 color: Colors.orangeAccent,
//                                 minHeight: 4,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             const SizedBox(height: 25),

//                             Text(
//                               isPage
//                                   ? "Arrange the sentence"
//                                   : "Grammar Lesson",
//                               style: const TextStyle(
//                                 color: Colors.cyanAccent,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             TeacherAnimation(),

//                              if(!isPage)const SizedBox(height: 16),
//                             if(isPage)  Text(
//           meaning,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: 30,),

//                             isPage ? _wordArrange() : _grammarLesson(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Widget _grammarLesson() {
//     return Column(
//       children: [
//         Text(
//           lesson ?? "",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 40),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         setState(() {
        //           isPage = true;
        //         });
        //       },
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.transparent,
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 40,
        //           vertical: 12,
        //         ),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //           side: const BorderSide(
        //             color: Colors.cyanAccent,
        //             width: 1.5,
        //           ),
        //         ),
        //         shadowColor: Colors.cyanAccent.withOpacity(0.6),
        //       ),
        //       child: const Text(
        //         "Start Practice",
        //         style: TextStyle(
        //           color: Colors.cyanAccent,
        //           fontSize: 16,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     TextButton(
        //       onPressed: _speakLesson,
        //       child: const Text(
        //         "🔁 Listen Lesson",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 15,
        //           decoration: TextDecoration.underline,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _wordArrange() {
//     return Column(
//       children: [
//         // Selected words



        // Container(
        //   height: 60,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: Colors.cyanAccent.withOpacity(0.3),
        //       width: 1.2,
        //     ),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   alignment: Alignment.center,
        //   child: Text(
        //     selectedIndexes.isEmpty
        //         ? ""
        //         : selectedIndexes.map((i) => options[i]).join(" "),
        //     style: const TextStyle(
        //       color: Colors.white,
        //       fontSize: 18,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 30),



        // Wrap(
        //   alignment: WrapAlignment.center,
        //   spacing: 12,
        //   runSpacing: 12,
        //   children: List.generate(options.length, (index) {
        //     final word = options[index];
        //     final selected = selectedIndexes.contains(index);



//             return GestureDetector(
//               onTap: () => _onWordTap(index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: selected
//                       ? Colors.cyanAccent.withOpacity(0.3)
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: selected
//                         ? Colors.cyanAccent
//                         : Colors.cyanAccent.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Text(
//                   word,
//                   style: TextStyle(
//                     color: selected ? Colors.cyanAccent : Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),

//         const SizedBox(height: 30),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: selectedIndexes.isNotEmpty ? _onCheckArrange : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 40,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: const BorderSide(
//                     color: Colors.cyanAccent,
//                     width: 1.5,
//                   ),
//                 ),
//                 shadowColor: Colors.cyanAccent.withOpacity(0.6),
//               ),
//               child: const Text(
//                 "CHECK",
//                 style: TextStyle(
//                   color: Colors.cyanAccent,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () => _speakText(questionText),
//               child: const Text(
//                 "🔁 Listen Again",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



