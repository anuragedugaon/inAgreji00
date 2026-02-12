import 'package:flutter/material.dart';

class MyPremiumScreen extends StatelessWidget {
  const MyPremiumScreen({super.key});

  // Theme colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF111113);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () {
            Navigator.pop(context); // 👈 goes back to previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              const Spacer(),

              // ✅ Title
              const Text(
                "You're Premium Now!",
                style: TextStyle(
                  color: kBorder,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // ✅ Features Card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                decoration: BoxDecoration(
                  color: kCardFill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kGlow.withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildFeatureRow(Icons.check_circle, "Unlimited Practice"),
                    const SizedBox(height: 14),
                    _buildFeatureRow(
                        Icons.rate_review_outlined, "Detailed Feedback"),
                    const SizedBox(height: 14),
                    _buildFeatureRow(Icons.block, "No Ads"),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Start Exploring Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to home or dashboard
                    // Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: kBorder, width: 1.5),
                    ),
                    elevation: 8,
                    shadowColor: kGlow.withOpacity(0.6),
                  ),
                  child: const Text(
                    "Start Exploring",
                    style: TextStyle(
                      color: kBorder,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kBorder,
        unselectedItemColor: Colors.white70,
        currentIndex: 3, // Profile highlighted
        onTap: (index) {
          // TODO: Handle navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Track"),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle), label: "Learn"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// ✅ Feature Row Builder
  static Widget _buildFeatureRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: kBorder, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: kText,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
