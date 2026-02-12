import 'package:flutter/material.dart';

class CustomizeAvatarScreen extends StatefulWidget {
  const CustomizeAvatarScreen({super.key});

  @override
  State<CustomizeAvatarScreen> createState() => _CustomizeAvatarScreenState();
}

class _CustomizeAvatarScreenState extends State<CustomizeAvatarScreen> {
  int selectedHair = 0; // track selected hair index

  // Theme colors
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;

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
        centerTitle: true,
        title: const Text(
          "Customise Your Avatar",
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 🧑 Avatar Preview Image
          const CircleAvatar(
            radius: 70,
            backgroundImage:
                AssetImage("assets/images/avatar.png"), // placeholder
          ),

          const SizedBox(height: 20),

          // Options: Hair, Skin, Accessories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _OptionIcon(icon: Icons.face_retouching_natural, label: "Hair"),
                _OptionIcon(icon: Icons.circle, label: "Skin"),
                _OptionIcon(icon: Icons.face, label: "Accessories"),
              ],
            ),
          ),

          const SizedBox(height: 25),

// Hair options (example only)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4, // Example: 4 hair styles
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedHair = index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedHair == index
                            ? accentColor
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade900,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                              "assets/images/avatar.png"), // placeholder
                        ),
                        const SizedBox(height: 5),
                        if (index == 0) // Show coin cost only for first option
                          Row(
                            mainAxisSize:
                                MainAxisSize.min, // ✅ Shrinks row to content
                            children: const [
                              Icon(Icons.monetization_on,
                                  color: Colors.orange, size: 10),
                              SizedBox(width: 4),
                              Text(
                                "230",
                                style:
                                    TextStyle(color: textColor, fontSize: 12),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          // Preview button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/tip');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: accentColor, width: 1.5),
                  ),
                  elevation: 8,
                  shadowColor: glowColor.withOpacity(0.6),
                ),
                child: const Text(
                  "Preview",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

/// Small reusable option icon widget
class _OptionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _OptionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 32),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
