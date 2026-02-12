import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../../models/request_model/card_swipe_request_model.dart';

// ==================== CELEBRATION SCREEN ====================



// ==================== PREMIUM CELEBRATION SCREEN ====================
class CelebrationScreen extends StatefulWidget {
  final dynamic summary; // Your LessonSummary object

  const CelebrationScreen({super.key, required this.summary});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _glowController;
  late AnimationController _rotateController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    // Confetti Controller - 5 second blast
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    
    // Scale Animation - Trophy bounce with elastic effect
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Fade Animation - Smooth text appearance
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Glow Animation - Continuous pulsating effect
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Rotate Animation - Subtle trophy rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.easeInOut,
      ),
    );

    // Start all animations with delays
    _confettiController.play();
    _scaleController.forward();
    
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fadeController.forward();
    });

    // Auto navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonResultScreen(summary: widget.summary),
        ),
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    ),
      body: Stack(
        children: [
          // Animated Background Gradient
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      // Colors.amber.withOpacity(0.15 * _glowAnimation.value),
                      // Colors.orange.withOpacity(0.08 * _glowAnimation.value),
                      Colors.black,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),

          // Confetti Effect
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.02,
              numberOfParticles: 60,
              gravity: 0.15,
              maxBlastForce: 25,
              minBlastForce: 12,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.pink,
                Colors.purple,
                Colors.cyan,
                Colors.red,
                Colors.yellow,
                Colors.amber,
                Colors.lime,
              ],
            ),
          ),

          // Main Content
         
         
         
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium Trophy with Multiple Effects
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_glowAnimation, _rotateAnimation]),
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Outer glow
                              BoxShadow(
                                color: Colors.amber.withOpacity(_glowAnimation.value * 0.7),
                                blurRadius: 80 * _glowAnimation.value,
                                spreadRadius: 30 * _glowAnimation.value,
                              ),
                              // Inner glow
                              BoxShadow(
                                color: Colors.orange.withOpacity(_glowAnimation.value * 0.5),
                                blurRadius: 40 * _glowAnimation.value,
                                spreadRadius: 15 * _glowAnimation.value,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.amber.withOpacity(0.4 * _glowAnimation.value),
                                  Colors.orange.withOpacity(0.2 * _glowAnimation.value),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Trophy icon
                                Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 110,
                                  shadows: [
                                    Shadow(
                                      color: Colors.amber.withOpacity(0.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                // Sparkle effects
                                ...List.generate(8, (index) {
                                  final angle = (index * 45) * (3.14159 / 180);
                                  return Transform.rotate(
                                    angle: angle + (_glowAnimation.value * 0.5),
                                    child: Transform.translate(
                                      offset: Offset(
                                        cos(angle) * 60,
                                        sin(angle) * 60,
                                      ),
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(_glowAnimation.value),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.amber,
                                              blurRadius: 8 * _glowAnimation.value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),

                // Animated Text Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Premium Gradient Text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.amber.shade100,
                            Colors.amber.shade200,
                            Colors.white,
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ).createShader(bounds),
                        child: const Text(
                          "Congratulations!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                color: Colors.amber,
                                blurRadius: 30,
                              ),
                              Shadow(
                                color: Colors.orange,
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Subtitle with glow
                      Column(
                        children: [
                          Text(
                            "You have successfully",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.8,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "completed this Lesson",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.8,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),

                      // Loading Indicator with glow
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(_glowAnimation.value * 0.5),
                                  blurRadius: 20 * _glowAnimation.value,
                                  spreadRadius: 5 * _glowAnimation.value,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.amber.withOpacity(0.8),
                                ),
                                backgroundColor: Colors.amber.withOpacity(0.2),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Loading results...",
                        style: TextStyle(
                          color: Colors.amber.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),



          // Floating Particles System
          // ...List.generate(20, (index) {
          //   return _FloatingParticle(
          //     delay: index * 150,
          //     startX: Random().nextDouble(),
          //   );
          // }),
        ],
      ),
    );
  }
}

// ==================== LESSON RESULT SCREEN ====================



class LessonResultScreen extends StatelessWidget {
  final LessonSummary summary;

  const LessonResultScreen({super.key, required this.summary});

  double get accuracy =>
      (summary.correctAnswers / summary.totalQuestions) * 100;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
      
              // 🔥 Title
              const Text(
                "Lesson Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
      
              const SizedBox(height: 24),
      
              // 🔵 Score Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statCard(
                    "Accuracy",
                    "${accuracy.toInt()}%",
                    Colors.cyanAccent,
                  ),
                  _statCard(
                    "Correct",
                    "${summary.correctAnswers}/${summary.totalQuestions}",
                    Colors.greenAccent,
                  ),
                ],
              ),
      
              const SizedBox(height: 32),
      
              // 🔥 Review Section
              Expanded(
                child: summary.results.isEmpty
                    ? _perfectView()
                    : Column(
                        children: [
                          const Text(
                            "Review Answers",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
      
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              itemCount: summary.results.length,
                              itemBuilder: (context, i) {
                                return _reviewTile(summary.results[i], i);
                              },
                            ),
                          ),
                        ],
                      ),
              ),
      
              // 🔘 Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 8,
                      shadowColor: Colors.cyanAccent.withOpacity(0.6),
                    ),
                    onPressed: () =>    Navigator.pushReplacementNamed(
                                      context, '/dailyQuiz'),
                    child: const Text(
                      "START NEXT LESSON",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.2,
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

  // ================= PERFECT VIEW =================
  Widget _perfectView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_rounded,
              color: Colors.amberAccent, size: 80),
          SizedBox(height: 16),
          Text(
            "Perfect Score!",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "No mistakes 🎉",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ================= STAT CARD =================
  Widget _statCard(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.25), color],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  // ================= REVIEW TILE =================
  // Widget _reviewTile(WordReview r, int index) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(18),
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF0F172A), Color(0xFF1F2937)],
  //       ),
  //       border: Border.all(color: Colors.redAccent, width: 1.4),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.redAccent.withOpacity(0.25),
  //           blurRadius: 12,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Question Index
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 14,
  //               backgroundColor: Colors.black54,
  //               child: Text(
  //                 "${index + 1}",
  //                 style: const TextStyle(
  //                     color: Colors.white, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             const Text(
  //               "Your Answer vs Correct",
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 12),

  //         // User Answer
  //         _answerBox(
  //           icon: Icons.close_rounded,
  //           text: r.userAnswer,
  //           color: Colors.orangeAccent,
  //         ),

  //         const SizedBox(height: 10),

  //         // Correct Answer
  //         _answerBox(
  //           icon: Icons.check_circle_rounded,
  //           text: r.correctAnswer,
  //           color: Colors.greenAccent,
  //         ),
  //       ],
  //     ),
  //   );
  // }



