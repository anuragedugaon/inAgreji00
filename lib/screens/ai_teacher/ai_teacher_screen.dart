// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/widgets/animated_teacher_widget.dart';
// import 'package:inangreji_flutter/widgets/animated_answer.dart';
// import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AITeacherScreen extends StatefulWidget {
//   const AITeacherScreen({Key? key}) : super(key: key);

//   @override
//   State<AITeacherScreen> createState() => _AITeacherScreenState();
// }






// class _AITeacherScreenState extends State<AITeacherScreen> {
//   final AIService _aiService = AIService();
//   final TextEditingController _controller = TextEditingController();
//   final GlobalKey<AnimatedTeacherState> _teacherKey = GlobalKey();

//   String? _question;
//   String? _answer;
//   bool _isSpeaking = false;
//   bool _isLoading = false;

//   Future<void> _askTeacher() async {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;

//     // 👇 Hide keyboard immediately
//     FocusScope.of(context).unfocus();

//     setState(() {
//       _question = text;
//       _answer = null;
//       _isLoading = true;
//     });

//     _controller.clear();

//     final answer = await _aiService.getAnswer(text);

//     setState(() {
//       _answer = answer;
//       _isLoading = false;
//     });

//     await _teacherKey.currentState?.speak(answer);
//   }



//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       resizeToAvoidBottomInset: true, // 👈 handles keyboard properly
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () =>
//               FocusScope.of(context).unfocus(), // 👈 hide keyboard on tap
//           child: Stack(
//             children: [
//               // ✨ Glowing background overlay
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.blue.withOpacity(0.08),
//                         Colors.transparent,
//                       ],
//                       radius: 0.85,
//                       center: const Alignment(0, -0.6),
//                     ),
//                   ),
//                 ),
//               ),

//               // 🧠 Main content
//               Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.06,
//                         vertical: screenHeight * 0.02,
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 20),

//                           // 👩‍🏫 Title + Avatar
//                           Column(
//                             children: [
//                               Text(
//                                 "InAngreji AI Teacher",
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.blueAccent.shade100,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 1.2,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               AnimatedTeacher(
//                                 key: _teacherKey,
//                                 aiService: _aiService,
//                               ),
//                             ],
//                           ),
//                           Positioned(
//                             right: 0,
//                             top: 0,
//                             child: IconButton(
//                               icon: const Icon(Icons.login_rounded,
//                                   color: Colors.white70, size: 26),
//                               onPressed: () {
//                                 Navigator.pushReplacementNamed(context,
//                                     '/login'); // 👈 navigate using your route variable
//                               },
//                               tooltip: 'Login',
//                             ),
//                           ),

//                           const SizedBox(height: 28),

//                           // 💬 Answer
//                           if (_answer != null)
//                             AnimatedContainer(
//                               duration: const Duration(milliseconds: 400),
//                               curve: Curves.easeOut,
//                               padding: const EdgeInsets.all(16),
//                               margin: const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.07),
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(
//                                   color: Colors.blueAccent.withOpacity(0.3),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.blueAccent.withOpacity(0.2),
//                                     blurRadius: 10,
//                                     spreadRadius: 2,
//                                   ),
//                                 ],
//                               ),
//                               child: AnimatedAnswer(
//                                 text: _answer!,
//                                 isSpeaking: _isSpeaking,
//                                 aiService: _aiService,
//                               ),
//                             ),

//                           if (_isLoading)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 30),
//                               child: Column(
//                                 children: const [
//                                   CircularProgressIndicator(
//                                     color: Colors.blueAccent,
//                                     strokeWidth: 3,
//                                   ),
//                                   SizedBox(height: 12),
//                                   Text(
//                                     "Thinking...",
//                                     style: TextStyle(
//                                       color: Colors.white54,
//                                       fontSize: 14,
//                                       letterSpacing: 1.1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                           const SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ✍️ Input Section (glitch-free)
//                   AnimatedPadding(
//                     duration: const Duration(milliseconds: 250),
//                     curve: Curves.easeOut,
//                     padding: EdgeInsets.only(
//                       left: 18,
//                       right: 18,
//                       bottom: MediaQuery.of(context).viewInsets.bottom + 10,
//                     ),
//                     child: SafeArea(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 18, vertical: 14),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(
//                             color: Colors.blueAccent.withOpacity(0.3),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.blueAccent.withOpacity(0.15),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: _controller,
//                                 textInputAction: TextInputAction.send,
//                                 onSubmitted: (_) => _askTeacher(),
//                                 style: GoogleFonts.poppins(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                                 decoration: const InputDecoration(
//                                   hintText: "Ask your AI teacher...",
//                                   hintStyle: TextStyle(color: Colors.white54),
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blueAccent,
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.send_rounded,
//                                     color: Colors.white),
//                                 onPressed: _isLoading ? null : _askTeacher,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // 🔹 Footer
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Text(
//                       "Your personal English mentor ✨",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white38,
//                         fontSize: 13,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
