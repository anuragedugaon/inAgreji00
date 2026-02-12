
import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'dart:math' as math;

import '../../models/ai_question_model/swipe_question_model.dart';
import '../../models/request_model/card_swipe_request_model.dart';
import '../../models/request_model/swipe_question_request.dart';
import 'openai_service.dart';
import 'result_page.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/ai_model_/ai_model_repo.dart';


class SwipeableCardsScreen extends StatefulWidget {
  const SwipeableCardsScreen({super.key});

  @override
  State<SwipeableCardsScreen> createState() => _SwipeableCardsScreenState();
}

class _SwipeableCardsScreenState extends State<SwipeableCardsScreen> {
  static const Color backgroundColor = Color(0xFF050505);
  static const Color accentColor = Colors.cyanAccent;
  static const Color textColor = Colors.white;

  final List<List<Color>> cardGradients = const [
    [Color(0xFF1D2671), Color(0xFFC33764)],
    [Color(0xFF134E5E), Color(0xFF71B280)],
    [Color(0xFF42275A), Color(0xFF734B6D)],
    [Color(0xFF0F2027), Color(0xFF203A43)],
    [Color(0xFF141E30), Color(0xFF243B55)],
  ];

  final List<Map<String, dynamic>> _questions = [];
          final List<CardSwipeQuestion>  _resultsApi = [];
  final List<QuestionResult> _results = [];
  bool _loading = true;
  int currentIndex = 0;
  double _dragDistance = 0;
  int correctCount = 0;

  late final String sessionId;

  @override
  void initState() {
    super.initState();
    sessionId = _generateSessionId();
    _loadAiQuestions();
  }

  // ================= SESSION ID =================
  String _generateSessionId() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    return "sess_$millis";
  }
