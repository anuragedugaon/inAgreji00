  import 'package:flutter/material.dart';
  import 'package:flutter_tts/flutter_tts.dart';
  import 'package:inangreji_flutter/provider/ai_model_/ai_model_repo.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../../models/request_model/daily_question_request_model.dart';
import '../../services/video_player.dart';
  import '../../widgets/message_bubble.dart';
  import '../ai_teacher/ai_service.dart';
  import '../result/quiz_result_screen.dart';


import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/ai_model_/ai_model_repo.dart';
import '../ai_teacher/ai_service.dart';
import '../result/quiz_result_screen.dart';
import '../../services/video_player.dart';
import '../../widgets/message_bubble.dart';

class DailyQuizScreen extends StatefulWidget {
  const DailyQuizScreen({super.key});

  @override
  State<DailyQuizScreen> createState() => _DailyQuizScreenState();
}

class _DailyQuizScreenState extends State<DailyQuizScreen> {
  final FlutterTts tts = FlutterTts();

  /// 🔥 UI expects Map-based questions → DO NOT CHANGE
  List<Map<String, dynamic>> questions = [];

  int currentIndex = 0;
  int score = 0;
  int? selectedIndex;
  bool loading = true;
  String errorMessage = "";

  /// store selected option index for each question
  List<int?> selectedIndices = [];

