import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 📊 For bar chart and pie chart

class LearningDashboardScreen extends StatelessWidget {
  const LearningDashboardScreen({super.key});

  // 🎨 Theme Colors
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
        title: const Text(
          "Learning Dashboard",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 📊 Weekly Activity + Skill Focus Row
            Row(
              children: [
                Expanded(child: _buildWeeklyActivityCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildSkillFocusCard()),
              ],
            ),

            const SizedBox(height: 20),

            // 🤖 AI Insights
            _buildAIInsightsCard(),

            const SizedBox(height: 20),

            // 💰 Surt Coins Progress
            _buildSurtCoinsCard(),
          ],
        ),
      ),

      // 🔽 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBackground,
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// 📊 Weekly Activity (Bar Chart)
  Widget _buildWeeklyActivityCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Weekly Activity", style: TextStyle(color: kText, fontSize: 14)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ["M", "T", "W", "T", "F", "S"];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()],
                              style: const TextStyle(color: kAccent, fontSize: 12));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (int i = 0; i < 6; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (i + 2) * 2.5, // sample data
                          color: kAccent,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🥧 Skill Focus (Pie Chart)
  Widget _buildSkillFocusCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Skill Focus", style: TextStyle(color: kText, fontSize: 14)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 45, color: kAccent, title: "45%", radius: 40),
                  PieChartSectionData(value: 25, color: Colors.blue, title: "25%", radius: 35),
                  PieChartSectionData(value: 15, color: Colors.indigo, title: "15%", radius: 30),
                  PieChartSectionData(value: 15, color: Colors.cyan.shade700, title: "15%", radius: 25),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🤖 AI Insights Card
  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: const [
          Icon(Icons.smart_toy, color: kAccent, size: 36),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "AI Insights\nYou speak 23% faster",
              style: TextStyle(color: kAccent, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// 💰 Surt Coins Progress
  Widget _buildSurtCoinsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Surt Coins", style: TextStyle(color: kText, fontSize: 16)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey.shade800,
            valueColor: const AlwaysStoppedAnimation<Color>(kAccent),
            minHeight: 12,
          ),
          const SizedBox(height: 8),
          const Text("60%", style: TextStyle(color: kAccent, fontSize: 14)),
        ],
      ),
    );
  }

  /// 🔲 Card Decoration (reuse)
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }
}