AppProvider appProvider = AppProvider();
  // ================= API LOAD =================
  Future<void> _loadAiQuestions() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await AIModelRepo.generateSwipeQuestions(
      request: SwipeQuestionRequest(
        sessionId: sessionId,
        selectedLanguageName:
            prefs.getString('selected_language') ?? "Tamil",
        selectedLanguageCode:
            prefs.getString("selected_language_code") ?? "ta",
        userLevel: appProvider.userDetails.data?.level?.name?? "beginner",
        stage: "intro",
      ),
    );

    if (!mounted) return;

    final data = response?.data ?? [];

    _questions.clear();

    for (final SwipeQuestion q in data) {
      final correctOnLeft = math.Random().nextBool();

      _questions.add({
        "sentence_en": q.sentenceEn,
        "sentence_local": q.sentenceLocal,
        "leftOption": correctOnLeft ? q.correct : q.wrong,
        "rightOption": correctOnLeft ? q.wrong : q.correct,
        "correctAnswer": q.correct,
      });
    }

    setState(() => _loading = false);
  }

  // ================= GESTURE =================
  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _dragDistance += d.delta.dx);
  }

  void _onPanEnd(DragEndDetails d) {
    if (_dragDistance.abs() > 100) {
      _handleSwipe(_dragDistance < 0 ? 'left' : 'right');
    } else {
      setState(() => _dragDistance = 0);
    }
  }

  // ================= SWIPE LOGIC =================
  void _handleSwipe(String dir) {
    final current = _questions[currentIndex];
    final selected =
        dir == 'left' ? current['leftOption'] : current['rightOption'];

    final correct = current['correctAnswer'];
    final isCorrect = selected == correct;

    if (isCorrect) correctCount++;

    _resultsApi.add(
      CardSwipeQuestion(
        sentenceEn:  current['sentence_en'],
         sentenceLocal: current['sentence_local'],
          correct:selected  == correct ? selected : correct, 
          wrong: selected != correct ? selected : correct,
        // question: current['sentence_en'],
        // userAnswer: selected,
        // correctAnswer: correct,
        // isCorrect: isCorrect,
      ),
    );


    _results.add(
      QuestionResult(
        question: current['sentence_en'],
        userAnswer: selected,
        correctAnswer: correct,
        isCorrect: isCorrect,
      ),
    );

    _showResultModal(isCorrect);
  }

  // ================= RESULT MODAL =================
  void _showResultModal(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.42,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCorrect
                ? [Colors.greenAccent, Color(0xFF0B6B4F)]
                : [Colors.redAccent, Color(0xFF6A0F0F)],
          ),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              isCorrect ? "WONDERFUL!" : "TRY AGAIN",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (currentIndex < _questions.length - 1) {
                      setState(() {
                        currentIndex++;
                        _dragDistance = 0;
                      });
                    } else {
                      _finishLesson();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                        isCorrect ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "CONTINUE",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FINISH =================
  Future<void> _finishLesson() async {

    await AIModelRepo.sendCardSwipeApi(
      request: CardSwipeRequest(questions: _resultsApi),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CelebrationScreen(
          summary: LessonSummary(
            totalQuestions: _questions.length,
            correctAnswers: correctCount,
            results: _results,
          ),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: accentColor),
        ),
      );
    }

    final current = _questions[currentIndex];
    final gradient =
        cardGradients[currentIndex % cardGradients.length];

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/home'),
          ),
          title: const Text("Swipe Practice"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        current['sentence_en'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        current['sentence_local'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child:
                          _optionBox(current['leftOption'], "Swipe Left")),
                  const SizedBox(width: 16),
                  Expanded(
                      child:
                          _optionBox(current['rightOption'], "Swipe Right")),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _optionBox(String text, String hint) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}




// class SwipeableCardsScreen extends StatefulWidget {
//   const SwipeableCardsScreen({super.key});

//   @override
//   State<SwipeableCardsScreen> createState() => _SwipeableCardsScreenState();
// }

// class _SwipeableCardsScreenState extends State<SwipeableCardsScreen> {
//   static const Color backgroundColor = Color(0xFF050505);
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color textColor = Colors.white;

//   final List<List<Color>> cardGradients = [
//     [Color(0xFF1D2671), Color(0xFFC33764)],
//     [Color(0xFF134E5E), Color(0xFF71B280)],
//     [Color(0xFF42275A), Color(0xFF734B6D)],
//     [Color(0xFF0F2027), Color(0xFF203A43)],
//     [Color(0xFF141E30), Color(0xFF243B55)],
//   ];

//   final OpenAIService _ai = OpenAIService();

//   List<Map<String, dynamic>> _questions = [];
//   bool _loading = true;

//   int currentIndex = 0;
//   double _dragDistance = 0;
//   int correctCount = 0;

//   final List<QuestionResult> _results = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadAiQuestions();
//   }

//   Future<void> _loadAiQuestions() async {
//     final aiData = await _ai.getSwipeCardQuestions();

//     _questions = aiData.map((q) {
//       final correct = q["correct"];
//       final wrong = q["wrong"];
//       final correctOnLeft = math.Random().nextBool();

//       return {
//         "sentence_en": q["sentence_en"],
//         "sentence_local": q["sentence_local"],
//         "leftOption": correctOnLeft ? correct : wrong,
//         "rightOption": correctOnLeft ? wrong : correct,
//         "correctAnswer": correct,
//       };
//     }).toList();

//     setState(() => _loading = false);
//   }

//   void _onPanUpdate(DragUpdateDetails d) {
//     setState(() => _dragDistance += d.delta.dx);
//   }

//   void _onPanEnd(DragEndDetails d) {
//     if (_dragDistance.abs() > 100) {
//       _handleSwipe(_dragDistance < 0 ? 'left' : 'right');
//     } else {
//       setState(() => _dragDistance = 0);
//     }
//   }

//   void _handleSwipe(String dir) {
//     final current = _questions[currentIndex];
//     final selected =
//         dir == 'left' ? current['leftOption'] : current['rightOption'];

//     final correct = current['correctAnswer'];
//     final isCorrect = selected == correct;

//     if (isCorrect) correctCount++;

//     _results.add(
//       QuestionResult(
//         question: current['sentence_en'],
//         userAnswer: selected,
//         correctAnswer: correct,
//         isCorrect: isCorrect,
//       ),
//     );

//     _showResultModal(isCorrect);
//   }

//   void _showResultModal(bool isCorrect) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isDismissible: false,
//       builder: (_) => Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height * 0.42,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isCorrect
//                 ? [Colors.greenAccent, Color(0xFF0B6B4F)]
//                 : [Colors.redAccent, Color(0xFF6A0F0F)],
//           ),
//           borderRadius:
//               const BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             Icon(
//               isCorrect ? Icons.check_circle : Icons.cancel,
//               size: 120,
//               color: Colors.white,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               isCorrect ? "WONDERFUL!" : "TRY AGAIN",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 34,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.all(24),
//               child: SizedBox(
//                                   width: double.infinity,

//                 child: ElevatedButton(
                
//                   onPressed: () {
//                     Navigator.pop(context);
//                     if (currentIndex < _questions.length - 1) {
//                       setState(() {
//                         currentIndex++;
//                         _dragDistance = 0;
//                       });
//                     } else {
//                       _finishLesson();
//                     }
//                   },
//                  style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor:
//                           isCorrect ? Colors.green : Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                     ),
//                     child: const Text(
//                       "CONTINUE",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }



//   void _finishLesson() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CelebrationScreen(
//           summary: LessonSummary(
//             totalQuestions: _questions.length,
//             correctAnswers: correctCount,
//             results: _results,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         backgroundColor: backgroundColor,
//         body: Center(
//           child: CircularProgressIndicator(color: accentColor),
//         ),
//       );
//     }

//     final current = _questions[currentIndex];
//     final gradient =
//         cardGradients[currentIndex % cardGradients.length];

//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacementNamed(context, '/home');
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           backgroundColor: backgroundColor,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () =>
//                 Navigator.pushReplacementNamed(context, '/home'),
//           ),
//           title: const Text("Swipe Practice"),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onPanUpdate: _onPanUpdate,
//                 onPanEnd: _onPanEnd,
//                 child: Container(
//                   margin: const EdgeInsets.all(24),
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: gradient),
//                     borderRadius: BorderRadius.circular(32),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         current['sentence_en'],
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         current['sentence_local'],
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white.withOpacity(0.85),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Row(
//                 children: [
//                   Expanded(
//                       child:
//                           _optionBox(current['leftOption'], "Swipe Left")),
//                   const SizedBox(width: 16),
//                   Expanded(
//                       child:
//                           _optionBox(current['rightOption'], "Swipe Right")),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _optionBox(String text, String hint) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white12,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Column(
//         children: [
//           Text(
//             text,
//             style: const TextStyle(
//               color: textColor,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             hint,
//             style: TextStyle(
//               color: textColor.withOpacity(0.6),
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