  /// 🎨 Theme constants (UNCHANGED)
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color correctOptionColor = Colors.cyanAccent;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // ============================================================
  // 🔥 ONLY LOGIC CHANGE: API → ADAPTER → MAP LIST
  // ============================================================
  Future<void> loadQuestions() async {
    try {
      final response = await AIModelRepo.generateQuizeQuestions();

      if (response == null || response.questions.isEmpty) {
        setState(() {
          loading = false;
          errorMessage = "No questions found.";
        });
        return;
      }

      /// 🔥 ADAPTER: QuizQuestion → Map (UI SAME)
      questions = response.questions.map((q) {
        return {
          "question": q.question,
          "options": q.options,
          "answer": q.correctAnswer,
        };
      }).toList();

      setState(() {
        selectedIndices = List.filled(questions.length, null);
        loading = false;
      });

      AIService().readAloud(questions[currentIndex]["question"]);
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Failed to load quiz.";
      });
    }
  }

  Future<void> _speak(String text) async {
    await tts.setLanguage('en');
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.55);
    await tts.speak(text);
  }

  // ============================================================
  // ✅ CHECK ANSWER (UNCHANGED)
  // ============================================================
  void checkAnswer() async {
    if (selectedIndex == null) {
      showResultSnackBar(context, "Please select an answer first!", false);
      return;
    }

    selectedIndices[currentIndex] = selectedIndex;

    final options = questions[currentIndex]['options'] as List;
    final selected = options[selectedIndex!].toString();
    final correct = questions[currentIndex]['answer'].toString();

    if (selected == correct) {
      score++;
      await AIService().readAloud("Correct!");
      _showSnack("✅ Correct Answer!", true);
    } else {
      await AIService().readAloud("Incorrect, correct answer is $correct");
      _showSnack("❌ Incorrect! Correct: $correct", false);
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          selectedIndex = null;
        });
        AIService().readAloud(questions[currentIndex]["question"]);
      } else {
        showResult();
      }
    });
  }

  void _showSnack(String text, bool correct) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: correct
                  ? [Color(0xFF00FFC6), Color(0xFF00A6FF)]
                  : [Color(0xFFFF4D4D), Color(0xFFB30000)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showResult() async {
    await AIService()
        .readAloud("Your score is $score out of ${questions.length}");

    if (!mounted) return;

    final payload = <DailyQuestionRequest>[];
    payload.add(
      DailyQuestionRequest(
        question: questions[currentIndex]["question"],
        options: List<String>.from(questions[currentIndex]["options"]),
        answer: questions[currentIndex]["answer"],
        explanation: "",
      ),
    );

     AIModelRepo.sendDailyQuestionApi(questions: payload);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: score,
          totalQuestions: questions.length,
          questions: questions,
          selectedIndices: selectedIndices,
          page: 0,
        ),
      ),
    );
  }

  // ============================================================
  // 🖼️ UI (100% SAME)
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        await tts.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/home'),
          ),
        ),
        backgroundColor: backgroundColor,
        body: loading
            ? const Center(
                child: CircularProgressIndicator(color: accentColor),
              )
            : SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: questions.isEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                "Daily Test",
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),

                              /// 👩‍🏫 Teacher animation
                              const SizedBox(
                                height: 140,
                                child: TeacherAnimation(),
                              ),

                              const SizedBox(height: 20),

                              /// ❓ Question
                              Text(
                                questions[currentIndex]["question"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// Options
                              ...List.generate(
                                questions[currentIndex]["options"].length,
                                (i) => Column(
                                  children: [
                                    _buildOption(
                                      i,
                                      questions[currentIndex]["options"][i],
                                    ),
                                    const SizedBox(height: 18),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              ElevatedButton(
                                onPressed: checkAnswer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                        color: accentColor, width: 1.8),
                                  ),
                                ),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: () => AIService().readAloud(
                                    questions[currentIndex]["question"]),
                                child: const Text(
                                  "🔁 Listen Again",
                                  style: TextStyle(
                                    color: accentColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
      ),
    );
  }

  /// 🧱 Option Builder (UNCHANGED)
  Widget _buildOption(int index, String text) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? correctOptionColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? correctOptionColor : accentColor,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? correctOptionColor : textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}



  // class DailyQuizScreen extends StatefulWidget {
  //   const DailyQuizScreen({super.key});

  //   @override
  //   State<DailyQuizScreen> createState() => _DailyQuizScreenState();
  // }

  // class _DailyQuizScreenState extends State<DailyQuizScreen> {
  //   final FlutterTts tts = FlutterTts();

  //   List<dynamic> questions = [];
  //   int currentIndex = 0;
  //   int score = 0;
  //   int? selectedIndex;
  //   bool loading = true;
  //   String errorMessage = "";


  //   // 👉 NEW: store selected option index for each question
  //   List<int?> selectedIndices = [];

  //     // 🎨 Theme constants
  //     static const Color backgroundColor = Colors.black;
  //     static const Color accentColor = Colors.cyanAccent;
  //     static const Color glowColor = Color(0xFF80FFFF);
  //     static const Color textColor = Colors.white;
  //     static const Color correctOptionColor = Colors.cyanAccent;

  //   @override
  //   void initState() {
  //     super.initState();
  //     loadQuestions();
  //   }

  //   Future<void> loadQuestions() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     AIModelRepo.generateQuizeQuestions();
  //     final selectedLang =
  //         "${prefs.getString('selected_language')?.toLowerCase() ?? 'english'} Grammar  ";
  //     questions = await AIService().getCachedDailyQuestions(selectedLang,"Beginner");
  //     setState(() => loading = false);
  //         errorMessage = questions.isEmpty ? "No questions found." : "";

  //     AIService().readAloud(questions[currentIndex]["question"]);
  //   }

  //   Future<void> _speak(String text) async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final selectedLangCode =
  //         prefs.getString('')?.toLowerCase() ?? 'en';

  //     debugPrint("🗣️ Speaking in $selectedLangCode: $text");
  //     errorMessage = text;
  //     await tts.setLanguage(selectedLangCode);
  //     await tts.setPitch(1.0);
  //     await tts.setSpeechRate(0.55);
  //     await tts.speak(text);
  //   }


  // void checkAnswer() async {
  //   // If user didn't pick any option for current question -> show message & stop
  //   if (selectedIndex == null) {
  //     showResultSnackBar(context, "Please select an answer first!", false);
  //     return;
  //   }

  //   // Save the answer for this question (safe write)
  //   if (currentIndex < selectedIndices.length) {
  //     selectedIndices[currentIndex] = selectedIndex;
  //   } else {
  //     selectedIndices.add(selectedIndex);
  //   }

  //   // Safely read selected & correct values (avoid type errors)
  //   final options = questions[currentIndex]['options'];
  //   final selected = (options is List && selectedIndex! >= 0 && selectedIndex! < options.length)
  //       ? options[selectedIndex!].toString()
  //       : selectedIndex!.toString();
  //   final rawCorrect = questions[currentIndex]['answer'];
  //   final correct = rawCorrect is List ? rawCorrect.map((e) => e.toString()).join(' ') : rawCorrect?.toString() ?? '';

  //   // Handle correct/incorrect UI + TTS
  //   if (selected == correct) {
  //     score++;
  //     await  AIService().readAloud("Correct!");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         behavior: SnackBarBehavior.floating,
  //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         content: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(
  //               colors: [Color(0xFF00FFC6), Color(0xFF00A6FF)],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: Colors.cyanAccent, width: 2),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.cyanAccent.withOpacity(0.6),
  //                 blurRadius: 20,
  //                 spreadRadius: 1,
  //               ),
  //             ],
  //           ),
  //           child: const Center(
  //             child: Text(
  //               "✅ Correct Answer!",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18,
  //                 letterSpacing: 1.2,
  //               ),
  //             ),
  //           ),
  //         ),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   } else {
  //     await  AIService().readAloud("Incorrect, correct answer is $correct");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         behavior: SnackBarBehavior.floating,
  //         elevation: 0,
  //         backgroundColor: Colors.transparent,
  //         content: Container(
  //           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(
  //               colors: [Color(0xFFFF4D4D), Color(0xFFB30000)],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: BorderRadius.circular(18),
  //             border: Border.all(color: Colors.white, width: 2),
  //           ),
  //           child: Center(
  //             child: Text(
  //               "❌ Incorrect! Correct: $correct",
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w900,
  //                 letterSpacing: 1.2,
  //               ),
  //             ),
  //           ),
  //         ),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //   }

  //   // Wait a moment then advance or finish
  //   Future.delayed(const Duration(seconds: 1), () {
  //     // If not last question -> next
  //     if (currentIndex < questions.length - 1) {
  //       setState(() {
  //         currentIndex++;
  //         selectedIndex = null; // reset for next question
  //       });
  //       AIService().readAloud(questions[currentIndex]["question"]);
  //       return;
  //     }

  //     // We're at the last question — before showing result, ensure ALL questions have been answered.
  //     // Find the first unanswered index (if any).
  //     final firstUnanswered = selectedIndices.indexWhere((element) => element == null);
  //     if (firstUnanswered != -1) {
  //       // If some earlier question (including question 0) is unanswered, go back to it and notify the user.
  //       setState(() {
  //         currentIndex = firstUnanswered;
  //         selectedIndex = selectedIndices.length > firstUnanswered ? selectedIndices[firstUnanswered] : null;
  //       });

  //       // Show friendly message
  //       showResultSnackBar(context, "Please answer all questions. Jumping to question ${firstUnanswered + 1}.", false);
  //       AIService().readAloud("Please answer question number ${firstUnanswered + 1}");
  //       return;
  //     }

  //     // All questions answered -> show result
  //     showResult();
  //   });
  // }


  // void showResult() async {
  //   await  AIService().readAloud("Your score is $score out of ${questions.length}");
  //   if (!mounted) return;

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => QuizResultScreen(
  //         score: score,
  //         totalQuestions: questions.length,
  //         questions: questions,
  //         selectedIndices: selectedIndices,
  //         page:0
  //       ),
  //     ),
  //   );
  // }


  //   @override
  //   Widget build(BuildContext context) {
  //     return WillPopScope(
  //       onWillPop: () async {
  //         Navigator.pushReplacementNamed(context, '/home');
  //         await tts.stop();
  //         return true;
  //       },
  //       child: Scaffold(
  //         appBar: AppBar(
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.pushReplacementNamed(context, '/home');
  //         },
  //       ),
  //     ),
  //         backgroundColor: backgroundColor,
  //         body: loading
  //             ? const Center(
  //                 child: CircularProgressIndicator(color: accentColor),
  //               )
  //             : SafeArea(
  //                 child:Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  //                     child: questions.isEmpty
  //                         ? Center(
  //                           child: Text(
  //                                 " $errorMessage",
  //                                 style: TextStyle(
  //                                     color: accentColor,
  //                                     fontSize: 20,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                         )
                            
  //                         :  SingleChildScrollView(
  //                   child: Column(
  //                             children: [
  //                               const Text(
  //                                 "Daily Test",
  //                                 style: TextStyle(
  //                                     color: accentColor,
  //                                     fontSize: 20,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                               const SizedBox(height: 15),
        
  //                               // 👩‍🏫 Teacher
  //                               SizedBox(
  //                                   height: 140,
  //                                   child: TeacherAnimation()),
        
  //                               const SizedBox(height: 20),
        
  //                               // ❓ Question
  //                               Text(
  //                                 questions[currentIndex]["question"],
  //                                 textAlign: TextAlign.center,
  //                                 style: const TextStyle(
  //                                     color: textColor,
  //                                     fontSize: 22,
  //                                     fontWeight: FontWeight.w500),
  //                               ),
        
  //                               const SizedBox(height: 30),
        
  //                               // Options
  //                               ...List.generate(
  //                                 questions[currentIndex]["options"].length,
  //                                 (i) => Column(
  //                                   children: [
  //                                     _buildOption(
  //                                         i, questions[currentIndex]["options"][i]),
  //                                     const SizedBox(height: 18),
  //                                   ],
  //                                 ),
  //                               ),
        
  //                               const SizedBox(height: 30),
        
  //                               // Continue
  //                               ElevatedButton(
  //                                 onPressed: checkAnswer,
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor: Colors.transparent,
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 50, vertical: 16),
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(14),
  //                                     side: const BorderSide(
  //                                         color: accentColor, width: 1.8),
  //                                   ),
  //                                   shadowColor: accentColor.withOpacity(0.6),
  //                                 ),
  //                                 child: const Text(
  //                                   "Continue",
  //                                   style: TextStyle(
  //                                       color: accentColor,
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
        
  //                               TextButton(
  //                                 onPressed: () =>
  //                                     AIService().readAloud(questions[currentIndex]["question"]),
  //                                 child: const Text(
  //                                   "🔁 Listen Again",
  //                                   style: TextStyle(
  //                                       color: accentColor,
  //                                       decoration: TextDecoration.underline,
  //                                       fontSize: 16),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                   ),
  //                 ),
  //               ),
  //       ),
  //     );
  //   }

  //   // 🧱 Option Builder
  //   Widget _buildOption(int index, String text) {
  //     final isSelected = selectedIndex == index;
  //     return GestureDetector(
  //       onTap: () => setState(() => selectedIndex = index),
  //       child: Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  //         decoration: BoxDecoration(
  //           color: isSelected
  //               ? correctOptionColor.withOpacity(0.2)
  //               : Colors.transparent,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //             color: isSelected ? correctOptionColor : accentColor,
  //             width: 1.5,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: glowColor.withOpacity(0.4),
  //               blurRadius: 8,
  //               spreadRadius: 1,
  //             ),
  //           ],
  //         ),
  //         child: Center(
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               color: isSelected ? correctOptionColor : textColor,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
















  /*
  class DailyQuizScreen extends StatefulWidget {
    const DailyQuizScreen({super.key});

    @override
    State<DailyQuizScreen> createState() => _DailyQuizScreenState();
  }

  class _DailyQuizScreenState extends State<DailyQuizScreen> {
    final FlutterTts tts = FlutterTts();

    List<QuizQuestion> questions = [];
    int currentIndex = 0;
    int score = 0;
    int? selectedIndex;
    bool loading = true;
    String errorMessage = "";

    List<int?> selectedIndices = [];

    static const Color backgroundColor = Colors.black;
    static const Color accentColor = Colors.cyanAccent;
    static const Color glowColor = Color(0xFF80FFFF);
    static const Color textColor = Colors.white;
    static const Color correctOptionColor = Colors.cyanAccent;

    @override
    void initState() {
      super.initState();
      loadQuestions();
    }

    Future<void> loadQuestions() async {
      try {
        QuizQuestion? response = await AIModelRepo.generateQuizeQuestions();

        if (response == null || response.question.isEmpty) {
          setState(() {
            loading = false;
            errorMessage = "No questions found.";
          });
          return;
        }

        setState(() {
          questions = response.category??.question?? ? [response] : [];
          selectedIndices = List.filled(questions.length, null);
          loading = false;
        });

        _speak(questions[currentIndex].question);
      } catch (e) {
        setState(() {
          loading = false;
          errorMessage = "Failed to load quiz.";
        });
      }
    }

    Future<void> _speak(String text) async {
      await tts.setLanguage('en');
      await tts.setPitch(1.0);
      await tts.setSpeechRate(0.55);
      await tts.speak(text);
    }

    void checkAnswer() async {
      if (selectedIndex == null) return;

      selectedIndices[currentIndex] = selectedIndex;

      final selected =
          questions[currentIndex].options[selectedIndex!];
      final correct =
          questions[currentIndex].correctAnswer;

      if (selected == correct) {
        score++;
        await _speak("Correct");
      } else {
        await _speak("Incorrect, correct answer is $correct");
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (currentIndex < questions.length - 1) {
          setState(() {
            currentIndex++;
            selectedIndex = null;
          });
          _speak(questions[currentIndex].question);
        } else {
          showResult();
        }
      });
    }

    void showResult() async {
      await _speak("Your score is $score out of ${questions.length}");
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: score,
            totalQuestions: questions.length,
            questions: questions,
            selectedIndices: selectedIndices,
            page: 0,
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: loading
            ? const Center(
                child: CircularProgressIndicator(color: accentColor),
              )
            : questions.isEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                          color: accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        questions[currentIndex].question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 30),
                      ...List.generate(
                        questions[currentIndex].options.length,
                        (i) => GestureDetector(
                          onTap: () =>
                              setState(() => selectedIndex = i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedIndex == i
                                    ? correctOptionColor
                                    : accentColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                questions[currentIndex].options[i],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: checkAnswer,
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
      );
    }
  }
  */