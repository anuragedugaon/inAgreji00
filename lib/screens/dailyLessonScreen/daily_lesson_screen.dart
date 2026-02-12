// import 'package:flutter/material.dart';

// import '../../services/video_player.dart';
// import '../ai_teacher/ai_service.dart';

// enum LessonStep {
//   listen,
//   chooseWord,
//   explainMeaning,
//   chooseMeaning,
//   success,
// }

// class DailyLessonScreen extends StatefulWidget {
//   final List<VocabularyWord> words;
//   const DailyLessonScreen({super.key, required this.words});

//   @override
//   State<DailyLessonScreen> createState() => _DailyLessonScreenState();
// }

// class _DailyLessonScreenState extends State<DailyLessonScreen> {
//   int currentIndex = 0;
//   LessonStep step = LessonStep.listen;

//   VocabularyWord get currentWord => widget.words[currentIndex];

//   void nextStep() {
//     setState(() {
//       switch (step) {
//         case LessonStep.listen:
//           step = LessonStep.chooseWord;
//           break;
//         case LessonStep.chooseWord:
//           step = LessonStep.explainMeaning;
//           break;
//         case LessonStep.explainMeaning:
//           step = LessonStep.chooseMeaning;
//           break;
//         case LessonStep.chooseMeaning:
//           step = LessonStep.success;
//           break;
//         case LessonStep.success:
//           currentIndex++;
//           if (currentIndex < widget.words.length) {
//             step = LessonStep.listen;
//           } else {
//             Navigator.pushReplacementNamed(context, '/dailyQuiz');
//           }
//           break;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacementNamed(context, '/home');
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//          appBar: AppBar(
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
//               const SizedBox(height: 10),
//               const SizedBox(height: 130, child: TeacherAnimation()),
//               const SizedBox(height: 10),
//               Expanded(child: _buildStep()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStep() {
//     switch (step) {
//       case LessonStep.listen:
//         return ListenScreen(word: currentWord.word, onDone: nextStep);
//       case LessonStep.chooseWord:
//         return ChooseWordScreen(
//           correctWord: currentWord.word,
//           options: _buildWordOptions(),
//           onCorrect: nextStep,
//         );
//       case LessonStep.explainMeaning:
//         return ExplainMeaningScreen(
//           word: currentWord.word,
//           meaning: currentWord.meaning,
//           image: currentWord.imageUrl,
//           onDone: nextStep,
//         );
//       case LessonStep.chooseMeaning:
//         return ChooseMeaningScreen(
//           correct: currentWord.meaning,
//           options: _buildMeaningOptions(),
//           onCorrect: nextStep,
//         );
//       case LessonStep.success:
//         return SuccessScreen(onDone: nextStep);
//     }
//   }

//   List<String> _buildWordOptions() {
//     final others = widget.words
//         .where((w) => w.word != currentWord.word)
//         .map((w) => w.word)
//         .toList()
//       ..shuffle();

//     return ([currentWord.word, others.first]..shuffle());
//   }

//   List<String> _buildMeaningOptions() {
//     final others = widget.words
//         .where((w) => w.meaning != currentWord.meaning)
//         .map((w) => w.meaning)
//         .toList()
//       ..shuffle();

//     return ([currentWord.meaning, others[0], others[1]]..shuffle());
//   }
// }


// // Dummy class for VocabularyWord
// class ListenScreen extends StatefulWidget {
//   final String word;
//   final VoidCallback onDone;
//   const ListenScreen({super.key, required this.word, required this.onDone});

//   @override
//   State<ListenScreen> createState() => _ListenScreenState();
// }

// class _ListenScreenState extends State<ListenScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 300), () async {
//       await AIService().readAloud(widget.word);
//       widget.onDone();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         "Listen carefully",
//         style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
//       ),
//     );
//   }
// }
// // Dummy class for VocabularyWord
// class ChooseWordScreen extends StatelessWidget {
//   final String correctWord;
//   final List<String> options;
//   final VoidCallback onCorrect;

//   const ChooseWordScreen({
//     super.key,
//     required this.correctWord,
//     required this.options,
//     required this.onCorrect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text("Which word did you hear?",
//             style: TextStyle(color: Colors.white)),
//         const SizedBox(height: 20),
//         ...options.map((w) => GestureDetector(
//               onTap: () {
//                 if (w == correctWord) {
//                   onCorrect();
//                 } else {
//                   AIService().readAloud(correctWord);
//                 }
//               },
//               child: _optionCard(w),
//             )),
//       ],
//     );
//   }

//   Widget _optionCard(String text) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.cyanAccent),
//       ),
//       child: Center(
//           child: Text(text,
//               style: const TextStyle(color: Colors.white, fontSize: 18))),
//     );
//   }
// }
// // Dummy class for VocabularyWord



// class ExplainMeaningScreen extends StatelessWidget {
//   final String word;
//   final String meaning;
//   final String image;
//   final VoidCallback onDone;

//   const ExplainMeaningScreen({
//     super.key,
//     required this.word,
//     required this.meaning,
//     required this.image,
//     required this.onDone,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(milliseconds: 500), () async {
//       await AIService().readAloud("$word means $meaning");
//       onDone();
//     });

//     return Column(
//       children: [
//         Image.network(image, height: 160),
//         const SizedBox(height: 10),
//         Text(word,
//             style: const TextStyle(
//                 color: Colors.cyanAccent,
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold)),
//         Text(meaning,
//             style: const TextStyle(color: Colors.white, fontSize: 20)),
//       ],
//     );
//   }
// }
// // Dummy class for VocabularyWord
// class ChooseMeaningScreen extends StatelessWidget {
//   final String correct;
//   final List<String> options;
//   final VoidCallback onCorrect;

//   const ChooseMeaningScreen({
//     super.key,
//     required this.correct,
//     required this.options,
//     required this.onCorrect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text("Choose the correct meaning",
//             style: TextStyle(color: Colors.white)),
//         const SizedBox(height: 20),
//         ...options.map((m) => GestureDetector(
//               onTap: () {
//                 if (m == correct) {
//                   onCorrect();
//                 }
//               },
//               child: _option(m),
//             )),
//       ],
//     );
//   }

//   Widget _option(String text) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.cyanAccent),
//       ),
//       child: Center(
//           child:
//               Text(text, style: const TextStyle(color: Colors.white))),
//     );
//   }
// }
// class SuccessScreen extends StatelessWidget {
//   final VoidCallback onDone;
//   const SuccessScreen({super.key, required this.onDone});

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 2), onDone);

//     return Center(
//       child: Text(
//         "Excellent! 🎉",
//         style: TextStyle(
//           color: Colors.cyanAccent,
//           fontSize: 32,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
