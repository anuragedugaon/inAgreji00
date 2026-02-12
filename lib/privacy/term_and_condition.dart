import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static const Color bg = Colors.black;
  static const Color accent = Colors.cyanAccent;
  static const Color card = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent, width: 1.2),
          ),
          child: const Text(
            """
Welcome to InAgreji 👋

By using the InAgreji mobile application, you agree to the following terms and conditions.

1. App Usage
InAgreji is an AI-powered English learning app designed for educational purposes only.

2. User Responsibility
You agree to use the app respectfully and not misuse learning content or AI features.

3. Account & Progress
Your learning progress may be stored locally or securely on our servers to improve your experience.

4. AI Content
AI-generated content is provided for learning assistance and may not always be 100% accurate.

5. Data & Privacy
Your data is handled according to our Privacy Policy. We do not sell personal data.

6. Modifications
We may update these terms at any time. Continued use means acceptance of updated terms.

7. Contact
For any questions, contact us at:
📧 inangreji@gmail.com

Thank you for using InAgreji ❤️
            """,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
