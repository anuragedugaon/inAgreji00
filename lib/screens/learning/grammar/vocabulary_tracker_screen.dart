import 'package:flutter/material.dart';

class VocabularyTrackerScreen extends StatefulWidget {
  const VocabularyTrackerScreen({super.key});

  @override
  State<VocabularyTrackerScreen> createState() => _VocabularyTrackerScreenState();
}

class _VocabularyTrackerScreenState extends State<VocabularyTrackerScreen> {
  // Current selected tab
  String selectedTab = "Favorite";

  // Sample vocabulary list
  final List<String> words = [
    "Achievement",
    "Benefit",
    "Confidence",
    "Determined",
    "Effort",
    "Fluency",
    "Indicate",
    "Pronounce",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vocabulary Tracker",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tabs (New | Favorite | Mastered)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton("New"),
                const SizedBox(width: 10),
                _buildTabButton("Favorite"),
                const SizedBox(width: 10),
                _buildTabButton("Mastered"),
              ],
            ),
            const SizedBox(height: 20),

            // 📃 Vocabulary List
            Expanded(
              child: ListView.separated(
                itemCount: words.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.grey, height: 1),
                itemBuilder: (context, index) {
                  final word = words[index];
                  return ListTile(
                    title: Text(
                      word,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: _buildProgressIndicator(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Tab button builder
  Widget _buildTabButton(String tabName) {
    final isSelected = selectedTab == tabName;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tabName;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent.withOpacity(0.2) : Colors.transparent,
          border: Border.all(color: Colors.cyanAccent, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            color: isSelected ? Colors.cyanAccent : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 🔹 Progress Indicator (circular ring or speaker icon)
  Widget _buildProgressIndicator(int index) {
    if (words[index] == "Indicate") {
      return const Icon(Icons.volume_up, color: Colors.cyanAccent, size: 24);
    }
    return SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        value: (index + 1) / words.length, // sample progress
        strokeWidth: 3,
        color: Colors.cyanAccent,
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}
