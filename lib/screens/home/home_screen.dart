import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_details_model.dart';
import '../dailyLessonScreen/listen_and_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AIService _aiService = AIService();

  String? role;
  @override
  void initState() {
    super.initState();
        _loadUserDetails();

    getUser();
    Future.delayed(const Duration(milliseconds: 600), _speakWelcome);
  }

  UserDetailsModel? _userDetails;
  bool _loading = true;
  Future<void> _loadUserDetails() async {
    try {
      final appProvider = context.read<AppProvider>();
      final details = await appProvider.getUserDetails();

      if (!mounted) return;

      setState(() {
        _userDetails = details;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userDetails = null;
        _loading = false;
      });
    }
  }


  Future<void> _speakWelcome() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final message = appProvider.translate("home_greeting") == "home_greeting"
        ? "Welcome back! Let's continue your English journey."
        : appProvider.translate("home_greeting");
    await _aiService.speakText(message);
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    role = preferences.getString("selected_purpose");
    print("role $role");
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
 // Wallet amount from user model (in rupees, backend me "0.00" string)
    final String walletStr =
        _userDetails?.data?.walletBalance?.toString() ?? "0";
    final double rupees = double.tryParse(walletStr) ?? 0.0;

    // // Coins = rupees * coinsPerRupee
    // final int earnedCoins =
    //     (rupees * WalletScreen.coinsPerRupee).floor();
    const Color backgroundColor = Colors.black;
    const Color titleColor = Colors.white;
    const Color accentColor = Colors.cyanAccent;
    const Color cardColor = Color(0xFF1C1C1E);
    const Color goldColor = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Top navigation row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TopNavItem(
                    icon: Icons.book,
                    label: appProvider.translate("practice") == "practice"
                        ? "Practice"
                        : appProvider.translate("practice"),
                    routeName: '/today',
                  ),
                  _TopNavItem(
                    icon: Icons.emoji_events,
                    label: appProvider.translate("rewards") == "rewards"
                        ? "Rewards"
                        : appProvider.translate("rewards"),
                    routeName: '/rewards',
                  ),
                  _TopNavItem(
                    icon: Icons.chat,
                    label: appProvider.translate("ai_chat") == "ai_chat"
                        ? "AI Chat"
                        : appProvider.translate("ai_chat"),
                    routeName: '/AiChat',
                  ),
                  _TopNavItem(
                    icon: Icons.menu,
                    label: appProvider.translate("menu") == "menu"
                        ? "Menu"
                        : appProvider.translate("menu"),
                    routeName: AppRoutes.menu,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🏅 XP and Coins Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.stars, color: accentColor, size: 20),
                      SizedBox(width: 6),
                      Text("XP 240",
                          style: TextStyle(color: titleColor, fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: goldColor, size: 20),
                      const SizedBox(width: 6),
                      Text("$rupees Coins",
                          style: const TextStyle(color: titleColor, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 My Goals Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appProvider.translate("my_goals") == "my_goals"
                          ? "My Goals"
                          : appProvider.translate("my_goals"),
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      // appProvider.translate(role??"") == "goal_example"
                      //     ?
                           role ?? "",
                          // : appProvider.translate(role??""),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🧠 Lessons Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        // Daily Test Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  appProvider.translate("daily_test") ==
                                          "daily_test"
                                      ? "Daily Test"
                                      : appProvider.translate("daily_test"),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  appProvider.translate("start_skill_check") ==
                                          "start_skill_check"
                                      ? "Start your Skill Check!"
                                      : appProvider
                                          .translate("start_skill_check"),
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.dailyQuiz);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: const BorderSide(
                                            color: accentColor, width: 1.5),
                                      ),
                                    ),
                                    child: Text(
                                      appProvider.translate("continue") ==
                                              "continue"
                                          ? "Continue"
                                          : appProvider.translate("continue"),
                                      style: const TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Weekly Progress + Word of the Day
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                 
                                 
                                  // Navigator.push(
                                  //     context, MaterialPageRoute(builder: (context) => const ListenSelectScreen()));
                               
                               
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appProvider.translate(
                                                    "weekly_progress") ==
                                                "weekly_progress"
                                            ? "Weekly Progress"
                                            : appProvider
                                                .translate("weekly_progress"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        appProvider.translate("current_streak") ==
                                                "current_streak"
                                            ? "Current streak: 4 days 🔥"
                                            : appProvider
                                                .translate("current_streak"),
                                        style: const TextStyle(
                                            color: Colors.white70, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/opportunity');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appProvider.translate("word_day") ==
                                                "word_day"
                                            ? "Word of the Day"
                                            : appProvider.translate("word_day"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        appProvider.translate("opportunity") ==
                                                "opportunity"
                                            ? "Opportunity"
                                            : appProvider
                                                .translate("opportunity"),
                                        style: const TextStyle(
                                            color: Colors.cyanAccent,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🌍 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.lesson);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.rule);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.parent);
              break;
          }
        },
        backgroundColor: cardColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: appProvider.translate("home") == "home"
                ? "Home"
                : appProvider.translate("home"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: appProvider.translate("lessons") == "lessons"
                ? "Lessons"
                : appProvider.translate("lessons"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.lightbulb),
            label: appProvider.translate("tips") == "tips"
                ? "Tips"
                : appProvider.translate("tips"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.family_restroom_rounded),
            label: appProvider.translate("parent") == "parent"
                ? "Parent"
                : appProvider.translate("parent"),
          ),
        ],
      ),
    );
  }
}

/// Reusable localized top navigation item
class _TopNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? routeName;

  const _TopNavItem({
    required this.icon,
    required this.label,
    this.routeName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (routeName != null) {
          Navigator.pushNamed(context, routeName!);
        }
      },
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
