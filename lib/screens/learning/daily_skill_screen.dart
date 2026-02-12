import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart'; // ✅ use your existing AIService

class DailySkillScreen extends StatefulWidget {
  const DailySkillScreen({super.key});

  @override
  State<DailySkillScreen> createState() => _DailySkillScreenState();
}

class _DailySkillScreenState extends State<DailySkillScreen> {
  final AIService _aiService = AIService(); // ✅ Use your AI teacher voice

  @override
  void initState() {
    super.initState();

    // 🗣️ Speak when the screen loads
    Future.delayed(const Duration(milliseconds: 700), () {
      _aiService.speakText("Start your daily skill check!");
    });
  }

  @override
  void deactivate() {
    _aiService.stopSpeaking();
    super.deactivate();
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  Future<void> _startSkill() async {
    // 🗣️ Speak before navigation
    await _aiService.speakText(
      "Great! Let's begin.",
      onComplete: () {
        Navigator.pushReplacementNamed(context, '/where');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color textColor = Colors.white;
    const Color glowColor = Color(0xFF80FFFF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Row (Coin Balance)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                  SizedBox(width: 6),
                  Text(
                    "12,590",
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ],
              ),

              const Spacer(),

              // Title
              const Text(
                "Start your\nDaily Skill Check!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),

              // Circular Countdown
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.6),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "60s",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Start Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startSkill, // ✅ trigger voice + navigate
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: accentColor, width: 1.5),
                    ),
                    elevation: 8,
                    shadowColor: glowColor.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer Text
              const Text(
                "Practice makes perfect!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
