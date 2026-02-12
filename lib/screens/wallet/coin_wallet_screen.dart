import 'package:flutter/material.dart';

class CoinWalletScreen extends StatelessWidget {
  const CoinWalletScreen({super.key});

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBorder),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Coin Wallet",
          style: TextStyle(
            color: kBorder,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // ✅ Coin Balance
            const Text(
              "15,200 +",
              style: TextStyle(
                color: kBorder,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // ✅ Wallet Options
            _buildWalletAction(
              icon: Icons.play_circle_fill,
              label: "Watch a video",
              trailing: Icons.monetization_on,
            ),
            const SizedBox(height: 16),
            _buildWalletAction(
              icon: Icons.group,
              label: "Refer a friend",
              trailing: Icons.monetization_on,
            ),
            const SizedBox(height: 16),
            _buildWalletAction(
              icon: Icons.check_circle,
              label: "Complete a lesson",
              trailing: Icons.monetization_on,
            ),

            const Spacer(),

            // ✅ Redeem Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Redeem action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: kBorder, width: 1.5),
                  ),
                  elevation: 8,
                  shadowColor: kGlow.withOpacity(0.6),
                ),
                child: const Text(
                  "Redeem",
                  style: TextStyle(
                    color: kBorder,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kCardFill,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kBorder,
        unselectedItemColor: Colors.white70,
        currentIndex: 2, // Wallet highlighted
        onTap: (index) {
          // TODO: Add navigation logic
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// ✅ Wallet Action Card
  static Widget _buildWalletAction({
    required IconData icon,
    required String label,
    required IconData trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: kBorder, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: kText, fontSize: 16),
            ),
          ),
          Icon(trailing, color: kBorder, size: 22),
        ],
      ),
    );
  }
}
