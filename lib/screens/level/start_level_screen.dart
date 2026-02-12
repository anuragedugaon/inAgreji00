import 'package:flutter/material.dart';

class StartLevelScreen extends StatelessWidget {
  const StartLevelScreen({super.key});

  // 🎨 Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔥 Level Title
            const Text(
              "Level 12 → 13",
              style: TextStyle(
                color: kAccent,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 📊 Progress Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kCardFill,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: kGlow.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: 0.6, // ✅ 60% filled (example)
                    backgroundColor: Colors.grey.shade800,
                    valueColor: const AlwaysStoppedAnimation<Color>(kAccent),
                    minHeight: 12,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "4000 XP",
                    style: TextStyle(
                      color: kText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // 🚀 Start Expiring Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle navigation or action
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
                  "Start Expiring",
                  style: TextStyle(
                    color: kAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // 🔽 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackground,
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Lessons",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
