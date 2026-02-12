// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart';

// class InviteFriendsScreen extends StatelessWidget {
//   const InviteFriendsScreen({super.key});

//   // Theme Colors
//   static const Color kBackground = Colors.black;
//   static const Color kBorder = Colors.cyanAccent;
//   static const Color kGlow = Color(0xFF80FFFF);
//   static const Color kText = Colors.white;
//   static const Color kCardFill = Color(0xFF1C1C1E);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
//           onPressed: () {
//             Navigator.pop(context); // 👈 goes back to previous screen
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             children: [
//               const Spacer(),

//               // ✅ Heading
//               const Text(
//                 "Invite Friends\n& Earn",
//                 style: TextStyle(
//                   color: kBorder,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 30),

//               // ✅ Referral Code Card
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                 decoration: BoxDecoration(
//                   color: kCardFill,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: kBorder, width: 1.5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: kGlow.withOpacity(0.4),
//                       blurRadius: 12,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "INANGREJI50",
//                     style: TextStyle(
//                       color: kBorder,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // ✅ Earned Coins Section
//               Column(
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.monetization_on, color: kBorder, size: 26),
//                       SizedBox(width: 10),
//                       Text(
//                         "Earned coins",
//                         style: TextStyle(
//                           color: kText,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Spacer(),
//                       Text(
//                         "120",
//                         style: TextStyle(
//                           color: kBorder,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // Progress bar
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: LinearProgressIndicator(
//                       value: 0.6, // ✅ Example progress
//                       minHeight: 8,
//                       backgroundColor: Colors.white12,
//                       valueColor: const AlwaysStoppedAnimation<Color>(kBorder),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 40),

//               // ✅ Share Now Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacementNamed(context, '/simulate');
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: const BorderSide(color: kBorder, width: 1.5),
//                     ),
//                     elevation: 8,
//                     shadowColor: kGlow.withOpacity(0.6),
//                   ),
//                   child: const Text(
//                     "Share Now",
//                     style: TextStyle(
//                       color: kBorder,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const Spacer(),
//             ],
//           ),
//         ),
//       ),

//       // ✅ Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: kCardFill,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: kBorder,
//         unselectedItemColor: Colors.white70,
//         currentIndex: 3, // Profile highlighted
//         onTap: (index) {
//           switch (index) {
//             case 0: // Home
//               Navigator.pushReplacementNamed(context, AppRoutes.home);
//               break;
//             case 1: // learn
//               Navigator.pushReplacementNamed(context, AppRoutes.start);
//               break;
//             case 2: // track
//               Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
//               break;
//             case 3: // profile
//               Navigator.pushReplacementNamed(context, AppRoutes.profile);
//               break;
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.play_circle), label: "Learn"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.track_changes), label: "Track"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';

import '../../provider/app_provider.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({super.key});

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  UserDetailsModel? _userDetails;
  bool _loading = true;

  /// ✅ Referral code from API (fallback dashes)
  String get _referralCode =>
      _userDetails?.data?.referralCode?.toUpperCase() ?? '------';

  /// ✅ Wallet / Coins from API (fallback 0)
  String get _coins =>
      _userDetails?.data?.walletBalance?.toString() ?? '0';

  /// 🔊 Message that will be shared
