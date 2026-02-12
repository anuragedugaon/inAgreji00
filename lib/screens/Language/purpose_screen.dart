import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const Color background = Colors.black;
  static const Color titleText = Colors.cyan;
  static const Color border = Colors.cyan;
  static const Color buttonText = Colors.white;
}

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({Key? key}) : super(key: key);

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  String? _selectedPurpose;
  String? _puposeId;
  List<dynamic> _purposes = [];
  bool _isLoading = true;

  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    fetchPurposes();
    Future.delayed(const Duration(milliseconds: 800), _speakQuestion);
  }

  Future<void> _speakQuestion() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final question = appProvider.translate("why_learning") == "why_learning"
        ? "Why do you want to learn English? Please choose your purpose."
        : appProvider.translate("why_learning");
    await _aiService.speakText(question);
  }

  Future<void> fetchPurposes() async {
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final result = await appProvider.getPurposes();
      debugPrint("🔹 API Response (Purposes): $result");

      setState(() {
        _purposes = result;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching purposes: $e");
      setState(() => _isLoading = false);
    }
  }

  void _replayQuestion() {
    _aiService.stopSpeaking();
    _speakQuestion();
  }

  Future<void> _handleContinue() async {
    if (_selectedPurpose == null) return;

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_purpose', _selectedPurpose!);
        await prefs.setString('selected_purpose_id', _puposeId!);

    debugPrint("✅ Selected Purpose: $_selectedPurpose");

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final nextMsg = appProvider.translate("next_level") == "next_level"
        ? "That's great! Let's find your English level next."
        : appProvider.translate("next_level");

    await _aiService.speakText(
      nextMsg,
      onComplete: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/level');
        }
      },
    );

    setState(() => _isLoading = false);
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

  /// 🔠 Map English purposes to Hindi/Bengali display names
  String _getLocalizedPurposeLabel(String englishName, String languageCode) {
    const translations = {
      'school': {'hi': 'स्कूल', 'bn': 'স্কুল'},
      'travel': {'hi': 'यात्रा', 'bn': 'ভ্রমণ'},
      'fun': {'hi': 'मज़ा', 'bn': 'মজা'},
      'exam prep': {'hi': 'परीक्षा तैयारी', 'bn': 'পরীক্ষার প্রস্তুতি'},
      'job': {'hi': 'नौकरी', 'bn': 'চাকরি'},
    };

    final lowerName = englishName.toLowerCase();

    if (languageCode == 'en') return englishName;

    if (translations.containsKey(lowerName)) {
      final localWord = translations[lowerName]?[languageCode];
      return localWord != null ? "$localWord / $englishName" : englishName;
    }

    return englishName;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final langCode = appProvider.locale.languageCode;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/choose');
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
              : _purposes.isEmpty
                  ? Center(
                      child: Text(
                        appProvider.translate("no_purposes") == "no_purposes"
                            ? "No purposes available."
                            : appProvider.translate("no_purposes"),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appProvider.translate("why_learning") ==
                                    "why_learning"
                                ? "Why are you\nlearning English?"
                                : appProvider.translate("why_learning"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleText,
                            ),
                          ),
                          const SizedBox(height: 40),

                          /// Dynamic Purpose List
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: fetchPurposes,
                              backgroundColor: AppColors.titleText,
                              color: AppColors.background,
                              child: ListView.builder(
                                itemCount: _purposes.length,
                                itemBuilder: (context, index) {
                                  final purpose = _purposes[index];
                                  final englishName =
                                      purpose['name']?.toString() ?? 'Unknown';

                                  // 🌍 Build bilingual label
                                  final label = _getLocalizedPurposeLabel(
                                      englishName, langCode);

                                  final isSelected =
                                      _selectedPurpose == englishName;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(
                                          () {_selectedPurpose = englishName;
                                          _puposeId="${purpose['id']}";

                                          
                                    });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.border
                                              : Colors.white54,
                                          width: 1.5,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.border
                                                      .withOpacity(0.6),
                                                  blurRadius: 10,
                                                  spreadRadius: 1,
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: isSelected
                                                ? AppColors.border
                                                : Colors.white70,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Continue button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedPurpose == null || _isLoading
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
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      appProvider.translate("continue") ==
                                              "continue"
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
}
