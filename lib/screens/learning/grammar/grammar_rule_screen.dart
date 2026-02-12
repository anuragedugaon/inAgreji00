import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

import '../../../models/request_model/grammar_lesson_request_model.dart';
import '../../../models/request_model/grammer_request_model.dart';
import '../../../services/video_player.dart';
import '../../../widgets/message_bubble.dart';
// TODO: iss path ko apne hisaab se correct karo
import '../choose_option_screen.dart';
import 'grammar_arrange_practice_screen.dart';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:inangreji_flutter/provider/ai_model_/ai_model_repo.dart';

import '../../../widgets/message_bubble.dart';
import 'grammar_arrange_practice_screen.dart';


class GrammarRuleScreen extends StatefulWidget {
  const GrammarRuleScreen({super.key});

  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color cardFill = Color(0xFF1C1C1E);

  @override
  State<GrammarRuleScreen> createState() => _GrammarRuleScreenState();
}

class _GrammarRuleScreenState extends State<GrammarRuleScreen> {
  final AIService _aiService = AIService();
  final AppProvider appProvider = AppProvider();

  bool loading = true;

  String ruleTitle = '';
  String ruleDescription = '';
  List<String> examples = [];
  List<Map<String, dynamic>> arrangeQuestions = [];

  @override
  void initState() {
    super.initState();
    _fetchGrammarRule();
  }

  // ================= FETCH GRAMMAR =================
  Future<void> _fetchGrammarRule() async {
    setState(() => loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

     final grammarRule = await getRandomGrammarRule(prefs);


      final response = await AIModelRepo.generateGrammarLesson(
        request: GrammarLessonRequestSend(
          grammarRule:
              (grammarRule == null || grammarRule.isEmpty)
                  ? "Future simple tense"
                  : grammarRule,
          userLevel:
              appProvider.userDetails.data?.level?.name ??
              prefs.getString("user_level") ??
              "beginner",
          selectedLanguage:
              prefs.getString('selected_language') ?? "Tamil",
        ),
      
      
      );

      if (!mounted || response == null) return;

      final data = response.data;

      if (data.examples.isEmpty &&
          data.arrangeQuestions.isEmpty) {
        throw Exception("No grammar data returned");
      }

      setState(() {
        ruleTitle = data.title;
        ruleDescription = data.theory;
        examples = data.examples;

        arrangeQuestions = data.arrangeQuestions
            .map((q) => {
                  "sentence": q.sentence,
                  "meaning": q.meaning,
                  "words": q.words,
                  "answer": q.answer,
                })
            .toList();

        loading = false;
      });

      // 🔊 Speak grammar rule
      final buffer = StringBuffer()
        ..writeln(ruleTitle)
        ..writeln(ruleDescription);

      for (final ex in examples) {
        buffer.writeln(ex);
      }

      await _aiService.speakText(buffer.toString());
    } catch (e) {
      if (!mounted) return;

      setState(() {
        ruleTitle = "No Grammar Found";
        ruleDescription =
            "Please select a valid grammar rule and try again.";
        examples = [];
        arrangeQuestions = [];
        loading = false;
      });

      showResultSnackBar(
        context,
        "Failed to load grammar content",
        false,
      );
    }
  }