String get _inviteMessage => """
🚀 Learn English Easily with InAngreji!  

I am improving my English speaking skills using the **InAngreji** app.  
It’s super fun — AI Teacher, daily lessons & easy practice! ✨  

🎯 Use my Referral Code during signup and we both earn **extra coins** inside the app 🎁  

🔐 Referral Code: $_referralCode  

👇 Download Now & Start Speaking English Confidently!  
📱 Play Store: https://play.google.com/store/apps/details?id=com.inangreji.app  
🍎 App Store: https://apps.apple.com/app/id00000000  

Let’s learn together! 😄✨  
""";


  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final appProvider = context.read<AppProvider>();
      final details = await appProvider.getUserDetails();

      if (!mounted) return;
      setState(() {
        _userDetails = details;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userDetails = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const Spacer(),

                    // Heading
                    const Text(
                      "Invite Friends\n& Earn",
                      style: TextStyle(
                        color: kBorder,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // Referral Code Card (from API now)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: kCardFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kBorder, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: kGlow.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _referralCode,
                          style: const TextStyle(
                            color: kBorder,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Earned Coins Section
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: kBorder, size: 26),
                            const SizedBox(width: 10),
                            const Text(
                              "Earned coins",
                              style: TextStyle(
                                color: kText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _coins, // <-- wallet_balance from API
                              style: const TextStyle(
                                color: kBorder,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress bar (still dummy for now)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 8,
                            backgroundColor: Colors.white12,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kBorder),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Share Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Share.share(
                            _inviteMessage,
                            subject: "Learn English with InAngreji",
                          );
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
                          "Share Now",
                          style: TextStyle(
                            color: kBorder,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart'; // <-- add this in pubspec.yaml
// import 'package:inangreji_flutter/routes/app_routes.dart';

// class InviteFriendsScreen extends StatelessWidget {
//   const InviteFriendsScreen({super.key});

//   // Theme Colors
//   static const Color kBackground = Colors.black;
//   static const Color kBorder = Colors.cyanAccent;
//   static const Color kGlow = Color(0xFF80FFFF);
//   static const Color kText = Colors.white;
//   static const Color kCardFill = Color(0xFF1C1C1E);

//   static const String referralCode = "INANGREJI50";

//   // 🔊 This is the message that will be shared
//   String get _inviteMessage => """
// Hi 👋,

// I am learning to speak English using the InAngreji app.  
// It has User-friendly explanations, practice exercises, and an AI teacher to help you speak confidently.

// Download the InAngreji app and use my referral code when you sign up:

// Referral Code: $referralCode

// When you use this code, both of us will earn extra coins inside the app. 🎁
// """;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             children: [
//               const Spacer(),

//               // Heading
//               const Text(
//                 "Invite Friends\n& Earn",
//                 style: TextStyle(
//                   color: kBorder,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   height: 1.4,
//                 ),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 30),

//               // Referral Code Card
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                 decoration: BoxDecoration(
//                   color: kCardFill,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: kBorder, width: 1.5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: kGlow.withOpacity(0.4),
//                       blurRadius: 12,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     referralCode,
//                     style: TextStyle(
//                       color: kBorder,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Earned Coins Section
//               Column(
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.monetization_on, color: kBorder, size: 26),
//                       SizedBox(width: 10),
//                       Text(
//                         "Earned coins",
//                         style: TextStyle(
//                           color: kText,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Spacer(),
//                       Text(
//                         "120", // Example value
//                         style: TextStyle(
//                           color: kBorder,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // Progress bar
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: const LinearProgressIndicator(
//                       value: 0.6, // Example progress
//                       minHeight: 8,
//                       backgroundColor: Colors.white12,
//                       valueColor:
//                           AlwaysStoppedAnimation<Color>(kBorder),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 40),

//               // Share Now Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Share.share(
//                       _inviteMessage,
//                       subject: "Learn English with InAngreji",
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: const BorderSide(color: kBorder, width: 1.5),
//                     ),
//                     elevation: 8,
//                     shadowColor: kGlow.withOpacity(0.6),
//                   ),
//                   child: const Text(
//                     "Share Now",
//                     style: TextStyle(
//                       color: kBorder,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const Spacer(),
//             ],
//           ),
//         ),
//       ),

//       // // Bottom Navigation Bar
//       // bottomNavigationBar: BottomNavigationBar(
//       //   backgroundColor: kCardFill,
//       //   type: BottomNavigationBarType.fixed,
//       //   selectedItemColor: kBorder,
//       //   unselectedItemColor: Colors.white70,
//       //   currentIndex: 3, // Profile highlighted
//       //   onTap: (index) {
//       //     switch (index) {
//       //       case 0: // Home
//       //         Navigator.pushReplacementNamed(context, AppRoutes.home);
//       //         break;
//       //       case 1: // Learn
//       //         Navigator.pushReplacementNamed(context, AppRoutes.start);
//       //         break;
//       //       case 2: // Track
//       //         Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
//       //         break;
//       //       case 3: // Profile
//       //         Navigator.pushReplacementNamed(context, AppRoutes.profile);
//       //         break;
//       //     }
//       //   },
//       //   items: const [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.play_circle), label: "Learn"),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.track_changes), label: "Track"),
//       //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       //   ],
//       // ),
//     );
//   }
// }
