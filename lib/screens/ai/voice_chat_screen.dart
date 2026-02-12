import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';
import '../../provider/app_provider.dart';
import '../../services/video_player.dart';
import '../ai_teacher/ai_service.dart';
import 'ai_chat_screen.dart';

  // /// --- Color constants ---
  // class AppColors {
  //   static const Color backgroundDark = Colors.black;
  //   static const Color primaryBlue = Color(0xFF00BFFF); // Neon blue
  //   static const Color textWhite = Colors.white;
  //   static const Color subtitleColor = Colors.white70;
  // }
  // class VoiceChatScreen extends StatefulWidget {
  //   final String ?prom;

    
  //   const VoiceChatScreen({super.key,  this.prom});

  //   @override
  //   State<VoiceChatScreen> createState() => _VoiceChatScreenState();
  // }

  // class _VoiceChatScreenState extends State<VoiceChatScreen> with SingleTickerProviderStateMixin  {
  //   final AIService _ai = AIService();
  //   final FlutterTts tts = FlutterTts();

  //   final  provider=AppProvider();

  //   bool isListening = false;
  //   String lastUserText = "";
  //   String lastAiText = "";
    
  //   late AnimationController _glowController;
  //   bool _isSpeaking = false;
  //   bool _micBusy = false;     // 🔒 real mic lock
  // bool _ttsSpeaking = false;

  // @override
  // void initState() {
  //   super.initState();

  //   _glowController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(seconds: 2),
  //     lowerBound: 0.2,
  //     upperBound: 1.0,
  //   )..repeat(reverse: true);

  //   tts.setStartHandler(() {
  //     _ttsSpeaking = true;
  //     _isSpeaking = true;
  //   });

  //   tts.setCompletionHandler(() async {
  //     _ttsSpeaking = false;
  //     _isSpeaking = false;

  //     await Future.delayed(const Duration(milliseconds: 500));

  //     if (mounted && !_micBusy) {
  //       startListening();
  //     }
  //   });

  //   if (widget.prom != null) {
  //     // processVoice(widget.prom!);
  //     _ai.readAloud(widget.prom??"");
  //   }

  //   Future.delayed(const Duration(milliseconds: 600), greetUser);
  // }

  // String welcomeMessage() {
  //   return "Welcome, ! I’m Sia, your AI teacher. Ask me anything.";
  // }

  //   // 👋 AI का पहला Welcome Message + Mic Auto Start
  //   Future<void> greetUser() async {
  //     final welcome = welcomeMessage();
  //     setState(() => lastAiText = welcome);

  //     // chatSession.messages.add({"role": "assistant", "text": welcome});

  //     await tts.speak(welcome); // बोलने के बाद mic चालू होगा (auto)
  //   }

  // Future<void> startListening() async {
  //   if (_micBusy || _ttsSpeaking) return;

  //   _micBusy = true;
  //   setState(() => isListening = true);

  //   final text = await _ai.listenVoice();

  //   _micBusy = false;
  //   setState(() => isListening = false);

  //   if (text.isEmpty) return;

  //   await processVoice(text);
  // }
  // Future<void> processVoice(String text) async {
  //   if (_ttsSpeaking) return;

  //   final reply = await _ai.getAnswer(text);

  //   // await tts.setLanguage("en-IN");
  //   // await tts.setSpeechRate(0.45);
  //   // await tts.speak(reply);
  //   _ai.readAloud(reply);
  // }


  // // Future<void> processVoice(String text) async {
  // //   if (_ttsSpeaking || _micBusy) return;

  // //   lastUserText = text;
  // //   setState(() {});

  //   // chatSession.messages.add({"role": "user", "text": text});

  // //   final reply = await _ai.getAnswer(text);

  // //   lastAiText = reply;
  // //   setState(() {});

  // //   chatSession.messages.add({"role": "assistant", "text": reply});

  // //   await tts.setLanguage("en-US");
  // //   await tts.setSpeechRate(0.45);
  // //   await tts.speak(reply); // ✅ ONLY THIS
  // // }



  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       backgroundColor: Colors.black,
  //       appBar: AppBar(
  //         title: const Text("Voice Chat"),
  //         backgroundColor: Colors.black,
  //       ),
  //       body: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           // Text(lastUserText, style: const TextStyle(color: Colors.white)),
  //           // const SizedBox(height: 10),
  //           // Text(lastAiText, style: const TextStyle(color: Colors.cyanAccent)),

  //             /// --- Animated Teacher (Lottie) ---
  //                 AnimatedBuilder(
  //                   animation: _glowController,
  //                   builder: (context, child) {
  //                     final glow = _isSpeaking ? _glowController.value * 40 : 0.0;
  //                     final fadeOpacity = _glowController.value;

  //                     return Stack(
  //                       alignment: Alignment.center,
  //                       children: [
  //                         // 🌌 Faded glow background
  //                         AnimatedOpacity(
  //                           duration: const Duration(milliseconds: 500),
  //                           opacity: _isSpeaking ? fadeOpacity : 0.4,
  //                           child: Container(
  //                             height: 280,
  //                             width: 280,
  //                             decoration: BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               gradient: RadialGradient(
  //                                 colors: [
  //                                   AppColors.primaryBlue.withOpacity(0.25),
  //                                   Colors.transparent,
  //                                 ],
  //                                 stops: const [0.3, 1.0],
  //                               ),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: AppColors.primaryBlue
  //                                       .withOpacity(0.5 * fadeOpacity),
  //                                   blurRadius: glow,
  //                                   spreadRadius: glow / 4,
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),

  //                         // 🧠 Teacher animation
  //                         TeacherAnimation(),
  // // SizedBox(
  // //   height: 300,
  // //   width: 220,
  // //   child: Image.asset(
  // //     'assets/video/316338_small.gif',
  // //     fit: BoxFit.contain,
  // //   ),
  // // ),

  //                         // SizedBox(
  //                         //   height: 220,
  //                         //   width: 220,
  //                         //   child: Lottie.asset(
  //                         //     'assets/animations/human_ani.json',
  //                         //     repeat: _isSpeaking,
  //                         //     animate: true,
  //                         //     // fit: BoxFit.contain,
  //                         //   ),
  //                         // ),
  //                       ],
  //                     );
  //                   },
  //                 ),

              
              
  //           const SizedBox(height: 20),

  //     GestureDetector(
  //   onTap: () {
  //     if (!_ttsSpeaking && !_micBusy) {
  //       startListening();
  //     }
  //   },
  //   child: Icon(
  //     isListening ? Icons.mic : Icons.mic_off,
  //     color: Colors.white,
  //     size: 80,
  //   ),
  // ),

  //         ],
  //       ),
  //     );
  //   }
  // }





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

