import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart'; // ✅ Import your routes

class ListenAndChooseScreen extends StatefulWidget {
  const ListenAndChooseScreen({super.key});

  @override
  State<ListenAndChooseScreen> createState() => _ListenAndChooseScreenState();
}

class _ListenAndChooseScreenState extends State<ListenAndChooseScreen> {
  // Track the selected answer index
  int? selectedIndex;

  // Correct answer index
  final int correctAnswerIndex = 2; // ✅ "Nice to meet you." is correct

  // Theme constants
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color correctOptionColor = Colors.greenAccent;
  static const Color wrongOptionColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
       appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                "Listen and Choose\nthe Correct Response",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Play Button
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: accentColor,
                  size: 48,
                ),
              ),

              const SizedBox(height: 50),

              // Options
              _buildOption(0, "Hello? Who is this?", Icons.graphic_eq),
              const SizedBox(height: 20),
              _buildOption(1, "Yes, my name is Alice.", Icons.mic),
              const SizedBox(height: 20),
              _buildOption(2, "Nice to meet you.", Icons.graphic_eq),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Option Builder
  Widget _buildOption(int index, String text, IconData icon) {
    final bool isSelected = selectedIndex == index;
    final bool isCorrect = index == correctAnswerIndex;

    final Color borderColor = isSelected
        ? (isCorrect ? correctOptionColor : wrongOptionColor)
        : accentColor;

    final Color fillColor = isSelected
        ? (isCorrect
            ? correctOptionColor.withOpacity(0.2)
            : wrongOptionColor.withOpacity(0.2))
        : Colors.transparent;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // ✅ If correct, navigate to next screen after short delay
        // if (index == correctAnswerIndex) {
        //   Future.delayed(const Duration(milliseconds: 800), () {
        //     Navigator.pushReplacementNamed(context, AppRoutes.blank);
        //     // 👆 Replace with your actual route from app_routes.dart
        //   });
        // }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: borderColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
