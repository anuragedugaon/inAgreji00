

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:inangreji_flutter/models/request_model/send_voc_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../models/ai_question_model/vocabulary_questions_model.dart';
import '../../models/request_model/word_listen_request_model.dart';
import '../../models/request_model/word_requesti_model.dart';
import '../../provider/ai_model_/ai_model_repo.dart';
import '../../provider/app_provider.dart';
import '../ai_teacher/ai_service.dart';
import 'WordMeaningScreen.dart';

import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


final List<String> vocabularyTopics = [
  "Colors vocabulary",
  "Fruits vocabulary",
  "Vegetables vocabulary",
  "Animals vocabulary",
  "Birds vocabulary",
  "Body parts vocabulary",
  "Family members vocabulary",
  "School items vocabulary",
  "Office items vocabulary",
  "Household items vocabulary",
  "Kitchen items vocabulary",
  "Clothes vocabulary",
  "Transport vocabulary",
  "Numbers vocabulary",
  "Days and months vocabulary",
  "Weather vocabulary",
  "Food and drinks vocabulary",
  "Sports vocabulary",
  "Jobs and professions vocabulary",
  "Opposite words vocabulary",
  "Common verbs vocabulary",
  "Adjectives vocabulary",
  "Emotions vocabulary",
  "Places vocabulary",
    "Daily conversation",
  "Greetings and introductions",
  "Asking for directions",
  "At the restaurant",
  "At the hospital",
  "At the airport",
  "Shopping conversation",
  "Talking about hobbies",
  "Talking about family",
  "Talking about weather",
  "Talking about time and date",
  "Ordering food",
  "Telephone conversation",
  "Emergency conversation",
  "Job interview conversation",
  "Classroom conversation",
  "Office conversation",
  "Travel conversation",
  "Hotel booking conversation",
  "Bank conversation",
  "Polite requests and permissions",
  "Apologies and thanking",
  "Compliments and responses",
];


Future<String> getRandomUniqueItem({
  required SharedPreferences prefs,
  required String storageKey,
  required List<String> items,
}) async {
  final usedString = prefs.getString(storageKey);

  final usedItems = usedString != null
      ? Set<String>.from(jsonDecode(usedString))
      : <String>{};

  // reset if all used
  if (usedItems.length >= items.length) {
    usedItems.clear();
  }

  // get unused items
  final unusedItems = items.where((e) => !usedItems.contains(e)).toList();

  // random unused selection
  final randomItem = unusedItems[Random().nextInt(unusedItems.length)];

  // save used
  usedItems.add(randomItem);
  await prefs.setString(storageKey, jsonEncode(usedItems.toList()));

  return randomItem;
}



class ListenSelectScreen extends StatefulWidget {
  const ListenSelectScreen({super.key});

  @override
  State<ListenSelectScreen> createState() => _ListenSelectScreenState();
}

class _ListenSelectScreenState extends State<ListenSelectScreen>
    with TickerProviderStateMixin, RouteAware {
  // SERVICES
  final FlutterTts tts = FlutterTts();
  final AIService _aiService = AIService();
  final AIModelRepo aiModelRepo = AIModelRepo();

  // THEME
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;

  // STATE
  bool loading = true;
  int currentIndex = 0;
  int correctCount = 0;
  List<VocabularyQuestion> questions = [];

final List<WordListenPayload> _attempts = [];
  // ANIMATION
  late AnimationController speakerController;
  late AnimationController optionController;
  late Animation<double> speakerPulse;
  late Animation<double> optionScale;

  // SPEAK GUARDS
  bool _isSpeaking = false;
  bool _autoSpokenOnce = false;
  String? _lastSpokenWord;

  // IMAGE CACHE
  final Map<String, String> _imageCache = {};
  final Map<String, Future<String?>> _imageFutureCache = {};

  @override
  void initState() {
    super.initState();

    speakerController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    optionController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    speakerPulse = Tween(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: speakerController, curve: Curves.easeInOut),
    );
    optionScale =
        CurvedAnimation(parent: optionController, curve: Curves.elasticOut);

    tts.setLanguage("en-IN");
    tts.setSpeechRate(0.45);

    loadQuestions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    _autoSpokenOnce = false;
    _lastSpokenWord = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
  }

  // ================= API =================
