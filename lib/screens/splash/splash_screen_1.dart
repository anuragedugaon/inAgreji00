import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../../provider/payment_method/paymentProvider.dart';

const Color primaryColor = Color(0xFF00BFFF);
const Color backgroundColor = Colors.black;

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  final AIService _aiService = AIService(); // ✅ Use your existing AI voice
  final String _welcomeText =
      "Welcome to InAngreji! Let's begin your learning journey.";

  @override
  void initState() {
    super.initState();

    // 🗣️ Speak welcome message on splash start
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _aiService.speakText(
        _welcomeText,
        onComplete: () {
          // 🧭 Navigate automatically after speaking

          if (mounted) {
            checkLoginStatus(context);
            // Navigator.pushReplacementNamed(context, '/splash2');
          }
        },
      );
    });
  }


Future<void> checkLoginStatus(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
 final paymentProvider = context.read<PaymentProvider>();

                                  // Check subscription status from backend (best effort).
            final hasSubscription = await paymentProvider.checkSubscriptionStatus(context: context);


  final token =prefs.getString('auth_token');
  final languageCode = prefs.getString('selected_language_code');
  final languageName = prefs.getString('selected_language');
  final purpose = prefs.getString('selected_purpose');
  final level = prefs.getString('selected_level');
  final userCity = prefs.getString('user_city');
  
  final isLoggedIn = token != null && token.isNotEmpty;

  // Debug Logs
  debugPrint('👉 Token: $token');
  debugPrint('👉 Language Code: $languageCode');
  debugPrint('👉 Language Name: $languageName');
  debugPrint('👉 Purpose: $purpose');
  debugPrint('👉 Level: $level');
  debugPrint('👉 City: $userCity');

  debugPrint('👉 Is Logged In: $hasSubscription');
if(purpose == null || purpose.isEmpty){
  // 1) Language
    if (languageCode == null || languageName == null) 
 {
    Navigator.pushReplacementNamed(context, '/splash2');
    return;
  }
}

  // 2) Purpose
  if (purpose == null || purpose.isEmpty) {
    Navigator.pushReplacementNamed(context, '/purpose');
    return;
  }

  // 3) Level
  if (level == null || level.isEmpty) {
    Navigator.pushReplacementNamed(context, '/level');
    return;
  }

  // 4) City
  // if (userCity == null || userCity.isEmpty) {
  //   Navigator.pushReplacementNamed(context, '/myself');
  //   return;
  // }

  // 5) Login

          // Navigator.pushReplacementNamed(context, isLoggedIn ? (sub_active ?? false) ? '/home' : '/trial-start' : '/login');
          if (isLoggedIn) {
            if (hasSubscription != null && hasSubscription) {
              Navigator.pushReplacementNamed(context, '/home');
            } 
            else {
              Navigator.pushReplacementNamed(context, '/trial-start');
            }
          } else {
            Navigator.pushReplacementNamed(context, '/login');
          }

}




  @override
  void deactivate() {
    _aiService.stopSpeaking(); // ✅ stop if user navigates early
    super.deactivate();
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            /// --- Big Circular Image (App Logo) ---
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png', // 👈 your app logo path
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// --- App Name ---
            const Text(
              'InAngreji',
              style: TextStyle(
                color: primaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            /// --- Tagline ---
            const Text(
              'Learn with Fun',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 48),

            /// --- Progress Indicator (glowing blue) ---
            const CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    ),
  );
  }
}
