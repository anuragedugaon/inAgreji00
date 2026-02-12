// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import '../../ai_teacher/ai_service.dart';
// import '../../../services/video_player.dart';
// import '../../dailyLessonScreen/daily_lesson_screen.dart';

// class VocabularyScreen extends StatefulWidget {
//   const VocabularyScreen({super.key});

//   @override
//   State<VocabularyScreen> createState() => _VocabularyScreenState();
// }

// class _VocabularyScreenState extends State<VocabularyScreen>
//     with SingleTickerProviderStateMixin {
//   final FlutterTts flutterTts = FlutterTts();
//   final AIService _aiService = AIService();

//   // Pages of vocabulary batches (each from API, 15–25 items)
//   final List<List<VocabularyWord>> _pages = [];
//     final Set<String> _allWords = {}; // 🔥 duplicate stopper

//   int _currentPageIndex = 0;
//   bool _isLoading = true;

//   // 🎨 Theme constants
//   static const Color backgroundColor = Colors.black;
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color glowColor = Color(0xFF80FFFF);
//   static const Color textColor = Colors.white;

//   List<VocabularyWord> get _currentWords =>
//       _pages.isNotEmpty ? _pages[_currentPageIndex] : [];

//   @override
//   void initState() {
//     super.initState();
//     _loadNewPage(); // first page
//   }

//   Future<void> _loadNewPage() async {
//     setState(() => _isLoading = true);
//     final vocab = await _aiService.getVocabularyWithImages(      excludeWords: _allWords.toList(),
// );

//  for (var w in vocab) {
//       _allWords.add(w.word.toLowerCase());
//     }
//     setState(() {
//       _pages.add(vocab);
//       _currentPageIndex = _pages.length - 1;
//       _isLoading = false;
//     });
//   }

//   Future<void> _refreshCurrentPage() async {
//     setState(() => _isLoading = true);
//     final vocab = await _aiService.getVocabularyWithImages(      excludeWords: _allWords.toList(),
// );
//     setState(() {
//       // current page ko replace kar diya nayi list se
//       if (_pages.isEmpty) {
//         _pages.add(vocab);
//         _currentPageIndex = 0;
//       } else {
//         _pages[_currentPageIndex] = vocab;
//       }
//       _isLoading = false;
//     });
//   }

//   Future<void> _speakWord(String word) async {
//     // await flutterTts.setLanguage("en-IN");
//     // await flutterTts.setPitch(1.0);
//     // await flutterTts.setSpeechRate(0.6);
//     // await flutterTts.setVolume(1.0);
//     // await flutterTts.speak(word);
//    AIService().readAloud( word);
//    Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => DailyLessonScreen(words: _currentWords),
//   ),
// );

//   }

//   @override
//   void dispose() {
//     flutterTts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacementNamed(context, '/lesson');
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         body: SafeArea(
//           child: _isLoading
//               ? const Center(
//                   child: CircularProgressIndicator(color: accentColor),
//                 )
//               : Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Header row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pushReplacementNamed(
//                                   context, '/lesson');
//                             },
//                             icon: const Icon(
//                               Icons.arrow_back_ios,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const Text(
//                             "Vocabulary Practice",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: accentColor,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: _refreshCurrentPage,
//                             icon: const Icon(
//                               Icons.refresh_rounded,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 10),

//                       // Teacher + hint
//                       SizedBox(
//                         height: 130,
//                         child: Column(
//                           children: const [
//                             Expanded(
//                               child: TeacherAnimation(),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               "Tap on any card to hear the word 👆",
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // Page indicator row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.white.withOpacity(0.06),
//                               border:
//                                   Border.all(color: accentColor, width: 0.8),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.layers_rounded,
//                                   size: 16,
//                                   color: accentColor,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "Set ${_currentPageIndex + 1}",
//                                   style: const TextStyle(
//                                     color: accentColor,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             "${_currentWords.length} words in this set",
//                             style: const TextStyle(
//                               color: Colors.white60,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 16),

//                       // Grid of vocab cards
//                       Expanded(
//                         child: GridView.builder(
//                           itemCount: _currentWords.length,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 18,
//                             crossAxisSpacing: 18,
//                             childAspectRatio: 0.78,
//                           ),
//                           itemBuilder: (context, index) {
//                             final word = _currentWords[index];
//                             return _buildWordCard(word,);
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       // Pagination buttons
                    
                    
//                       Row(
//                         children: [
                         
//                           // Expanded(
//                           //   child: OutlinedButton(
//                           //     onPressed: _currentPageIndex > 0
//                           //         ? () {
//                           //             setState(() {
//                           //               _currentPageIndex--;
//                           //             });
//                           //           }
//                           //         : null,
//                           //     style: OutlinedButton.styleFrom(
//                           //       side: BorderSide(
//                           //         color: _currentPageIndex > 0
//                           //             ? accentColor
//                           //             : Colors.white24,
//                           //       ),
//                           //       padding:
//                           //           const EdgeInsets.symmetric(vertical: 10),
//                           //       shape: RoundedRectangleBorder(
//                           //         borderRadius: BorderRadius.circular(14),
//                           //       ),
//                           //     ),
//                           //     child: Text(
//                           //       "Previous",
//                           //       style: TextStyle(
//                           //         color: _currentPageIndex > 0
//                           //             ? accentColor
//                           //             : Colors.white38,
//                           //         fontSize: 14,
//                           //         fontWeight: FontWeight.w600,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
                          
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pushReplacementNamed(
//                                     context, '/dailyQuiz');
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: accentColor,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 elevation: 6,
//                                 shadowColor:
//                                     accentColor.withOpacity(0.6),
//                               ),
//                               child: const Text(
//                                 "Next",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
                   
                   
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

// Widget _buildWordCard(VocabularyWord vocab, ) {
//   return GestureDetector(
//     onTap: () => _speakWord(vocab.word),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF020617), Color(0xFF082F49)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: accentColor.withOpacity(0.7), width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: glowColor.withOpacity(0.35),
//             blurRadius: 12,
//             spreadRadius: 1,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 10),

//           /// IMAGE
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: vocab.imageUrl.isNotEmpty
//                     ? Image.network(
//                         vocab.imageUrl,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder: (_, __, ___) => const Icon(
//                           Icons.broken_image,
//                           size: 40,
//                           color: Colors.grey,
//                         ),
//                       )
//                     : const Icon(
//                         Icons.image_not_supported_rounded,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//               ),
//             ),
//           ),


//           /// WORD + MEANING + SPEAKER
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             child: Column(
//               children: [
//                 Text(
//                   vocab.word,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: textColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 Text(
//                   vocab.meaning, // ✅ NOW IT WILL SHOW
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 20,
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 const Icon(
//                   Icons.volume_up_rounded,
//                   size: 18,
//                   color: accentColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }
