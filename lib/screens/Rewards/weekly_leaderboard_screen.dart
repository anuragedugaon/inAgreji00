import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';

class WeeklyLeaderboardScreen extends StatelessWidget {
  const WeeklyLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color primaryColor = Colors.cyanAccent;
    const Color textColor = Colors.white;
    const Color cardColor = Color(0xFF1C1C1E);

    // Sample data
    final List<Map<String, dynamic>> leaderboard = [
      {"rank": 1, "name": "Emma", "xp": 2350},
      {"rank": 2, "name": "Luke", "xp": 2310},
      {"rank": 3, "name": "Sophia", "xp": 2140},
      {"rank": 4, "name": "Mia", "xp": 2020},
      {"rank": 5, "name": "Liam", "xp": 1960},
      {"rank": 6, "name": "James", "xp": 1890},
      {"rank": 7, "name": "Aditi", "xp": 1840},
      {"rank": 8, "name": "Isabella", "xp": 1780},
      {"rank": 9, "name": "Noah", "xp": 1730},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button + Title
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Leaderboard",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Toggle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Weekly stays here
                  _buildToggleButton("Weekly", true, () {
                    // already on weekly, do nothing
                  }),
                  const SizedBox(width: 12),
                  // Monthly navigates
                  _buildToggleButton("Monthly", false, () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.milestone);
                  }),
                ],
              ),

              const SizedBox(height: 20),

              // Leaderboard List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final player = leaderboard[index];
                      return _buildLeaderTile(
                        rank: player["rank"],
                        name: player["name"],
                        xp: player["xp"],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Toggle Button Widget (with navigation support)
  static Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent, width: 1.2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.cyanAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Leaderboard Tile Widget
  static Widget _buildLeaderTile({
    required int rank,
    required String name,
    required int xp,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blueGrey,
        child: Text(
          name[0], // First letter placeholder
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      title: Text(
        "$rank. $name",
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Text(
        "$xp XP",
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
