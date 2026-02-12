// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart';

// class RewardsScreen extends StatelessWidget {
//   const RewardsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Theme Colors
//     const Color backgroundColor = Colors.black;
//     const Color accentColor = Colors.cyanAccent;
//     const Color glowColor = Color(0xFF80FFFF);
//     const Color textColor = Colors.white;
//     const Color cardColor = Color(0xFF1C1C1E);
//     const Color coinColor = Colors.orange;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Rewards Store",
//           style: TextStyle(
//             color: accentColor,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // ✅ Grammar Pack Reward
//             _buildRewardCard(
//               icon: Icons.menu_book,
//               label: "Unlock Grammar Pack",
//               price: 500,
//               coinColor: coinColor,
//             ),
//             const SizedBox(height: 20),

//             // ✅ Avatar Reward
//             _buildRewardCard(
//               icon: Icons.person,
//               label: "New Avatar",
//               price: 250,
//               coinColor: coinColor,
//             ),
//           ],
//         ),
//       ),

//       // ✅ Bottom Navigation Bar
    
    
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: 0, // highlight current tab (set accordingly per screen)
//       //   onTap: (index) {
//       //     switch (index) {
//       //       case 0: // Home
//       //         Navigator.pushReplacementNamed(context, AppRoutes.home);
//       //         break;
//       //       // case 1: // store
//       //       //   Navigator.pushReplacementNamed(context, AppRoutes.challenge);
//       //       //   break;
//       //       case 1: // Tips
//       //         //Navigator.pushReplacementNamed(context, AppRoutes.rule);
//       //         break;
//       //       case 3: // Menu
//       //         //Navigator.pushReplacementNamed(context, AppRoutes.menu);
//       //         break;
//       //     }
//       //   },
//       //   backgroundColor: cardColor,
//       //   type: BottomNavigationBarType.fixed,
//       //   selectedItemColor: accentColor,
//       //   unselectedItemColor: Colors.white70,
//       //   items: const [
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.home),
//       //       label: "Home",
//       //     ),
//       //     // BottomNavigationBarItem(
//       //     //   icon: Icon(Icons.book),
//       //     //   label: "Store",
//       //     // ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.lightbulb),
//       //       label: "AI",
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.menu),
//       //       label: "Profile",
//       //     ),
//       //   ],
//       // ),
    
    
    
//     );
//   }

//   /// ✅ Reward Card Builder
//   Widget _buildRewardCard({
//     required IconData icon,
//     required String label,
//     required int price,
//     required Color coinColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.cyanAccent, width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.cyanAccent.withOpacity(0.4),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.cyanAccent, size: 40),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Icon(Icons.monetization_on, color: coinColor, size: 22),
//               const SizedBox(width: 4),
//               Text(
//                 "$price",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/provider/app_provider.dart';

import '../../models/reward_model.dart';




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  static const Color backgroundColor = Colors.black;
  static const Color accentColor = Colors.cyanAccent;
  static const Color glowColor = Color(0xFF80FFFF);
  static const Color textColor = Colors.white;
  static const Color cardColor = Color(0xFF1C1C1E);
  static const Color coinColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      appProvider.fetchReferralHistory();
      // (Optional) also fetch wallet balance here if you want:
      // appProvider.getWalletBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Referral Rewards",
          style: TextStyle(
            color: accentColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 🔝 Top: Total Reward Amount (coins / money)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Earned",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: coinColor,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appProvider.totalReferralReward.toStringAsFixed(2),
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main content: list / loader / error
            Expanded(
              child: _buildContent(appProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppProvider provider) {
    if (provider.referralsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: accentColor),
      );
    }

    if (provider.referralsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              provider.referralsError!,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: provider.fetchReferralHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (provider.referralHistory.isEmpty) {
      return const Center(
        child: Text(
          "No referral rewards yet.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.referralHistory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final referral = provider.referralHistory[index];
        return _buildReferralCard(referral: referral);
      },
    );
  }

  /// ✅ Referral Card: shows name, reward_amount, created_at (date)
  Widget _buildReferralCard({required ReferralEntry referral}) {
    final dateFormatted =
        DateFormat('dd MMM yyyy, hh:mm a').format(referral.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: user + date
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.cyanAccent,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👤 Name (e.g. "Arpit")
                      Text(
                        referral.referred.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 📧 Email (optional)
                      Text(
                        referral.referred.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 📅 Date (from created_at)
                      Text(
                        dateFormatted,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right: Reward amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: coinColor,
                    size: 22,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    referral.rewardAmount, // "50.00"
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                referral.status, // e.g. "completed"
                style: TextStyle(
                  color: referral.status.toLowerCase() == 'completed'
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



















// class RewardsScreen extends StatefulWidget {
//   const RewardsScreen({super.key});

//   @override
//   State<RewardsScreen> createState() => _RewardsScreenState();
// }

// class _RewardsScreenState extends State<RewardsScreen> {
//   static const Color backgroundColor = Colors.black;
//   static const Color accentColor = Colors.cyanAccent;
//   static const Color glowColor = Color(0xFF80FFFF);
//   static const Color textColor = Colors.white;
//   static const Color cardColor = Color(0xFF1C1C1E);
//   static const Color coinColor = Colors.orange;

//   @override
//   void initState() {
//     super.initState();
//     // Screen open hote hi local/mock rewards load
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final appProvider = context.read<AppProvider>();
//       appProvider.loadMockRewards();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appProvider = context.watch<AppProvider>();

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Rewards Store",
//           style: TextStyle(
//             color: accentColor,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // Top: user coins
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Your Coins",
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.monetization_on,
//                       color: coinColor,
//                       size: 22,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       appProvider.rewardCoins.toString(),
//                       style: const TextStyle(
//                         color: textColor,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Main content: list / loader / error
//             Expanded(
//               child: _buildContent(appProvider),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(AppProvider provider) {
//     if (provider.rewardsLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: accentColor),
//       );
//     }

//     if (provider.rewardsError != null) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               provider.rewardsError!,
//               style: const TextStyle(color: Colors.white70),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: provider.loadMockRewards,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: accentColor,
//               ),
//               child: const Text("Retry"),
//             ),
//           ],
//         ),
//       );
//     }

//     if (provider.rewards.isEmpty) {
//       return const Center(
//         child: Text(
//           "No rewards available yet.",
//           style: TextStyle(color: Colors.white70),
//         ),
//       );
//     }

//     return ListView.separated(
//       itemCount: provider.rewards.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 14),
//       itemBuilder: (context, index) {
//         final reward = provider.rewards[index];
//         return _buildRewardCard(
//           reward: reward,
//           coinColor: coinColor,
//         );
//       },
//     );
//   }

//   /// ✅ Reward Card (sirf details, NO redeem button)
//   Widget _buildRewardCard({
//     required RewardItem reward,
//     required Color coinColor,
//   }) {
//     IconData icon;

    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.cyanAccent, width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.cyanAccent.withOpacity(0.4),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//          Row(
//             children: [
//               Icon(Icons.person, color: Colors.cyanAccent, size: 40),
//           const SizedBox(width: 16),
        
           
//                 Text(
//                   reward.title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//             ],
//           ),
         
//           const SizedBox(width: 12),
//           Row(
//             children: [
//               Icon(
//                 Icons.monetization_on,
//                 color: coinColor,
//                 size: 22,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 "${reward.priceCoins}",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