AppProvider appProvider = AppProvider();
  Future<void> loadQuestions() async {
    try {
      setState(() => loading = true);

      final prefs = await SharedPreferences.getInstance();
final randomVocabTopic = await getRandomUniqueItem(
  prefs: prefs,
  storageKey: "used_vocab_topics",
  items: vocabularyTopics,
);
      final request = WordListenRequest(
        selectedCategory:
          randomVocabTopic?? "others" ,
        selectedLanguageName:
            prefs.getString("selected_language") ?? "telugu",
        selectedLanguageCode:
            prefs.getString("selected_language_code") ?? "tel",
        userLevel: appProvider.userDetails.data?.level?.name  ?? "beginner",
        avoidWords: ["apple", "book", "water"],
      );

      final response =
          await AIModelRepo.generateVocabularyQuestions(request: request);

      if (response == null || response.questions.isEmpty) {
        setState(() => loading = false);
        return;
      }

      setState(() {
        questions = response.questions;
        currentIndex = 0;
        correctCount = 0;
        loading = false;
        _autoSpokenOnce = false;
        _lastSpokenWord = null;
      });

      optionController.forward(from: 0);
    } catch (e) {
      debugPrint("❌ Load error: $e");
      setState(() => loading = false);
    }
  }

  // ================= SPEAK =================

  Future<void> speak() async {
    if (questions.isEmpty || _isSpeaking) return;

    final word = questions[currentIndex].correct.word;
    if (_lastSpokenWord == word) return;

    _isSpeaking = true;
    _lastSpokenWord = word;

    await _aiService.speakText(word);

    _isSpeaking = false;
  }

  // ================= IMAGE =================

  Future<String?> getImageCached(String word) {
    if (_imageCache.containsKey(word)) {
      return Future.value(_imageCache[word]);
    }
    if (_imageFutureCache.containsKey(word)) {
      return _imageFutureCache[word]!;
    }

    final future = aiModelRepo.getImageForWord(word).then((img) {
      if (img != null) _imageCache[word] = img;
      return img;
    });

    _imageFutureCache[word] = future;
    return future;
  }

  // ================= UI =================

  Widget premiumImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.network(
            url,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionCard(VocabularyWord data) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectOption(data),
        child: ScaleTransition(
          scale: optionScale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: accentColor.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<String?>(
                  future: getImageCached(data.word),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Icon(Icons.image,
                          color: Colors.white24, size: 60);
                    }
                    return premiumImage(snapshot.data!);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  data.word.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                Text(
                  data.localWord,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectOption(VocabularyWord option) async {
    final isCorrect =
        option.word == questions[currentIndex].correct.word;

    if (isCorrect) correctCount++;


  final payload = WordListenPayload(
    correct: VocabularyWordSent(
      word: questions[currentIndex].correct.word,   
      localWord: questions[currentIndex].correct.localWord,
      type: questions[currentIndex].correct.type,
      meaning: questions[currentIndex].correct.meaning,
      image: "",
    ),
    wrong: VocabularyWordSent(
      word:  option.word,
      localWord: option.localWord,
      type:  option.type,
      meaning: option.meaning,
      image: "",
    ),
  );

  _attempts.add(payload);



    //   _attempts.add(
    //   VocabularyWordSent(
    //     word: option.word,
    //     localWord: option.localWord,
    //     type: option.type,
    //     meaning: option.meaning,
    //     image: "",

        
    //   ),
    // );
  
  AIModelRepo.sendWordListenApi(_attempts);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.32,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
          gradient: LinearGradient(
            colors: isCorrect
                ? [Colors.green, Colors.green.shade900]
                : [Colors.red, Colors.red.shade900],
          ),
        ),
        child: Column(
          children: [
            Icon(
              isCorrect ? Icons.verified : Icons.error,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              isCorrect ? "Correct!" : "Wrong!",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final image =
                      await aiModelRepo.getImageForWord(option.word) ?? "";

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WordMeaningScreen(
                        word: option.word,
                        type: option.type,
                        meaning: option.meaning,
                        image: image,
                        correct: correctCount,
                        total: questions.length,
                      ),
                    ),
                  );

                  if (currentIndex < questions.length - 1) {
                    setState(() {
                      currentIndex++;
                      _autoSpokenOnce = false;
                      _lastSpokenWord = null;
                    });
                  } else {
                    loadQuestions();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Next ▶",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  
      if (currentIndex == questions.length - 1) {

        // Navigator.pushReplacementNamed(context, '/home');


    
//  setState(() {
//       currentIndex++;
//       _autoSpokenOnce = false;
//       _lastSpokenWord = null;
//     });
  
  }}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: accentColor),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_autoSpokenOnce) {
        _autoSpokenOnce = true;
        speak();
      }
    });

    final current = questions[currentIndex];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Listen & Choose",
              style: TextStyle(
                color: textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _lastSpokenWord = null;
                    speak();
                  },
                  child: ScaleTransition(
                    scale: speakerPulse,
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(color: glowColor, blurRadius: 45),
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        size: 48,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  optionCard(current.correct),
                  optionCard(current.wrong),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    speakerController.dispose();
    optionController.dispose();
    _aiService.stop();
    super.dispose();
  }
}