class VoiceChatScreen extends StatefulWidget {
     String ? prom;
   VoiceChatScreen({super.key,this.prom});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen>
    with SingleTickerProviderStateMixin {
  // 🎤 STT
  final stt.SpeechToText _speech = stt.SpeechToText();

  // 🔊 TTS
  final FlutterTts _tts = FlutterTts();

  // 🔒 States
  bool _isListening = false;
  bool _micBusy = false;
  bool _ttsSpeaking = false;

  // 📝 Text
  String userText = "";
  String aiText = "";

  // 🌟 Animation
  late AnimationController _glow;

  @override
  void initState() {
    super.initState();

    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _tts.setStartHandler(() {
      _ttsSpeaking = true;
    });

    _tts.setCompletionHandler(() async {
      _ttsSpeaking = false;
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) startListening();
    });

    Future.delayed(const Duration(milliseconds: 800), greetUser);
  }

  // 👋 Welcome
  Future<void> greetUser() async {
         widget.prom!=""?    processVoice(widget.prom!):

    await _tts.speak(
      "Hello! I am Sia, your English teacher. "
     ,
    ).then((value) {
    },);
  }
AIService _aiService=AIService();
  // 🎤 START LISTENING (STABLE)
  Future<void> startListening() async {
    if (_micBusy || _ttsSpeaking) return;

    _micBusy = true;
    setState(() => _isListening = true);

    final available = await _speech.initialize(
      onError: (e) => debugPrint("❌ STT error: ${e.errorMsg}"),
      onStatus: (s) => debugPrint("🎤 STT status: $s"),
    );

    if (!available) {
      _micBusy = false;
      return;
    }

    String finalText = "";
    final localeId = await _aiService.getBestIndianLocale(_speech);

    await _speech.listen(
      localeId: localeId, // 🔥 BEST for Indian languages
      listenMode: stt.ListenMode.dictation,
      // partialResults: false,
        listenFor: const Duration(seconds: 45), // long wait
  pauseFor: const Duration(seconds: 8),   // slow speaker
        partialResults: true, // 🔥 Show text while speaking
    cancelOnError: false,
    // pauseFor: const Duration(seconds: 5), // 🔥 Wait 5 sec after they stop talking
    // listenFor: const Duration(minutes: 10),
      onResult: (result) {
        //  if (_speech.isNotListening) {
        //     startUnlimitedListening();
        //   }
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          finalText = result.recognizedWords;
        }
      },
    );

    await Future.delayed(const Duration(seconds: 6));
    await _speech.stop();

    _micBusy = false;
    setState(() => _isListening = false);

    if (finalText.trim().isEmpty) return;

    userText = finalText;
    setState(() {});
    debugPrint("debug print how to ansewere $finalText");

    await processVoice(finalText);
  }

  
  // 🧠 PROCESS
  Future<void> processVoice(String text) async {
    if (_ttsSpeaking) return;

    final reply = await _aiService.getAnswer(text);
    if (reply.isEmpty) return;

    aiText = reply;
    setState(() {});

    // await _tts.setLanguage("en-IN");
    // await _tts.setSpeechRate(0.45);
    await _aiService.readAloud(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Voice AI Tutor"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _glow,
                builder: (_, __) {
                  return Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.3),
                          Colors.transparent
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.6),
                          blurRadius:
                              _ttsSpeaking ? _glow.value * 40 : 15,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 90,
                      color: Colors.white,
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              if (userText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "You said:\n$userText",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),

              if (aiText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 10),
                  child: Text(
                    aiText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: startListening,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_off,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
