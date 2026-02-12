import 'package:flutter/material.dart';

class ParentSettingsScreen extends StatelessWidget {
  const ParentSettingsScreen({super.key});

  static const Color kBackgroundStart = Color(0xFF000000);
  static const Color kBackgroundEnd = Color(0xFF0047AB);
  static const Color kAccent = Colors.cyanAccent;

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
            automaticallyImplyLeading: false, // 👈 leading icon OFF

          centerTitle: true,
          title: const Text(
            "Parent Settings",
            style: TextStyle(
              color: kAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSettingTile(Icons.notifications, "Manage Notifications"),
            _buildSettingTile(Icons.lock, "Parental Controls"),
            _buildSettingTile(Icons.people, "Linked Child Accounts"),
            _buildSettingTile(Icons.security, "Privacy & Security"),
            _buildSettingTile(Icons.logout, "Log Out"),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: kAccent),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white70, size: 18),
        onTap: () {},
      ),
    );
  }
}
