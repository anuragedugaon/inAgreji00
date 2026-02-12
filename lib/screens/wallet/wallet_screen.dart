// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes//app_routes.dart'; // ✅ for navigation

// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Theme colors
//     const Color backgroundColor = Colors.black;
//     const Color cardColor = Colors.cyanAccent;
//     const Color glowColor = Color(0xFF80FFFF);
//     const Color textColor = Colors.black;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
//           onPressed: () {
//             Navigator.pop(context); // 👈 goes back to previous screen
//           },
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Wallet",
//           style: TextStyle(
//             color: cardColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ✅ Coin Wallet Card
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacementNamed(
//                     context, AppRoutes.coin); // route to CoinWalletScreen
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: glowColor.withOpacity(0.6),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: const Text(
//                   "Coin Wallet",
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ✅ Payment Method Card
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacementNamed(
//                     context, AppRoutes.payment); // route to PaymentMethodScreen
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: glowColor.withOpacity(0.6),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: const Text(
//                   "Payment Method",
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';

import 'payment_method_screen.dart';

// lib/screens/wallet/wallet_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:inangreji_flutter/models/wallet_balance_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  // Theme colors
  static const Color backgroundColor = Colors.black;
  static const Color cardColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color cardFill = Color(0xFF111317);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  WalletBalanceModel? _walletInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _loadWalletInfo();
  }

  Future<void> _loadWalletInfo() async {
    try {
      final appProvider = context.read<AppProvider>();
      final info = await appProvider.getWalletBalance();

      if (!mounted) return;

      setState(() {
        _walletInfo = info;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _walletInfo = null;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = _walletInfo;
    final double rupees = wallet?.walletBalance ?? 0;
    final double earnedCoins = wallet?.earnedCoins ?? 0;
    final double withdrawableCoins = wallet?.withdrawableCoins ?? 0;
    final double pending = wallet?.pendingWithdrawals ?? 0;
    final double totalWithdrawn = wallet?.totalWithdrawn ?? 0;
    final double available = wallet?.availableForWithdrawal ?? 0;
    final int minWithdrawal = wallet?.minWithdrawal ?? 0;
    final double maxWithdrawal = wallet?.maxWithdrawal ?? 0;
    final int conversion = wallet?.conversionRate ?? 1;

    return Scaffold(
      backgroundColor: WalletScreen.backgroundColor,
      appBar: AppBar(
        backgroundColor: WalletScreen.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: WalletScreen.cardColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: WalletScreen.cardColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;

          return Stack(
            children: [
              _buildAnimatedBackground(t),

              if (_loading)
                const Center(
                  child: CircularProgressIndicator(
                    color: WalletScreen.cardColor,
                  ),
                )
              else if (wallet == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Failed to load wallet details.",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadWalletInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WalletScreen.cardColor,
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                )
              else
                RefreshIndicator(
                  onRefresh: _loadWalletInfo,
                  backgroundColor: WalletScreen.cardColor,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // 💰 Wallet summary card
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.9, end: 1.0),
                          duration:
                              const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: _buildWalletSummary(
                            rupees: rupees,
                            earnedCoins: earnedCoins,
                            conversion: conversion,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 📊 Details cards
                        _buildDetailsGrid(
                          withdrawableCoins: withdrawableCoins,
                          pending: pending,
                          totalWithdrawn: totalWithdrawn,
                          available: available,
                          minWithdrawal: minWithdrawal,
                          maxWithdrawal: maxWithdrawal,
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "You earn coins from invites and rewards.\nConvert them into real money and withdraw to your bank account.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        // Withdraw button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                             rupees <= 0
                                ? null
                                :
                                 () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.payment,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.white12,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: WalletScreen.cardColor,
                                  width: 1.5,
                                ),
                              ),
                              elevation: 10,
                              shadowColor: WalletScreen.glowColor
                                  .withOpacity(0.6),
                            ),
                            child: Text(
                              rupees <= 0
                                  ? "No coins to withdraw"
                                  : 
                                  
                                  "Withdraw ₹${rupees.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: WalletScreen.cardColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Invite more friends to earn extra coins and rewards.",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// 🌈 Animated background with gradient + moving glow circles
  Widget _buildAnimatedBackground(double t) {
    final Color topColor = Color.lerp(
          const Color(0xFF000000),
          const Color(0xFF02101F),
          t,
        ) ??
        Colors.black;

    final Color bottomColor = Color.lerp(
          const Color(0xFF050A18),
          const Color(0xFF001B2E),
          1 - t,
        ) ??
        Colors.black;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topColor, bottomColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120 + 40 * t,
            left: -80 + 20 * t,
            child: _glowCircle(
                220, WalletScreen.glowColor.withOpacity(0.25)),
          ),
          Positioned(
            bottom: -140 + 30 * (1 - t),
            right: -100 + 20 * (1 - t),
            child: _glowCircle(
                260, WalletScreen.glowColor.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  /// 💰 Top summary card: shows wallet balance + earned coins
  Widget _buildWalletSummary({
    required double rupees,
    required double earnedCoins,
    required int conversion,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: WalletScreen.cardFill.withOpacity(0.95),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: WalletScreen.cardColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: WalletScreen.glowColor.withOpacity(0.5),
            blurRadius: 22,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: WalletScreen.cardColor, width: 1.6),
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: WalletScreen.cardColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Coin Balance",
                  style: TextStyle(
                    color: WalletScreen.textColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${earnedCoins.toStringAsFixed(0)} coins",
                  style: const TextStyle(
                    color: WalletScreen.cardColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Conversion: $conversion coin = ₹1",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Wallet balance",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "₹${rupees.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: WalletScreen.cardColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 Detail cards grid (Withdrawable, Pending, etc.)
  Widget _buildDetailsGrid({
    required double withdrawableCoins,
    required double pending,
    required double totalWithdrawn,
    required double available,
    required int minWithdrawal,
    required double maxWithdrawal,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _smallStatCard(
                title: "Withdrawable",
                value: "${withdrawableCoins.toStringAsFixed(0)}",
                subtitle: "Coins ready to withdraw",
                icon: Icons.download_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallStatCard(
                title: "Pending",
                value: "${pending.toStringAsFixed(0)}",
                subtitle: "Under review",
                icon: Icons.hourglass_top_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _smallStatCard(
                title: "Total Withdrawn",
                value: "${totalWithdrawn.toStringAsFixed(0)}",
                subtitle: "Coins cashed out",
                icon: Icons.outbox_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallStatCard(
                title: "Available",
                value: "${available.toStringAsFixed(0)}",
                subtitle: "Eligible coins",
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _smallStatCard(
                title: "Min Withdraw",
                value: "$minWithdrawal",
                subtitle: "Min coins required",
                icon: Icons.vertical_align_bottom_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallStatCard(
                title: "Max Withdraw",
                value: "${maxWithdrawal.toStringAsFixed(0)}",
                subtitle: "Per request limit",
                icon: Icons.vertical_align_top_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WalletScreen.cardFill.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: WalletScreen.cardColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: WalletScreen.glowColor.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: WalletScreen.cardColor, width: 1.2),
            ),
            child: Icon(
              icon,
              color: WalletScreen.cardColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: WalletScreen.textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: WalletScreen.cardColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

