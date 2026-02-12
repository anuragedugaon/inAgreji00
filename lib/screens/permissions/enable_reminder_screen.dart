import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';

class EnableReminderScreen extends StatelessWidget {
  const EnableReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color kAccent = Colors.cyanAccent;
    const Color textColor = Colors.white;
    const Color subtitleColor = Colors.white70;

    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 30);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () => Navigator.pop(context, selectedTime),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔔 Bell Icon (replace with asset if available)
                const Icon(
                  Icons.notifications_active,
                  color: Colors.amber,
                  size: 80,
                ),
                const SizedBox(height: 30),

                // Title
                const Text(
                  "Enable Reminders\nto Stay Consistent",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Subtitle / Info text
                const Text(
                  "\"InAngreji\" Would Like to Send You Notifications.\n\n"
                  "Notifications may include alerts, sounds, and icon badges. "
                  "These can be configured in Settings.",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // ✅ Allow Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Set Daily Reminder screen
                      Navigator.pushReplacementNamed(context, AppRoutes.daily);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: kAccent, width: 1.5),
                      ),
                      elevation: 6,
                      shadowColor: kAccent.withOpacity(0.6),
                    ),
                    child: const Text(
                      "Allow",
                      style: TextStyle(
                        color: kAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ❌ Don’t Allow Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // example: close screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      "Don't Allow",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
