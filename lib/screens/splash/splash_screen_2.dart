import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:flutter/services.dart';

import '../../services/video_player.dart';

/// --- Color constants ---
class AppColors {
  static const Color backgroundDark = Colors.black;
  static const Color primaryBlue = Color(0xFF00BFFF); // Neon blue
  static const Color textWhite = Colors.white;
  static const Color subtitleColor = Colors.white70;
}

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2>
    with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  final String _introSpeech =
      "Welcome to InAngreji — your personal AI English tutor.";
  bool _isSpeaking = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);

    // 🗣️ Speak intro after short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      _speakIntroAndNavigate();
    });
  }

  void _speakIntroAndNavigate() async {
    // Delay a bit more to let TTS engine settle after previous screen
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isSpeaking = true);

    await _aiService.speakText(
      _introSpeech,
      onStart: () => debugPrint("🎤 Splash2 TTS started"),
      onComplete: () async {
        setState(() => _isSpeaking = false);

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          debugPrint("➡️ Navigating to Splash3");
          Navigator.pushReplacementNamed(context, '/splash3');
        }
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
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            
                /// --- Animated Teacher (Lottie) ---
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final glow = _isSpeaking ? _glowController.value * 40 : 0.0;
                    final fadeOpacity = _glowController.value;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // 🌌 Faded glow background
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _isSpeaking ? fadeOpacity : 0.4,
                          child: Container(
                            height: 280,
                            width: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primaryBlue.withOpacity(0.25),
                                  Colors.transparent,
                                ],
                                stops: const [0.3, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue
                                      .withOpacity(0.5 * fadeOpacity),
                                  blurRadius: glow,
                                  spreadRadius: glow / 4,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 🧠 Teacher animation
                        TeacherAnimation(),
// SizedBox(
//   height: 300,
//   width: 220,
//   child: Image.asset(
//     'assets/video/316338_small.gif',
//     fit: BoxFit.contain,
//   ),
// ),

                        // SizedBox(
                        //   height: 220,
                        //   width: 220,
                        //   child: Lottie.asset(
                        //     'assets/animations/human_ani.json',
                        //     repeat: _isSpeaking,
                        //     animate: true,
                        //     // fit: BoxFit.contain,
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),

             
             
             
                const SizedBox(height: 32),

                /// --- Title ---
                const Text(
                  'Welcome to\nInAngreji',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                    height: 1.3,
                  ),
                ),

                // const SizedBox(height: 12),

                /// --- Subtitle ---
                const Text(
                  'Your personal\nAI English tutor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
