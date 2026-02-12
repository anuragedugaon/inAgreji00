// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:inangreji_flutter/provider/app_provider.dart';

// import '../../widgets/message_bubble.dart';

// class LanguagePreferenceScreen extends StatefulWidget {
//   const LanguagePreferenceScreen({super.key});

//   @override
//   State<LanguagePreferenceScreen> createState() =>
//       _LanguagePreferenceScreenState();
// }

// class _LanguagePreferenceScreenState extends State<LanguagePreferenceScreen> {
//   // Theme constants
//   static const Color backgroundColor = Colors.black;
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color glowColor = Color(0xFF80FFFF);
//   static const Color textColor = Colors.white;

//   int selectedIndex = -1;
//   List<dynamic> languages = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchLanguages();
//   }

//   Future<void> fetchLanguages() async {
//     final appProvider = Provider.of<AppProvider>(context, listen: false);
//     final result = await appProvider.getLanguages();

//     setState(() {
//       languages = result;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: accentColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: accentColor),
//               )
//             : Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // 🔹 Title
//                     const Text(
//                       "Language\nPreferences",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: accentColor,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 40),

//                     // 🔹 Language Options (from API)
//                     Expanded(
//                       child: RefreshIndicator(
//                         onRefresh: fetchLanguages,
//                         backgroundColor: accentColor,
//                         color: Colors.black,
//                         child: ListView.builder(
//                           itemCount: languages.length,
//                           itemBuilder: (context, index) {
//                             final lang = languages[index];
//                             final isSelected = selectedIndex == index;
//                             final langName = lang['name'] ?? 'Unknown';

//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 20),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedIndex = index;
//                                   });
//                                 },
//                                 child: Container(
//                                   width: double.infinity,
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 14),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? accentColor
//                                           : Colors.white54,
//                                       width: 1.5,
//                                     ),
//                                     color: isSelected
//                                         ? accentColor.withOpacity(0.1)
//                                         : Colors.transparent,
//                                     boxShadow: isSelected
//                                         ? [
//                                             BoxShadow(
//                                               color: glowColor.withOpacity(0.6),
//                                               blurRadius: 10,
//                                               spreadRadius: 1,
//                                             ),
//                                           ]
//                                         : [],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       langName,
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? accentColor
//                                             : textColor,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                     // 🔹 Confirm Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: selectedIndex == -1
//                             ? null
//                             : () {
//                                 final selectedLang =
//                                     languages[selectedIndex]['name'];
                               
//        showResultSnackBar(context,"You selected: $selectedLang",false);

//                                 // Example navigation
//                                 // Navigator.pushReplacementNamed(context, AppRoutes.home);
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: const BorderSide(
//                                 color: accentColor, width: 1.5),
//                           ),
//                           elevation: 8,
//                           shadowColor: glowColor.withOpacity(0.5),
//                         ),
//                         child: const Text(
//                           "Confirm",
//                           style: TextStyle(
//                             color: accentColor,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/message_bubble.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

import '../../widgets/message_bubble.dart';
import 'language_catalog.dart';

class LanguagePreferenceScreen extends StatefulWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  State<LanguagePreferenceScreen> createState() =>
      _LanguagePreferenceScreenState();
}

class _LanguagePreferenceScreenState extends State<LanguagePreferenceScreen> {
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;

  late final List<LanguageInfo> _allLanguages;
  List<LanguageInfo> _visibleLanguages = [];

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    // Load from LOCAL file same as first onboarding screen
    _allLanguages = List<LanguageInfo>.from(kWorldLanguages);
    _visibleLanguages = _allLanguages;

    // Current app language pre-select
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final currentCode = appProvider.locale.languageCode.toLowerCase();

    for (int i = 0; i < _allLanguages.length; i++) {
      if (_allLanguages[i].code.toLowerCase() == currentCode) {
        selectedIndex = i;
        break;
      }
    }

    setState(() {});
  }



  Future<void> _onConfirm() async {
    if (selectedIndex == -1) return;
  final prefs = await SharedPreferences.getInstance();

    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final selectedLang = _visibleLanguages[selectedIndex];

    final code = selectedLang.code.toLowerCase();

    final name = selectedLang.englishName;
            debugPrint("-========================lagauge code $name,$code");

 final effectiveUiCode = kUiSupportedLanguageCodes.contains(code)
        ? code
        : 'en';
    debugPrint("-========================lagauge code $name,$code");

     final selectedLangCode =
      prefs.setString('selected_language_code',code) ;
  final selectedLangName =
      prefs.setString('selected_language',name) ;


    await appProvider.changeLanguage(effectiveUiCode);

    showResultSnackBar(context, "Language updated to: $name", true);

    Navigator.pop(context); // Return to Settings
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: accentColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Language Preferences",
          style: TextStyle(color: accentColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Choose a language",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // Language List
            Expanded(
              child: ListView.builder(
                itemCount: _visibleLanguages.length,
                itemBuilder: (context, index) {
                  final lang = _visibleLanguages[index];
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? accentColor
                                : Colors.white54,
                            width: 1.5,
                          ),
                          color: isSelected
                              ? accentColor.withOpacity(0.1)
                              : Colors.transparent,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: glowColor.withOpacity(0.5),
                                    blurRadius: 8,
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            lang.nativeName,
                            style: TextStyle(
                              color: isSelected
                                  ? accentColor
                                  : textColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == -1 ? null : _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side:
                        const BorderSide(color: accentColor, width: 1.5),
                  ),
                  elevation: 6,
                  shadowColor: glowColor.withOpacity(0.5),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