  // ================= PRACTICE =================
  void _onPracticeNow() {
    if (loading) return;

    if (arrangeQuestions.isEmpty) {
      showResultSnackBar(
        context,
        "No practice available",
        false,
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GrammarArrangePracticeScreen(
          ruleTitle: ruleTitle,
          questions: arrangeQuestions,
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrammarRuleScreen.backgroundColor,
      appBar: AppBar(
        backgroundColor: GrammarRuleScreen.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: GrammarRuleScreen.accentColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Grammar Rule",
          style: TextStyle(
            color: GrammarRuleScreen.accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _fetchGrammarRule,
            icon: const Icon(
              Icons.refresh,
              color: GrammarRuleScreen.accentColor,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: GrammarRuleScreen.accentColor,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: GrammarRuleScreen.cardFill,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: GrammarRuleScreen.accentColor,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: GrammarRuleScreen.glowColor
                                .withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ruleTitle,
                            style: const TextStyle(
                              color: GrammarRuleScreen.accentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ruleDescription,
                            style: const TextStyle(
                              color: GrammarRuleScreen.textColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (examples.isNotEmpty) ...[
                            const Text(
                              "Examples:",
                              style: TextStyle(
                                color:
                                    GrammarRuleScreen.accentColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...examples.map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "- $e",
                                  style: const TextStyle(
                                    color:
                                        GrammarRuleScreen.textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onPracticeNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: GrammarRuleScreen.accentColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Practice Now",
                        style: TextStyle(
                          color: GrammarRuleScreen.accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}



// class GrammarRuleScreen extends StatefulWidget {
//   const GrammarRuleScreen({super.key});

//   // Theme colors
//   static const Color backgroundColor = Colors.black;
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color glowColor = Color(0xFF80FFFF);
//   static const Color textColor = Colors.white;
//   static const Color cardFill = Color(0xFF1C1C1E);

//   @override
//   State<GrammarRuleScreen> createState() => _GrammarRuleScreenState();
// }

// class _GrammarRuleScreenState extends State<GrammarRuleScreen> {
//   final AIService _aiService = AIService();

//   bool loading = true;
//   String ruleTitle = '';
//   String ruleDescription = '';
//   List examples = [];

//   // 🔹 10–15 sentence arrangement questions from API
//   List<Map<String, dynamic>> arrangeQuestions = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchGrammarRule();
//   }


//   Future<void> _fetchGrammarRule() async {
//     setState(() => loading = true);

//     try {
//       final data = await _aiService.fetchGrammarRuleWithExample();
// if (!mounted) return; // 🔥 ADD ONLY

//       // safely read data
//       final rawExamples = data['examples'];
//       final rawArrange = data['arrange_questions'];

//       setState(() {
//         ruleTitle = (data['title'] ?? 'Grammar Rule') as String;

//         ruleDescription =
//             (data['theory'] != null && data['theory'].toString().isNotEmpty)
//                 ? data['theory'].toString()
//                 : '';

//         examples = rawExamples is List ? rawExamples : [];

//         arrangeQuestions = (rawArrange is List)
//             ? rawArrange
//                 .whereType<Map<String, dynamic>>()
//                 .where((m) =>
//                     m['sentence'] is String &&
//                     (m['sentence'] as String).trim().isNotEmpty &&
//                     (m['meaning'] as String).trim().isNotEmpty &&

//                     m['words'] is List &&
//                     (m['words'] as List).isNotEmpty)
//                 .toList()
//             : [];

//         loading = false;
//       });



//        // Agar screen mounted hai tabhi bolna start karo
//     if (!mounted) return;

//     // 🔊 Yaha se "saara grammar rule" read karwana
//     final buffer = StringBuffer()
//       ..writeln(ruleTitle)
//       ..writeln(ruleDescription);

//     // Agar examples list me sentence / example stored hai to unko bhi add karo
//     for (final ex in examples.whereType<Map<String, dynamic>>()) {
//       final s = ex['sentence'] ?? ex['example'];
//       if (s is String && s.trim().isNotEmpty) {
//         buffer.writeln(s);
//       }
//     }

//     await _aiService.speakText(buffer.toString());
//     } catch (e) {
//       setState(() {
//         ruleTitle = 'Error';
//         ruleDescription = e.toString();
//         examples = [];
//         arrangeQuestions = [];
//         loading = false;
//       });

//       if (mounted) {
//         showResultSnackBar(
//           context,
//           "Failed to load grammar content. Please try again!",
//           false,
//         );
//       }
//     }
//   }



//   void _onPracticeNow() {
//     if (loading) {
//       showResultSnackBar(context, "Please wait, loading practice...", true);
//       return;
//     }

//     if (arrangeQuestions.isEmpty) {
//       showResultSnackBar(
//         context,
//         "No arrange sentences found. Try refreshing!",
//         false,
//       );
//       return;
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => GrammarArrangePracticeScreen(
//           ruleTitle: ruleTitle,
//           questions: arrangeQuestions,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GrammarRuleScreen.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: GrammarRuleScreen.backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: GrammarRuleScreen.accentColor,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Grammar Rule",
//           style: TextStyle(
//             color: GrammarRuleScreen.accentColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _fetchGrammarRule,
//             icon: const Icon(
//               Icons.refresh,
//               color: GrammarRuleScreen.accentColor,
//             ),
//           ),
//         ],
//       ),
//       body: loading
//           ? const Center(
//               child:
//                   CircularProgressIndicator(color: GrammarRuleScreen.accentColor),
//             )
//           : Column(
//               children: [
//                 // 🔹 Scrollable content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Cute teacher animation on top
                     

//                         // ✅ Grammar Rule Card
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: GrammarRuleScreen.cardFill,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: GrammarRuleScreen.accentColor,
//                               width: 1.5,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: GrammarRuleScreen.glowColor
//                                     .withOpacity(0.4),
//                                 blurRadius: 8,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Rule title + bookmark
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     ruleTitle,
//                                     style: const TextStyle(
//                                       color: GrammarRuleScreen.accentColor,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const Icon(
//                                     Icons.bookmark_border,
//                                     color: GrammarRuleScreen.accentColor,
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 12),

//                               // Description
//                               Text(
//                                 ruleDescription,
//                                 style: const TextStyle(
//                                   color: GrammarRuleScreen.textColor,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),

//                               // Examples
//                               if (examples.isNotEmpty)
//                                 RichText(
//                                   text: TextSpan(
//                                     style: const TextStyle(
//                                       color: GrammarRuleScreen.textColor,
//                                       fontSize: 14,
//                                     ),
//                                     children: [
//                                       const TextSpan(
//                                         text: "Example:\n\n",
//                                         style: TextStyle(
//                                           color: GrammarRuleScreen.accentColor,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       ...examples.map(
//                                         (e) => TextSpan(
//                                           text: "- $e\n",
//                                           style: const TextStyle(
//                                             color:
//                                                 GrammarRuleScreen.textColor,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // 🔹 Fixed bottom button (not inside scroll, so no RenderBox issue)
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _onPracticeNow,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           side: const BorderSide(
//                             color: GrammarRuleScreen.accentColor,
//                             width: 1.5,
//                           ),
//                         ),
//                         elevation: 8,
//                         shadowColor:
//                             GrammarRuleScreen.glowColor.withOpacity(0.6),
//                       ),
//                       child: const Text(
//                         "Practice Now",
//                         style: TextStyle(
//                           color: GrammarRuleScreen.accentColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
