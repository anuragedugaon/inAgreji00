import 'package:flutter/material.dart';

class RecapScreen extends StatelessWidget {
  const RecapScreen({super.key});

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF00FFFF);
  static const Color kText = Colors.white;

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: kAccent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: kAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Title
            const Text(
              "End of Day\nRecap",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kAccent,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Stats Grid
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard("Time Spent", "45 MIN"),
                _buildStatCard("Lessons", "3"),
                _buildStatCard("XP", "120"),
                _buildStatCard("Mood", "😊"),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 Streak + Avatar
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.local_fire_department,
                        color: Colors.orangeAccent, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "7-Day Streak!",
                      style: TextStyle(
                        color: kAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                      'assets/images/avatar.png'), // 🔹 Placeholder for avatar
                ),
                const SizedBox(height: 12),
                const Text(
                  "See you tomorrow!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 Sleep Mode Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add navigation or sleep action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: kAccent, width: 1.5),
                  ),
                  elevation: 8,
                  shadowColor: kGlow.withOpacity(0.6),
                ),
                child: const Text(
                  "Sleep Mode",
                  style: TextStyle(
                    color: kAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
