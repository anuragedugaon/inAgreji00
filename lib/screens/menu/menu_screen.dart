import 'package:flutter/material.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors
    const Color backgroundColor = Colors.black;
    const Color borderColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color textColor = Colors.white;

    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 30);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: borderColor),
          onPressed: () => Navigator.pop(context, selectedTime),
        ),
        title: const Text(
          "Menu",
          style: TextStyle(color: borderColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: borderColor),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.noti);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: borderColor),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.sett);
            },
          ),
          IconButton(
            icon: const Icon(Icons.language, color: borderColor),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.prefer);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Grid of Menu Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(context, Icons.person, "Profile", Colors.blue,
                      routeName: AppRoutes.profile),
                  _buildMenuCard(context, Icons.help, "Help", Colors.green,
                      routeName: AppRoutes.help),
                  _buildMenuCard(
                      context, Icons.workspace_premium, "Premium", Colors.amber,
                      routeName: AppRoutes.go),
                  _buildMenuCard(
                      context, Icons.group_add, "Invite Friends", Colors.purple,
                      routeName: AppRoutes.invite),
                  // _buildMenuCard(
                  //     context, Icons.compare_arrows, "Plans", Colors.orange,
                  //     routeName: AppRoutes.compare),
                  _buildMenuCard(context, Icons.account_balance_wallet,
                      "Wallet", Colors.teal,
                      routeName: AppRoutes.wallet),

                  _buildMenuCard(
                    context,
                    Icons.privacy_tip,
                    "Privacy Policy",
                    Colors.cyan,
                    onTap: () => _launchExternalUrl(
                      "https://inangreji.in/privacy-policy",
                    ),
                  ),

                  _buildMenuCard(
                    context,
                    Icons.contact_support,
                    "Contact Us",
                    Colors.indigo,
                    onTap: () => _launchExternalUrl(
                      "https://inangreji.in/contact-us",
                    ),
                  ),

                  _buildMenuCard(
                    context,
                    Icons.description,
                    "Terms & Conditions",
                    Colors.orangeAccent,
                    routeName: AppRoutes.termsConditions,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menu Card Builder with colored icon background
  Widget _buildMenuCard(
      BuildContext context, IconData icon, String label, Color backgroundColor,
      {String? routeName, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
          return;
        }
        if (routeName != null) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyanAccent, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Custom BoxDecoration with glow
  BoxDecoration _boxDecoration(Color borderColor, Color glowColor) {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: borderColor, width: 1.5),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
