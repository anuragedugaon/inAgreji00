import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

class AnimatedAnswer extends StatefulWidget {
  final String text;
  final bool isSpeaking;
  final Duration fadeDuration;
  final AIService aiService;

  const AnimatedAnswer({
    Key? key,
    required this.text,
    required this.isSpeaking,
    required this.aiService,
    this.fadeDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<AnimatedAnswer> createState() => _AnimatedAnswerState();
}

class _AnimatedAnswerState extends State<AnimatedAnswer> {
  bool _visible = true;
  Timer? _fadeTimer;

  @override
  void initState() {
    super.initState();
    _visible = true;
  }

  @override
  void didUpdateWidget(covariant AnimatedAnswer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When speaking starts, start fading
    if (widget.isSpeaking && !oldWidget.isSpeaking) {
      _startFadeOut();
    }

    // When speaking ends, reset visibility
    if (!widget.isSpeaking && oldWidget.isSpeaking) {
      _fadeTimer?.cancel();
      if (mounted) setState(() => _visible = true);
    }

    // When the answer text changes, reset fade
    if (oldWidget.text != widget.text) {
      _fadeTimer?.cancel();
      if (mounted) setState(() => _visible = true);
    }
  }

  void _startFadeOut() {
    _fadeTimer?.cancel();

    // Gradually fade out after short delay (while speaking)
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      if (!widget.isSpeaking) {
        timer.cancel();
        return;
      }
      // Fade out step-by-step (smooth)
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: widget.fadeDuration,
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: widget.isSpeaking ? Colors.grey[400] : Colors.white,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}
