import 'package:flutter/material.dart';

class WeeklyMilestoneScreen extends StatelessWidget {
  const WeeklyMilestoneScreen({super.key});

  // Theme colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
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
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Weekly Milestone",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🏆 Trophy Icon
            Icon(
              Icons.emoji_events,
              size: 80,
              color: kAccent,
              shadows: [
                Shadow(
                  color: kGlow.withOpacity(0.6),
                  blurRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📊 Weekly Progress Graph (Mocked as bars)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAccent, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: kGlow.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Days Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text("S", style: TextStyle(color: kText)),
                      Text("M", style: TextStyle(color: kText)),
                      Text("T", style: TextStyle(color: kText)),
                      Text("W", style: TextStyle(color: kText)),
                      Text("T", style: TextStyle(color: kText)),
                      Text("F", style: TextStyle(color: kText)),
                      Text("S", style: TextStyle(color: kText)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Bars for each day
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(40),
                        _buildBar(70),
                        _buildBar(50),
                        _buildBar(80),
                        _buildBar(30),
                        _buildBar(100),
                        _buildBar(60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Lessons Completed Text
            const Text(
              "You've completed 5 lessons this week",
              style: TextStyle(color: kText, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // 📘 View Report Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Report Screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: kAccent, width: 1.5),
                  ),
                  elevation: 8,
                  shadowColor: kGlow.withOpacity(0.6),
                ),
                child: const Text(
                  "View Report",
                  style: TextStyle(
                    color: kAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // 🔽 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackground,
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // Highlight Milestone/Progress tab
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Goals"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// 📊 Helper to build progress bars
  static Widget _buildBar(double height) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(
        color: kAccent,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
