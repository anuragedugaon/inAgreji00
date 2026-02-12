// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart'; // ✅ assuming you manage routes here

// class HelpScreen extends StatelessWidget {
//   const HelpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Theme colors
//     const Color backgroundColor = Colors.black;
//     const Color cardColor = Colors.cyanAccent;
//     const Color glowColor = Color(0xFF80FFFF);
//     const Color textColor = Colors.black;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
//           onPressed: () {
//             Navigator.pop(context); // 👈 goes back to previous screen
//           },
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Help",
//           style: TextStyle(
//             color: cardColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ✅ Support Center Card
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacementNamed(
//                     context, AppRoutes.center); // route to HelpScreen
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: glowColor.withOpacity(0.6),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: const Text(
//                   "Support Center",
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ✅ Report a Problem Card
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacementNamed(
//                     context, AppRoutes.report); // route to ReportProblemScreen
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: glowColor.withOpacity(0.6),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: const Text(
//                   "Report a Problem",
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  
  static const String supportPhone = "+919876543210";
static const String supportEmail = "inangreji@gmail.com";

Future<void> _callSupport() async {
  final uri = Uri(scheme: 'tel', path: supportPhone);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Error launching call: $e');
  }
}

Future<void> _emailSupport() async {
  final uri = Uri(
    scheme: 'mailto',
    path: supportEmail,
    query: Uri(queryParameters: {
      'subject': 'Support Request - InAngreji',
    }).query,
  );
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('Error launching email: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    const Color backgroundTop = Colors.black;
    const Color backgroundBottom = Color(0xFF001F3F);
    const Color cardColor = Color(0xFF101317);
    const Color accent = Colors.cyanAccent;
    const Color glow = Color(0xFF80FFFF);

    return Scaffold(
      backgroundColor: backgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Support Center",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundTop, backgroundBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header + subtitle
                const Text(
                  "Need Help?",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "We are here to support you.\nContact us any time for help with InAngreji.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Small illustration / icon circle
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.4),
                        accent.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withOpacity(0.5),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.headset_mic_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 32),

                // Phone Card
                _ContactCard(
                  title: "Call Support",
                  subtitle: "Talk to our support team",
                  value: supportPhone,
                  icon: Icons.phone_in_talk_rounded,
                  onTap: () => _callSupport(),
                ),

                const SizedBox(height: 18),

                // Email Card
                _ContactCard(
                  title: "Email Support",
                  subtitle: "Send us your questions",
                  value: supportEmail,
                  icon: Icons.email_rounded,
                  onTap: () => _emailSupport(),
                ),

                const Spacer(),

                // Small footer text
                const Text(
                  "Support hours: 9:00 AM – 8:00 PM (IST)",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _ContactCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF101317);
    const Color accent = Colors.cyanAccent;
    const Color glow = Color(0xFF80FFFF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withOpacity(0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: glow.withOpacity(0.35),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon side
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accent.withOpacity(0.7),
                  width: 1.2,
                ),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // Text side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      color: accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
