import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Toggle states
  bool dailyReminder = false; // ⬅️ Disabled by default
  bool lessonComplete = false;
  bool offers = true;

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBorder),
          onPressed: () => Navigator.pop(context, AppRoutes.menu),
        ),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: kBorder,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // // ✅ Daily Reminder (Navigation + Disabled Switch)
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pushReplacementNamed(context, AppRoutes.daily);
            //   },
            //   child: _buildToggleTile(
            //     "Daily Reminder",
            //     dailyReminder,
            //     null, // ⬅️ disable toggle interaction
            //   ),
            // ),
            // const SizedBox(height: 16),

            // ✅ Lesson Complete
            // _buildToggleTile("Lesson Complete", lessonComplete, (value) {
            //   setState(() => lessonComplete = value);
            // }),
            // const SizedBox(height: 16),

            // // ✅ Offers
            // _buildToggleTile("Offers", offers, (value) {
            //   setState(() => offers = value);
            // }),

            // const Spacer(),

            // // ✅ Save Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("Settings saved!")),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.transparent,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //         side: const BorderSide(color: kBorder, width: 1.5),
            //       ),
            //       elevation: 8,
            //       shadowColor: kGlow.withOpacity(0.6),
            //     ),
            //     child: const Text(
            //       "Save",
            //       style: TextStyle(
            //         color: kBorder,
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ✅ Toggle Tile Builder
  Widget _buildToggleTile(String label, bool value, Function(bool)? onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: kText, fontSize: 16),
          ),
          IgnorePointer(
            // ⬅️ makes switch non-clickable if onChanged == null
            ignoring: onChanged == null,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: kBorder,
              inactiveTrackColor: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
