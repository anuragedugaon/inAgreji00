import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../services/video_player.dart';
import '../../../widgets/message_bubble.dart';
import '../../ai_teacher/ai_service.dart';
import 'grammar_result_screen.dart';

class FillTheBlankScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int initialCorrect;
  final int totalQuestions;
  final List<Map<String, dynamic>> reviewList;

  const FillTheBlankScreen({
    super.key,
    required this.questions,
    required this.initialCorrect,
    required this.totalQuestions,
    required this.reviewList,
  });

  @override
  State<FillTheBlankScreen> createState() => _FillTheBlankScreenState();
}

class _FillTheBlankScreenState extends State<FillTheBlankScreen> {
  final FlutterTts flutterTts = FlutterTts();

  int? selectedIndex;
  List<String> options = [];
  String correctAnswer = "";
  String questionText = "";
  String meaning = "";

  int currentIndex = 0;
  late int correctCount;

  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color correctOptionColor = Colors.cyanAccent;

  @override
  void initState() {
    super.initState();
    correctCount = widget.initialCorrect;
    _loadQuestion(0);
  }

  void _loadQuestion(int index) {
    final q = widget.questions[index];
    questionText = q["question"] ?? "";
    options = List<String>.from(q["wordList"] ?? []);
    correctAnswer = q["answer"] ?? "";
    meaning = q['meaning'] ?? "";
    selectedIndex = null;

    _speakQuestion();
    setState(() {});
  }

  Future<void> _speakQuestion() async {
    if (questionText.isEmpty) return;
    AIService().readAloud(questionText.replaceAll("___", "blank"));
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _checkAnswer() async {
    if (selectedIndex == null) {
      showResultSnackBar(
        context,
        "Please select an answer first!",
        true,
      );
      return;
    }

    final selectedAnswer = options[selectedIndex!];
    final bool isCorrect = selectedAnswer == correctAnswer;

    widget.reviewList.add({
      "type": "fill",
      "question": questionText,
      "correct": correctAnswer,
      "user": selectedAnswer,
      "isCorrect": isCorrect,
    });

    if (isCorrect) {
      correctCount++;
      await flutterTts.setSpeechRate(0.6);
      await flutterTts.speak("Correct!");
      showResultSnackBar(context, "✅ Correct Answer!", true);
    } else {
      await flutterTts.setSpeechRate(0.6);
      await flutterTts.speak("That's not correct.");
      showResultSnackBar(
        context,
        "❌ Incorrect! Correct: $correctAnswer",
        false,
      );
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (currentIndex < widget.questions.length - 1) {
        setState(() {
          currentIndex++;
        });
        _loadQuestion(currentIndex);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GrammarResultScreen(
              correct: correctCount,
              total: widget.totalQuestions,
              reviewList: widget.reviewList,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/lesson');
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Fixed Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    // Back Button + Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: accentColor),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Fill in the Blanks",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance for back button
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress Bar
                    LinearProgressIndicator(
                      value: (currentIndex + 1) / (widget.questions.length.toDouble()),
                      backgroundColor: Colors.white12,
                      color: Colors.orangeAccent,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 8),

                    // Question Counter
                    Text(
                      "Question ${currentIndex + 1} of ${widget.questions.length}",
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Teacher Animation
                      SizedBox(
                        height: 180,
                        child: TeacherAnimation(),
                      ),
                      const SizedBox(height: 24),

                      // Question Text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          questionText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Meaning
                      if (meaning.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            meaning,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Options
                      ...List.generate(
                        options.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildOption(i, options[i]),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Listen Again Button
                      TextButton.icon(
                        onPressed: _speakQuestion,
                        icon: const Icon(Icons.volume_up, color: accentColor),
                        label: const Text(
                          "Listen Again",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.95),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                            color: accentColor,
                            width: 2,
                          ),
                        ),
                        shadowColor: accentColor.withOpacity(0.6),
                        elevation: 8,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(int index, String text) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? correctOptionColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? correctOptionColor : accentColor.withOpacity(0.5),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: glowColor.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Row(
          children: [
            // Radio Circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? correctOptionColor : Colors.white60,
                  width: 2,
                ),
                color: isSelected
                    ? correctOptionColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.black,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Option Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? correctOptionColor : textColor,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}