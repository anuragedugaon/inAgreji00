import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart'; // ✅ use existing AI voice

/// Define reusable app colors
class AppColors {
  static const Color background = Colors.black;
  static const Color titleText = Colors.cyan;
  static const Color buttonBorder = Colors.cyan;
  static const Color buttonText = Colors.white;
  static const Color allowButton = Colors.cyan;
}

class MicrophonePermissionScreen extends StatefulWidget {
  const MicrophonePermissionScreen({Key? key}) : super(key: key);

  @override
  State<MicrophonePermissionScreen> createState() =>
      _MicrophonePermissionScreenState();
}

class _MicrophonePermissionScreenState
    extends State<MicrophonePermissionScreen> {
  final AIService _aiService = AIService();
  final String _questionText =
      "Please enable microphone access for speaking practice.";

  @override
  void initState() {
    super.initState();

    // 🗣️ Speak intro after short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      _aiService.speakText(_questionText);
    });
  }

  void _replayQuestion() {
    _aiService.stopSpeaking();
    _aiService.speakText(_questionText);
  }

  Future<void> _handleAllow() async {
    await _aiService.speakText(
      "Thank you! Microphone access granted.",
      onComplete: () {
        Navigator.pushReplacementNamed(
            context, '/cam'); // ✅ go to camera permission
      },
    );
  }

  Future<void> _handleDeny() async {
    await _aiService.speakText(
      "Alright, you can enable it later from settings.",
      onComplete: () {
        Navigator.pop(context);
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Title
              Text(
                "Enable Mic for\nSpeaking Practice",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleText,
                ),
              ),
              const SizedBox(height: 40),

              /// Mic icon with soft glow
              Container(
                padding: const EdgeInsets.all(40),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Icon(
                  Icons.mic,
                  size: 100,
                  color: AppColors.allowButton,
                  shadows: [
                    Shadow(
                      color: AppColors.allowButton.withOpacity(0.8),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              /// "Don't Allow" Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _handleDeny,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppColors.buttonBorder, width: 2),
                    foregroundColor: AppColors.buttonText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Don't Allow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// "Allow" Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleAllow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.allowButton,
                    foregroundColor: AppColors.buttonText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: AppColors.allowButton,
                  ),
                  child: const Text(
                    "Allow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}
