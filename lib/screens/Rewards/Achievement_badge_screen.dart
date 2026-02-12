import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/app_provider.dart';

class AchievementBadgeScreen extends StatefulWidget {
  const AchievementBadgeScreen({super.key});

  @override
  State<AchievementBadgeScreen> createState() => _AchievementBadgeScreenState();
}

class _AchievementBadgeScreenState extends State<AchievementBadgeScreen> {
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  List<dynamic> _achievements = [];

  @override
  void initState() {
    super.initState();
    _fetchAchievements();
  }

  Future<void> _fetchAchievements() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final data = await appProvider.getAchievements();
    setState(() => _achievements = data);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () => Navigator.pop(context, '/leader'),
        ),
        centerTitle: true,
        title: const Text(
          "Achievement Badges",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: appProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 🌟 Highlighted Badge (Top 1 achievement)
                  if (_achievements.isNotEmpty)
                    _buildHighlightBadge(_achievements.first),

                  const SizedBox(height: 30),

                  // 🔲 Grid of achievements
                  Expanded(
                    child: _achievements.isEmpty
                        ? const Center(
                            child: Text(
                              "No achievements available.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : GridView.builder(
                            itemCount: _achievements.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              final achievement = _achievements[index];
                              return _buildAchievementTile(achievement, index);
                            },
                          ),
                  ),

                  // 📘 Bottom Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
                        "Sartirm payeny",
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
    );
  }

  /// 🌟 Highlighted top achievement
  Widget _buildHighlightBadge(dynamic achievement) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.star, size: 80, color: kAccent),
          const SizedBox(height: 12),
          Text(
            achievement['title'] ?? 'Achievement',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "+${achievement['reward_xp']} XP  |  ${achievement['reward_coins']} Coins",
            style: const TextStyle(
              fontSize: 16,
              color: kAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔲 Individual achievement tile
  Widget _buildAchievementTile(dynamic achievement, int index) {
    return Container(
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kAccent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 36, color: kAccent),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              achievement['title'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