// // 🔥 ADD ON (RouteObserver import)

// class ListenSelectScreen extends StatefulWidget {
//   const ListenSelectScreen({super.key});

//   @override
//   State<ListenSelectScreen> createState() => _ListenSelectScreenState();
// }

// class _ListenSelectScreenState extends State<ListenSelectScreen>
//     with TickerProviderStateMixin, RouteAware {
//   final FlutterTts tts = FlutterTts();
//   final OpenAIService _ai = OpenAIService();
//   final AIService _aiService = AIService();

//   // 🎨 THEME
//   static const Color backgroundColor = Colors.black;
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color glowColor = Color(0xFF80FFFF);
//   static const Color textColor = Colors.white;

//   int correctCount = 0;
//   bool loading = true;

//   List<Map<String, dynamic>> questions = [];
//   int currentIndex = 0;

//     /// 🛑 Stop speaking immediately

//   late AnimationController speakerController;
//   late AnimationController optionController;
//   late Animation<double> speakerPulse;
//   late Animation<double> optionScale;

//   // 🔥 ADD ON (state + tts guards)
//   String? _lastSpokenWord;
//   bool _isSpeaking = false;
//   bool _autoSpokenOnce = false;
// final Map<String, String> _imageCache = {};
// final Map<String, Future<String?>> _imageFutureCache = {};

// Future<String?> getImageCached(String word) {
//   // Already loaded image
//   if (_imageCache.containsKey(word)) {
//     return Future.value(_imageCache[word]);
//   }

//   // Already loading image
//   if (_imageFutureCache.containsKey(word)) {
//     return _imageFutureCache[word]!;
//   }

//   // New request
//   final future = _ai.getImageForWord(word).then((img) {
//     if (img != null) {
//       _imageCache[word] = img;
//     }
//     return img;
//   });

//   _imageFutureCache[word] = future;
//   return future;
// }


//   @override
//   void initState() {
//     super.initState();

//     speakerController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
//     optionController =
//         AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

//     speakerPulse = Tween(begin: 1.0, end: 1.15).animate(
//       CurvedAnimation(parent: speakerController, curve: Curves.easeInOut),
//     );
//     optionScale =
//         CurvedAnimation(parent: optionController, curve: Curves.elasticOut);

//     tts.setLanguage("en-IN");
//     tts.setSpeechRate(0.45);

//     loadQuestions();
//   }

//   // 🔥 ADD ON (Route subscribe)
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
//   }

//   // 🔥 ADD ON (BACK detect)
//   @override
//   void didPopNext() {
//     _autoSpokenOnce = false;
//     _lastSpokenWord = null;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       speak();
//     });
//   }

//   // ================= AI =================
//   Future<void> loadQuestions() async {
//     try {
//       setState(() => loading = true);

//       final data = await _ai.getListenSelectQuestions();

//       setState(() {
//         questions = data;
//         currentIndex = 0;
//         correctCount = 0;
//         loading = false;
//         _autoSpokenOnce = false;
//         _lastSpokenWord = null;
//       });

//       optionController.forward(from: 0);
//     } catch (e) {
//       debugPrint("❌ Load error: $e");
//       setState(() => loading = false);
//     }
//   }

//   // 🔊 SPEAK (SAFE)
//   Future<void> speak() async {
//     if (questions.isEmpty) return;

//     final word = questions[currentIndex]["correct"]["word"];

//     if (_lastSpokenWord == word) return;
//     if (_isSpeaking) return;

//     _isSpeaking = true;
//     _lastSpokenWord = word;

//     await _aiService.speakText(word);

//     _isSpeaking = false;
//   }

//   Future<void> onSpeakingCorrect() async {
//   final prefs = await SharedPreferences.getInstance();
//   int correct =
//       (prefs.getInt("speaking_correct_today") ?? 0) + 1;
//   await prefs.setInt("speaking_correct_today", correct);
// }


