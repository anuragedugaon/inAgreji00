import 'package:flutter/material.dart';

class MakeSentenceScreen extends StatefulWidget {
  const MakeSentenceScreen({super.key});

  @override
  State<MakeSentenceScreen> createState() => _MakeSentenceScreenState();
}

class _MakeSentenceScreenState extends State<MakeSentenceScreen> {
  String? selectedOption;

  // Correct answer
  final String correctAnswer = "go";

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color titleColor = Colors.cyanAccent;
    const Color borderColor = Colors.cyanAccent;
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
              ),

              const SizedBox(height: 10),

              // Title
              Center(
                child: Text(
                  "Make a sentence:",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sentence box
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "I ___ to school",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Options list
              Center(
                child: Column(
                  children: [
                    _buildOptionButton("going"),
                    const SizedBox(height: 20),
                    _buildOptionButton("go"), // ✅ Correct
                    const SizedBox(height: 20),
                    _buildOptionButton("went"),
                  ],
                ),
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to streak summary screen
                    Navigator.pushReplacementNamed(context, '/opportunity');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(
                        color: Colors.cyanAccent, // Cyan border
                        width: 1.5,
                      ),
                    ),
                    elevation: 8,
                    shadowColor: Colors.cyanAccent.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bottom Decoration (confetti simulation placeholder)
              Container(
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text(
                  "✨ Confetti Effect Here ✨",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a custom rounded option button
  Widget _buildOptionButton(String text) {
    bool isSelected = selectedOption == text;
    bool isCorrect = isSelected && text == correctAnswer;

    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedOption = text;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isCorrect ? Colors.cyanAccent : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
          ),
          elevation: isCorrect ? 10 : 4,
          shadowColor: Colors.cyanAccent.withOpacity(0.6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isCorrect ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
