import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  static const Color kBackgroundStart = Color(0xFF000000);
  static const Color kBackgroundEnd = Color(0xFF0047AB);
  static const Color kAccent = Colors.cyanAccent;

  final List<Map<String, dynamic>> _notifications = const [
    {
      "title": "New Lesson Unlocked! 🎉",
      "message": "Your child just unlocked the 'Colors & Shapes' lesson.",
      "time": "2 hours ago",
      "icon": Icons.school_rounded,
      "color": Colors.greenAccent,
    },
    {
      "title": "Reminder Set ⏰",
      "message": "Daily English practice reminder is active at 7:30 PM.",
      "time": "Yesterday",
      "icon": Icons.alarm_rounded,
      "color": Colors.orangeAccent,
    },
    {
      "title": "Achievement Earned 🏅",
      "message": "Anand completed the 'Basic Greetings' challenge.",
      "time": "2 days ago",
      "icon": Icons.emoji_events_rounded,
      "color": Colors.pinkAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kBackgroundStart, kBackgroundEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Announcements",
            style: TextStyle(
              color: kAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false, // 👈 leading icon OFF

        ),
        body: _notifications.isEmpty
            ? const Center(
                child: Text(
                  "No notifications yet 🎈",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kAccent.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: kAccent.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item["color"].withOpacity(0.3),
                        child: Icon(item["icon"], color: item["color"]),
                      ),
                      title: Text(
                        item["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item["message"],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        item["time"],
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
