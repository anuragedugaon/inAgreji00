import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

class GrammarTipScreen extends StatefulWidget {
  const GrammarTipScreen({super.key});

  @override
  State<GrammarTipScreen> createState() => _GrammarTipScreenState();
}

class _GrammarTipScreenState extends State<GrammarTipScreen> {
  List<dynamic> grammarTips = [];

  @override
  void initState() {
    super.initState();
    _loadGrammarTips();
  }

  Future<void> _loadGrammarTips() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final tips = await provider.getGrammarTips();
    setState(() {
      grammarTips = tips;
    });
  }

  // --- Theme constants ---
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color highlightColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AppProvider>(context, listen: true).isLoading;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/lesson'); // ✅ go to lesson
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: accentColor),
            onPressed: () => Navigator.pushReplacementNamed(context, '/lesson'),
          ),
          title: const Text(
            "Grammar Tips",
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: accentColor)
              : grammarTips.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "No Grammar Tips available.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: grammarTips.length,
                      itemBuilder: (context, index) {
                        final tip = grammarTips[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: accentColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                tip['title'] ?? "Grammar Tip",
                                style: const TextStyle(
                                  color: accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tip['description'] ??
                                    "No description available.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/listen');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(
                                        color: accentColor, width: 1.5),
                                  ),
                                  elevation: 8,
                                  shadowColor: glowColor.withOpacity(0.6),
                                ),
                                child: const Text(
                                  "Got it!",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
