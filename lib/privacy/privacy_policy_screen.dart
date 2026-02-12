import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const Color bg = Colors.black;
  static const Color accent = Colors.cyanAccent;
  static const Color text = Colors.white70;

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
          "Privacy Policy",
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SectionTitle("InAgreji Privacy Policy"),
            _Paragraph(
              "InAgreji values your privacy and is committed to protecting your personal information. "
              "This Privacy Policy explains how we collect, use, and safeguard your data when you use our application.",
            ),

            _SectionTitle("Information We Collect"),
            _Bullet("Basic profile information such as name or learning level"),
            _Bullet("App usage data to improve learning experience"),
            _Bullet("Voice input (only for speaking practice, not stored permanently)"),
            _Bullet("Progress and performance data"),

            _SectionTitle("How We Use Your Information"),
            _Bullet("To personalize learning content"),
            _Bullet("To improve app performance and features"),
            _Bullet("To track learning progress"),
            _Bullet("To provide AI-based feedback"),

            _SectionTitle("Data Sharing"),
            _Paragraph(
              "We do not sell, trade, or rent your personal information to third parties. "
              "Your data is used only to enhance your learning experience.",
            ),

            _SectionTitle("Data Security"),
            _Paragraph(
              "We use industry-standard security measures to protect your information. "
              "However, no digital platform is 100% secure.",
            ),

            _SectionTitle("Children’s Privacy"),
            _Paragraph(
              "InAgreji does not knowingly collect personal information from children under 13. "
              "If you believe such data has been collected, please contact us.",
            ),

            _SectionTitle("Changes to This Policy"),
            _Paragraph(
              "We may update this Privacy Policy from time to time. "
              "Any changes will be reflected on this page.",
            ),

            _SectionTitle("Contact Us"),
            _ContactEmail(),
          ],
        ),
      ),
    );
  }
}

// ===================== UI HELPERS =====================

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(color: Colors.cyanAccent)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactEmail extends StatelessWidget {
  const _ContactEmail();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse("mailto:inangreji@gmail.com");
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "📧 inangreji@gmail.com",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