//   // ✅ SELECT OPTION
//   void selectOption(Map<String, dynamic> option) {
//     final correctWord = questions[currentIndex]["correct"]["word"];
//     final bool isCorrect = option["word"] == correctWord;
//     if (isCorrect) correctCount++;
//     if(isCorrect)  onSpeakingCorrect();

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isDismissible: false,
//       builder: (_) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.32,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius:
//                 const BorderRadius.vertical(top: Radius.circular(30)),
//             gradient: LinearGradient(
//               colors: isCorrect
//                   ? [Colors.green, Colors.green.shade900]
//                   : [Colors.red, Colors.red.shade900],
//             ),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 isCorrect ? Icons.verified : Icons.error,
//                 size: 64,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 isCorrect ? "Correct!" : "Wrong!",
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: () async{
//                     Navigator.pop(context);

//                     if (currentIndex < questions.length - 1) {
//                       setState(() {
//                         currentIndex++;
//                         _autoSpokenOnce = false;
//                         _lastSpokenWord = null;
//                       });

//                       optionController.forward(from: 0);

//                       var images=await _ai.getImageForWord(option["word"]);

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => WordMeaningScreen(
//                             word: option["word"],
//                             type: option["type"],
//                             meaning: option["meaning"],
//                             image:images??"",
//                             correct: correctCount,
//                             total: questions.length,
//                           ),
//                         ),
//                       );
//                     } else {
//                                             var images=await _ai.getImageForWord(option["word"]);

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => WordMeaningScreen(
//                             word: option["word"],
//                             type: option["type"],
//                             meaning: option["meaning"],
//                             image: images??"",
//                             correct: correctCount,
//                             total: questions.length,
//                           ),
//                         ),
//                       );

//                       loadQuestions();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: accentColor,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14)),
//                   ),
//                   child: const Text(
//                     "Next ▶",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

// Widget premiumImage(String url) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(20),
//     child: Stack(
//       children: [
//         Image.network(
//           url,
//           height: 150,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//         Container(
//           height: 110,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.35),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


//   Widget optionCard(Map<String, dynamic> data) {



//     return Expanded(
//       child: GestureDetector(
//         onTap: () => selectOption(data),
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(color: accentColor.withOpacity(0.5)),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//        FutureBuilder<String?>(
//               future: getImageCached(data["word"]),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const SizedBox(
//                     height: 100,
//                     child: Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   );
//                 }

//                 if (!snapshot.hasData || snapshot.data == null) {
//                   return const Icon(
//                     Icons.image,
//                     color: Colors.white24,
//                     size: 60,
//                   );
//                 }

//                 return premiumImage(snapshot.data!);
//               },
//             ),
//               const SizedBox(height: 20),
//               Text(
//                 data["word"].toUpperCase(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                   shadows: [
//                     Shadow(
//                       color: Colors.cyanAccent.withOpacity(0.6),
//                       blurRadius: 12,
//                     ),
//                   ],
//                 ),
                
//               ),
//                Text(
//                 data["local_word"],
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   shadows: [
//                     Shadow(
//                       color: Colors.cyanAccent.withOpacity(0.6),
//                       blurRadius: 12,
//                     ),
//                   ],
//                 )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }



//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         backgroundColor: backgroundColor,
//         body: Center(
//           child: CircularProgressIndicator(color: accentColor),
//         ),
//       );
//     }

//     // 🔥 ADD ON (auto speak once per state)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_autoSpokenOnce) {
//         _autoSpokenOnce = true;
//         speak();
//       }
//     });

//     final current = questions[currentIndex];

//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacementNamed(context, '/home');
//          await tts.stop();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pushReplacementNamed(context, '/home');
//         },
//       ),
//     ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               const Text(
//                 "Listen & Choose",
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
      
//               Expanded(
//                 flex: 3,
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       _lastSpokenWord = null;
//                       speak();
//                     },
//                     child: Container(
//                       height: 110,
//                       width: 110,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: accentColor,
//                         boxShadow: [
//                           BoxShadow(color: glowColor, blurRadius: 45),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.volume_up,
//                         size: 48,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
      
//               Expanded(
//                 flex: 2,
//                 child: Row(
//                   children: [
//                     optionCard(current["correct"]),
//                     optionCard(current["wrong"]),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     speakerController.dispose();
//     optionController.dispose();
//     _aiService.stop();
//     super.dispose();
//   }
// }


