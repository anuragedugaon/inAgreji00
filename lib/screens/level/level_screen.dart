import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

/// Reusable App Colors
class AppColors {
  static const Color background = Colors.black;
  static const Color primaryText = Colors.white;
  static const Color titleText = Colors.cyan;
  static const Color border = Colors.cyan;
  static const Color inactive = Colors.grey;
  static const Color buttonText = Colors.white;
}

class LevelScreen extends StatefulWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  String? _selectedLevel;
  String? _levelId;
  List<dynamic> _levels = [];
  bool _isLoading = true;

  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    fetchLevels();
    Future.delayed(const Duration(milliseconds: 800), _speakQuestion);
  }

  /// 🧠 Speak translated question
  Future<void> _speakQuestion() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final question = appProvider.translate("choose_level") == "choose_level"
        ? "Please choose your current English level."
        : appProvider.translate("choose_level");
    await _aiService.speakText(question);
  }

  /// Fetch levels from API
  Future<void> fetchLevels() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final result = await appProvider.getLevels();
    debugPrint("🔹 API Response Levels: $result");

    setState(() {
      _levels = result;
      _isLoading = false;
    });
  }

  /// Replay question
  void _replayQuestion() {
    _aiService.stopSpeaking();
    _speakQuestion();
  }

  /// Handle Continue
  Future<void> _handleContinue() async {
    if (_selectedLevel == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_level', _selectedLevel!);
    debugPrint("✅ Selected Level: $_selectedLevel");
    await prefs.setString('selected_level_id',_levelId !);

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final nextText = appProvider.translate("great_choice") == "great_choice"
        ? "Great choice! Let’s continue."
        : appProvider.translate("great_choice");

    await _aiService.speakText(
      nextText,
      onComplete: () {
        Navigator.pushReplacementNamed(context, '/myself');
      },
    );
  }

  @override
  void deactivate() {
    _aiService.stopSpeaking();
    super.deactivate();
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  /// 🗺️ Level translations for Hindi/Bengali
  String _getLocalizedLevelLabel(String englishName, String languageCode) {
    const translations = {
      'basic': {'hi': 'मूलभूत', 'bn': 'মৌলিক'},
      'beginner': {'hi': 'शुरुआती', 'bn': 'প্রাথমিক'},
      'elementary': {'hi': 'प्रारंभिक', 'bn': 'প্রাথমিক স্তর'},
      'intermediate': {'hi': 'मध्यवर्ती', 'bn': 'মধ্যবর্তী'},
      'advanced': {'hi': 'उन्नत', 'bn': 'উন্নত'},
      'fluent': {'hi': 'धाराप्रवाह', 'bn': 'ফ্লুয়েন্ট'},
      'expert': {'hi': 'विशेषज्ञ', 'bn': 'বিশেষজ্ঞ'},
      'proficient': {'hi': 'कुशल', 'bn': 'দক্ষ'},
    };

    final lower = englishName.toLowerCase();

    if (languageCode == 'en') return englishName;

    if (translations.containsKey(lower)) {
      final local = translations[lower]?[languageCode];
      return local != null ? "$local / $englishName" : englishName;
    }
    return englishName;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final langCode = appProvider.locale.languageCode;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/purpose');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _replayQuestion,
              icon: const Icon(Icons.mic, color: AppColors.titleText, size: 28),
              tooltip: 'Replay Question',
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.titleText),
                )
              : _levels.isEmpty
                  ? Center(
                      child: Text(
                        appProvider.translate("no_levels") == "no_levels"
                            ? "No levels available."
                            : appProvider.translate("no_levels"),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            appProvider.translate("your_level") == "your_level"
                                ? "Your current\nEnglish level"
                                : appProvider.translate("your_level"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleText,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: fetchLevels,
                              backgroundColor: AppColors.titleText,
                              color: AppColors.background,
                              child: ListView.builder(
                                itemCount: _levels.length,
                                itemBuilder: (context, index) {
                                  final level = _levels[index];
                                  final englishName =
                                      level['name']?.toString() ?? 'Unknown';
                                  final label = _getLocalizedLevelLabel(
                                      englishName, langCode);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child:
                                        _buildLevelOption(level, label),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedLevel == null
                                  ? null
                                  : _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.border,
                                foregroundColor: AppColors.buttonText,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                shadowColor: AppColors.border,
                              ),
                              child: Text(
                                appProvider.translate("continue") == "continue"
                                    ? "Continue"
                                    : appProvider.translate("continue"),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  /// 🎚️ Level Option Widget
  Widget _buildLevelOption(Map<String,dynamic> englishName, String displayLabel) {
    final bool isSelected = _selectedLevel == englishName['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = englishName['name'];
          _levelId="${englishName['id']}";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.border : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.border.withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.border : AppColors.inactive,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.border,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayLabel,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
