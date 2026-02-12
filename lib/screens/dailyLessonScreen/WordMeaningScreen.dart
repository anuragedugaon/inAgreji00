

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/screens/dailyLessonScreen/daily_lesson_screen.dart';

import '../ai_teacher/ai_service.dart';
import 'CongratulationScreen.dart';

class WordMeaningScreen extends StatefulWidget {
  final String word;
  final String type;
  final String meaning;
  final String image;
  final int total;
  final int correct;

  const WordMeaningScreen({
    super.key,
    required this.word,
    required this.type,
    required this.meaning,
    required this.image,
    required this.total,
    required this.correct,
  });

  @override
  State<WordMeaningScreen> createState() => _WordMeaningScreenState();
}

class _WordMeaningScreenState extends State<WordMeaningScreen>
    with TickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  final AIService _aiService = AIService(); // ✅ Instance for TTS

  // 🎨 THEME
  static const Color bg = Colors.black;
  static const Color accent = Colors.cyanAccent;
  static const Color textColor = Colors.white;

  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    fadeAnim =
        CurvedAnimation(parent: fadeController, curve: Curves.easeIn);
    slideAnim = Tween(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOut),
    );

    // tts.setLanguage("en-IN");
    // tts.setSpeechRate(0.45);
    speakWord();

    fadeController.forward();
    slideController.forward();
  }

  void speakWord() async {
    await tts.speak(widget.word);
    // ✅ Use AI Service to speak the word
    var word = [ "word", widget.word, "meaning", widget.meaning];
    _aiService.speakText(word.toString());

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
         await tts.stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: bg,
         appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
      ),
    ),
        body: SafeArea(
          child: FadeTransition(
            opacity: fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔝 TOP BAR
               
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.white12,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(height: 12),
      
                // 🖼 IMAGE (CORRECT WORD IMAGE)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      widget.image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.black26,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image,
                            color: Colors.white54, size: 60),
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 24),
      
                // 📘 WORD CONTENT
                SlideTransition(
                  position: slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TAG (VERB / NOUN)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.type.toUpperCase(),
                            style: const TextStyle(
                              color: accent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
      
                        const SizedBox(height: 12),
      
                        // WORD + SPEAKER
                        Row(
                          children: [
                            Text(
                              widget.word,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: speakWord,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.volume_up,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
      
                        const SizedBox(height: 20),
      
                        // MEANING
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "MEANING",
                                style: TextStyle(
                                  color: accent,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.meaning,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      
                const Spacer(),
      
                // 🔘 CONTINUE
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
      if (widget.total == widget.correct) {
        debugPrint("All answers correct");
        debugPrint("Total: ${widget.total}, Correct: ${widget.correct}");
      
        Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => CongratulationScreen(
          total: widget.total,
          correct: widget.correct,
        ),
      ),
      (route) => false,
        );
      } else {
        Navigator.pop(context);
      }
      
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 8,
                        shadowColor: accent.withOpacity(0.6),
                      ),
                      child: const Text(
                        "CONTINUE",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }
}


