// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:inangreji_flutter/provider/app_provider.dart';

// import '../../routes/app_routes.dart';

// class ChildProgressScreen extends StatefulWidget {
//   const ChildProgressScreen({super.key});

//   @override
//   State<ChildProgressScreen> createState() => _ChildProgressScreenState();
// }

// class _ChildProgressScreenState extends State<ChildProgressScreen> {
//   static const Color kBackgroundStart = Color(0xFF000000);
//   static const Color kBackgroundEnd = Color(0xFF0047AB);
//   static const Color kAccent = Colors.cyanAccent;

//   bool isLoading = true;
//   List<dynamic> lessons = [];
//   List<dynamic> goals = [];
//   List<dynamic> achievements = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadProgressData();
//   }

//   Future<void> _loadProgressData() async {
//     final provider = Provider.of<AppProvider>(context, listen: false);

//     final fetchedLessons = await provider.getUserLessons();
//     final fetchedGoals = await provider.getGoals();
//     final fetchedAchievements = await provider.getAchievements();

//     setState(() {
//       lessons = fetchedLessons;
//       goals = fetchedGoals;
//       achievements = fetchedAchievements;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [kBackgroundStart, kBackgroundEnd],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         automaticallyImplyLeading: false, // 👈 leading icon OFF

//           centerTitle: true,
//           title: const Text(
//             "Child Progress",
//             style: TextStyle(
//               color: kAccent,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: kAccent),
//               )
//             : RefreshIndicator(
//                 onRefresh: _loadProgressData,
//                 color: kAccent,
//                 backgroundColor: Colors.black,
//                 child: ListView(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   children: [
//                     const SizedBox(height: 12),

//                     // 🔹 Summary Card
//                     _buildSummaryCard(),

//                     const SizedBox(height: 20),

//                     // 🔹 Daily / Weekly Reports
//                     _buildReportSection(),

//                     const SizedBox(height: 20),

//                     // 🔹 Achievements Section
//                     _buildAchievementsSection(),

//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   /// 🧮 Summary Section
//   Widget _buildSummaryCard() {
//     int totalLessons = lessons.length;
//     int totalGoals = goals.length;
//     int totalAchievements = achievements.length;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: kAccent.withOpacity(0.3)),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           const Text(
//             "Performance Summary",
//             style: TextStyle(
//               color: kAccent,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _summaryItem(Icons.book_rounded, "Lessons", totalLessons),
//               _summaryItem(Icons.flag_rounded, "Goals", totalGoals),
//               _summaryItem(Icons.emoji_events_rounded, "Achievements",
//                   totalAchievements),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryItem(IconData icon, String label, int value) {
//     return Column(
//       children: [
//         Icon(icon, color: kAccent, size: 32),
//         const SizedBox(height: 6),
//         Text(
//           value.toString(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//       ],
//     );
//   }

