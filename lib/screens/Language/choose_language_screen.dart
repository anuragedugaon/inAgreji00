import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

import 'language_catalog.dart';

class AppColors {
  static const Color background = Colors.black;
  static const Color primaryText = Colors.white;
  static const Color primaryColor = Color(0xFFFFA500);
  static const Color buttonText = Colors.white;
  static const Color titleText = Colors.cyan;
  static const Color border = Colors.cyan;
}

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final AIService _aiService = AIService();

  String? _selectedCode;
  String _searchQuery = '';

  late final List<LanguageInfo> _allLanguages;
  late List<LanguageInfo> _visibleLanguages;

  @override
  void initState() {
    super.initState();

    // Load world-wide language list from central file
    _allLanguages = List<LanguageInfo>.from(kWorldLanguages);
    _visibleLanguages = _allLanguages;

    // Pre-select device language if present, otherwise English
    final systemCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final defaultLang = _allLanguages.firstWhere(
      (l) => l.code == systemCode,
      orElse: () =>
          _allLanguages.firstWhere((l) => l.code == 'en', orElse: () => _allLanguages.first),
    );
    _selectedCode = defaultLang.code;

    // Speak intro line
    Future.delayed(const Duration(milliseconds: 800), () {
      _aiService.speakText('Please choose your preferred language.');
    });
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

  void _onSearchChanged(String value) {
    final query = value.trim().toLowerCase();
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _visibleLanguages = _allLanguages;
      } else {
        _visibleLanguages = _allLanguages.where((lang) {
          final en = lang.englishName.toLowerCase();
          final native = lang.nativeName.toLowerCase();
          final code = lang.code.toLowerCase();
          return en.contains(query) || native.contains(query) || code.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _onLanguageTap(LanguageInfo language) async {
    final prefs = await SharedPreferences.getInstance();
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    final selectedCode = language.code;

    // UI language code – only use codes you actually have json for.
    final effectiveUiCode = kUiSupportedLanguageCodes.contains(selectedCode)
        ? selectedCode
        : 'en';

    String confirmationSpeech;
    switch (selectedCode) {
      case 'hi':
        confirmationSpeech = 'आपने हिंदी चुनी है।';
        break;
      case 'bn':
        confirmationSpeech = 'আপনি বাংলা নির্বাচন করেছেন।';
        break;
      default:
        confirmationSpeech = 'You selected ${language.englishName}.';
    }

    setState(() {
      _selectedCode = selectedCode;
    });

    // Save what user picked
    await prefs.setString('selected_language_code', selectedCode);
    await prefs.setString('selected_language', language.englishName);

    

    // Change app UI language (safe only for supported codes)
    await appProvider.changeLanguage(effectiveUiCode);

    // Refresh AI voice + speak confirmation
    await _aiService.refreshVoice();
    await _aiService.speakText(confirmationSpeech);
  }

  Future<void> _handleContinue() async {
    if (_selectedCode == null) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final msg = appProvider.translate('language_selected');

    await _aiService.speakText(
      msg,
      onComplete: () {
        // Next step of your onboarding
        Navigator.pushReplacementNamed(context, '/purpose');
      },
    );
  }

  void _replayQuestion() {
    _aiService.stopSpeaking();
    _aiService.speakText('Please choose your preferred language.');
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    final continueLabel = appProvider.translate('continue');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _replayQuestion,
            icon: const Icon(
              Icons.mic,
              color: AppColors.titleText,
              size: 28,
            ),
            tooltip: 'Replay Question',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Choose your\nlanguage',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleText,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 24),

              // 🔍 AI-style search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.titleText.withOpacity(0.4),
                  ),
                ),
                child: TextField(
                  onChanged: _onSearchChanged,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  cursorColor: AppColors.titleText,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    hintText: 'Search language (English, हिन्दी, Español...)',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔽 Scrollable world-wide list
              Expanded(
                child: _visibleLanguages.isEmpty
                    ? const Center(
                        child: Text(
                          'No languages found.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _visibleLanguages.length,
                        itemBuilder: (context, index) {
                          final lang = _visibleLanguages[index];
                          final isSelected = _selectedCode == lang.code;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _LanguageTile(
                              language: lang,
                              isSelected: isSelected,
                              onTap: () => _onLanguageTap(lang),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 24),

              // 🔸 Continue button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: _selectedCode == null
                        ? const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFFFC36A),
                              Color(0xFFFF7A00),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                    boxShadow: _selectedCode == null
                        ? const []
                        : const [
                            BoxShadow(
                              color: Color(0x66FF8000),
                              blurRadius: 22,
                              offset: Offset(0, 10),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: _selectedCode == null ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      continueLabel,
                      style: const TextStyle(
                        color: AppColors.buttonText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final LanguageInfo language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? AppColors.border : Colors.white54,
            width: 1.5,
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
            // No country flag – just a clean code chip
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.titleText,
              child: Text(
                language.code.toUpperCase().length > 3
                    ? language.code.toUpperCase().substring(0, 3)
                    : language.code.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.englishName,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSelected
                          ? AppColors.titleText
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language.nativeName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.check_circle_rounded,
              color:
                  isSelected ? AppColors.titleText : Colors.white38,
            ),
          ],
        ),
        
      ),
    );
  }
}
