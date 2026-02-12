import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
            automaticallyImplyLeading: false, // 👈 leading icon OFF

          backgroundColor: Colors.transparent,
          elevation: 0,
          
          centerTitle: true,
          title: const Text(
            "Daily Schedule",
            style: TextStyle(
              color: kAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            _buildScheduleCard(
              icon: Icons.sunny,
              title: "Morning Learning",
              time: "8:00 AM - 9:30 AM",
            ),
            _buildScheduleCard(
              icon: Icons.book,
              title: "Grammar & Vocabulary",
              time: "10:00 AM - 11:30 AM",
            ),
            _buildScheduleCard(
              icon: Icons.headphones,
              title: "Listening Practice",
              time: "4:00 PM - 5:00 PM",
            ),
            _buildScheduleCard(
              icon: Icons.bedtime,
              title: "Bedtime Story Session",
              time: "8:00 PM",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
      {required IconData icon, required String title, required String time}) {
    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: kAccent, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
