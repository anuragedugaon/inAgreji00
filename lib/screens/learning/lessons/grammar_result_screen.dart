import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/ai_model_/ai_model_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/request_model/grammer_fill_blank.dart';
import '../../dailyLessonScreen/listen_and_select_screen.dart';

class GrammarResultScreen extends StatefulWidget {
  final int correct;
  final int total;

  // 🔴 NEW: full review list (arrange + fill)
  final List<Map<String, dynamic>> reviewList;

  const GrammarResultScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.reviewList,
  });

  @override
  State<GrammarResultScreen> createState() => _GrammarResultScreenState();
}

class _GrammarResultScreenState extends State<GrammarResultScreen> {
  late ConfettiController _leftConfetti;
  late ConfettiController _rightConfetti;

  int get wrong => widget.total - widget.correct;

  double get ratio =>
      widget.total == 0 ? 0.0 : widget.correct / widget.total;

  @override
  void initState() {
    super.initState();
    _leftConfetti = ConfettiController(duration: const Duration(seconds: 4));
    _rightConfetti = ConfettiController(duration: const Duration(seconds: 4));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendGrammarResultToApi();
      _leftConfetti.play();
      _rightConfetti.play();
    });
  }

  @override
  void dispose() {
    _leftConfetti.dispose();
    _rightConfetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Colors.cyanAccent;

    // Dynamic texts based on performance
    String title;
    String subtitle;
    String level;
    Color levelColor;

    if (ratio >= 0.85) {
      title = "🏆 Grammar Champion!";
      subtitle = "Your grammar is on fire! Keep shining! ✨";
      level = "Pro Level";
      levelColor = Colors.amberAccent;
    } else if (ratio >= 0.6) {
      title = "✨ Good Effort!";
      subtitle = "You’re getting better every day. Keep practicing!";
      level = "Rising Star";
      levelColor = Colors.lightGreenAccent;
    } else {
      title = "🚀 Keep Practicing!";
      subtitle = "Don’t worry. Grammar improves with daily practice.";
      level = "Learner";
      levelColor = Colors.orangeAccent;
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    ),
             
      
        body: SafeArea(
          child: Stack(
            children: [
              // 🌈 Glowing background circles
              Positioned(
                top: -80,
                left: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyanAccent.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -90,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent.withOpacity(0.16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.45),
                        blurRadius: 45,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
      
              Column(
                children: [
                  const SizedBox(height: 12),
      
                  // Small label
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Grammar Practice Summary",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
      
                  // ===== HEADER CARD =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: -20, end: 0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, value),
                          child: Opacity(
                            opacity: ((20 + value) / 20).clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00FFC6), Color(0xFF0066FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.55),
                              blurRadius: 25,
                              spreadRadius: 1,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Trophy circle
                            Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.15),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(
                                child: Text(
                                  "📚",
                                  style: TextStyle(fontSize: 34),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _smallChip(
                                        icon: Icons.star_rounded,
                                        label:
                                            "Score: ${widget.correct}/${widget.total}",
                                        color: Colors.black.withOpacity(0.65),
                                        textColor: Colors.white,
                                      ),
                                      _smallChip(
                                        icon: Icons.check_circle_rounded,
                                        label: "Correct: ${widget.correct}",
                                        color: Colors.black.withOpacity(0.5),
                                        textColor: Colors.lightGreenAccent,
                                      ),
                                      _smallChip(
                                        icon: Icons.cancel_rounded,
                                        label: "Wrong: $wrong",
                                        color: Colors.black.withOpacity(0.5),
                                        textColor: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 12),
      
                  // Level chip + small info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(color: levelColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.flash_on_rounded,
                                  size: 18, color: levelColor),
                              const SizedBox(width: 6),
                              Text(
                                level,
                                style: TextStyle(
                                  color: levelColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Accuracy: ${(ratio * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 16),
      
                  // ===== DETAILED REVIEW LIST =====
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListView.builder(
                        itemCount: widget.reviewList.length,
                        itemBuilder: (context, index) {
                          final item = widget.reviewList[index];
                          final bool isCorrect = item["isCorrect"] == true;
                          final String type = item["type"] ?? "";
                          final String question = item["question"] ?? "";
                          final String user = item["user"] ?? "";
                          final String correct = item["correct"] ?? "";
      
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0F172A),
                                  isCorrect
                                      ? const Color(0xFF022C22)
                                      : const Color(0xFF1F2937),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: isCorrect
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                width: 1.3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (isCorrect
                                          ? Colors.greenAccent
                                          : Colors.redAccent)
                                      .withOpacity(0.18),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: type chip + status
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.06),
                                      ),
                                      child: Text(
                                        type == "arrange"
                                            ? "Sentence Arrange"
                                            : "Fill in the Blank",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isCorrect
                                              ? Icons.check_circle_rounded
                                              : Icons.cancel_rounded,
                                          size: 16,
                                          color: isCorrect
                                              ? Colors.greenAccent
                                              : Colors.redAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isCorrect ? "Correct" : "Wrong",
                                          style: TextStyle(
                                            color: isCorrect
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
      
                                Text(
                                  question,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
      
                                // User answer
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Your answer: ",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.isEmpty ? "Not answered" : user,
                                        style: TextStyle(
                                          color: isCorrect
                                              ? Colors.greenAccent
                                              : Colors.orangeAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (!isCorrect) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Correct: ",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    correct,
                                    style: const TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      
                  // // Button
               
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamedAndRemoveUntil(
                          //   context,
                          //   '/lesson',
                          //   (route) => false,
                          // );

                             Navigator.pushReplacement(
                                    context, MaterialPageRoute(
                                      builder: (context) => const ListenSelectScreen(),
                                    ),);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                          shadowColor: Colors.cyanAccent.withOpacity(0.6),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                
                ],
              ),
      
              // 🎊 CONFETTI ON TOP
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: _leftConfetti,
                  blastDirection: pi / 4,
                  emissionFrequency: 0.12,
                  numberOfParticles: 10,
                  gravity: 0.1,
                  colors: const [
                    Colors.pinkAccent,
                    Colors.purple,
                    Colors.cyanAccent,
                    Colors.white
                  ],
                  createParticlePath: _drawFlower,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _rightConfetti,
                  blastDirection: 3 * pi / 4,
                  emissionFrequency: 0.12,
                  numberOfParticles: 10,
                  gravity: 0.1,
                  colors: const [
                    Colors.pinkAccent,
                    Colors.purple,
                    Colors.cyanAccent,
                    Colors.white
                  ],
                  createParticlePath: _drawFlower,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🌸 Flower Confetti Particles (same style as quiz result)
  Path _drawFlower(Size size) {
    final Path path = Path();
    const petals = 10;
    final r = size.width / 2;

    for (int i = 0; i < petals; i++) {
      final theta = (2 * pi * i) / petals;
      final x = r + r * cos(theta);
      final y = r + r * sin(theta);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.quadraticBezierTo(r, r, x, y);
      }
    }
    return path..close();
  }

  Widget _smallChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendGrammarResultToApi() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final lessonName =
        prefs.getString('selected_lesson') ?? 'Grammar Practice';

    final token = prefs.getString("auth_token") 
       ;

    String typeOf(Map e) =>
        (e['type'] ?? '').toString().toLowerCase().trim();

    /// ===============================
    /// ✅ ARRANGE QUESTIONS (API FORMAT)
    /// ===============================
    final arrangeQuestions = widget.reviewList
        .where((e) => typeOf(e) == "arrange")
        .map((e) {
      final correctSentence =
          (e['correct'] ?? '').toString().trim();

      return {
        "sentence": (e['question'] ?? '').toString(),
        "meaning": (e['meaning'] ?? '').toString(),
        "words": (e['words'] ?? []) as List,
        "answer": correctSentence.isEmpty
            ? []
            : correctSentence
                .split(' ')
                .where((w) => w.isNotEmpty)
                .toList(),
        "explanation": (e['explanation'] ?? '').toString(),
      };
    }).toList();

    /// ===============================
    /// ✅ FILL QUESTIONS (API FORMAT)
    /// ===============================
    final fillQuestions = widget.reviewList
        .where((e) => typeOf(e) == "fill")
        .map((e) {
      final correctAnswer =
          (e['correct'] ?? '').toString().trim();

      return {
        "question": (e['question'] ?? '').toString(),
        "meaning": (e['meaning'] ?? '').toString(),
        "wordList": (e['wordList'] ?? []) as List,
        "answer": correctAnswer,
        "correct_answer": correctAnswer,
      };
    }).toList();

    /// ===============================
    /// ✅ FINAL REQUEST BODY (CURL MATCH)
    /// ===============================
    final requestBody = {
      "lesson": lessonName,
      "arrange_questions": arrangeQuestions,
      "fill_questions": fillQuestions,
    };

    debugPrint("📤 RequestBody: ${jsonEncode(requestBody)}");

    final dio = Dio();
    final response = await dio.post(
      "https://admin.inangreji.in/api/grammar-lesson",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("✅ Grammar result submitted successfully");
      debugPrint("✅ Response: ${jsonEncode(response.data)}");
    } else {
      debugPrint("❌ Failed: ${response.statusMessage}");
    }
  } on DioException catch (e) {
    debugPrint("❌ DioException: ${e.message}");
    debugPrint("❌ Response: ${e.response?.data}");

    if (mounted) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Failed to submit grammar results"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  } catch (e) {
    debugPrint("❌ Error: $e");
  }
}

/// ========================================
/// ✅ EXAMPLE: reviewList Structure
/// ========================================
/// 
/// For ARRANGE type:
/// {
///   "type": "arrange",
///   "question": "The dog barks loudly",
///   "meaning": "कुत्ता जोर से भौंकता है",
///   "words": ["The", "dog", "barks", "loudly"],
///   "correct": "The dog barks loudly",
///   "user": "dog The loudly barks",  // User's answer
///   "isCorrect": false,
///   "explanation": "This sentence uses simple present tense"
/// }
/// 
/// For FILL type:
/// {
///   "type": "fill",
///   "question": "I _ to music",
///   "meaning": "मैं संगीत सुनता हूँ",
///   "wordList": ["listen", "listens", "listened"],
///   "correct": "listen",
///   "user": "listens",  // User's wrong answer
///   "isCorrect": false
/// }
// Future<void> _sendGrammarResultToApi() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();

//     final lessonName = prefs.getString('selected_lesson') ?? 'Grammar Practice';

//     /// ✅ Token (prefs se lo)
//     final token = prefs.getString("auth_token") ??
//         "170|RWPEgIpV5SbTU2B3CMKRmY47aeB91RmF0aHrOGpy";

//     debugPrint(
//         '📤 Sending ${widget.reviewList.length} grammar results (arrange + fill)...');

//     /// 🔹 Arrange questions
//     final arrangeQuestions = widget.reviewList
//         .where((e) => e['type'] == 'arrange')
//         .map((e) {
//       return {
//         'sentence': (e['question'] ?? '').toString(),
//         'meaning': (e['meaning'] ?? '').toString(),
//         'words': e['words'] ?? [],
//         'answer': (e['correct'] ?? '').toString().split(' ').toList(),
//         'explanation': (e['explanation'] ?? '').toString(),
//       };
//     }).toList();

//     /// 🔹 Fill questions
//     final fillQuestions = widget.reviewList
//         .where((e) => e['type'] == 'fill')
//         .map((e) {
//       return {
//         'question': (e['question'] ?? '').toString(),
//         'meaning': (e['meaning'] ?? '').toString(),
//         'wordList': e['wordList'] ?? [],
//         'answer': (e['correct'] ?? '').toString(),
//         'correct_answer': (e['correct'] ?? '').toString(),
//       };
//     }).toList();

//     /// ✅ Request body (EXACT format like your API)
//     final requestBody = {
//       "lesson": lessonName,
//       "arrange_questions": arrangeQuestions,
//       "fill_questions": fillQuestions,
//     };

//     debugPrint("📤 RequestBody: ${jsonEncode(requestBody)}");

//     /// ✅ Headers exactly like given code
//     final headers = {
//       "Content-Type": "application/json",
//       "Authorization": "Bearer $token",
//       // Cookie optional hai, mostly required nahi hota
//       // "Cookie": prefs.getString("cookie") ?? "",
//     };

//     final dio = Dio();

//     /// ✅ Direct API call
//     final response = await dio.post(
//       "https://admin.inangreji.in/api/grammar-lesson",
//       data: jsonEncode(requestBody),
//       options: Options(headers: headers),
//     );

//     if (response.statusCode == 200) {
//       debugPrint("✅ Grammar result submitted: ${jsonEncode(response.data)}");
//     } else {
//       debugPrint("❌ API Failed: ${response.statusMessage}");
//     }
//   } on DioException catch (e) {
//     debugPrint("❌ DioException: ${e.message}");
//     debugPrint("StatusCode: ${e.response?.statusCode}");
//     debugPrint("Response: ${e.response?.data}");
//   } catch (e) {
//     debugPrint("❌ Result submit failed: $e");
//   }
// }

}
  