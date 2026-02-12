import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart'; // ✅ Use your existing AIService

/// --- Color Constants ---
const Color primaryColor = Color(0xFFFFA500); // Orange for button
const Color accentBlue = Color(0xFF00BFFF); // Light Blue for headings
const Color backgroundColor = Colors.black; // Screen background
const Color subtitleColor = Colors.white70; // Secondary text

class TrackProgressScreen extends StatefulWidget {
  const TrackProgressScreen({Key? key}) : super(key: key);

  @override
  State<TrackProgressScreen> createState() => _TrackProgressScreenState();
}

class _TrackProgressScreenState extends State<TrackProgressScreen> {
  final AIService _aiService = AIService();

  final String _introVoice = "Track your progress and earn rewards.";
  final String _continueVoice =
      "Great job! Let's continue your learning journey.";

  @override
  void initState() {
    super.initState();

    // 🗣️ Speak the intro line after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _aiService.speakText(_introVoice);
    });
  }

  Future<void> _handleContinue() async {
    await _aiService.speakText(
      _continueVoice,
      onComplete: () {
        Navigator.pushReplacementNamed(context, '/set'); // ✅ Next route
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// --- Title Text ---
              const Text(
                'Track your progress\n& earn rewards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// --- Subtitle Text ---
              const Text(
                'Stay motivated daily',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              /// --- Icon Section (Coins, Fire, Chart) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon('assets/images/coins.png'),
                  const SizedBox(width: 30),
                  _buildIcon('assets/images/fire.png'),
                  const SizedBox(width: 30),
                  _buildIcon('assets/images/chart.png'),
                ],
              ),

              const SizedBox(height: 60),

              /// --- Continue Button ---
              ElevatedButton(
                onPressed: _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: primaryColor.withOpacity(0.5),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Text color contrast
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --- Helper Widget for Icons ---
  Widget _buildIcon(String path) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
