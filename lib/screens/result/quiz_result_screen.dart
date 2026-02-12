// import 'dart:math';
// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';

// class QuizResultScreen extends StatefulWidget {
//   final int score;
//   final int totalQuestions;
//   final List<dynamic> questions;
//   final List<int?> selectedIndices;

//   const QuizResultScreen({
//     super.key,
//     required this.score,
//     required this.totalQuestions,
//     required this.questions,
//     required this.selectedIndices,
//   });

//   @override
//   State<QuizResultScreen> createState() => _QuizResultScreenState();
// }

// class _QuizResultScreenState extends State<QuizResultScreen> {
//   late ConfettiController _leftConfetti;
//   late ConfettiController _rightConfetti;

//   int get wrongCount => widget.totalQuestions - widget.score;

//   double get ratio =>
//       widget.totalQuestions == 0 ? 0 : widget.score / widget.totalQuestions;

//   @override
//   void initState() {
//     super.initState();
//     _leftConfetti = ConfettiController(duration: const Duration(seconds: 4));
//     _rightConfetti = ConfettiController(duration: const Duration(seconds: 4));

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _leftConfetti.play();
//       _rightConfetti.play();
//     });
//   }

//   @override
//   void dispose() {
//     _leftConfetti.dispose();
//     _rightConfetti.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const accentColor = Colors.cyanAccent;

//     // Dynamic texts based on performance
//     String title;
//     String subtitle;
//     String level;
//     Color levelColor;

//     if (ratio >= 0.85) {
//       title = "🏆 Awesome Job!";
//       subtitle = "You’re smashing it. Keep shining!";
//       level = "Pro Level";
//       levelColor = Colors.amberAccent;
//     } else if (ratio >= 0.6) {
//       title = "✨ Good Effort!";
//       subtitle = "You’re on the right track. Keep going!";
//       level = "Rising Star";
//       levelColor = Colors.lightGreenAccent;
//     } else {
//       title = "🚀 Keep Practicing!";
//       subtitle = "Every day you get better. Don't give up!";
//       level = "Learner";
//       levelColor = Colors.orangeAccent;
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFF020617),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // 🌈 Glowing background elements
//             Positioned(
//               top: -80,
//               left: -40,
//               child: Container(
//                 width: 180,
//                 height: 180,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.cyanAccent.withOpacity(0.18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.cyanAccent.withOpacity(0.5),
//                       blurRadius: 40,
//                       spreadRadius: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -90,
//               right: -60,
//               child: Container(
//                 width: 220,
//                 height: 220,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.purpleAccent.withOpacity(0.16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.purpleAccent.withOpacity(0.45),
//                       blurRadius: 45,
//                       spreadRadius: 12,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             Column(
//               children: [
//                 const SizedBox(height: 12),

//                 // Small title line
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Daily Test Summary",
//                       style: TextStyle(
//                         color: Colors.white54,
//                         fontSize: 13,
//                         letterSpacing: 1.1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),

