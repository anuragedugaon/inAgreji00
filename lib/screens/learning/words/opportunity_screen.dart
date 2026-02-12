// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart';
// import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

// import '../../ai/voice_chat_screen.dart';

// class OpportunityScreen extends StatefulWidget {
//   const OpportunityScreen({super.key});

//   @override
//   State<OpportunityScreen> createState() => _OpportunityScreenState();
// }

// class _OpportunityScreenState extends State<OpportunityScreen> {
//   AIService _aiService = AIService();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _aiService.fetchWordDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Theme Colors
//     const Color backgroundColor = Colors.black;
//     const Color primaryColor = Colors.cyanAccent;
//     const Color textColor = Colors.white;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         // ✅ Correct
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
//           onPressed: () {
//             // 👇 Navigate directly to Home using your defined route
//             Navigator.pushReplacementNamed(
//               context,
//               AppRoutes
//                   .home, // ✅ Make sure AppRoutes.home exists in app_routes.dart
//               // removes all previous routes
//             );
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center, // Center vertically
//             crossAxisAlignment:
//                 CrossAxisAlignment.center, // Center horizontally
//             children: [
//               const Spacer(),

//               // Word Title
//               const Text(
//                 "Opportunity",
//                 style: TextStyle(
//                   color: primaryColor,
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 20),

//               // Definition
//               const Text(
//                 "A chance to do something\nor achieve something",
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: 16,
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 16),

//               // Translation (Hindi)
//               const Text(
//                 "अवसर",
//                 style: TextStyle(
//                   color: primaryColor,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 20),

//               // Example sentence
//               const Text(
//                 "“They offered me an\namazing opportunity.”",
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 16,
//                   fontStyle: FontStyle.italic,
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const Spacer(),

//               // Mic Button
//               Center(
//                 child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: primaryColor, width: 2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: primaryColor.withOpacity(0.6),
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                       )
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.mic, color: primaryColor, size: 40),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => VoiceChatScreen(
//                               prom: """
// {
//   "Greeting People": [
//     "Hello! How are you?",
//     "Nice to meet you!",
//     "Good morning!",
//     "Good afternoon!",
//     "Good evening!"
//   ],
//   "Asking for Help": [
//     "Can you help me, please?",
//     "I need some assistance.",
//     "Can you show me this?",
//     "Can you explain that to me?",
//     "I don’t understand. Can you help?"
//   ],
//   "Making Requests": [
//     "Could you please open the door?",
//     "Please speak slowly.",
//     "Can I borrow your pen?",
//     "Can you tell me the time?",
//     "May I sit here?"
//   ],
//   "Describing Places": [
//     "This place is very beautiful.",
//     "The room is large and clean.",
//     "The park is full of trees.",
//     "The city is very crowded.",
//     "The restaurant is quiet and cozy."
//   ]
// }

// """,
//                             ),
//                           ));
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import '../../ai/voice_chat_screen.dart';

class OpportunityScreen extends StatefulWidget {
  const OpportunityScreen({super.key});

  @override
  State<OpportunityScreen> createState() => _OpportunityScreenState();
}

class _OpportunityScreenState extends State<OpportunityScreen> {
  AIService _aiService = AIService();

  // Store word details
  String word = '';
  String hindi = '';
  String definition = '';
  String example = '';
  String voicePrompt = '';

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
  }

  Future<void> _loadRandomWord() async {
    setState(() {
      loading = true;
    });

    try {
      final data = await _aiService.fetchWordDetails(); // ✅ Auto random word
      setState(() {
        word = data['word'] ?? 'Word';
        hindi = data['hindi'] ?? '';
        definition = data['definition'] ?? '';
        example = (data['examples'] != null && data['examples'].isNotEmpty)
            ? data['examples'][0]
            : '';
        voicePrompt = data['voice_prompt'] ?? '';
        loading = false;
      });
    } catch (e) {
      setState(() {
        word = 'Error';
        definition = e.toString();
        hindi = '';
        example = '';
        voicePrompt = '';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.black;
    const Color primaryColor = Colors.cyanAccent;
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.cyanAccent),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Word Title
                    Text(
                      word,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Definition
                    Text(
                      definition,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Translation (Hindi)
                    Text(
                      hindi,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Example sentence
                    Text(
                      example,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(),

                    // Mic Button
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.mic, color: primaryColor, size: 40),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VoiceChatScreen(
                                  prom: voicePrompt,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
        ),
      ),
    );
  }
}
