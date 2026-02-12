import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart'; // ✅ import your routes

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});




  @override
  Widget build(BuildContext context) {
    // Theme Colors
    const Color backgroundColor = Colors.black;
    const Color primaryColor = Colors.cyanAccent;
    const Color textColor = Colors.white;
    const Color cardColor = Color(0xFF1C1C1E);
    const Color goldColor = Color(0xFFFFD700);
    const Color silverColor = Color(0xFFC0C0C0);
    const Color bronzeColor = Color(0xFFCD7F32);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Title Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Leaderboard",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleButton(
                        "Weekly",
                        true,
                        routeName: '/weekly',
                        context: context,
                      ),
                      const SizedBox(width: 12),
                      _buildToggleButton(
                        "Daily",
                        false,
                        //routeName: '/monthlyLeaderboard',
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Crown Icon
            const Icon(Icons.emoji_events, color: goldColor, size: 60),

            const SizedBox(height: 10),

            // 1st Place Highlight
            _buildLeaderTile(
              rank: 1,
              name: "Aditya",
              coins: 1008,
              xp: 1120,
              medalColor: goldColor,
              isTop: true,
            ),

            // Other Players
            Expanded(
              child: ListView(
                children: [
                  _buildLeaderTile(
                    rank: 2,
                    name: "Sophia",
                    coins: 396,
                    xp: 1100,
                    medalColor: silverColor,
                  ),
                  _buildLeaderTile(
                    rank: 3,
                    name: "Alex",
                    coins: 372,
                    xp: 1040,
                    medalColor: bronzeColor,
                  ),
                  _buildLeaderTile(
                    rank: 4,
                    name: "Desha",
                    coins: 295,
                    xp: 970,
                  ),
                  _buildLeaderTile(
                    rank: 5,
                    name: "Emma",
                    coins: 210,
                    xp: 890,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar with navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Rewards tab highlighted by default
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            // case 1: // Rewards (current screen)
            //   Navigator.pushReplacementNamed(context, AppRoutes.rewards);
              // break;
            case 1: // AI Chat
              Navigator.pushReplacementNamed(context, AppRoutes.aiChat);
              break;
            case 2: // Explore
              //Navigator.pushReplacementNamed(context, AppRoutes.explore);
              break;
          }
        },
        backgroundColor: cardColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.emoji_events), label: "Rewards"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
          // BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        ],
      ),
    );
  }

  /// Toggle Button Widget
  static Widget _buildToggleButton(
    String text,
    bool isSelected, {
    String? routeName,
    BuildContext? context,
  }) {
    return GestureDetector(
      onTap: () {
        if (routeName != null && context != null) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    required int coins,
    required int xp,
    Color? medalColor,
    bool isTop = false,
  }) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (medalColor != null)
            Icon(Icons.emoji_events, color: medalColor, size: 20),
          if (medalColor == null)
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.cyanAccent,
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueGrey,
            child: Text(
              name[0], // first letter as placeholder
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(
        "Coins: $coins",
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
      trailing: Text(
        "$xp XP",
        style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