//                 // ====== HEADER CARD (animated) ======
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18),
//                   child: TweenAnimationBuilder<double>(
//                     tween: Tween(begin: -20, end: 0),
//                     duration: const Duration(milliseconds: 600),
//                     curve: Curves.easeOutBack,
//                     builder: (context, value, child) {
//                       return Transform.translate(
//                         offset: Offset(0, value),
//                         child: Opacity(
//                           opacity: ((20 + value) / 20).clamp(0.0, 1.0),
//                           child: child,
//                         ),
//                       );
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.easeOutCubic,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(26),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF00FFC6), Color(0xFF0066FF)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: accentColor.withOpacity(0.55),
//                             blurRadius: 25,
//                             spreadRadius: 1,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           // Trophy circle
//                           Container(
//                             height: 72,
//                             width: 72,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black.withOpacity(0.15),
//                               border: Border.all(color: Colors.white, width: 2),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "🏅",
//                                 style: TextStyle(fontSize: 36),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           // Texts
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   title,
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   subtitle,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Wrap(
//                                   spacing: 8,
//                                   runSpacing: 4,
//                                   children: [
//                                     _smallChip(
//                                       icon: Icons.star_rounded,
//                                       label:
//                                           "Score: ${widget.score}/${widget.totalQuestions}",
//                                       color: Colors.black.withOpacity(0.65),
//                                       textColor: Colors.white,
//                                     ),
//                                     _smallChip(
//                                       icon: Icons.check_circle_rounded,
//                                       label: "Correct: ${widget.score}",
//                                       color: Colors.black.withOpacity(0.5),
//                                       textColor: Colors.lightGreenAccent,
//                                     ),
//                                     _smallChip(
//                                       icon: Icons.cancel_rounded,
//                                       label: "Wrong: $wrongCount",
//                                       color: Colors.black.withOpacity(0.5),
//                                       textColor: Colors.redAccent,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Level chip + label
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white.withOpacity(0.06),
//                           border: Border.all(color: levelColor, width: 1),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.flash_on_rounded,
//                                 size: 18, color: levelColor),
//                             const SizedBox(width: 6),
//                             Text(
//                               level,
//                               style: TextStyle(
//                                 color: levelColor,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       const Text(
//                         "Review Answers",
//                         style: TextStyle(
//                           color: Colors.cyanAccent,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // ====== Q&A LIST ======
               
               
// Expanded(
//                   child: ListView.builder(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                     itemCount: widget.questions.length,
//                     itemBuilder: (context, index) {
//                       final q = widget.questions[index];
//                       final userIndex = widget.selectedIndices[index];
//                       final userAnswer = userIndex != null
//                           ? q["options"][userIndex]
//                           : "Not answered";
//                       final correct = q["answer"];
//                       final isCorrect = userAnswer == correct;

//                       return TweenAnimationBuilder<double>(
//                         tween: Tween(begin: 0.96, end: 1),
//                         duration: const Duration(milliseconds: 350),
//                         curve: Curves.easeOut,
//                         builder: (context, scale, child) {
//                           return Transform.scale(
//                             scale: scale,
//                             alignment: Alignment.center,
//                             child: child,
//                           );
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 14),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xFF0F172A),
//                                 isCorrect
//                                     ? const Color(0xFF022C22)
//                                     : const Color(0xFF1F2937),
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             border: Border.all(
//                               color: isCorrect
//                                   ? Colors.greenAccent
//                                   : Colors.redAccent,
//                               width: 1.6,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: (isCorrect
//                                         ? Colors.greenAccent
//                                         : Colors.redAccent)
//                                     .withOpacity(0.18),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: Stack(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     14, 14, 14, 14),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Circular badge for question number
//                                         Container(
//                                           width: 30,
//                                           height: 30,
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors.black
//                                                 .withOpacity(0.5),
//                                             border: Border.all(
//                                               color: Colors.white24,
//                                               width: 1,
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               "${index + 1}",
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         // Question text
//                                         Expanded(
//                                           child: Text(
//                                             q["question"],
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 12),
//                                     // Your answer
//                                     Text(
//                                       "Your Answer:",
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.white.withOpacity(0.7),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 6),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: isCorrect
//                                             ? Colors.greenAccent
//                                                 .withOpacity(0.12)
//                                             : Colors.orangeAccent
//                                                 .withOpacity(0.10),
//                                         border: Border.all(
//                                           color: isCorrect
//                                               ? Colors.greenAccent
//                                               : Colors.orangeAccent,
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         userAnswer,
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                           color: isCorrect
//                                               ? Colors.greenAccent
//                                               : Colors.orangeAccent,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                     if (!isCorrect) ...[
//                                       const SizedBox(height: 10),
//                                       Text(
//                                         "Correct Answer:",
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           color:
//                                               Colors.white.withOpacity(0.7),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           color: Colors.cyanAccent
//                                               .withOpacity(0.12),
//                                           border: Border.all(
//                                             color: Colors.cyanAccent,
//                                             width: 1,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           correct,
//                                           style: const TextStyle(
//                                             fontSize: 15,
//                                             color: Colors.cyanAccent,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),

//                               // Top-right status chip
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: isCorrect
//                                         ? Colors.greenAccent.withOpacity(0.15)
//                                         : Colors.redAccent.withOpacity(0.15),
//                                     border: Border.all(
//                                       color: isCorrect
//                                           ? Colors.greenAccent
//                                           : Colors.redAccent,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         isCorrect
//                                             ? Icons.check_circle_rounded
//                                             : Icons.cancel_rounded,
//                                         size: 16,
//                                         color: isCorrect
//                                             ? Colors.greenAccent
//                                             : Colors.redAccent,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         isCorrect ? "Correct" : "Wrong",
//                                         style: TextStyle(
//                                           color: isCorrect
//                                               ? Colors.greenAccent
//                                               : Colors.redAccent,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),


