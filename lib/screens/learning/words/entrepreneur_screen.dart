import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';

import '../../../widgets/message_bubble.dart';

class EntrepreneurScreen extends StatelessWidget {
  const EntrepreneurScreen({super.key});

  // Theme colors
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Word title
              const Text(
                "Entrepreneur",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              // ✅ Mic Button
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  size: 50,
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Waveform Placeholder
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  "~~~~~  Waveform Animation  ~~~~~",
                  style: TextStyle(
                    color: accentColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ AI Score
              const Text(
                "AI Score: Thumbs up down",
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Feedback buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _feedbackButton(Icons.thumb_down, Colors.redAccent, () {
                    // Show feedback only
                 

                                 showResultSnackBar(context, "❌ Incorrect, try again.",true);

                  }),
                  _feedbackButton(Icons.thumb_up, Colors.greenAccent, () {
                    // ✅ Navigate to next screen
                    Navigator.pushReplacementNamed(context, AppRoutes.meet);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable feedback button with onPressed
  static Widget _feedbackButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
