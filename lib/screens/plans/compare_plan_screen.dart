import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/payment_method/paymentProvider.dart';

class ComparePlansScreen extends StatelessWidget {
   ComparePlansScreen({super.key});

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<PaymentProvider>(context);

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
          "Compare Plans",
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
            // ✅ Plans Row
            Row(
              children: [
                // Free Plan
                Expanded(
                  child: _buildPlanCard(
                    title: "Free",
                    isHighlighted: false,
                  ),
                ),
                const SizedBox(width: 20),
                // Premium Plan
                Expanded(
                  child: _buildPlanCard(
                    title: "Premium",
                    isHighlighted: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ✅ Upgrade Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add upgrade functionality

    //                  provider.createSubscription(
    //   planId: "2", // ⚠️ Razorpay Dashboard se copy
    //   name: "User Name",
    //   email: "user@gmail.com",
    //   phone: "9876543210",
    //   totalCount: "12",
      
    // );
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
                  "Upgrade Now",
                  style: TextStyle(
                    color: kBorder,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kCardFill,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kBorder,
        unselectedItemColor: Colors.white70,
        currentIndex: 1, // Activity tab highlighted
        onTap: (index) {
          // TODO: Add navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// ✅ Builds a plan card
  static Widget _buildPlanCard({
    required String title,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted ? kBorder : Colors.white54,
          width: 1.5,
        ),
        boxShadow: isHighlighted
            ? [
          BoxShadow(
            color: kGlow.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isHighlighted ? kBorder : kText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildFeature("Unlimited Practice"),
          const SizedBox(height: 12),
          _buildFeature("Detailed Feedback"),
          const SizedBox(height: 12),
          _buildFeature("No Ads"),
        ],
      ),
    );
  }

  /// ✅ Feature row (with tick + text)
  static Widget _buildFeature(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: kBorder, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: kText, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