//                 // Expanded(
//                 //   child: ListView.builder(
//                 //     padding:
//                 //         const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                 //     itemCount: widget.questions.length,
//                 //     itemBuilder: (context, index) {
//                 //       final q = widget.questions[index];
//                 //       final userIndex = widget.selectedIndices[index];
//                 //       final userAnswer = userIndex != null
//                 //           ? q["options"][userIndex]
//                 //           : "Not answered";
//                 //       final correct = q["answer"];
//                 //       final isCorrect = userAnswer == correct;

//                 //       return TweenAnimationBuilder<double>(
//                 //         tween: Tween(begin: 0.96, end: 1),
//                 //         duration: const Duration(milliseconds: 300),
//                 //         curve: Curves.easeOut,
//                 //         builder: (context, scale, child) {
//                 //           return Transform.scale(
//                 //             scale: scale,
//                 //             alignment: Alignment.center,
//                 //             child: child,
//                 //           );
//                 //         },
//                 //         child: Container(
//                 //           margin: const EdgeInsets.only(bottom: 14),
//                 //           child: Row(
//                 //             crossAxisAlignment: CrossAxisAlignment.stretch,
//                 //             children: [
//                 //               // Neon strip on the left
//                 //               Container(
//                 //                 width: 4,
//                 //                 decoration: BoxDecoration(
//                 //                   borderRadius: BorderRadius.circular(20),
//                 //                   gradient: LinearGradient(
//                 //                     colors: isCorrect
//                 //                         ? [
//                 //                             Colors.greenAccent,
//                 //                             Colors.lightGreenAccent
//                 //                           ]
//                 //                         : [
//                 //                             Colors.redAccent,
//                 //                             Colors.deepOrangeAccent
//                 //                           ],
//                 //                     begin: Alignment.topCenter,
//                 //                     end: Alignment.bottomCenter,
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //               const SizedBox(width: 8),
//                 //               Expanded(
//                 //                 child: Container(
//                 //                   decoration: BoxDecoration(
//                 //                     borderRadius: BorderRadius.circular(20),
//                 //                     gradient: LinearGradient(
//                 //                       colors: [
//                 //                         const Color(0xFF020617),
//                 //                         isCorrect
//                 //                             ? const Color(0xFF022C22)
//                 //                             : const Color(0xFF111827),
//                 //                       ],
//                 //                       begin: Alignment.topLeft,
//                 //                       end: Alignment.bottomRight,
//                 //                     ),
//                 //                     border: Border.all(
//                 //                       color: isCorrect
//                 //                           ? Colors.greenAccent
//                 //                           : Colors.redAccent,
//                 //                       width: 1.4,
//                 //                     ),
//                 //                     boxShadow: [
//                 //                       BoxShadow(
//                 //                         color: (isCorrect
//                 //                                 ? Colors.greenAccent
//                 //                                 : Colors.redAccent)
//                 //                             .withOpacity(0.16),
//                 //                         blurRadius: 14,
//                 //                         offset: const Offset(0, 8),
//                 //                       ),
//                 //                     ],
//                 //                   ),
//                 //                   child: Stack(
//                 //                     children: [
//                 //                       Padding(
//                 //                         padding: const EdgeInsets.fromLTRB(
//                 //                             14, 14, 14, 14),
//                 //                         child: Column(
//                 //                           crossAxisAlignment:
//                 //                               CrossAxisAlignment.start,
//                 //                           children: [
//                 //                             Row(
//                 //                               crossAxisAlignment:
//                 //                                   CrossAxisAlignment.start,
//                 //                               children: [
//                 //                                 // Circular badge for question number
//                 //                                 Container(
//                 //                                   width: 30,
//                 //                                   height: 30,
//                 //                                   decoration: BoxDecoration(
//                 //                                     shape: BoxShape.circle,
//                 //                                     color: Colors.black
//                 //                                         .withOpacity(0.5),
//                 //                                     border: Border.all(
//                 //                                       color: Colors.white24,
//                 //                                       width: 1,
//                 //                                     ),
//                 //                                   ),
//                 //                                   child: Center(
//                 //                                     child: Text(
//                 //                                       "${index + 1}",
//                 //                                       style: const TextStyle(
//                 //                                         color: Colors.white,
//                 //                                         fontSize: 14,
//                 //                                         fontWeight:
//                 //                                             FontWeight.bold,
//                 //                                       ),
//                 //                                     ),
//                 //                                   ),
//                 //                                 ),
//                 //                                 const SizedBox(width: 10),
//                 //                                 // Question text
//                 //                                 Expanded(
//                 //                                   child: Text(
//                 //                                     q["question"],
//                 //                                     style: const TextStyle(
//                 //                                       fontSize: 16,
//                 //                                       color: Colors.white,
//                 //                                       fontWeight:
//                 //                                           FontWeight.w600,
//                 //                                     ),
//                 //                                   ),
//                 //                                 ),
//                 //                               ],
//                 //                             ),
//                 //                             const SizedBox(height: 12),

