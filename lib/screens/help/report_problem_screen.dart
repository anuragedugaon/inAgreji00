import 'package:flutter/material.dart';

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme colors
    const Color backgroundColor = Colors.black;
    const Color borderColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: borderColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Report a Problem",
          style: TextStyle(
            color: borderColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ✅ Subject Field
            _buildInputField("Subject", 1),

            const SizedBox(height: 20),

            // ✅ Description Field
            _buildInputField("Description", 4),

            const SizedBox(height: 20),

            // ✅ Attach Screenshot Field
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: _boxDecoration(borderColor, glowColor),
              child: Row(
                children: const [
                  Icon(Icons.add, color: borderColor, size: 28),
                  SizedBox(width: 12),
                  Text(
                    "Attach Screenshot",
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ✅ Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: borderColor, width: 1.5),
                  ),
                  elevation: 6,
                  shadowColor: glowColor.withOpacity(0.6),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: borderColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Reusable Input Field Builder
  static Widget _buildInputField(String hint, int maxLines) {
    return Container(
      decoration: _boxDecoration(Colors.cyanAccent, const Color(0xFF80FFFF)),
      child: TextField(
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// ✅ Custom BoxDecoration with glow
  static BoxDecoration _boxDecoration(Color borderColor, Color glowColor) {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: borderColor, width: 1.5),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
