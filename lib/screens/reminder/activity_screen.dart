import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Toggle state for tabs
  int selectedIndex = 2; // Default to "All"

  // Theme colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  final List<String> tabs = ["Daily", "Weekly", "All"];

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
          "Activity",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                tabs.length,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? kAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kAccent, width: 1.2),
                      boxShadow: selectedIndex == index
                          ? [
                        BoxShadow(
                          color: kGlow.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                          : [],
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: selectedIndex == index ? Colors.black : kAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Activity Cards
            Expanded(
              child: ListView(
                children: [
                  _buildActivityCard(
                    avatar: "assets/images/avatar.png",
                    title: "Learn a Sentence",
                    progress: "90%",
                    subtitle: "Make a Sentence",
                  ),
                  _buildActivityCard(
                    time: "10:15 AM",
                    progress: "87%",
                    title: "Flashcards",
                    subtitle: "Flashcards",
                  ),
                  _buildActivityCard(
                    time: "Yesterday",
                    progress: "95%",
                    title: "Grammar Rule",
                    subtitle: "Voice Practice",
                  ),
                  _buildActivityCard(
                    time: "Monday",
                    progress: "88%",
                    title: "Voice Practice",
                    subtitle: "Listening Practice",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Reusable Activity Card Widget
  Widget _buildActivityCard({
    String? avatar,
    String? time,
    required String progress,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          if (avatar != null) ...[
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(avatar),
            ),
            const SizedBox(width: 12),
          ] else if (time != null) ...[
            Text(
              time,
              style: const TextStyle(color: kText, fontSize: 12),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: kAccent, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            progress,
            style: const TextStyle(
              color: kAccent,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: kAccent, size: 16), // ✅ trailing arrow
        ],
      ),
    );
  }
}