//                 //                             // Your answer
//                 //                             Text(
//                 //                               "Your Answer:",
//                 //                               style: TextStyle(
//                 //                                 fontSize: 13,
//                 //                                 color: Colors.white
//                 //                                     .withOpacity(0.7),
//                 //                               ),
//                 //                             ),
//                 //                             const SizedBox(height: 4),
//                 //                             Container(
//                 //                               padding:
//                 //                                   const EdgeInsets.symmetric(
//                 //                                       horizontal: 10,
//                 //                                       vertical: 6),
//                 //                               decoration: BoxDecoration(
//                 //                                 borderRadius:
//                 //                                     BorderRadius.circular(12),
//                 //                                 color: isCorrect
//                 //                                     ? Colors.greenAccent
//                 //                                         .withOpacity(0.12)
//                 //                                     : Colors.orangeAccent
//                 //                                         .withOpacity(0.10),
//                 //                                 border: Border.all(
//                 //                                   color: isCorrect
//                 //                                       ? Colors.greenAccent
//                 //                                       : Colors.orangeAccent,
//                 //                                   width: 1,
//                 //                                 ),
//                 //                               ),
//                 //                               child: Text(
//                 //                                 userAnswer,
//                 //                                 style: TextStyle(
//                 //                                   fontSize: 15,
//                 //                                   color: isCorrect
//                 //                                       ? Colors.greenAccent
//                 //                                       : Colors.orangeAccent,
//                 //                                   fontWeight: FontWeight.w600,
//                 //                                 ),
//                 //                               ),
//                 //                             ),
//                 //                             if (!isCorrect) ...[
//                 //                               const SizedBox(height: 10),
//                 //                               Text(
//                 //                                 "Correct Answer:",
//                 //                                 style: TextStyle(
//                 //                                   fontSize: 13,
//                 //                                   color: Colors.white
//                 //                                       .withOpacity(0.7),
//                 //                                 ),
//                 //                               ),
//                 //                               const SizedBox(height: 4),
//                 //                               Container(
//                 //                                 padding:
//                 //                                     const EdgeInsets.symmetric(
//                 //                                         horizontal: 10,
//                 //                                         vertical: 6),
//                 //                                 decoration: BoxDecoration(
//                 //                                   borderRadius:
//                 //                                       BorderRadius.circular(
//                 //                                           12),
//                 //                                   color: Colors.cyanAccent
//                 //                                       .withOpacity(0.12),
//                 //                                   border: Border.all(
//                 //                                     color: Colors.cyanAccent,
//                 //                                     width: 1,
//                 //                                   ),
//                 //                                 ),
//                 //                                 child: Text(
//                 //                                   correct,
//                 //                                   style: const TextStyle(
//                 //                                     fontSize: 15,
//                 //                                     color: Colors.cyanAccent,
//                 //                                     fontWeight: FontWeight.w600,
//                 //                                   ),
//                 //                                 ),
//                 //                               ),
//                 //                             ],
//                 //                           ],
//                 //                         ),
//                 //                       ),

