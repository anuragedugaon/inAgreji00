// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:inangreji_flutter/screens/premium/plan_details.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart';
// import '../../provider/payment_method/paymentProvider.dart';

// /// Go Premium screen for Inangreji
// class GoPremiumScreen extends StatefulWidget {
//   const GoPremiumScreen({super.key});

//   // Named colors
//   static const Color kBackground = Colors.black;
//   static const Color kBorder = Colors.cyanAccent;
//   static const Color kGlow = Color(0xFF80FFFF);
//   static const Color kCardFill = Color(0xFF0F0F10);
//   static const Color kText = Colors.white;

//   @override
//   State<GoPremiumScreen> createState() => _GoPremiumScreenState();
// }

// class _GoPremiumScreenState extends State<GoPremiumScreen> {
//   late Future<bool> _subFuture;

//   @override
//   void initState() {
//     super.initState();
//     _subFuture = _checkSub();
//   }

//   Future<bool> _checkSub() async {
//     final provider = context.read<PaymentProvider>();
//     return provider.checkSubscriptionStatus();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GoPremiumScreen.kBackground,
//       appBar: AppBar(
//         backgroundColor: GoPremiumScreen.kBackground,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: GoPremiumScreen.kBorder),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         centerTitle: true,
//         title: ShaderMask(
//           shaderCallback: (bounds) => const LinearGradient(
//             colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ).createShader(bounds),
//           child: const Text(
//             'Go Premium',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w800,
//               fontSize: 20,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Animated gradient / circles background
//             _buildBackgroundDecor(),
//             FutureBuilder<bool>(
//               future: _subFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         GoPremiumScreen.kBorder,
//                       ),
//                     ),
//                   );
//                 }

//                 final isSubscribed = snapshot.data ?? false;
//                 if (isSubscribed) {
//                   return _buildSubscribedContent(context);
//                 } else {
//                   return _buildNotSubscribedContent(context);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------- BACKGROUND DECOR ----------------

//   Widget _buildBackgroundDecor() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.black, Color(0xFF020B1A)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             top: -80,
//             left: -40,
//             child: Container(
//               width: 220,
//               height: 220,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     GoPremiumScreen.kGlow.withOpacity(0.24),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -80,
//             right: -60,
//             child: Container(
//               width: 260,
//               height: 260,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: RadialGradient(
//                   colors: [
//                     GoPremiumScreen.kGlow.withOpacity(0.18),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- SUBSCRIBED UI ----------------

//   Widget _buildSubscribedContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Premium chip
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: GoPremiumScreen.kBorder.withOpacity(0.7),
//                 width: 1.2,
//               ),
//               color: GoPremiumScreen.kCardFill.withOpacity(0.6),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: const [
//                 Icon(Icons.star, size: 16, color: Colors.amber),
//                 SizedBox(width: 6),
//                 Text(
//                   "Premium Active",
//                   style: TextStyle(
//                     color: GoPremiumScreen.kText,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 18),

//           // Animated premium hero card
//           TweenAnimationBuilder<double>(
//             duration: const Duration(milliseconds: 800),
//             curve: Curves.easeOutBack,
//             tween: Tween(begin: 0.85, end: 1.0),
//             builder: (context, value, child) {
//               return Transform.scale(scale: value, child: child);
//             },
//             child: _premiumActiveCard(),
//           ),

//           const SizedBox(height: 24),

//           const Text(
//             "Your premium subscription is active.\nEnjoy full access to all lessons, AI tools and more.",
//             style: TextStyle(
//               color: GoPremiumScreen.kText,
//               fontSize: 14,
//               height: 1.5,
//             ),
//           ),

//           const SizedBox(height: 20),

//           _subPerkTile(Icons.workspace_premium, "All premium lessons unlocked"),
//           const SizedBox(height: 10),
//           _subPerkTile(Icons.mic_none_rounded, "Unlimited AI speaking practice"),
//           const SizedBox(height: 10),
//           _subPerkTile(Icons.bolt, "Faster progress tracking & reports"),