// ================= REVIEW TILE =================
Widget _reviewTile(QuestionResult r, int index) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1F2937)],
      ),
      border: Border.all(
        color: r.isCorrect ? Colors.greenAccent : Colors.redAccent,
        width: 1.4,
      ),
      boxShadow: [
        BoxShadow(
          color: (r.isCorrect ? Colors.greenAccent : Colors.redAccent)
              .withOpacity(0.25),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question number + text
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black54,
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                r.question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const Text(
          "Your Answer",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 4),
        _answerBox(
          icon: r.isCorrect
              ? Icons.check_circle_rounded
              : Icons.close_rounded,
          text: r.userAnswer,
          color:
              r.isCorrect ? Colors.greenAccent : Colors.orangeAccent,
        ),

        if (!r.isCorrect) ...[
          const SizedBox(height: 10),
          const Text(
            "Correct Answer",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          _answerBox(
            icon: Icons.check_circle_rounded,
            text: r.correctAnswer,
            color: Colors.cyanAccent,
          ),
        ],
      ],
    ),
  );
}




  Widget _answerBox({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}








// ==================== EXAMPLE USAGE ====================
// After completing a lesson, navigate like this:
// 





class LessonSummary {
  final int totalQuestions;
  final int correctAnswers;
  final List<QuestionResult> results;

  LessonSummary({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.results,
  });
}



class QuestionResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuestionResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}





class WordReview {
  final String userAnswer;
  final String correctAnswer;

  WordReview({
    required this.userAnswer,
    required this.correctAnswer,
  });
}
