// lib/widgets/animated_teacher_widget.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'dart:math' as math;

import '../services/video_player.dart';

class AnimatedTeacher extends StatefulWidget {
  final AIService aiService;

  const AnimatedTeacher({Key? key, required this.aiService}) : super(key: key);

  @override
  AnimatedTeacherState createState() => AnimatedTeacherState();
}

class AnimatedTeacherState extends State<AnimatedTeacher>
    with TickerProviderStateMixin {
  bool _isSpeaking = false;
  late final AIService _aiService;
  late final ValueNotifier<int> _wordNotifier;
  late final AnimationController _glowController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _aiService = widget.aiService;
    _wordNotifier = _aiService.currentWordIndex;

    // 🌟 Soft glow (ambient breathing)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 👄 Pulse effect on words
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.95,
      upperBound: 1.05,
    );

    _wordNotifier.addListener(() {
      if (_isSpeaking) _pulseController.forward(from: 0.95);
    });
  }

  /// 🔊 Triggered from parent when AI speaks
  Future<void> speak(String text) async {
    setState(() => _isSpeaking = true);

    await _aiService.speakText(
      text,
      onStart: () {
        setState(() => _isSpeaking = true);
        _glowController.repeat(reverse: true);
      },
      onComplete: () {
        setState(() => _isSpeaking = false);
        _glowController.stop();
      },
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double avatarSize = MediaQuery.of(context).size.width * 0.6;

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowController, _pulseController]),
        builder: (context, _) {
          final glowStrength = _isSpeaking
              ? 10 + 10 * math.sin(_glowController.value * math.pi * 2)
              : 0;
          final pulseScale = _isSpeaking ? _pulseController.value : 1.0;

          return Transform.scale(
            scale: pulseScale,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: _isSpeaking
                    ? [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.5),
                          blurRadius: glowStrength.toDouble(),
                          spreadRadius: (glowStrength / 3).toDouble(),
                        ),
                      ]
                    : [],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                    child:                         TeacherAnimation(),

                // child: _isSpeaking
                //     ? Lottie.asset(
                //         'assets/animations/teacher_speaking.json',
                //         key: const ValueKey('speaking'),
                //         height: avatarSize,
                //         fit: BoxFit.contain,
                //         repeat: true,
                //       ):
                    // : Lottie.asset(
                    //     'assets/animations/teacher_idle.json',
                    //     key: const ValueKey('idle'),
                    //     height: avatarSize,
                    //     fit: BoxFit.contain,
                    //     repeat: true,
                    //   ),
              ),
            ),
          );
        },
      ),
    );
  }
}
