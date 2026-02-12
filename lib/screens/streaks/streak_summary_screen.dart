import 'package:flutter/material.dart';

class StreakSummaryScreen extends StatelessWidget {
  const StreakSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors for consistent usage
    const Color backgroundColor = Colors.black;
    const Color titleColor = Colors.cyanAccent;
    const Color textColor = Colors.white;
    const Color highlightColor = Colors.cyanAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Section
              Column(
                children: [
                  // Title
                  Text(
                    "STREAK SUMMARY",
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Fire icon (placeholder, replace with asset if available)
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orangeAccent,
                    size: 100,
                  ),

                  const SizedBox(height: 20),

                  // Streak text
                  const Text(
                    "5 DAY STREAK",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left side (+56 / total 256)
                      Column(
                        children: const [
                          Text(
                            "+56",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "TOTAL\n256",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Middle (Coins 45)
                      Column(
                        children: const [
                          Icon(Icons.monetization_on,
                              color: Colors.cyanAccent, size: 28),
                          SizedBox(height: 6),
                          Text(
                            "COINS\n45",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      // Right side (Accuracy 96%)
                      Column(
                        children: const [
                          Icon(Icons.check_circle,
                              color: Colors.cyanAccent, size: 28),
                          SizedBox(height: 6),
                          Text(
                            "ACCURACY\n96%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Continue Lesson Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to next lesson
                    Navigator.pushReplacementNamed(context, '/make');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side:
                          const BorderSide(color: Colors.cyanAccent, width: 2),
                    ),
                    elevation: 8,
                    shadowColor: Colors.cyanAccent.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Continue Lesson",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
