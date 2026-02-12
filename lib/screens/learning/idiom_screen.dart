import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/app_provider.dart';
import '../dailyLessonScreen/listen_and_select_screen.dart';
import 'lessons/vocabulary_screen.dart';

class IdiomScreen extends StatefulWidget {
  const IdiomScreen({super.key});

  @override
  State<IdiomScreen> createState() => _IdiomScreenState();
}




class _IdiomScreenState extends State<IdiomScreen> {
  // 🎨 THEME
  static const Color kBackground = Colors.black;
  static const Color kText = Colors.white;
  static const Color kAccentBlue = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF00FFFF);

  // 📦 DATA
  List<Map<String, dynamic>> _idioms = [];
  Map<String, dynamic>? _currentIdiom;
  int _currentIndex = 0;

  bool _isLoading = false;

  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadIdioms();
  }

  // 🔊 Speak full idiom content
  Future<void> _speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final selectedLangCode =
        prefs.getString('selected_language_code') ?? 'en';

    await tts.setLanguage(selectedLangCode);
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.5);
    await tts.awaitSpeakCompletion(true);

    await tts.speak(cleanText);
  }

  // 🗣️ Speak current idiom (idiom + meaning + example + explanation)
  void _speakCurrentIdiom() {
    final idiom = _currentIdiom?['idiom'] ?? '';
    final meaning = _currentIdiom?['meaning'] ?? '';
    final example = _currentIdiom?['example'] ?? '';
    final explanation = _currentIdiom?['explanation'] ?? '';

    final fullText = [
      'Idiom',
      idiom,
      'Meaning',
      meaning,
      'Example',
      example,
      'Explanation',
      explanation,
    ].where((e) => e.trim().isNotEmpty).join('. ');

    _speak(fullText);
  }

  // 📥 Load idioms (ONLY ONCE)
  Future<void> _loadIdioms() async {
    setState(() => _isLoading = true);

    try {
      final aiService = AIService();
      final idiomsList = await aiService.getIdiomPhrase();

      if (idiomsList.isNotEmpty) {
        idiomsList.shuffle(); // 🔥 shuffle once

        setState(() {
          _idioms = idiomsList;
          _currentIndex = 0;
          _currentIdiom = _idioms[_currentIndex];
        });

        _speakCurrentIdiom();
      }
    } catch (e) {
      debugPrint("❌ Error loading idioms: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ▶️ Next idiom OR go to Vocabulary
  void _showAnotherIdiom() {
    // 🔚 All idioms finished
    if (_currentIndex >= _idioms.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ListenSelectScreen(),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
      _currentIdiom = _idioms[_currentIndex];
    });

    _speakCurrentIdiom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccentBlue),
          onPressed: () => Navigator.pushReplacementNamed(context, '/lesson'),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kAccentBlue),
            )
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: _currentIdiom == null
                    ? const Center(
                        child: Text(
                          "No idioms available.",
                          style:
                              TextStyle(color: kAccentBlue, fontSize: 18),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Idiom of the Day",
                            style: TextStyle(
                              color: kAccentBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          const Icon(Icons.ac_unit,
                              color: kAccentBlue, size: 80),

                          const SizedBox(height: 25),

                          // 🔹 Idiom
                          Text(
                            _currentIdiom?['idiom'] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kAccentBlue,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 🔹 Meaning
                          _buildInfoSection(
                            title: "Meaning",
                            content:
                                _currentIdiom?['meaning'] ?? '—',
                          ),
                          const SizedBox(height: 15),

                          // 🔹 Example
                          _buildInfoSection(
                            title: "Example",
                            content:
                                _currentIdiom?['example'] ?? '—',
                          ),
                          const SizedBox(height: 15),

                          // 🔹 Explanation
                          _buildInfoSection(
                            title: "Explanation",
                            content: _currentIdiom?['explanation'] ??
                                '—',
                          ),

                          const Spacer(),

                          // 🔘 Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _showAnotherIdiom,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                      color: kAccentBlue, width: 1.5),
                                ),
                                elevation: 8,
                                shadowColor: kGlow.withOpacity(0.6),
                              ),
                              child: Text(
                                _currentIndex == _idioms.length - 1
                                    ? "Go to Vocabulary"
                                    : "Learn Another",
                                style: const TextStyle(
                                  color: kAccentBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
              ),
            ),
    );
  }

  // 🧩 Info section widget
  static Widget _buildInfoSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kAccentBlue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            color: kText,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}