//                 //                       // Top-right status chip
//                 //                       Positioned(
//                 //                         top: 10,
//                 //                         right: 10,
//                 //                         child: Container(
//                 //                           padding: const EdgeInsets.symmetric(
//                 //                               horizontal: 10, vertical: 4),
//                 //                           decoration: BoxDecoration(
//                 //                             borderRadius:
//                 //                                 BorderRadius.circular(20),
//                 //                             color: isCorrect
//                 //                                 ? Colors.greenAccent
//                 //                                     .withOpacity(0.15)
//                 //                                 : Colors.redAccent
//                 //                                     .withOpacity(0.15),
//                 //                             border: Border.all(
//                 //                               color: isCorrect
//                 //                                   ? Colors.greenAccent
//                 //                                   : Colors.redAccent,
//                 //                               width: 1,
//                 //                             ),
//                 //                           ),
//                 //                           child: Row(
//                 //                             mainAxisSize: MainAxisSize.min,
//                 //                             children: [
//                 //                               Icon(
//                 //                                 isCorrect
//                 //                                     ? Icons
//                 //                                         .check_circle_rounded
//                 //                                     : Icons.cancel_rounded,
//                 //                                 size: 16,
//                 //                                 color: isCorrect
//                 //                                     ? Colors.greenAccent
//                 //                                     : Colors.redAccent,
//                 //                               ),
//                 //                               const SizedBox(width: 4),
//                 //                               Text(
//                 //                                 isCorrect
//                 //                                     ? "Correct"
//                 //                                     : "Wrong",
//                 //                                 style: TextStyle(
//                 //                                   color: isCorrect
//                 //                                       ? Colors.greenAccent
//                 //                                       : Colors.redAccent,
//                 //                                   fontSize: 12,
//                 //                                   fontWeight: FontWeight.w600,
//                 //                                 ),
//                 //                               ),
//                 //                             ],
//                 //                           ),
//                 //                         ),
//                 //                       ),
//                 //                     ],
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ),
//                 //       );
//                 //     },
//                 //   ),
//                 // ),



