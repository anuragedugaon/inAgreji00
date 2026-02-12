import 'package:flutter/material.dart';

class SevenDayStreakScreen extends StatelessWidget {
  const SevenDayStreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color textColor = Colors.white;
    const Color fireColor = Colors.orangeAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔥 Fire Icon + Number
              const Icon(
                Icons.local_fire_department,
                size: 100,
                color: fireColor,
              ),
              const SizedBox(height: 12),

              // ✅ Streak Text
              const Text(
                "🔥 You're on a\n7-day streak!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fireColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // 📤 Share Button (outlined)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: accentColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Share",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🚀 Keep Going Button (filled)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/avatar');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: accentColor, width: 1.5),
                    ),
                    elevation: 6,
                    shadowColor: glowColor.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Keep Going",
                    style: TextStyle(
                      color: accentColor,
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
