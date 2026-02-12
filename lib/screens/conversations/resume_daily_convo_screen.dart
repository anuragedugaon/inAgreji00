import 'package:flutter/material.dart';

import '../ai/voice_chat_screen.dart';

class ResumeDailyConvoScreen extends StatelessWidget {
  const ResumeDailyConvoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color inProgressColor = Colors.orangeAccent;
    const Color lockedColor = Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: accentColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Progress",
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Title
            const Text(
              "Daily Conversations",
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Progress items
            _buildProgressItem("Greeting People", true, accentColor),
            const SizedBox(height: 20),
            _buildProgressItem("Asking for Help", true, accentColor),
            const SizedBox(height: 20),
            _buildProgressItem("Making Requests", true, inProgressColor),
            const SizedBox(height: 20),
            _buildProgressItem("Describing Places", false, lockedColor,
                isLocked: true),

            const Spacer(),

            // ✅ Resume Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceChatScreen(
                          prom: """
{
  "Greeting People": [
    "Hello! How are you?",
    "Nice to meet you!",
    "Good morning!",
    "Good afternoon!",
    "Good evening!"
  ],
  "Asking for Help": [
    "Can you help me, please?",
    "I need some assistance.",
    "Can you show me this?",
    "Can you explain that to me?",
    "I don’t understand. Can you help?"
  ],
  "Making Requests": [
    "Could you please open the door?",
    "Please speak slowly.",
    "Can I borrow your pen?",
    "Can you tell me the time?",
    "May I sit here?"
  ],
  "Describing Places": [
    "This place is very beautiful.",
    "The room is large and clean.",
    "The park is full of trees.",
    "The city is very crowded.",
    "The restaurant is quiet and cozy."
  ]
}

""",
                        ),
                      ));
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
                  "Resume",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ✅ Progress item builder
  Widget _buildProgressItem(String title, bool completed, Color color,
      {bool isLocked = false}) {
    return Row(
      children: [
        if (isLocked)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            child: const Text(
              "Task 4",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: color,
            size: 26,
          ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
