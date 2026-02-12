import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart'; // ✅ Import routes

class TapTheImageScreen extends StatefulWidget {
  const TapTheImageScreen({super.key});

  @override
  State<TapTheImageScreen> createState() => _TapTheImageScreenState();
}

class _TapTheImageScreenState extends State<TapTheImageScreen> {
  int selectedIndex = -1; // Track selected image

  // Theme constants
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;

  // Example image assets (replace with your actual assets)
  final List<String> imagePaths = [
    "assets/images/apple.png", // ✅ correct answer
    "assets/images/tree.png",
    "assets/images/house.png",
    "assets/images/orange.png",
    "assets/images/carrot.png",
  ];

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
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Title
            const Text(
              "Tap the image\nfor ‘apple’.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Grid of images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: imagePaths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      // ✅ Navigate if correct image is selected
                      if (imagePaths[index].contains("apple")) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.puzzled);
                          // 👆 replace AppRoutes.nextScreen with your actual route
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? accentColor : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: glowColor.withOpacity(0.8),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
