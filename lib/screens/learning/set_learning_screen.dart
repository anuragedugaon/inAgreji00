import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

/// Color constants for the InAngreji theme
class AppColors {
  static const Color background = Colors.black;
  static const Color primaryText = Colors.lightBlueAccent;
  static const Color subtitleText = Colors.white70;
  static const Color buttonText = Colors.white;
  static const Color cardHighlight = Color(0xFF1A237E);
}

class SetLearningScreen extends StatefulWidget {
  const SetLearningScreen({super.key});

  @override
  State<SetLearningScreen> createState() => _SetLearningScreenState();
}

class _SetLearningScreenState extends State<SetLearningScreen>
    with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  final String _questionText = "Set your learning goal.";
  String _selectedGoal = "Fun";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Speak the question after screen appears
    Future.delayed(const Duration(milliseconds: 700), () {
      _aiService.speakText(_questionText);
    });
  }

  void _replayQuestion() {
    _aiService.stopSpeaking();
    _aiService.speakText(_questionText);
  }

  Future<void> _handleGetStarted() async {
    await Future.delayed(const Duration(milliseconds: 400)); // warm-up delay
    await _aiService.speakText(
      "Great! Let's set your goal.",
      onComplete: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/choose');
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _aiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // 🎤 Mic Replay Button
          Container(
            margin: const EdgeInsets.only(right: 14, top: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.mic_rounded,
                  color: AppColors.primaryText, size: 28),
              onPressed: _replayQuestion,
              tooltip: 'Replay Voice',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 🔹 Subtle radial glow to make center pop (still black-dominant)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.black,
                    Colors.black,
                  ],
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                ),
              ),
            ),
          ),

          // 🌟 Main content animation
          FadeTransition(
            opacity: _controller,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOutCubic,
              )),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🧠 Title
                      Text(
                        "Set your\nlearning goal",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.blueAccent.shade100,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 18,
                              color: Colors.blueAccent.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 🎯 Goal Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _GoalCard(
                            emoji: "💼",
                            label: "Job\nInterview",
                            isSelected: _selectedGoal == "Job Interview",
                            onTap: () =>
                                setState(() => _selectedGoal = "Job Interview"),
                          ),
                          _GoalCard(
                            emoji: "😄",
                            label: "Fun",
                            isSelected: _selectedGoal == "Fun",
                            onTap: () => setState(() => _selectedGoal = "Fun"),
                          ),
                          _GoalCard(
                            emoji: "✈️",
                            label: "Travel",
                            isSelected: _selectedGoal == "Travel",
                            onTap: () =>
                                setState(() => _selectedGoal = "Travel"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ✨ Subtitle
                      Text(
                        "Stay motivated daily",
                        style: GoogleFonts.poppins(
                          color: AppColors.subtitleText,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 🚀 Get Started Button
                      InkWell(
                        onTap: _handleGetStarted,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.shade400,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.5),
                                blurRadius: 18,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.poppins(
                              color: AppColors.buttonText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎯 Goal Card Widget
class _GoalCard extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 110,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF1C1C1C), Color(0xFF0D0D0D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.8),
                      blurRadius: 18,
                      spreadRadius: 2,
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.w400,
                  shadows: widget.isSelected
                      ? [
                          const Shadow(
                            blurRadius: 10.0,
                            color: Colors.blueAccent,
                          )
                        ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
