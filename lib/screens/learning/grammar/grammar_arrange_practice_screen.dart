


// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:inangreji_flutter/provider/app_provider.dart';
// import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../models/request_model/grammar_rule_request_model.dart';
// import '../../../provider/ai_model_/ai_model_repo.dart';
// import '../../../services/video_player.dart';
// import '../../../widgets/message_bubble.dart';
// import '../../result/quiz_result_screen.dart'; // <-- jahan tumhara QuizResultScreen hai, uska path sahi karo



import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/request_model/grammar_rule_request_model.dart';
import '../../../provider/ai_model_/ai_model_repo.dart';
import '../../../services/video_player.dart';
import '../../../widgets/message_bubble.dart';
import '../../result/quiz_result_screen.dart';
// ========================================
// FIXED: Grammar Arrange Practice Screen
// ========================================

class GrammarArrangePracticeScreen extends StatefulWidget {
  final String ruleTitle;
  final List<Map<String, dynamic>> questions;

  const GrammarArrangePracticeScreen({
    super.key,
    required this.ruleTitle,
    required this.questions,
  });

  @override
  State<GrammarArrangePracticeScreen> createState() =>
      _GrammarArrangePracticeScreenState();
}

class _GrammarArrangePracticeScreenState
    extends State<GrammarArrangePracticeScreen>
    with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> _questions;
  int _currentIndex = 0;
  List<int> _selectedIndexes = [];
  int _correctCount = 0;

  final List<_PracticeResult> _results = [];

  late AnimationController _controller;
  late Animation<Color?> _gradient1;
  late Animation<Color?> _gradient2;

  @override
  void initState() {
    super.initState();

    _questions = List<Map<String, dynamic>>.from(widget.questions);
    if (_questions.isEmpty) {
      debugPrint("⚠️ GrammarArrangePracticeScreen: questions list is empty!");
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _gradient1 = ColorTween(
      begin: Colors.black,
      end: const Color(0xFF001F3F),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _gradient2 = ColorTween(
      begin: const Color(0xFF00BFFF),
      end: const Color(0xFF0077FF),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // ✅ Speak first sentence after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_questions.isNotEmpty) {
        debugPrint("🎤 Speaking first sentence: $_currentCorrectSentence");
        _speakSentence(_currentCorrectSentence);
      }
    });
  }

  bool get _hasQuestions => _questions.isNotEmpty;

  Map<String, dynamic> get _currentQuestion =>
      _hasQuestions ? _questions[_currentIndex] : {};

  List<String> get _currentWords =>
      List<String>.from(_currentQuestion['words'] ?? const []);

  String get _currentMCorrectSentence =>
      (_currentQuestion['meaning'] ?? '').toString();

  String get _currentCorrectSentence =>
      (_currentQuestion['sentence'] ?? '').toString();

  // ✅ FIXED: Now uses AIService().readAloud() without second parameter
  Future<void> _speakSentence(String text) async {
    if (text.trim().isEmpty) {
      debugPrint("⚠️ Cannot speak empty text");
      return;
    }
    
    debugPrint("🗣️ Speaking: $text");
    try {
      await AIService().readAloud(text);
    } catch (e) {
      debugPrint("❌ Speech error: $e");
    }
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  void _onWordTap(int index) {
    if (!_hasQuestions) return;

    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
    
    debugPrint("📝 Selected indexes: $_selectedIndexes");
  }

  void _onCheck() {
    if (!_hasQuestions) {
      showResultSnackBar(context, "No questions available.", false);
      return;
    }

    if (_selectedIndexes.isEmpty) {
      showResultSnackBar(context, "Please select words first!", false);
      return;
    }

    final words = _currentWords;
    final userWords = _selectedIndexes.map((i) => words[i]).toList();
    final userSentence = userWords.join(" ");
    final correctSentence = _currentCorrectSentence;

    debugPrint("✅ RAW USER: '$userSentence'");
    debugPrint("✅ RAW CORRECT: '$correctSentence'");
    debugPrint("✅ NORM USER: '${_normalize(userSentence)}'");
    debugPrint("✅ NORM CORRECT: '${_normalize(correctSentence)}'");

    final isCorrect =
        _normalize(userSentence) == _normalize(correctSentence);

    if (isCorrect) {
      _correctCount++;
      showResultSnackBar(context, "🎉 Correct sentence!", true);
      debugPrint("🎉 Correct answer!");
    } else {
      showResultSnackBar(
        context,
        "❌ Incorrect.\nCorrect: $correctSentence",
        false,
      );
      debugPrint("❌ Wrong answer. Correct: $correctSentence");
    }

    _results.add(
      _PracticeResult(
        sentence: correctSentence,
        userSentence: userSentence,
        isCorrect: isCorrect,
      ),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedIndexes.clear();
        });
        debugPrint("➡️ Moving to question ${_currentIndex + 1}");
        _speakSentence(_currentCorrectSentence);
      } else {
        debugPrint("🏁 Quiz completed! Going to results...");
        _goToResultPage();
      }
    });
  }

  void _goToResultPage() {
    final total = _results.length;
    // _submitGrammarArrange();

    final questionsForResult = _results.map((r) {
      return {
        "question": "Arrange this sentence correctly:",
        "options": [
          r.sentence,
          r.userSentence.isEmpty ? "Not answered" : r.userSentence
        ],
        "answer": r.sentence,
      };
    }).toList();

    final selectedIndices =
        _results.map<int?>((r) => r.isCorrect ? 0 : 1).toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: _correctCount,
          totalQuestions: total,
          questions: questionsForResult,
          selectedIndices: selectedIndices,
          page: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // ✅ Stop TTS when leaving screen
    AIService().stopSpeaking();
    debugPrint("🛑 Screen disposed, TTS stopped");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasQuestions) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Sentence Arrangement",
            style: TextStyle(color: Colors.cyanAccent),
          ),
          iconTheme: const IconThemeData(color: Colors.cyanAccent),
        ),
        body: const Center(
          child: Text(
            "No practice questions available.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            height: double.infinity,
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
                  // Fixed Header with Progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                value: progress,
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
                          widget.ruleTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Sentence ${_currentIndex + 1} of ${_questions.length}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable Content
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                      
                            // ✅ Teacher Animation
                            SizedBox(
                              height: 250,
                              child: TeacherAnimation(),
                            ),
                            const SizedBox(height: 24),
                      
                            // Meaning/Prompt
                            Text(
                              _currentMCorrectSentence,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                      
                            // Selected sentence box
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Text(
                                _selectedIndexes.isEmpty
                                    ? "Tap the words below to build the sentence"
                                    : _selectedIndexes
                                        .map((i) => _currentWords[i])
                                        .join(" "),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                      
                            const SizedBox(height: 28),
                      
                            // Words chips
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 12,
                              children:
                                  List.generate(_currentWords.length, (index) {
                                final word = _currentWords[index];
                                final selected = _selectedIndexes.contains(index);
                      
                                return GestureDetector(
                                  onTap: () => _onWordTap(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
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
                                      word,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.cyanAccent
                                            : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                      
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Fixed Bottom Buttons
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onCheck,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
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
                            debugPrint("🔊 Listen button pressed");
                            _speakSentence(_currentCorrectSentence);
                          },
                          icon: const Icon(Icons.volume_up,
                              color: Colors.white70),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

// ✅ Result data class
class _PracticeResult {
  final String sentence;
  final String userSentence;
  final bool isCorrect;

  _PracticeResult({
    required this.sentence,
    required this.userSentence,
    required this.isCorrect,
  });
}


// class _PracticeResult {
//   final String sentence;
//   final String userSentence;
//   final bool isCorrect;

//   _PracticeResult({
//     required this.sentence,
//     required this.userSentence,
//     required this.isCorrect,
//   });
// }


// class GrammarArrangePracticeScreen extends StatefulWidget {
//   final String ruleTitle;
//   final List<Map<String, dynamic>> questions;

//   const GrammarArrangePracticeScreen({
//     super.key,
//     required this.ruleTitle,
//     required this.questions,
//   });

//   @override
//   State<GrammarArrangePracticeScreen> createState() =>
//       _GrammarArrangePracticeScreenState();
// }

// class _GrammarArrangePracticeScreenState
//     extends State<GrammarArrangePracticeScreen>
//     with SingleTickerProviderStateMixin {
//   final FlutterTts _tts = FlutterTts();

//   late List<Map<String, dynamic>> _questions;
//   int _currentIndex = 0;
//   List<int> _selectedIndexes = [];
//   int _correctCount = 0;

//   // Result store: har question ke liye user sentence + correct sentence
//   final List<_PracticeResult> _results = [];

//   late AnimationController _controller;
//   late Animation<Color?> _gradient1;
//   late Animation<Color?> _gradient2;

//   @override
//   void initState() {
//     super.initState();

//     // 🔹 Questions yahin set karo (GrammarRuleScreen se aayenge)
//     _questions = List<Map<String, dynamic>>.from(widget.questions);
//     if (_questions.isEmpty) {
//       debugPrint("⚠️ GrammarArrangePracticeScreen: questions list is empty!");
//     }

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat(reverse: true);

//     _gradient1 = ColorTween(
//       begin: Colors.black,
//       end: const Color(0xFF001F3F),
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     _gradient2 = ColorTween(
//       begin: const Color(0xFF00BFFF),
//       end: const Color(0xFF0077FF),
//     ).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_questions.isNotEmpty) {
//         _speakSentence(_currentCorrectSentence);
//       }
//     });
//   }

//   bool get _hasQuestions => _questions.isNotEmpty;

//   Map<String, dynamic> get _currentQuestion =>
//       _hasQuestions ? _questions[_currentIndex] : {};

//   List<String> get _currentWords =>
//       List<String>.from(_currentQuestion['words'] ?? const []);
//       String get _currentMCorrectSentence =>
//       (_currentQuestion['meaning'] ?? '').toString();

//   String get _currentCorrectSentence =>
//       (_currentQuestion['sentence'] ?? '').toString();

//   Future<void> _speakSentence(String text) async {
//    AIService().readAloud( text);
//   }

//   /// 🔧 Normalization: lowercase + punctuation remove + extra spaces remove
//   String _normalize(String s) => s
//       .toLowerCase()
//       .replaceAll(RegExp(r'[^\w\s]'), '') // punctuation hatao (. , ? ! " ' etc)
//       .replaceAll(RegExp(r'\s+'), ' ') // multiple spaces -> single
//       .trim();

//   void _onWordTap(int index) {
//     if (!_hasQuestions) return;

//     setState(() {
//       if (_selectedIndexes.contains(index)) {
//         _selectedIndexes.remove(index);
//       } else {
//         _selectedIndexes.add(index);
//       }
//     });
//   }

//   void _onCheck() {
//     if (!_hasQuestions) {
//       showResultSnackBar(context, "No questions available.", false);
//       return;
//     }

//     if (_selectedIndexes.isEmpty) {
//       showResultSnackBar(context, "Please select words first!", false);
//       return;
//     }

//     final words = _currentWords;
//     final userWords = _selectedIndexes.map((i) => words[i]).toList();
//     final userSentence = userWords.join(" ");
//     final correctSentence = _currentCorrectSentence;

//     // Debugging logs (optional)
//     debugPrint("RAW USER: '$userSentence'");
//     debugPrint("RAW CORRECT: '$correctSentence'");
//     debugPrint("NORM USER: '${_normalize(userSentence)}'");
//     debugPrint("NORM CORRECT: '${_normalize(correctSentence)}'");

//     final isCorrect =
//         _normalize(userSentence) == _normalize(correctSentence);

//     if (isCorrect) {
//       _correctCount++;
//       showResultSnackBar(context, "🎉 Correct sentence!", true);
//     } else {
//       showResultSnackBar(
//         context,
//         "❌ Incorrect.\nCorrect: $correctSentence",
//         false,
//       );
//     }

//     // Save result for final summary
//     _results.add(
//       _PracticeResult(
//         sentence: correctSentence,
//         userSentence: userSentence,
//         isCorrect: isCorrect,
//       ),
//     );

//     // Next question or result page
//     Future.delayed(const Duration(milliseconds: 700), () {
//       if (!mounted) return;

//       if (_currentIndex < _questions.length - 1) {
//         setState(() {
//           _currentIndex++;
//           _selectedIndexes.clear();
//         });
//         _speakSentence(_currentCorrectSentence);
//       } else {
//         _goToResultPage();
//       }
//     });
//   }

//   void _goToResultPage() {
//     final total = _results.length;
// _submitGrammarArrange(); // Answers submit kar do backend ko
//     // QuizResultScreen ke liye data prepare:
//     final questionsForResult = _results.map((r) {
//       return {
//         "question": "Arrange this sentence correctly:",
//         "options": [
//           r.sentence,
//           r.userSentence.isEmpty ? "Not answered" : r.userSentence
//         ],
//         "answer": r.sentence,
//       };
//     }).toList();

//     final selectedIndices =
//         _results.map<int?>((r) => r.isCorrect ? 0 : 1).toList();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => QuizResultScreen(
//           score: _correctCount,
//           totalQuestions: total,
//           questions: questionsForResult,
//           selectedIndices: selectedIndices,
//           page: 1,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _tts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Agar questions hi nahi aaye toh simple error UI
//     if (!_hasQuestions) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: const Text(
//             "Sentence Arrangement",
//             style: TextStyle(color: Colors.cyanAccent),
//           ),
//           iconTheme: const IconThemeData(color: Colors.cyanAccent),
//         ),
//         body: const Center(
//           child: Text(
//             "No practice questions available.",
//             style: TextStyle(color: Colors.white70),
//           ),
//         ),
//       );
//     }

//     final progress = (_currentIndex + 1) / _questions.length;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, _) {
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [_gradient1.value!, _gradient2.value!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Progress
//                       LinearProgressIndicator(
//                         value: progress,
//                         backgroundColor: Colors.white12,
//                         color: Colors.orangeAccent,
//                         minHeight: 4,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       const SizedBox(height: 16),
                
//                       Text(
//                         widget.ruleTitle,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: Colors.cyanAccent,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         "Sentence ${_currentIndex + 1} of ${_questions.length}",
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 13,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                
//                       SizedBox(
//                         height: 250,
//                         child: TeacherAnimation(),
//                       ),
//                       const SizedBox(height: 24),
                
//                       Text(
//                         _currentMCorrectSentence,
//                         style: const TextStyle(
//                           color: Colors.white70,
//                           fontSize: 25,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                
//                       // Selected sentence box
//                       Container(
//                         height: 70,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Colors.cyanAccent.withOpacity(0.3),
//                             width: 1.2,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         alignment: Alignment.center,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Text(
//                           _selectedIndexes.isEmpty
//                               ? "Tap the words below to build the sentence"
//                               : _selectedIndexes
//                                   .map((i) => _currentWords[i])
//                                   .join(" "),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
                
//                       const SizedBox(height: 28),
                
//                       // Words chips
//                       Wrap(
//                         alignment: WrapAlignment.center,
//                         spacing: 12,
//                         runSpacing: 12,
//                         children:
//                             List.generate(_currentWords.length, (index) {
//                           final word = _currentWords[index];
//                           final selected = _selectedIndexes.contains(index);
                
//                           return GestureDetector(
//                             onTap: () => _onWordTap(index),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 180),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: selected
//                                     ? Colors.cyanAccent.withOpacity(0.3)
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: selected
//                                       ? Colors.cyanAccent
//                                       : Colors.cyanAccent.withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: Text(
//                                 word,
//                                 style: TextStyle(
//                                   color: selected
//                                       ? Colors.cyanAccent
//                                       : Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                       ),
                
//                       const Spacer(),
                
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: _onCheck,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 side: const BorderSide(
//                                   color: Colors.cyanAccent,
//                                   width: 1.5,
//                                 ),
//                               ),
//                               shadowColor:
//                                   Colors.cyanAccent.withOpacity(0.6),
//                             ),
//                             child: const Text(
//                               "CHECK",
//                               style: TextStyle(
//                                 color: Colors.cyanAccent,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () =>
//                                 _speakSentence(_currentCorrectSentence),
//                             child: const Text(
//                               "🔁 Listen",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }


//   Future<void> _submitGrammarArrange() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final appProvider = AppProvider();
      
//       final userLevel = appProvider.userDetails?.data?.level?.name ?? "Beginner";
//       final lessonName = widget.ruleTitle;

//       debugPrint('📤 Submitting ${_results.length} grammar arrange results...');

//       // 🔹 Convert results to GrammarArrangeResult
//       final grammarResults = _results.map((r) {
//         return GrammarArrangeResult(
//           sentence: r.sentence.toString().trim(),
//           userAnswer: r.userSentence.isEmpty 
//               ? <String>[] 
//               : r.userSentence.toString().trim().split(' ').where((w) => w.isNotEmpty).toList(),
//           correctAnswer: r.sentence.toString().trim().split(' ').where((w) => w.isNotEmpty).toList(),
//           isCorrect: r.isCorrect,
//         );
//       }).toList();

//       // 🔹 Build request with only needed fields
//       final request = GrammarArrangeSubmitRequest(
//         grammarRule: lessonName,
//         selectedLanguage: prefs.getString('selected_language') ?? "English",
//         results: grammarResults,
//         userLevel: userLevel,
//       );

//       debugPrint('📤 Sending: ${grammarResults.length} results for "$lessonName"');

//       await AIModelRepo.submitGrammarArrangeAnswers(request: request);
//       debugPrint("✅ Grammar arrange answers submitted successfully");
//     } catch (e) {
//       debugPrint("❌ Grammar arrange submit failed: $e");
//       debugPrint("Stack trace: $e");
//     }
//   }

  
// }

// class _PracticeResult {
//   final String sentence;
//   final String userSentence;
//   final bool isCorrect;

//   _PracticeResult({
//     required this.sentence,
//     required this.userSentence,
//     required this.isCorrect,
//   });
// }