//   /// 📆 Reports Section
//   Widget _buildReportSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Weekly Report",
//           style: TextStyle(
//             color: kAccent,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: kAccent.withOpacity(0.3)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text("🗓️ Lessons Completed: 5/10",
//                   style: TextStyle(color: Colors.white)),
//               SizedBox(height: 6),
//               Text("📖 Practice Streak: 7 days",
//                   style: TextStyle(color: Colors.white)),
//               SizedBox(height: 6),
//               Text("🏅 Accuracy: 85%", style: TextStyle(color: Colors.white)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   /// 🏆 Achievements Section
//   Widget _buildAchievementsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Achievements",
//           style: TextStyle(
//             color: kAccent,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         achievements.isEmpty
//             ? const Text(
//                 "No achievements yet 🎯",
//                 style: TextStyle(color: Colors.white70),
//               )
//             : Column(
//                 children: achievements.map((ach) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: kAccent.withOpacity(0.4)),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 32),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ach['title'] ?? 'Achievement',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 ach['description'] ?? '',
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Icon(Icons.arrow_forward_ios,
//                             color: Colors.white38, size: 16),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProgressScreen extends StatefulWidget {
  const ChildProgressScreen({super.key});

  @override
  State<ChildProgressScreen> createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen>
    with SingleTickerProviderStateMixin {
 
  static const Color kAccent = Colors.cyanAccent;
  static const Color kCardBg = Color(0x1AFFFFFF);

  late TabController _tabController;
  bool isLoading = true;

  // Daily Data
  Map<String, dynamic> dailyWordListen = {};
  Map<String, dynamic> dailyCardSwipe = {};
  Map<String, dynamic> dailySpeaking = {};
  Map<String, dynamic> dailyGrammar = {};

  // Weekly Data
  Map<String, dynamic> weeklyWordListen = {};
  Map<String, dynamic> weeklyCardSwipe = {};
  Map<String, dynamic> weeklySpeaking = {};
  Map<String, dynamic> weeklyGrammar = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProgressData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProgressData() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '169|vtYU9ZOsCcnvu6oUT0lKXjJGQ9NnbihCXEAIegWW';

    try {
      debugPrint('🔄 Loading progress data...');
      
      // Fetch all data in parallel
      final results = await Future.wait([
        _fetchData('https://admin.inangreji.in/api/dashboard/daily-word-listen', token),
        _fetchData('https://admin.inangreji.in/api/dashboard/card-swipe/daily', token),
        _fetchData('https://admin.inangreji.in/api/dashboard/speaking/daily', token),
        _fetchData('https://admin.inangreji.in/api/report/grammar/daily', token),
        _fetchData('https://admin.inangreji.in/api/dashboard/weekly-word-listen', token),
        _fetchData('https://admin.inangreji.in/api/dashboard/card-swipe/weekly', token),
        _fetchData('https://admin.inangreji.in/api/dashboard/speaking/weekly', token),
        _fetchData('https://admin.inangreji.in/api/report/grammar/weekly', token),
      ]);

      setState(() {
        dailyWordListen = results[0];
        dailyCardSwipe = results[1];
        dailySpeaking = results[2];
        dailyGrammar = _normalizeGrammarResponse(results[3]);
        weeklyWordListen = results[4];
        weeklyCardSwipe = results[5];
        weeklySpeaking = results[6];
        weeklyGrammar = _normalizeGrammarResponse(results[7]);
        isLoading = false;
      });
      
      debugPrint('✅ Progress data loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading progress: $e');
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _fetchData(String url, String token) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Success fetching ${url.split('/').last}: ${response.body}');
        return data;
      } else {
        debugPrint('❌ Failed fetching $url: Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Exception fetching $url: $e');
    }
    return {};
  }

  // Safe parsing helpers: APIs sometimes return numbers as String or int/double
  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? double.tryParse(v ?? '')?.toInt() ?? 0;
    return 0;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  // Normalize grammar API response to match UI expectations
  // Grammar API returns: {"total": 1, "correct": "0", "wrong": "1", ...}
  // UI expects: {"total_questions": 1, "correct": 0, "wrong": 1, "accuracy": 0.0, ...}
  Map<String, dynamic> _normalizeGrammarResponse(Map<String, dynamic> data) {
    if (data.isEmpty) return {};
    
    final int total = _toInt(data['total']);
    final int correct = _toInt(data['correct']);
    final int wrong = _toInt(data['wrong']);
    final double accuracy = total > 0 ? (correct / total * 100) : 0.0;
    
    return {
      'total_questions': total,
      'correct': correct,
      'wrong': wrong,
      'accuracy': accuracy,
      // Preserve other fields (date, from, to, type, etc.)
      ...data,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Child Progress",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kAccent,
          indicatorWeight: 3,
          labelColor: kAccent,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "📅 Daily"),
            Tab(text: "📊 Weekly"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kAccent),
            )
          : RefreshIndicator(
              onRefresh: _loadProgressData,
              color: kAccent,
              backgroundColor: Colors.black,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDailyView(),
                  _buildWeeklyView(),
                ],
              ),
            ),
    );
  }

  // 📅 DAILY VIEW
  Widget _buildDailyView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionTitle("🎧 Word Listening", "Today's Practice"),
        const SizedBox(height: 12),
        _buildActivityCard(
          icon: Icons.headphones_rounded,
          title: "Word Listening",
          data: dailyWordListen,
          color: Colors.purple,
        ),
        const SizedBox(height: 20),

        _buildSectionTitle("🎴 Card Swipe", "Today's Activity"),
        const SizedBox(height: 12),
        _buildActivityCard(
          icon: Icons.swipe_rounded,
          title: "Card Swipe",
          data: dailyCardSwipe,
          color: Colors.orange,
        ),
        const SizedBox(height: 20),

        _buildSectionTitle("🎤 Speaking Practice", "Today's Session"),
        const SizedBox(height: 12),
        _buildActivityCard(
          icon: Icons.mic_rounded,
          title: "Speaking Practice",
          data: dailySpeaking,
          color: Colors.green,
        ),
        const SizedBox(height: 20),

        _buildSectionTitle("📚 Grammar", "Today's Lesson"),
        const SizedBox(height: 12),
        _buildActivityCard(
          icon: Icons.school_rounded,
          title: "Grammar",
          data: dailyGrammar,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),

        _buildDailySummaryCard(),
      ],
    );
  }

  // 📊 WEEKLY VIEW
  Widget _buildWeeklyView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildWeeklySummaryHeader(),
        const SizedBox(height: 20),

        _buildSectionTitle("📈 Activity Breakdown", "Last 7 Days"),
        const SizedBox(height: 12),

        _buildWeeklyActivityCard(
          icon: Icons.headphones_rounded,
          title: "Word Listening",
          data: weeklyWordListen,
          color: Colors.purple,
        ),
        const SizedBox(height: 12),

        _buildWeeklyActivityCard(
          icon: Icons.swipe_rounded,
          title: "Card Swipe",
          data: weeklyCardSwipe,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),

        _buildWeeklyActivityCard(
          icon: Icons.mic_rounded,
          title: "Speaking Practice",
          data: weeklySpeaking,
          color: Colors.green,
        ),
        const SizedBox(height: 12),

        _buildWeeklyActivityCard(
          icon: Icons.school_rounded,
          title: "Grammar",
          data: weeklyGrammar,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),

        _buildWeeklyInsightsCard(),
      ],
    );
  }

  Widget _buildWeeklyActivityCard({
    required IconData icon,
    required String title,
    required Map<String, dynamic> data,
    required Color color,
  }) {
    final totalQuestions = _toInt(data['total_questions']);
    final correct = _toInt(data['correct']);
    final wrong = _toInt(data['wrong']);
    final accuracy = _toDouble(data['accuracy']);
    final avgPerDay = (totalQuestions / 7).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kCardBg,
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$totalQuestions questions this week",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (totalQuestions > 0) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeeklyStatItem("✅", correct.toString(), "Correct", Colors.green),
                _buildWeeklyStatItem("❌", wrong.toString(), "Wrong", Colors.red),
                _buildWeeklyStatItem("🎯", "${accuracy.toStringAsFixed(1)}%", "Accuracy", color),
                _buildWeeklyStatItem("📊", avgPerDay, "Avg/Day", kAccent),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyStatItem(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyInsightsCard() {
    // Calculate best performing activity
    final wordAccuracy = _toDouble(weeklyWordListen['accuracy']);
    final cardAccuracy = _toDouble(weeklyCardSwipe['accuracy']);
    final speakAccuracy = _toDouble(weeklySpeaking['accuracy']);

    final activities = [
      {'name': 'Word Listening', 'accuracy': wordAccuracy, 'color': Colors.purple},
      {'name': 'Card Swipe', 'accuracy': cardAccuracy, 'color': Colors.orange},
      {'name': 'Speaking', 'accuracy': speakAccuracy, 'color': Colors.green},
    ];
    activities.sort((a, b) => (b['accuracy'] as double).compareTo(a['accuracy'] as double));
    final bestActivity = activities.first;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withOpacity(0.3),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.4), width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 28),
              SizedBox(width: 12),
              Text(
                "Weekly Insights",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (bestActivity['accuracy'] as double > 0) ...[
            Text(
              "🌟 Best Performance: ${bestActivity['name']}",
              style: TextStyle(
                color: bestActivity['color'] as Color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Accuracy: ${(bestActivity['accuracy'] as double).toStringAsFixed(1)}%",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ] else
            const Text(
              "Start practicing to see your insights!",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required Map<String, dynamic> data,
    required Color color,
  }) {
    final totalQuestions = _toInt(data['total_questions']);
    final correct = _toInt(data['correct']);
    final wrong = _toInt(data['wrong']);
    final accuracy = _toDouble(data['accuracy']);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kCardBg,
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalQuestions == 0 ? "No activity today" : "$totalQuestions questions",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (totalQuestions > 0) ...[
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("✅ Correct", correct.toString(), Colors.green),
                _buildStatItem("❌ Wrong", wrong.toString(), Colors.red),
                _buildStatItem("🎯 Accuracy", "${accuracy.toStringAsFixed(1)}%", color),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummaryCard() {
    int totalQuestions = _toInt(dailyWordListen['total_questions']) +
      _toInt(dailyCardSwipe['total_questions']) +
      _toInt(dailySpeaking['total_questions']);

    int totalCorrect = _toInt(dailyWordListen['correct']) +
      _toInt(dailyCardSwipe['correct']) +
      _toInt(dailySpeaking['correct']);

    int totalWrong = _toInt(dailyWordListen['wrong']) +
      _toInt(dailyCardSwipe['wrong']) +
      _toInt(dailySpeaking['wrong']);

    double overallAccuracy = totalQuestions > 0
      ? (totalCorrect / totalQuestions * 100)
      : 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kAccent.withOpacity(0.2),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccent.withOpacity(0.4), width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.today_rounded, color: Colors.amber, size: 48),
          const SizedBox(height: 12),
          const Text(
            "Today's Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem("Questions", totalQuestions.toString(), Icons.help_outline),
              _buildSummaryItem("Correct", totalCorrect.toString(), Icons.check_circle_outline),
              _buildSummaryItem("Accuracy", "${overallAccuracy.toStringAsFixed(1)}%", Icons.track_changes),
            ],
          ),
          if (totalQuestions > 0) ...[
            const SizedBox(height: 20),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: overallAccuracy / 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, kAccent],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: kAccent, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: kAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildWeeklySummaryHeader() {
    int totalQuestions = _toInt(weeklyWordListen['total_questions']) +
      _toInt(weeklyCardSwipe['total_questions']) +
      _toInt(weeklySpeaking['total_questions']);

    int totalCorrect = _toInt(weeklyWordListen['correct']) +
      _toInt(weeklyCardSwipe['correct']) +
      _toInt(weeklySpeaking['correct']);

    double overallAccuracy = totalQuestions > 0
      ? (totalCorrect / totalQuestions * 100)
      : 0;

    // Get week dates
    final weekData = weeklyWordListen['week'] ?? weeklyCardSwipe['week'] ?? weeklySpeaking['week'];
    final weekStart = weekData?['start'] ?? '';
    final weekEnd = weekData?['end'] ?? '';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Text(
            "📊 Weekly Performance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (weekStart.isNotEmpty && weekEnd.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "$weekStart to $weekEnd",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeeklyHeaderItem("Questions", totalQuestions.toString()),
              _buildWeeklyHeaderItem("Correct", totalCorrect.toString()),
              _buildWeeklyHeaderItem("Accuracy", "${overallAccuracy.toStringAsFixed(1)}%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHeaderItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String average,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Total: ",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Avg: ",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "$average/day",
                      style: const TextStyle(
                        color: kAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressChart() {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccent.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📈 Progress Trend",
            style: TextStyle(
              color: kAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final height = 40.0 + (index * 15.0);
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kAccent, Colors.blue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Showing consistent improvement! 🚀",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}