import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart'; // ✅ import your routes file

class NiceToMeetScreen extends StatefulWidget {
  const NiceToMeetScreen({super.key});

  @override
  State<NiceToMeetScreen> createState() => _NiceToMeetScreenState();
}

class _NiceToMeetScreenState extends State<NiceToMeetScreen> {
  // Track the currently selected index
  int _selectedIndex = 0;

  // Theme constants
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color highlightTextColor = Colors.orangeAccent;

  // ✅ Handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1: // Lessons
        Navigator.pushReplacementNamed(context, AppRoutes.idiom);
        break;
      case 2: // Practice
        Navigator.pushReplacementNamed(context, AppRoutes.image);
        break;
      case 3: // Messages
        Navigator.pushReplacementNamed(context, AppRoutes.calendar);
        break;
      case 4: // Profile
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ✅ Bottom Navigation Bar with navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // <-- Added navigation handler
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "Lessons"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: "Practice"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Repeat After Me Button
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  "Repeat after me",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Avatar Image Placeholder
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Highlighted sentence
              const Text(
                "Nice to meet you.",
                style: TextStyle(
                  color: highlightTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),

              // ✅ Mic Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.mic, color: accentColor, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
