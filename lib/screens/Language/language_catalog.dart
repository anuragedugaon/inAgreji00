import 'package:flutter/foundation.dart';

@immutable
class LanguageInfo {
  final String code;        // e.g. en, hi, bn
  final String englishName; // English name
  final String nativeName;  // Name in its own script

  const LanguageInfo({
    required this.code,
    required this.englishName,
    required this.nativeName,
  });
}

/// ✅ UI translation JSON available languages only
/// (yahi codes appProvider.changeLanguage me use karna safe hai)
const Set<String> kUiSupportedLanguageCodes = <String>{
  'en', // English
  'hi', // Hindi
  'bn', // Bengali
  'ta', // Tamil
  'te', // Telugu
  'mr', // Marathi
  'gu', // Gujarati
  'ur', // Urdu
  'kn', // Kannada
  'or', // Odia
  'pa', // Punjabi
  'as', // Assamese
  'ml', // Malayalam
  'ne', // Nepali
  'sa', // Sanskrit
};

/// ✅ Only Indian Languages (as per your requirement)
const List<LanguageInfo> kWorldLanguages = <LanguageInfo>[
    LanguageInfo(code: 'en', englishName: 'English', nativeName: 'English'),

  LanguageInfo(code: 'hi', englishName: 'Hindi', nativeName: 'हिन्दी'),
  LanguageInfo(code: 'bn', englishName: 'Bengali', nativeName: 'বাংলা'),
  LanguageInfo(code: 'ta', englishName: 'Tamil', nativeName: 'தமிழ்'),
  LanguageInfo(code: 'te', englishName: 'Telugu', nativeName: 'తెలుగు'),
  LanguageInfo(code: 'mr', englishName: 'Marathi', nativeName: 'मराठी'),
  LanguageInfo(code: 'gu', englishName: 'Gujarati', nativeName: 'ગુજરાતી'),
  LanguageInfo(code: 'ur', englishName: 'Urdu', nativeName: 'اردو'),
  LanguageInfo(code: 'kn', englishName: 'Kannada', nativeName: 'ಕನ್ನಡ'),
  LanguageInfo(code: 'or', englishName: 'Odia', nativeName: 'ଓଡ଼ିଆ'),
  LanguageInfo(code: 'pa', englishName: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
  LanguageInfo(code: 'as', englishName: 'Assamese', nativeName: 'অসমীয়া'),
  LanguageInfo(code: 'ml', englishName: 'Malayalam', nativeName: 'മലയാളം'),
  LanguageInfo(code: 'ne', englishName: 'Nepali', nativeName: 'नेपाली'),

  // ✅ Extra Indian Languages you asked
  LanguageInfo(code: 'sd', englishName: 'Sindhi', nativeName: 'سنڌي'),
  LanguageInfo(code: 'ks', englishName: 'Kashmiri', nativeName: 'کٲشُر'),
  LanguageInfo(code: 'kok', englishName: 'Konkani', nativeName: 'कोंकणी'),
  LanguageInfo(code: 'mni', englishName: 'Manipuri (Meitei)', nativeName: 'মৈতৈলোন্'),
  LanguageInfo(code: 'brx', englishName: 'Bodo', nativeName: 'बड़ो'),
  LanguageInfo(code: 'doi', englishName: 'Dogri', nativeName: 'डोगरी'),
  LanguageInfo(code: 'mai', englishName: 'Maithili', nativeName: 'मैथिली'),
  LanguageInfo(code: 'sat', englishName: 'Santali', nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ'),
  LanguageInfo(code: 'sa', englishName: 'Sanskrit', nativeName: 'संस्कृतम्'),
];