//           const Spacer(),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   AppRoutes.home,
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: const BorderSide(
//                     color: GoPremiumScreen.kBorder,
//                     width: 1.5,
//                   ),
//                 ),
//                 elevation: 10,
//                 shadowColor: GoPremiumScreen.kGlow.withOpacity(0.6),
//               ),
//               child: const Text(
//                 "Start Learning",
//                 style: TextStyle(
//                   color: GoPremiumScreen.kBorder,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _premiumActiveCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: GoPremiumScreen.kGlow.withOpacity(0.7),
//             blurRadius: 26,
//             spreadRadius: 4,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 58,
//             height: 58,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.4),
//             ),
//             child: const Icon(
//               Icons.workspace_premium,
//               color: Colors.white,
//               size: 32,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ShaderMask(
//             shaderCallback: (bounds) => const LinearGradient(
//               colors: [Colors.white, Color(0xFFE0FFFF)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ).createShader(bounds),
//             child: const Text(
//               "You're Premium!",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             "Thank you for upgrading to InAngreji Premium.",
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _subPerkTile(IconData icon, String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//       decoration: BoxDecoration(
//         color: GoPremiumScreen.kCardFill.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: GoPremiumScreen.kBorder.withOpacity(0.7),
//           width: 1.1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: GoPremiumScreen.kGlow.withOpacity(0.25),
//             blurRadius: 12,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: GoPremiumScreen.kBorder, size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(
//                 color: GoPremiumScreen.kText,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------- NOT SUBSCRIBED UI ----------------

//   Widget _buildNotSubscribedContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Upgrade badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: GoPremiumScreen.kBorder.withOpacity(0.7),
//                 width: 1.2,
//               ),
//               color: GoPremiumScreen.kCardFill.withOpacity(0.7),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: const [
//                 Icon(Icons.lock_open_rounded,
//                     size: 16, color: GoPremiumScreen.kBorder),
//                 SizedBox(width: 6),
//                 Text(
//                   "Upgrade to Premium",
//                   style: TextStyle(
//                     color: GoPremiumScreen.kText,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 18),

//           // Hero card
//           _heroCard(context),

//           const SizedBox(height: 24),

//           const Text(
//             "What you’ll get",
//             style: TextStyle(
//               color: GoPremiumScreen.kText,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 14),

//           _featureCardRow(
//             Icons.check_circle_outline,
//             "Unlimited practice sessions without daily limits",
//           ),
//           const SizedBox(height: 10),
//           _featureCardRow(
//             Icons.rate_review_outlined,
//             "Detailed AI feedback on your speaking",
//           ),
//           const SizedBox(height: 10),
//           _featureCardRow(
//             Icons.block,
//             "100% ad-free learning experience",
//           ),

//           const Spacer(),

//           // Highlight starting price text (static hint)
//           // const Align(
//           //   alignment: Alignment.centerLeft,
//           //   child: Text(
//           //     "Premium starting from just ₹249/month",
//           //     style: TextStyle(
//           //       color: Colors.white60,
//           //       fontSize: 13,
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(height: 10),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const PlansScreen(),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: const BorderSide(
//                     color: GoPremiumScreen.kBorder,
//                     width: 1.5,
//                   ),
//                 ),
//                 elevation: 10,
//                 shadowColor: GoPremiumScreen.kGlow.withOpacity(0.6),
//               ),
//               child: const Text(
//                 "See Plans",
//                 style: TextStyle(
//                   color: GoPremiumScreen.kBorder,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Large top card that visually emphasizes "Go Premium"
//   Widget _heroCard(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
//       decoration: BoxDecoration(
//         color: GoPremiumScreen.kCardFill.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: GoPremiumScreen.kBorder, width: 1.3),
//         boxShadow: [
//           BoxShadow(
//             color: GoPremiumScreen.kGlow.withOpacity(0.4),
//             blurRadius: 18,
//             spreadRadius: 2,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: const [
//           Icon(
//             Icons.rocket_launch_rounded,
//             color: GoPremiumScreen.kBorder,
//             size: 32,
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Go Premium',
//             style: TextStyle(
//               color: GoPremiumScreen.kBorder,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Unlock full InAngreji access – unlimited practice, AI guidance, and distraction-free learning.',
//             style: TextStyle(
//               color: GoPremiumScreen.kText,
//               fontSize: 14,
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   /// A single feature row styled as a card (icon on left, text on right)
//   Widget _featureCardRow(IconData icon, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all( 
//           color: GoPremiumScreen.kBorder.withOpacity(0.9),
//           width: 1.2,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: GoPremiumScreen.kGlow.withOpacity(0.25),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.transparent,
//               border: Border.all(
//                 color: GoPremiumScreen.kBorder,
//                 width: 1.2,
//               ),
//             ),
//             child: Icon(icon, color: GoPremiumScreen.kBorder, size: 20),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: GoPremiumScreen.kText,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           const Icon(
//             Icons.arrow_forward_ios,
//             color: GoPremiumScreen.kBorder,
//             size: 16,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/screens/premium/plan_details.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import '../../provider/payment_method/paymentProvider.dart';

/// Go Premium screen for Inangreji
class GoPremiumScreen extends StatefulWidget {
  const GoPremiumScreen({super.key});

  // Named colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kCardFill = Color(0xFF14161C);
  static const Color kText = Colors.white;

  @override
  State<GoPremiumScreen> createState() => _GoPremiumScreenState();
}

class _GoPremiumScreenState extends State<GoPremiumScreen> {
  late Future<bool> _subFuture;

  @override
  void initState() {
    super.initState();
    _subFuture = _checkSub();
  }

  Future<bool> _checkSub() async {
    final provider = context.read<PaymentProvider>();
    return provider.checkSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoPremiumScreen.kBackground,
      appBar: AppBar(
        backgroundColor: GoPremiumScreen.kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: GoPremiumScreen.kBorder),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            'Go Premium',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundDecor(),
            FutureBuilder<bool>(
              future: _subFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        GoPremiumScreen.kBorder,
                      ),
                    ),
                  );
                }

                final isSubscribed = snapshot.data ?? false;
                if (isSubscribed) {
                  return _buildSubscribedContent(context);
                } else {
                  return _buildNotSubscribedContent(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BACKGROUND DECOR ----------------

  Widget _buildBackgroundDecor() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFF020816)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GoPremiumScreen.kGlow.withOpacity(0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GoPremiumScreen.kGlow.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SUBSCRIBED UI ----------------

  Widget _buildSubscribedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: GoPremiumScreen.kBorder.withOpacity(0.8),
                width: 1.2,
              ),
              color: GoPremiumScreen.kCardFill.withOpacity(0.9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.star, size: 18, color: Colors.amber),
                SizedBox(width: 6),
                Text(
                  "Premium Active",
                  style: TextStyle(
                    color: GoPremiumScreen.kText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            tween: Tween(begin: 0.88, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: _premiumActiveCard(),
          ),

          const SizedBox(height: 24),

          const Text(
            "Your premium subscription is active.\nEnjoy full access to all lessons, AI tools and more.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          _sectionDivider("Benefits included"),

          const SizedBox(height: 10),

          _subPerkTile(Icons.workspace_premium, "All premium lessons unlocked"),
          const SizedBox(height: 10),
          _subPerkTile(Icons.mic_none_rounded, "Unlimited AI speaking practice"),
          const SizedBox(height: 10),
          _subPerkTile(Icons.bolt, "Faster progress tracking & reports"),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: GoPremiumScreen.kBorder,
                    width: 1.6,
                  ),
                ),
                elevation: 12,
                shadowColor: GoPremiumScreen.kGlow.withOpacity(0.7),
              ),
              child: const Text(
                "Start Learning",
                style: TextStyle(
                  color: GoPremiumScreen.kBorder,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumActiveCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: GoPremiumScreen.kGlow.withOpacity(0.8),
            blurRadius: 26,
            spreadRadius: 4,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.4),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "You're Premium!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Thank you for upgrading to InAngreji Premium.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _subPerkTile(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
      decoration: BoxDecoration(
        color: GoPremiumScreen.kCardFill.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GoPremiumScreen.kBorder.withOpacity(0.8),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: GoPremiumScreen.kGlow.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: GoPremiumScreen.kBorder, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: GoPremiumScreen.kText,
                fontSize: 15.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- NOT SUBSCRIBED UI ----------------

  Widget _buildNotSubscribedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upgrade chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: GoPremiumScreen.kBorder.withOpacity(0.9),
                width: 1.2,
              ),
              color: GoPremiumScreen.kCardFill.withOpacity(0.9),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.lock_open_rounded,
                    size: 18, color: GoPremiumScreen.kBorder),
                SizedBox(width: 6),
                Text(
                  "Upgrade to Premium",
                  style: TextStyle(
                    color: GoPremiumScreen.kText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          _heroCard(context),

          const SizedBox(height: 22),

          _sectionDivider("What you’ll get"),

          const SizedBox(height: 14),

          _featureCardRow(
            Icons.check_circle_outline,
            "Unlimited practice sessions without daily limits.",
          ),
          const SizedBox(height: 10),
          _featureCardRow(
            Icons.rate_review_outlined,
            "Detailed AI feedback on your speaking and writing.",
          ),
          const SizedBox(height: 10),
          _featureCardRow(
            Icons.block,
            "100% ad-free learning experience.",
          ),

          const Spacer(),

          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Premium starting from just ₹249/month",
          //     style: TextStyle(
          //       color: Colors.white70,
          //       fontSize: 13.5,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlansScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: GoPremiumScreen.kBorder,
                    width: 1.6,
                  ),
                ),
                elevation: 12,
                shadowColor: GoPremiumScreen.kGlow.withOpacity(0.7),
              ),
              child: const Text(
                "See Plans",
                style: TextStyle(
                  color: GoPremiumScreen.kBorder,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section headline + small glowing line
  Widget _sectionDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: GoPremiumScreen.kText,
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
            ),
            boxShadow: [
              BoxShadow(
                color: GoPremiumScreen.kGlow.withOpacity(0.7),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Large top card for non-subscribed view
  Widget _heroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: GoPremiumScreen.kCardFill.withOpacity(0.98),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GoPremiumScreen.kBorder,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: GoPremiumScreen.kGlow.withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 3,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(
            Icons.rocket_launch_rounded,
            color: GoPremiumScreen.kBorder,
            size: 34,
          ),
          SizedBox(height: 10),
          Text(
            'Go Premium',
            style: TextStyle(
              color: GoPremiumScreen.kBorder,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Unlock full InAngreji access – unlimited practice, AI guidance, and distraction-free learning.',
            style: TextStyle(
              color: GoPremiumScreen.kText,
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Single feature row
  Widget _featureCardRow(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: GoPremiumScreen.kCardFill.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GoPremiumScreen.kBorder.withOpacity(0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: GoPremiumScreen.kGlow.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: GoPremiumScreen.kBorder,
                width: 1.2,
              ),
            ),
            child: Icon(icon, color: GoPremiumScreen.kBorder, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: GoPremiumScreen.kText,
                fontSize: 15.5,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: GoPremiumScreen.kBorder,
            size: 16,
          ),
        ],
      ),
    );
  }
}
