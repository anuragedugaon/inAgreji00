import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:flutter/services.dart';

import '../../services/video_player.dart'; // ✅ using your AI voice service

/// Define app color constants
class AppColors {
  static const Color backgroundDark = Color(0xFF000000); // Black background
  static const Color primaryBlue = Color(0xFF00BFFF); // Neon Blue
  static const Color textWhite = Colors.white;
  static const Color buttonOrange = Color(0xFFFFA500);
}

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({super.key});

  @override
  State<SplashScreen4> createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> with SingleTickerProviderStateMixin  {
  final AIService _aiService = AIService();
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

    // 🎙️ Delay to allow TTS engine and UI to settle
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        // 🧠 Reinitialize TTS to be extra-safe
        await _aiService.speakText(
          "Speak, listen, and grow daily !",
          onStart: () {
            debugPrint("🎤 Splash4: Voice started speaking");
          },
          onComplete: () async {
            debugPrint("✅ Splash4: Voice finished speaking");

            // ⏳ Small delay for smooth transition
            await Future.delayed(const Duration(seconds: 1));

            if (mounted) {
              Navigator.pushReplacementNamed(context, '/track');
            }
          },
        );
      } catch (e) {
        debugPrint("❌ TTS Error on Splash4: $e");
        // Fallback navigation in case TTS fails
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pushReplacementNamed(context, '/track');
      }
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
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              /// Title text
              const Text(
                "Speak, Listen\n& Grow – Daily",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                  height: 1.4,
                ),
              ),

              /// Bot + Wave + Mic section
            
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

       
            
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     /// Bot icon placeholder
              //     Icon(
              //       Icons.android, // Replace with your bot asset if available
              //       color: AppColors.primaryBlue,
              //       size: 48,
              //     ),
              //     const SizedBox(width: 16),

              //     /// Animated wave line
              //     Expanded(
              //       child: Container(
              //         height: 40,
              //         alignment: Alignment.center,
              //         child: CustomPaint(
              //           painter: WavePainter(),
              //           size: const Size(double.infinity, 40),
              //         ),
              //       ),
              //     ),

              //     const SizedBox(width: 16),

              //     /// Mic icon placeholder
              //     Icon(
              //       Icons.graphic_eq,
              //       color: AppColors.primaryBlue,
              //       size: 48,
              //     ),
              //   ],
              // ),
          
          
          
          
            ],
          ),
        ),
      ),
    ),
  );
  }
}

/// Custom painter for wave effect between bot and icon
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const waveHeight = 12.0;

    for (double i = 0; i < size.width; i++) {
      double y = size.height / 2 +
          waveHeight * (i % 20 < 10 ? -1 : 1); // simple zigzag wave
      if (i == 0) {
        path.moveTo(i, y);
      } else {
        path.lineTo(i, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
