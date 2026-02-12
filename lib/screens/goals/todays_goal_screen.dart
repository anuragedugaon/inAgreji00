import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../provider/app_provider.dart';
import '../../routes/app_routes.dart';

class TodaysGoalScreen extends StatefulWidget {
  const TodaysGoalScreen({super.key});

  @override
  State<TodaysGoalScreen> createState() => _TodaysGoalScreenState();
}

class _TodaysGoalScreenState extends State<TodaysGoalScreen> {
  static const Color kBackground = Colors.black;
  static const Color kText = Colors.white;
  static const Color kAccentBlue = Colors.cyanAccent;
  static const Color kOrange = Colors.deepOrangeAccent;
  static const Color kGlow = Color(0xFF00FFFF);

  double _progress = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final goals = await appProvider.getGoals();

    if (goals.isNotEmpty && goals.first != null) {
      // Example: your backend may return something like {"progress": 80}
      final goal = goals.first;
      double percent = 0.0;

      if (goal['progress'] != null) {
        // Expecting progress in percentage (e.g., 80)
        percent = (goal['progress'] / 100).clamp(0.0, 1.0);
      }

      setState(() {
        _progress = percent;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
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
          icon: const Icon(Icons.arrow_back_ios, color: kAccentBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading || appProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccentBlue))
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TODAY'S GOAL",
                    style: TextStyle(
                      color: kAccentBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔹 Dynamic Circular Progress
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 14.0,
                    percent: _progress,
                    startAngle: 180,
                    circularStrokeCap: CircularStrokeCap.round,
                    linearGradient: const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.deepOrangeAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orange, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          "${(_progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            color: kText,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "STREAK",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // 🔹 Continue Practice Button
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.convo);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: kAccentBlue, width: 1.5),
                        ),
                        elevation: 8,
                        shadowColor: kGlow.withOpacity(0.6),
                      ),
                      child: const Text(
                        "Continue Practice",
                        style: TextStyle(
                          color: kAccentBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 🔹 Bottom Navigation
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                            context, Icons.home, "Home", false, AppRoutes.home),
                        _buildNavItem(context, Icons.fitness_center, "Practice",
                            true, AppRoutes.today),
                        _buildNavItem(context, Icons.card_giftcard,
                            "Achievements", false, AppRoutes.badge),
                        // _buildNavItem(context, Icons.more_horiz,
                        //     "Grammar Master", false, AppRoutes.master),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  static Widget _buildNavItem(BuildContext context, IconData icon, String label,
      bool isActive, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? kAccentBlue : Colors.white54,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? kAccentBlue : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
