import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

import '../../widgets/message_bubble.dart';

class WhereAreYouScreen extends StatefulWidget {
  const WhereAreYouScreen({super.key});

  @override
  State<WhereAreYouScreen> createState() => _WhereAreYouScreenState();


  
}

class _WhereAreYouScreenState extends State<WhereAreYouScreen>
    with SingleTickerProviderStateMixin {
  final AIService _aiService = AIService();
  final TextEditingController _answerController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  late AnimationController _micController;
  late Animation<double> _micPulse;

  bool _isSpeaking = false;
  bool _isListening = false;
  bool _hasSpokenCity = false;

  @override
  void initState() {
    super.initState();
    _initMicAnimation();
    _requestMicPermission();
    Future.delayed(const Duration(milliseconds: 800), _speakQuestion);
  }

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final msg = appProvider.translate("mic_permission") == "mic_permission"
          ? "Microphone permission is required."
          : appProvider.translate("mic_permission");


             showResultSnackBar(context,msg,false);

    }
  }

  void _initMicAnimation() {
    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _micPulse = CurvedAnimation(
      parent: _micController,
      curve: Curves.easeInOut,
    );
  }

  /// 🗣️ Speak question dynamically
  Future<void> _speakQuestion() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final question = appProvider.translate("where_are_you") == "where_are_you"
        ? "Where are you from?"
        : appProvider.translate("where_are_you");

    await _aiService.stopSpeaking();
    setState(() => _isSpeaking = true);
    _micController.repeat(reverse: true);

    await _aiService.speakText(
      question,
      onComplete: () async {
        setState(() => _isSpeaking = false);
        _micController.stop();
        await Future.delayed(const Duration(seconds: 1));
        await _startListening();
      },
    );
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;

    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.voiceChat,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType:
          AndroidAudioFocusGainType.gainTransientExclusive,
      androidWillPauseWhenDucked: false,
    ));

    try {
      await session.setActive(true);
      debugPrint("🎧 Audio session activated (Bluetooth mic ready)");
    } on PlatformException catch (e) {
      debugPrint("⚠️ Error activating audio session: $e");
    }
  }

  Future<void> _startListening() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }

    await _setupAudioSession();
    await _speech.stop();

    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("🎙️ STT Status: $status"),
      onError: (err) => debugPrint("❌ STT Error: $err"),
    );

    if (!available) {
      final msg =
          appProvider.translate("speech_unavailable") == "speech_unavailable"
              ? "Speech recognition unavailable."
              : appProvider.translate("speech_unavailable");
                   showResultSnackBar(context, msg,false);

      return;
    }

    setState(() {
      _isListening = true;
      _hasSpokenCity = false;
      _answerController.clear();
    });

    _speech.listen(
      localeId: appProvider.locale.languageCode == 'hi'
          ? 'hi-IN'
          : appProvider.locale.languageCode == 'bn'
              ? 'bn-IN'
              : 'en-IN',
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 5),
      cancelOnError: false,
      onResult: (result) async {
        final spokenText = result.recognizedWords.trim();
        if (spokenText.isNotEmpty) {
          setState(() {
            _answerController.text = spokenText;
            _hasSpokenCity = true;
          });
        }

        if (result.finalResult && spokenText.isNotEmpty) {
          setState(() => _isListening = false);
          debugPrint("🗣️ User said: $spokenText");
        }
      },
    );
  }

  /// 🚀 Handle Continue
  /// 🚀 Handle Continue
  Future<void> _handleContinue() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    String citySpoken = _answerController.text.trim();
    String nextText;

    // If no city was spoken, use a fallback response
    if (citySpoken.isEmpty) {
      nextText = appProvider.translate("no_city_continue") == "no_city_continue"
          ? "Alright! Let's continue."
          : appProvider.translate("no_city_continue");
    } else {
      nextText = appProvider.translate("nice_from") == "nice_from"
          ? "Nice! You’re from $citySpoken. Let’s continue."
          : appProvider
              .translate("nice_from")
              .replaceAll("{city}", citySpoken); // dynamic replacement
    }

    // 🗣️ Speak and navigate forward
    await _aiService.speakText(
      nextText,
      onComplete: () async {
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) Navigator.pushReplacementNamed(context, '/from');
      },
    );
  }

  @override
  void deactivate() {
    try {
      _aiService.stopSpeaking();
      _speech.stop();
      _micController.stop();
    } catch (_) {}
    super.deactivate();
  }

  @override
  void dispose() {
    try {
      _aiService.dispose();
      _speech.stop();
      _micController.dispose();
      _answerController.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    const backgroundColor = Colors.black;
    const accentColor = Colors.cyanAccent;
    const glowColor = Color(0xFF80FFFF);
    const textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.grey.shade800,
                  color: accentColor,
                  minHeight: 4,
                ),
                const SizedBox(height: 20),
                Text(
                  appProvider.translate("speak_out_loud") == "speak_out_loud"
                      ? "Speak out loud and record your answer:"
                      : appProvider.translate("speak_out_loud"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // 🧠 Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: accentColor, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        appProvider.translate("where_are_you") ==
                                "where_are_you"
                            ? "Where are you from?"
                            : appProvider.translate("where_are_you"),
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _speakQuestion,
                        child: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.orangeAccent,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 🗣️ Recognized Speech Box
                TextField(
                  controller: _answerController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _isListening
                        ? appProvider.translate("listening") == "listening"
                            ? "Listening..."
                            : appProvider.translate("listening")
                        : appProvider.translate("answer_appears_here") ==
                                "answer_appears_here"
                            ? "Your answer will appear here"
                            : appProvider.translate("answer_appears_here"),
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black26,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyan),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🎤 Mic Animation
                AnimatedBuilder(
                  animation: _micPulse,
                  builder: (context, child) {
                    final double scale = 1 + (_micPulse.value * 0.15);
                    return GestureDetector(
                      onTap: _startListening,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accentColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: _isListening
                                    ? glowColor.withOpacity(0.8)
                                    : glowColor.withOpacity(0.4),
                                blurRadius: _isListening ? 25 : 10,
                                spreadRadius: _isListening ? 6 : 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _hasSpokenCity
                                ? Colors.greenAccent
                                : accentColor,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // 🚀 Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: const BorderSide(color: accentColor, width: 1.5),
                      ),
                      elevation: 6,
                      shadowColor: glowColor.withOpacity(0.6),
                    ),
                    child: Text(
                      appProvider.translate("continue") == "continue"
                          ? "Continue"
                          : appProvider.translate("continue"),
                      style: const TextStyle(
                        color: accentColor,
                        fontSize: 16,
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
      ),
    );
  }
}
