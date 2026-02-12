import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart'; // ✅ use your existing AI voice

/// App color constants (reusable across app)
class AppColors {
  static const Color background = Colors.black;
  static const Color titleText = Colors.cyan;
  static const Color primaryText = Colors.white;
  static const Color buttonText = Colors.white;
  static const Color buttonBg = Colors.cyan;
  static const Color optionBorder = Colors.cyan;
  static const Color optionBg = Colors.black54;
}

class CameraPermissionScreen extends StatefulWidget {
  const CameraPermissionScreen({Key? key}) : super(key: key);

  @override
  State<CameraPermissionScreen> createState() => _CameraPermissionScreenState();
}

class _CameraPermissionScreenState extends State<CameraPermissionScreen> {
  final AIService _aiService = AIService(); // ✅ AI voice instance
  final String _introText = "Please enable your camera for smart detection.";

  @override
  void initState() {
    super.initState();

    // 🗣️ Speak when the screen opens
    Future.delayed(const Duration(milliseconds: 600), () {
      _aiService.speakText(_introText);
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

  void _onAllowPressed() async {
    // 🗣️ Speak feedback before navigating
    await _aiService.speakText(
      "Great! Let's proceed.",
      onComplete: () {
        Navigator.pushReplacementNamed(
            context, '/skill'); // ✅ navigate after voice
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Camera image placeholder (optional, replace with your asset)
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/camera.png', // 👈 replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              /// Title text
              Text(
                "Enable Camera\nfor Smart Detection",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleText,
                ),
              ),
              const SizedBox(height: 40),

              /// Option row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    icon: Icons.face,
                    label: "Face detection",
                  ),
                  _buildOption(
                    icon: Icons.emoji_emotions,
                    label: "Expression\nanalysis",
                  ),
                ],
              ),
              const SizedBox(height: 60),

              /// Bottom buttons row
              Row(
                children: [
                  /// Don't Allow button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _aiService.stopSpeaking(); // stop any speech
                        debugPrint("Camera Permission: Denied");
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: AppColors.optionBorder, width: 2),
                        foregroundColor: AppColors.buttonText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Don't Allow",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// OK button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onAllowPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBg,
                        foregroundColor: AppColors.buttonText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        shadowColor: AppColors.buttonBg,
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable option widget (icon + label)
  Widget _buildOption({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 130,
      decoration: BoxDecoration(
        color: AppColors.optionBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.optionBorder, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: AppColors.titleText,
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