//                 // ====== BUTTONS ======
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                   child: Row(
//                     children: [
//                       // Expanded(
//                       //   child: OutlinedButton(
//                       //     onPressed: () => Navigator.pop(context),
//                       //     style: OutlinedButton.styleFrom(
//                       //       side: const BorderSide(color: Colors.cyanAccent),
//                       //       padding: const EdgeInsets.symmetric(vertical: 12),
//                       //       shape: RoundedRectangleBorder(
//                       //         borderRadius: BorderRadius.circular(18),
//                       //       ),
//                       //     ),
//                       //     child: const Text(
//                       //       "Close",
//                       //       style: TextStyle(
//                       //         color: Colors.cyanAccent,
//                       //         fontSize: 16,
//                       //         fontWeight: FontWeight.w600,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       // const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton(
//                           // You can wire this to restart quiz if needed
//                           onPressed:() {
//                             Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false
//                             );}
// ,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.cyanAccent,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18),
//                             ),
//                             elevation: 6,
//                             shadowColor: Colors.cyanAccent.withOpacity(0.6),
//                           ),
//                           child: const Text(
//                             "Back to Home",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             // ====== CONFETTI ON TOP ======
//             Align(
//               alignment: Alignment.topLeft,
//               child: ConfettiWidget(
//                 confettiController: _leftConfetti,
//                 blastDirection: pi / 4,
//                 emissionFrequency: 0.12,
//                 numberOfParticles: 10,
//                 gravity: 0.1,
//                 colors: const [
//                   Colors.pinkAccent,
//                   Colors.purple,
//                   Colors.cyanAccent,
//                   Colors.white
//                 ],
//                 createParticlePath: _drawFlower,
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: ConfettiWidget(
//                 confettiController: _rightConfetti,
//                 blastDirection: 3 * pi / 4,
//                 emissionFrequency: 0.12,
//                 numberOfParticles: 10,
//                 gravity: 0.1,
//                 colors: const [
//                   Colors.pinkAccent,
//                   Colors.purple,
//                   Colors.cyanAccent,
//                   Colors.white
//                 ],
//                 createParticlePath: _drawFlower,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🌸 Flower Confetti Particles
//   Path _drawFlower(Size size) {
//     final Path path = Path();
//     const petals = 10;
//     final r = size.width / 2;

//     for (int i = 0; i < petals; i++) {
//       final theta = (2 * pi * i) / petals;
//       final x = r + r * cos(theta);
//       final y = r + r * sin(theta);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.quadraticBezierTo(r, r, x, y);
//       }
//     }
//     return path..close();
//   }

//   Widget _smallChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required Color textColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: textColor),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// lib/screens/quiz_result_screen.dart
import 'dart:convert';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<dynamic> questions;
  final List<int?> selectedIndices;
 final int page;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.questions,
    required this.selectedIndices, 
    required this.page,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  late ConfettiController _leftConfetti;
  late ConfettiController _rightConfetti;

  // Normalized questions used by UI
  late final List<_NormalizedQuestion> _normalized;

  int get wrongCount => widget.totalQuestions - widget.score;

  double get ratio =>
      widget.totalQuestions == 0 ? 0 : widget.score / widget.totalQuestions;

  @override
  void initState() {
    super.initState();
    _leftConfetti = ConfettiController(duration: const Duration(seconds: 4));
    _rightConfetti = ConfettiController(duration: const Duration(seconds: 4));

    _normalized = widget.questions
        .map((q) => _NormalizedQuestion.fromRaw(q))
        .toList(growable: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leftConfetti.play();
      _rightConfetti.play();
    });
  }

  @override
  void dispose() {
    _leftConfetti.dispose();
    _rightConfetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Colors.cyanAccent;

    

    // Dynamic texts based on performance
    String title;
    String subtitle;
    String level;
    Color levelColor;

    if (ratio >= 0.85) {
      title = "🏆 Awesome Job!";
      subtitle = "You’re smashing it. Keep shining!";
      level = "Pro Level";
      levelColor = Colors.amberAccent;
    } else if (ratio >= 0.6) {
      title = "✨ Good Effort!";
      subtitle = "You’re on the right track. Keep going!";
      level = "Rising Star";
      levelColor = Colors.lightGreenAccent;
    } else {
      title = "🚀 Keep Practicing!";
      subtitle = "Every day you get better. Don't give up!";
      level = "Learner";
      levelColor = Colors.orangeAccent;
    }

    return WillPopScope(
      onWillPop: () async {

        widget.page==0?
        Navigator.pushReplacementNamed(context, '/home'):
          Navigator.pushReplacementNamed(context, '/lesson');
        return false;
      },
      child: Scaffold(

        
        
        backgroundColor: const Color(0xFF020617),
        body: SafeArea(
          child: Stack(
            children: [
              // Glowing background circles
              Positioned(
                top: -80,
                left: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyanAccent.withOpacity(0.18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -90,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent.withOpacity(0.16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.45),
                        blurRadius: 45,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
      
              Column(
                children: [
                  const SizedBox(height: 12),
      
                  // Small title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Daily Test Summary",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
      
                  // Header card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: -20, end: 0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, value),
                          child: Opacity(
                            opacity: ((20 + value) / 20).clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00FFC6), Color(0xFF0066FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.55),
                              blurRadius: 25,
                              spreadRadius: 1,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Trophy circle
                            Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.15),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Center(
                                child: Text(
                                  "🏅",
                                  style: TextStyle(fontSize: 36),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Texts
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _smallChip(
                                        icon: Icons.star_rounded,
                                        label:
                                            "Score: ${widget.score}/${widget.totalQuestions}",
                                        color: Colors.black.withOpacity(0.65),
                                        textColor: Colors.white,
                                      ),
                                      _smallChip(
                                        icon: Icons.check_circle_rounded,
                                        label: "Correct: ${widget.score}",
                                        color: Colors.black.withOpacity(0.5),
                                        textColor: Colors.lightGreenAccent,
                                      ),
                                      _smallChip(
                                        icon: Icons.cancel_rounded,
                                        label: "Wrong: $wrongCount",
                                        color: Colors.black.withOpacity(0.5),
                                        textColor: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 10),
      
                  // Level chip + review label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(color: levelColor, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.flash_on_rounded, size: 18, color: levelColor),
                              const SizedBox(width: 6),
                              Text(
                                level,
                                style: TextStyle(
                                  color: levelColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Review Answers",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 8),
      
                  // Questions list
                  Expanded(
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      itemCount: _normalized.length,
                      itemBuilder: (context, index) {
                        final q = _normalized[index];
      
                        // Safe selected index reading
                        int? userIndex;
                        if (index < widget.selectedIndices.length) {
                          userIndex = widget.selectedIndices[index];
                        } else {
                          userIndex = null;
                        }
      
                        final userAnswer = (userIndex != null &&
                                userIndex >= 0 &&
                                userIndex < q.options.length)
                            ? q.options[userIndex]
                            : (userIndex == null ? "Not answered" : "Invalid answer");
      
                        final isCorrect = userAnswer == q.answer;
      
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.96, end: 1),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0F172A),
                                  isCorrect
                                      ? const Color(0xFF022C22)
                                      : const Color(0xFF1F2937),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color:
                                    isCorrect ? Colors.greenAccent : Colors.redAccent,
                                width: 1.6,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isCorrect ? Colors.greenAccent : Colors.redAccent)
                                          .withOpacity(0.18),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withOpacity(0.5),
                                              border: Border.all(
                                                color: Colors.white24,
                                                width: 1,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${index + 1}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              q.question,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Your Answer:",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: isCorrect
                                              ? Colors.greenAccent.withOpacity(0.12)
                                              : Colors.orangeAccent.withOpacity(0.10),
                                          border: Border.all(
                                            color: isCorrect
                                                ? Colors.greenAccent
                                                : Colors.orangeAccent,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          userAnswer,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                isCorrect ? Colors.greenAccent : Colors.orangeAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (!isCorrect) ...[
                                        const SizedBox(height: 10),
                                        Text(
                                          "Correct Answer:",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.cyanAccent.withOpacity(0.12),
                                            border: Border.all(
                                              color: Colors.cyanAccent,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            q.answer,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.cyanAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
      
                                // Top-right status chip
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isCorrect
                                          ? Colors.greenAccent.withOpacity(0.15)
                                          : Colors.redAccent.withOpacity(0.15),
                                      border: Border.all(
                                        color: isCorrect
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isCorrect
                                              ? Icons.check_circle_rounded
                                              : Icons.cancel_rounded,
                                          size: 16,
                                          color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isCorrect ? "Correct" : "Wrong",
                                          style: TextStyle(
                                            color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      
                  // // Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Return to home (adjust route as per your app)
                                widget.page==1?
                                 Navigator
                                 .pushReplacementNamed(
                                    context, '/option'):
                                    Navigator
                                    .pushReplacementNamed( 
                                      context,"/rule");                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 6,
                              shadowColor: Colors.cyanAccent.withOpacity(0.6),
                            ),
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
               
               
                ],
              ),
      
              // Confetti
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: _leftConfetti,
                  blastDirection: pi / 4,
                  emissionFrequency: 0.12,
                  numberOfParticles: 10,
                  gravity: 0.1,
                  colors: const [
                    Colors.pinkAccent,
                    Colors.purple,
                    Colors.cyanAccent,
                    Colors.white
                  ],
                  createParticlePath: _drawFlower,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _rightConfetti,
                  blastDirection: 3 * pi / 4,
                  emissionFrequency: 0.12,
                  numberOfParticles: 10,
                  gravity: 0.1,
                  colors: const [
                    Colors.pinkAccent,
                    Colors.purple,
                    Colors.cyanAccent,
                    Colors.white
                  ],
                  createParticlePath: _drawFlower,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Flower confetti path
  Path _drawFlower(Size size) {
    final Path path = Path();
    const petals = 10;
    final r = size.width / 2;

    for (int i = 0; i < petals; i++) {
      final theta = (2 * pi * i) / petals;
      final x = r + r * cos(theta);
      final y = r + r * sin(theta);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.quadraticBezierTo(r, r, x, y);
      }
    }
    return path..close();
  }

  Widget _smallChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal normalized question model to avoid runtime type issues
class _NormalizedQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  _NormalizedQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory _NormalizedQuestion.fromRaw(dynamic raw) {
    try {
      // raw might be Map<String, dynamic>, or a JSON string
      final Map<String, dynamic> map;
      if (raw is String) {
        map = jsonDecode(raw) as Map<String, dynamic>;
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      } else {
        map = {};
      }

      // Question text
      final question = (map['question'] ?? map['q'] ?? 'No question').toString();

      // Options: accept String list, or comma-separated, or null
      List<String> options = <String>[];
      final o = map['options'] ?? map['choices'] ?? map['opts'];
      if (o is List) {
        options = o.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      } else if (o is String) {
        // try to split by '|' or commas
        options = o.split(RegExp(r'[|,]')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }

      // Answer: may be string or list (join list)
      String answer;
      final a = map['answer'] ?? map['correct'];
      if (a is List) {
        answer = a.map((e) => e.toString()).join(' ');
      } else if (a == null) {
        answer = '';
      } else {
        answer = a.toString();
      }

      // Explanation
      final explanation = (map['explanation'] ?? '').toString();

      // If options empty but answer present, add answer as single option to avoid index errors
      if (options.isEmpty && answer.isNotEmpty) {
        options = [answer];
      }

      return _NormalizedQuestion(
        question: question,
        options: options,
        answer: answer,
        explanation: explanation,
      );
    } catch (e) {
      // On any parse error, return a safe fallback
      return _NormalizedQuestion(
        question: 'Invalid question data',
        options: <String>['Not available'],
        answer: 'Not available',
        explanation: '',
      );
    }
  }
}
