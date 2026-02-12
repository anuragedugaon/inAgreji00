import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

import '../../services/video_player.dart'; // ✅ using your existing AIService

/// --- Color constants ---
class AppColors {
  static const Color backgroundDark = Colors.black;
  static const Color primaryBlue = Color(0xFF00BFFF); // Neon blue for title
  static const Color textWhite = Colors.white;
  static const Color subtitleColor = Colors.white70;
}

class SplashScreen3 extends StatefulWidget {
  const SplashScreen3({Key? key}) : super(key: key);

  @override
  State<SplashScreen3> createState() => _SplashScreen3State();
}

class _SplashScreen3State extends State<SplashScreen3>
    with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  final String _speechText = "Learn English with your personal AI tutor.";
  bool _isSpeaking = false;

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    // 🎵 Setup glow animation controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.4,
      upperBound: 1.0,
    )..repeat(reverse: true);

    // 🗣️ Speak intro after a short delay
    Future.delayed(const Duration(milliseconds: 700), _speakIntroAndNavigate);
  }

  void _speakIntroAndNavigate() async {
    setState(() => _isSpeaking = true);

    // 🕒 Add a startup delay to allow TTS to fully warm up
    await Future.delayed(const Duration(seconds: 2));

    await _aiService.speakText(
      _speechText,
      onStart: () {
        debugPrint("🎙️ Splash 3: Speaking started");
      },
      onComplete: () async {
        debugPrint("🎯 Splash 3: Speaking complete");
        setState(() => _isSpeaking = false);

        // ✨ Short delay for smoother transition
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/splash4');
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
    _glowController.dispose();
    _aiService.dispose();
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
                /// --- Animated Teacher (Lottie) with glowing background ---
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final glow = _isSpeaking ? _glowController.value * 40 : 0.0;
                    final fadeOpacity = _glowController.value;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // 🌌 Faded radial background glow
                     
                     
                     
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




                        // 🧠 Teacher speaking animation
                        // SizedBox(
                        //   height: 220,
                        //   width: 220,
                        //   child: Lottie.asset(
                        //     'assets/animations/teacher_speaking.json',
                        //     repeat: _isSpeaking,
                        //     animate: true,
                        //     fit: BoxFit.contain,
                        //   ),
                        // ),

                                                TeacherAnimation(),

                      ],
                    );
                  },
                ),

                // const SizedBox(height: 40),

                /// --- Title ---
                const Text(
                  'Learn English\nwith your\npersonal AI tutor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
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
