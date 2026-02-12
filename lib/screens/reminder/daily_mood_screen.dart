import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';

import '../../widgets/message_bubble.dart';

class DailyMoodScreen extends StatefulWidget {
  const DailyMoodScreen({super.key});

  @override
  State<DailyMoodScreen> createState() => _DailyMoodScreenState();
}

class _DailyMoodScreenState extends State<DailyMoodScreen> {
  // Mood level state (0 = sad, 4 = happy)
  double moodValue = 2;

  // Theme colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  // Emoji List
  final List<String> emojis = ["😞", "😐", "🙂", "😊", "😁"];

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
        centerTitle: true,
        title: const Text(
          "Daily Mood",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "How are you feeling today?",
              style: TextStyle(color: kText, fontSize: 16),
            ),
            const SizedBox(height: 20),

            // ✅ Mood Emojis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                emojis.length,
                (index) => Text(
                  emojis[index],
                  style: TextStyle(
                    fontSize: 32,
                    color: moodValue.round() == index ? kAccent : kText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Mood Slider
            Slider(
              value: moodValue,
              min: 0,
              max: 4,
              divisions: 4,
              activeColor: kAccent,
              inactiveColor: Colors.grey.shade700,
              onChanged: (value) {
                setState(() {
                  moodValue = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // ✅ AI Suggestion Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: kGlow.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      "AI",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Try a brief breathing exercise",
                      style: TextStyle(color: kText, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ✅ Save Mood Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                

                                   showResultSnackBar(context, "Mood saved!",true);

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
                  "Save Today's Mood",
                  style: TextStyle(
                    color: kAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // highlight current tab (set accordingly per screen)
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1: // chat
              Navigator.pushReplacementNamed(context, AppRoutes.convo);
              break;
            case 2: // track
              Navigator.pushReplacementNamed(context, AppRoutes.mood);
              break;
            case 3: // profile
              Navigator.pushReplacementNamed(context, AppRoutes.profile);
              break;
          }
        },
        backgroundColor: kBackground,
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
