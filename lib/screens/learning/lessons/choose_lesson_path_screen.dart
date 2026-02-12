import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

import '../../dailyLessonScreen/listen_and_select_screen.dart';
import 'vocabulary_screen.dart' hide ListenSelectScreen; // ✅ Add AIService import

class ChooseLessonPathScreen extends StatefulWidget {
  const ChooseLessonPathScreen({super.key});

  @override
  State<ChooseLessonPathScreen> createState() => _ChooseLessonPathScreenState();
}

class _ChooseLessonPathScreenState extends State<ChooseLessonPathScreen> {
  final AIService _aiService = AIService(); // ✅ Instance for TTS

  List<dynamic> lessonCategories = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchLessonCategories();
    _speakInstruction(); // 🗣️ Speak when screen loads
  }

  /// 🗣️ Speak localized instruction using correct voice
  Future<void> _speakInstruction() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // 🧠 Get localized title text
    final title =
        appProvider.translate("choose_lesson_path") == "choose_lesson_path"
            ? "Choose a lesson path"
            : appProvider.translate("choose_lesson_path");

    // 🗣️ Speak in current app language (Hindi if selected)
    await _aiService.speakText(title);
  }

  Future<void> fetchLessonCategories() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final result = await appProvider.getLessonCategories();

    setState(() {
      // lessonCategories = result;
lessonCategories = result.where((item) {
  final name = item["name"]?.toString().toLowerCase() ?? "";
  return name.contains("grammar") || name.contains("vocabulary");
}).toList();



      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        break;
      // case 2:
      //   Navigator.pushReplacementNamed(context, AppRoutes.rewards);
      //   break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.AChat);
        break;
      case 3:
        break;
    }
  }

  @override
  void dispose() {
    _aiService.stopSpeaking(); // ✅ Stop speaking on screen exit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color textColor = Colors.white;

    // 🧠 Localized title text
    final screenTitle =
        appProvider.translate("choose_lesson_path") == "choose_lesson_path"
            ? "Choose a Lesson Path"
            : appProvider.translate("choose_lesson_path");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home'); // ✅ Back to /lesson
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            screenTitle,
            style: const TextStyle(
              color: accentColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.cyanAccent),
              tooltip: 'Replay Instruction',
              onPressed: _speakInstruction, // ✅ replay voice manually
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              )
            : lessonCategories.isEmpty
                ? const Center(
                    child: Text(
                      "No lesson categories found.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RefreshIndicator(
                      onRefresh: fetchLessonCategories,
                      backgroundColor: Colors.cyanAccent,
                      color: Colors.black,
                      child: GridView.builder(
                        itemCount: lessonCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final category = lessonCategories[index];
                          final name = category['name'] ?? 'Unnamed';
                          final normalizedName = name.trim().toLowerCase();
                          //  if(normalizedName.contains("phrase") ||
                          //         normalizedName.contains("idiom")) 
                          
                          return _buildLessonCard(
                            icon: Icons.menu_book,
                            label: name,
                            iconColor: Colors.cyanAccent,
                            onTap: () {
                              debugPrint("Selected Category: $name");

                              if (normalizedName == "grammar") {
                                Navigator.pushReplacementNamed(
                                    context, '/option');
                              } else if (normalizedName.contains("phrase") ||
                                  normalizedName.contains("idiom")) {
                                debugPrint(
                                    "✅ Matched Daily Phrases Category → Navigating to /idiom");
                                // Navigator.pushReplacementNamed(
                                //     context, '/idiom');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListenSelectScreen()), // ✅ Correct
                                );

                   
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(color: Colors.grey.shade800, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: backgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: accentColor,
            unselectedItemColor: Colors.white70,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book), label: "Practice"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.emoji_events), label: "Rewards"),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: "AI Chat"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.explore), label: "Explore"),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Lesson Card Builder
  Widget _buildLessonCard({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyanAccent, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
