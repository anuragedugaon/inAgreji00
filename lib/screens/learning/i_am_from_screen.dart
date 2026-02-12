import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

class IAmFromScreen extends StatefulWidget {
  
  const IAmFromScreen({super.key});

  @override
  State<IAmFromScreen> createState() => _IAmFromScreenState();
}

class _IAmFromScreenState extends State<IAmFromScreen> {
  final AIService _aiService = AIService();
  String? _city;

  @override
  void initState() {
    super.initState();
    _loadCity();
  }

  Future<void> _loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('user_city') ?? "your city";
    setState(() => _city = savedCity);

    // 🗣️ Speak localized greeting
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final greeting = appProvider.translate("city_greeting") == "city_greeting"
        ? "Oh, you're from $savedCity! That's wonderful!"
        : appProvider
            .translate("city_greeting")
            .replaceAll("{city}", savedCity);

    await _aiService.speakText(greeting);
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    const Color backgroundColor = Colors.black;
    const Color accentColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color textColor = Colors.white;
    const Color xpColor = Colors.cyanAccent;
    const Color coinColor = Colors.orangeAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
              const SizedBox(height: 20),

              /// 🧠 Localized “Great job!”
              Text(
                appProvider.translate("great_job") == "great_job"
                    ? "Great job!"
                    : appProvider.translate("great_job"),
                style: const TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// 🌍 Localized “I come from …”
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: appProvider.translate("i") == "i"
                          ? "I "
                          : appProvider.translate("i") + " ",
                      style: const TextStyle(color: textColor, fontSize: 20),
                    ),
                    TextSpan(
                      text: appProvider.translate("come_from") == "come_from"
                          ? "come from\n"
                          : appProvider.translate("come_from") + "\n",
                      style: const TextStyle(
                        color: accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: _city ?? 'Loading...',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              /// 🎖️ XP and Coins
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "+12 xp",
                    style: TextStyle(
                      color: xpColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 30),
                  Text(
                    "+3 ",
                    style: TextStyle(
                      color: coinColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.monetization_on, color: coinColor, size: 20),
                ],
              ),

              const SizedBox(height: 40),

              /// 🏠 Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final nextMsg = appProvider.translate("start_journey") ==
                            "start_journey"
                        ? "Let's go home and start your English journey!"
                        : appProvider.translate("start_journey");

                    await _aiService.speakText(
                      nextMsg,
                      onComplete: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(color: accentColor, width: 1.5),
                    ),
                    elevation: 6,
                    shadowColor: glowColor.withOpacity(0.6),
                  ),
                  child: Text(
                    appProvider.translate("continue") == "continue"
                        ? "Continue"
                        : appProvider.translate("continue"),
                    style: const TextStyle(
                      color: accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),
              const Text(
                "© InAngreji",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
