// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:lottie/lottie.dart';

// import '../../models/razerPay_plane_model.dart';
// import '../../provider/payment_method/paymentProvider.dart';

// // Theme constants matching the app's cyan + black design
// const Color appPrimary = Color(0xFF00BFFF);  // cyan accent
// const Color appBackground = Color(0xFF0A0A0A);  // black
// const Color cardBg = Color(0xFF0F0F0F);  // dark card
// const Color textPrimary = Colors.white;
// const Color textSecondary = Colors.white70;
// const Color appGlow = Color(0xFF80FFFF);  // glow highlight (matches app theme)

// /// Trial / Subscribe screen with sticky CTA and benefits.
// class TrialStartScreen extends StatefulWidget {
//   const TrialStartScreen({super.key});

//   @override
//   State<TrialStartScreen> createState() => _TrialStartScreenState();
// }

// class _TrialStartScreenState extends State<TrialStartScreen> with TickerProviderStateMixin {
//   late final AnimationController _pulseController;
//   final razorpayService = RazorpaySubscriptionService();

//   @override
//   void initState() {
//         razorpayService.initRazorpay();
//           loadPlans();


//     super.initState();
//     _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//         razorpayService.dispose();

//     _pulseController.dispose();
//     super.dispose();
//   }
//    var monthlyPlan;
//      var trialPlan;

//   RazorpayPlansResponse? plans;

// Future<void> loadPlans() async {
//       final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

//   plans = await paymentProvider.getPlans();
//   if (plans != null) {
//     print("Total plans: ${plans!.count}");

//      // Find trial plan (7 days)
//    trialPlan = plans?.items?.firstWhere(
//     (p) => p.period == 'daily' && p.interval == 7,
//     orElse: () => plans!.items!.first,
//   );

//   // Find monthly plan
//   final monthlyPlan = plans?.items?.firstWhere(
//     (p) => p.period == 'monthly' && p.interval == 1,
//     orElse: () => plans!.items!.last,
//   );

//   }
// }

  // Future<void> startSubscription() async {
  //   razorpayService.setContext(context); // Pass context for navigation after payment success
  //   String? subscriptionId = await razorpayService.createSubscription();

  //   if (subscriptionId != null) {
  //     razorpayService.openCheckout(subscriptionId);
  //   } else {
  //     print("Failed to create subscription");
  //   }
  // }
//   // void _startTrial() async {
//   //   final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
//   //   // Placeholder plan id, replace with real id from backend
//   //   await paymentProvider.createSubscription(
//   //     planId: 'plan_Rnv0Sw9IY91m5b',
//   //     name: 'User',
//   //     email: 'trial@inangreji.in',
//   //     phone: '0000000000',
//   //     totalCount: '1',
//   //     context: context,
//   //   );
//   // }




//   void _subscribeNow() async {
//     final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
//     // Placeholder paid plan id
//     await paymentProvider.createSubscription(
//       planId: 'plan_RnvlUeZSzfwAHK',
//       name: 'User',
//       email: 'user@inangreji.in',
//       phone: '0000000000',
//       totalCount: '1',
//       context: context,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     return Scaffold(
//       backgroundColor: appBackground,
//       body: WillPopScope(
//         onWillPop: () async {
//           // Close app instead of going back
//           SystemNavigator.pop();
//           return false;
//         },
//         child: Stack(
//           children: [
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 120),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Top bar with gradient accent
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               // Close app instead of going back
//                               SystemNavigator.pop();
//                             },
//                             icon: const Icon(Icons.arrow_back_ios, color: appPrimary),
//                           ),
//                           const Spacer(),
//                           // Razorpay badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(colors: [Color(0xFF1B4B8E), Color(0xFF2B5FB8)]),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Text('Powered by ', style: TextStyle(color: Colors.white, fontSize: 11)),
//                                 Text('Razorpay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
        
//                     // Hero animation (if present)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SizedBox(
//                         height: 180,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
        
//                     const SizedBox(height: 25),
        
//                     // Price Card with gradient border
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: appPrimary.withOpacity(0.3), width: 1),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: appPrimary.withOpacity(0.15),
//                               blurRadius: 12,
//                               spreadRadius: 2,
//                             )
//                           ],
//                         ),

//                         child: Card(
//                           color: cardBg,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                           elevation: 0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text('Unlock 7 Days Premium for', style: TextStyle(color: textSecondary, fontSize: 14)),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     const Text('₹', style: TextStyle(color: appGlow, fontSize: 26, fontWeight: FontWeight.w700)),
//                                     const SizedBox(width: 8),
//                                     Text('2', style: TextStyle(color: appGlow, fontSize: 64, fontWeight: FontWeight.bold)),
//                                     const SizedBox(width: 16),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: const [
//                                         Text('Then ₹299/month', style: TextStyle(color: textSecondary, fontSize: 13)),
//                                         SizedBox(height: 6),
//                                         Text('Cancel anytime', style: TextStyle(color: Colors.white38, fontSize: 11)),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 // 80% OFF badge
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(colors: [appGlow, Color(0xFFFFA500)]),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: const Text('🎉 80% OFF for first 7 days', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
                    
                    
//                       ),
//                     ),
        
//                     const SizedBox(height: 12),
        
//                     // Benefits
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         children: [
//                           _BenefitCardWithHighlight(
//                             highlightText: '24x7 AI Teacher',
//                             normalText: 'that gives instant feedback',
//                             icon: Icons.headset,
//                           ),
//                           const SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: '100+ Real life',
//                             normalText: 'speaking scenario practice',
//                             icon: Icons.group,
//                           ),
//                           const SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: 'Personalized lessons',
//                             normalText: '& progress tracking',
//                             icon: Icons.show_chart,
//                           ),
//                         ],
//                       ),
//                     ),
        
//                     const SizedBox(height: 14),
        
//                     // How trial works
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Card(
//                         color: cardBg,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('HOW TRIAL WORKS?', style: TextStyle(color: appGlow, fontWeight: FontWeight.bold, fontSize: 13)),
//                                 const SizedBox(height: 12),
//                                 const _HowStep(number: '1', title: 'Start trial by paying ₹2', subtitle: 'Get access to all premium features today'),
//                                 const SizedBox(height: 8),
//                                 const _HowStep(number: '2', title: 'Get Unlimited talktime with AI', subtitle: 'Available 24x7. No fear. No judgment'),
//                                 const SizedBox(height: 8),
//                                 const _HowStep(number: '3', title: 'Then ₹299/month', subtitle: 'After 7 days, plan auto-renews every month'),
//                               ],
//                             ),
//                         ),
//                       ),
//                     ),
        
//                     const SizedBox(height: 18),
        
//                     // After trial info
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: cardBg,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: appGlow.withOpacity(0.2), width: 1),
//                         ),
//                         child: const Text(
//                           'After trial, plan auto-renews for ₹299 every month',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: textSecondary, fontSize: 12),
//                         ),
//                       ),
//                     ),
        
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
        
//             // Sticky bottom CTA with Razorpay logo and pulsing button
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: appBackground,
//                   border: Border(
//                     top: BorderSide(color: appGlow.withOpacity(0.3), width: 1),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: appGlow.withOpacity(0.15),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     )
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: SafeArea(
//                   top: false,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Progress indicator line
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: LinearProgressIndicator(
//                           value: 0.3,
//                           backgroundColor: Colors.white10,
//                           valueColor: const AlwaysStoppedAnimation<Color>(appGlow),
//                           minHeight: 3,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           // // Razorpay logo in circle
//                           // Container(
//                           //   width: 50,
//                           //   height: 50,
//                           //   decoration: BoxDecoration(
//                           //     gradient: const LinearGradient(
//                           //       colors: [Color(0xFF1B4B8E), Color(0xFF2B5FB8)],
//                           //       begin: Alignment.topLeft,
//                           //       end: Alignment.bottomRight,
//                           //     ),
//                           //     borderRadius: BorderRadius.circular(25),
//                           //     boxShadow: [
//                           //       BoxShadow(
//                           //         color: const Color(0xFF1B4B8E).withOpacity(0.3),
//                           //         blurRadius: 6,
//                           //         spreadRadius: 1,
//                           //       )
//                           //     ],
//                           //   ),
//                           //   child: const Center(
//                           //     child: Text(
//                           //       'RP',
//                           //       style: TextStyle(
//                           //         color: Colors.white,
//                           //         fontWeight: FontWeight.bold,
//                           //         fontSize: 16,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           // const SizedBox(width: 12),
//                           // // Pulsing CTA button
//                           Expanded(
//                             child: AnimatedBuilder(
//                               animation: _pulseController,
//                               builder: (context, child) {
//                                 final scale = 0.98 + (_pulseController.value * 0.04);
//                                 return Transform.scale(
//                                   scale: scale,
//                                   child: ElevatedButton(
//                                     onPressed: provider.isLoading ? null : _subscribeNow,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: appGlow,
//                                       padding: const EdgeInsets.symmetric(vertical: 14),
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                       elevation: 4,
//                                       shadowColor: appGlow.withOpacity(0.5),
//                                     ),
//                                     child: const Text(
//                                       'Start 7 Days Trial @ ₹2',
//                                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
        
//             // loading overlay
//             if (provider.isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(child: CircularProgressIndicator(color: appPrimary)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // *** End of File

// class _BenefitCardWithHighlight extends StatelessWidget {
//   final String highlightText;
//   final String normalText;
//   final IconData icon;

//   const _BenefitCardWithHighlight({
//     required this.highlightText,
//     required this.normalText,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color(0xFF1C1C1E),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: appGlow.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: appGlow, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: highlightText,
//                       style: const TextStyle(color: appGlow, fontWeight: FontWeight.bold, fontSize: 13),
//                     ),
//                     TextSpan(
//                       text: ' $normalText',
//                       style: const TextStyle(color: textPrimary, fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HowStep extends StatelessWidget {
//   final String number;
//   final String title;
//   final String subtitle;

//   const _HowStep({required this.number, required this.title, required this.subtitle});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(colors: [appGlow, Color(0xFFFFA500)]),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [BoxShadow(color: appGlow.withOpacity(0.4), blurRadius: 6, spreadRadius: 1)],
//           ),
//           child: Center(child: Text(number, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
//               const SizedBox(height: 2),
//               Text(subtitle, style: const TextStyle(color: textSecondary, fontSize: 12)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
















// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import '../../models/planModel.dart';
// import '../../models/razerPay_plane_model.dart';
// import '../../models/user_details_model.dart';
// import '../../provider/app_provider.dart';
// import '../../provider/payment_method/paymentProvider.dart';

// // Theme constants matching the app's cyan + black design
// const Color appPrimary = Color(0xFF00BFFF); // cyan accent
// const Color appBackground = Color(0xFF0A0A0A); // black
// const Color cardBg = Color(0xFF0F0F0F); // dark card
// const Color textPrimary = Colors.white;
// const Color textSecondary = Colors.white70;
// const Color appGlow = Color(0xFF80FFFF); // glow highlight (matches app theme)

// class TrialStartScreen extends StatefulWidget {
//   const TrialStartScreen({super.key});

//   @override
//   State<TrialStartScreen> createState() => _TrialStartScreenState();
// }

// class _TrialStartScreenState extends State<TrialStartScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _pulseController;
//   final razorpayService = RazorpaySubscriptionService();

//   PlanModel _planModel = PlanModel();
//   RazorpayPlansResponse? _plans;
//   PlanItem? _trialPlan;   // Razorpay plan with trial (7 days)
//   PlanItem? _monthlyPlan; // Razorpay monthly plan
//   UserDetailsModel _userDetailsModel = UserDetailsModel();

//   String? discountText;

//   bool get _hasUsedTrial =>
//       (_userDetailsModel.data?.isTrialUsed ?? 0) == 1;

//   bool get _canShowTrial {
//     final list = _planModel.data;
//     if (list == null || list.isEmpty) return false;
//     final plan = list.first;

//     final hasTrialDays = (plan.trialDays ?? 0) > 0;
//     final hasTrialPrice = (plan.trialPrice ?? 0) > 0;

//     // ✅ Trial sirf tab dikhayenge jab:
//     // 1) backend plan me trial defined hai
//     // 2) user ne trial abhi tak use nahi kiya (trial_used == 0)
//     return !_hasUsedTrial && hasTrialDays && hasTrialPrice;
//   }

//   @override
//   void initState() {
//     super.initState();
//     razorpayService.initRazorpay();

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);

//     loadPlans();
//   }

//   @override
//   void dispose() {
//     razorpayService.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   Future<void> loadPlans() async {
//     // 🔹 Backend plans (PlanModel) + user details (trial_used)
//     _planModel = await context.read<AppProvider>().getPlans();
//     _userDetailsModel = await context.read<AppProvider>().getUserDetails();

//     // 🔹 Razorpay plans (for planId)
//     final paymentProvider =
//         Provider.of<PaymentProvider>(context, listen: false);
//     final fetchedPlans = await paymentProvider.getPlans();

//     if (!mounted) return;

//     _plans = fetchedPlans;

//     if (_plans?.items != null && _plans!.items!.isNotEmpty) {
//       // Razorpay trial plan → daily with interval 7
//       _trialPlan = _plans!.items!.firstWhere(
//         (p) => p.period == 'daily' && p.interval == 7,
//         orElse: () => _plans!.items!.first,
//       );

//       // Razorpay monthly plan → monthly with interval 1
//       _monthlyPlan = _plans!.items!.firstWhere(
//         (p) => p.period == 'monthly' && p.interval == 1,
//         orElse: () => _plans!.items!.last,
//       );
//     }

//     // 🔹 Discount calculate from backend plan (PlanModel) if trial allowed
//     final planList = _planModel.data;
//     if (planList != null &&
//         planList.isNotEmpty &&
//         _canShowTrial &&
//         (planList.first.price ?? 0) > 0 &&
//         (planList.first.trialPrice ?? 0) > 0) {
//       final monthlyAmount = planList.first.price!.toDouble();
//       final trialAmount = planList.first.trialPrice!.toDouble();
//       final discountPercent =
//           ((monthlyAmount - trialAmount) / monthlyAmount) * 100;
//       discountText = discountPercent.toStringAsFixed(0);
//     } else {
//       discountText = null;
//     }

//     setState(() {});

//     if (_plans != null) {
//       debugPrint("Total Razorpay plans: ${_plans!.count}");
//       debugPrint(
//           "Trial plan: ${_trialPlan?.id} amount: ${_trialPlan?.item?.amount}");
//       debugPrint(
//           "Monthly plan: ${_monthlyPlan?.id} amount: ${_monthlyPlan?.item?.amount}");
//     }
//   }

//   void _subscribeNow() async {
//     final paymentProvider =
//         Provider.of<PaymentProvider>(context, listen: false);

//     // 🔥 Agar trial available hai → trial plan, warna monthly plan
//     final selectedPlanId =
//         _canShowTrial ? _trialPlan?.id : _monthlyPlan?.id;

//     if (selectedPlanId == null) {
//       debugPrint("❌ No plan loaded yet");
//       return;
//     }

//     await paymentProvider.createSubscription(
//       planId: selectedPlanId,
//       name: _userDetailsModel.data?.name ?? "",
//       email: _userDetailsModel.data?.email ?? "",
//       phone: _userDetailsModel.data?.phone ?? "",
//       totalCount: '1',
//       context: context,
//     );
//   }

//   Future<void> startSubscription() async {
//     // Agar manually RazorpaySubscriptionService use karna hai:
//     final selectedPlanId =
//         _canShowTrial ? _trialPlan?.id : _monthlyPlan?.id;

//     if (selectedPlanId == null) {
//       debugPrint("❌ No plan loaded for service");
//       return;
//     }

//     razorpayService.setContext(context);
//     String? subscriptionId =
//         await razorpayService.createSubscription(selectedPlanId);

//     if (subscriptionId != null) {
//       razorpayService.openCheckout(subscriptionId);
//     } else {
//       debugPrint("Failed to create subscription");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     // 🔹 Backend plan data (for UI amounts)
//     final planData =
//         _planModel.data != null && _planModel.data!.isNotEmpty
//             ? _planModel.data!.first
//             : null;

//     final int trialDays = planData?.trialDays ?? 7;

//     // Monthly amount from backend plan
//     final double monthlyAmountValue =
//         (planData?.price ?? 299).toDouble();

//     // Trial amount: agar trial allowed nahi hai → same as monthly
//     final double trialAmountValue = _canShowTrial
//         ? (planData?.trialPrice ?? 2).toDouble()
//         : monthlyAmountValue;

//     final String trialAmountText = trialAmountValue.toStringAsFixed(0);
//     final String monthlyAmountText =
//         monthlyAmountValue.toStringAsFixed(0);

//     // CTA text based on trial_used
//     final String ctaText = _canShowTrial
//         ? 'Start $trialDays Days Trial @ ₹$trialAmountText'
//         : 'Subscribe @ ₹$monthlyAmountText / month';

//     // Title above price
//     final String topTitle = _canShowTrial
//         ? 'Unlock $trialDays Days Premium for'
//         : 'Get Premium access';

//     // “HOW ... WORKS?” title
//     final String howTitle =
//         _canShowTrial ? 'HOW TRIAL WORKS?' : 'HOW PREMIUM WORKS?';

//     return Scaffold(
//       backgroundColor: appBackground,
//       body: WillPopScope(
//         onWillPop: () async {
//           SystemNavigator.pop();
//           return false;
//         },
//         child: Stack(
//           children: [
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 120),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Top bar
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 8,
//                       ),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               SystemNavigator.pop();
//                             },
//                             icon: const Icon(
//                               Icons.arrow_back_ios,
//                               color: appPrimary,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Color(0xFF1B4B8E),
//                                   Color(0xFF2B5FB8)
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Text(
//                                   'Powered by ',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Razorpay',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Logo
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SizedBox(
//                         height: 180,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),

//                     // Price Card
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: appPrimary.withOpacity(0.3),
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: appPrimary.withOpacity(0.15),
//                               blurRadius: 12,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: Card(
//                           color: cardBg,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   topTitle,
//                                   style: const TextStyle(
//                                     color: textSecondary,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     const Text(
//                                       '₹',
//                                       style: TextStyle(
//                                         color: appGlow,
//                                         fontSize: 26,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       trialAmountText,
//                                       style: const TextStyle(
//                                         color: appGlow,
//                                         fontSize: 64,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Then ₹$monthlyAmountText/month',
//                                           style: const TextStyle(
//                                             color: textSecondary,
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         const Text(
//                                           'Cancel anytime',
//                                           style: TextStyle(
//                                             color: Colors.white38,
//                                             fontSize: 11,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 // Offer badge: sirf jab trial available ho
//                                 if (_canShowTrial && discountText != null)
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(
//                                         colors: [appGlow, Color(0xFFFFA500)],
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text(
//                                       '🎉 $discountText% OFF for first $trialDays days',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // Benefits
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         children: const [
//                           _BenefitCardWithHighlight(
//                             highlightText: '24x7 AI Teacher',
//                             normalText: 'that gives instant feedback',
//                             icon: Icons.headset,
//                           ),
//                           SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: '100+ Real life',
//                             normalText: 'speaking scenario practice',
//                             icon: Icons.group,
//                           ),
//                           SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: 'Personalized lessons',
//                             normalText: '& progress tracking',
//                             icon: Icons.show_chart,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     // How trial / premium works
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Card(
//                         color: cardBg,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 howTitle,
//                                 style: const TextStyle(
//                                   color: appGlow,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),

//                               if (_canShowTrial) ...[
//                                 _HowStep(
//                                   number: '1',
//                                   title:
//                                       'Start trial by paying ₹$trialAmountText',
//                                   subtitle:
//                                       'Get access to all premium features today',
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const _HowStep(
//                                   number: '2',
//                                   title:
//                                       'Get Unlimited talktime with AI',
//                                   subtitle:
//                                       'Available 24x7. No fear. No judgment',
//                                 ),
//                                 const SizedBox(height: 8),
//                                 _HowStep(
//                                   number: '3',
//                                   title:
//                                       'Then ₹$monthlyAmountText/month',
//                                   subtitle:
//                                       'After $trialDays days, plan auto-renews every month',
//                                 ),
//                               ] else ...[
//                                 _HowStep(
//                                   number: '1',
//                                   title:
//                                       'Subscribe for ₹$monthlyAmountText/month',
//                                   subtitle:
//                                       'Instant access to all premium features',
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const _HowStep(
//                                   number: '2',
//                                   title:
//                                       'Get Unlimited talktime with AI',
//                                   subtitle:
//                                       'Available 24x7. No fear. No judgment',
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const _HowStep(
//                                   number: '3',
//                                   title: 'Cancel anytime',
//                                   subtitle:
//                                       'Manage your subscription from settings',
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     // After-trial info
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: cardBg,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: appGlow.withOpacity(0.2),
//                             width: 1,
//                           ),
//                         ),
//                         child: Text(
//                           'After trial, plan auto-renews for ₹$monthlyAmountText every month',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: textSecondary,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),

//             // Sticky bottom CTA
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: appBackground,
//                   border: Border(
//                     top: BorderSide(
//                       color: appGlow.withOpacity(0.3),
//                       width: 1,
//                     ),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: appGlow.withOpacity(0.15),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: SafeArea(
//                   top: false,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: LinearProgressIndicator(
//                           value: 0.3,
//                           backgroundColor: Colors.white10,
//                           valueColor:
//                               const AlwaysStoppedAnimation<Color>(appGlow),
//                           minHeight: 3,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: AnimatedBuilder(
//                               animation: _pulseController,
//                               builder: (context, child) {
//                                 final scale =
//                                     0.98 + (_pulseController.value * 0.04);
//                                 return Transform.scale(
//                                   scale: scale,
//                                   child: ElevatedButton(
//                                     onPressed: provider.isLoading
//                                         ? null
//                                         : _subscribeNow,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: appGlow,
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 14),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12),
//                                       ),
//                                       elevation: 4,
//                                       shadowColor:
//                                           appGlow.withOpacity(0.5),
//                                     ),
//                                     child: Text(
//                                       ctaText,
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Loading overlay for subscription API calls
//             if (provider.isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: CircularProgressIndicator(color: appPrimary),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ───────────────── Helper Widgets ─────────────────

// class _BenefitCardWithHighlight extends StatelessWidget {
//   final String highlightText;
//   final String normalText;
//   final IconData icon;

//   const _BenefitCardWithHighlight({
//     required this.highlightText,
//     required this.normalText,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color(0xFF1C1C1E),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: appGlow.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: appGlow, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: highlightText,
//                       style: const TextStyle(
//                         color: appGlow,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' $normalText',
//                       style: const TextStyle(
//                         color: textPrimary,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HowStep extends StatelessWidget {
//   final String number;
//   final String title;
//   final String subtitle;

//   const _HowStep({
//     required this.number,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             gradient:
//                 const LinearGradient(colors: [appGlow, Color(0xFFFFA500)]),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: appGlow.withOpacity(0.4),
//                 blurRadius: 6,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: textPrimary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: textSecondary,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }






















import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/planModel.dart';
import '../../models/user_details_model.dart';
import '../../provider/app_provider.dart';
import '../../provider/payment_method/paymentProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/models/user_details_model.dart';

// Theme constants matching the app's cyan + black design
const Color appPrimary = Color(0xFF00BFFF);
const Color appBackground = Color(0xFF0A0A0A);
const Color cardBg = Color(0xFF0F0F0F);
const Color textPrimary = Colors.white;
const Color textSecondary = Colors.white70;
const Color appGlow = Color(0xFF80FFFF);

class TrialStartScreen extends StatefulWidget {
  const TrialStartScreen({super.key});

  @override
  State<TrialStartScreen> createState() => _TrialStartScreenState();
}

class _TrialStartScreenState extends State<TrialStartScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;

  PlanModel? _planModel;
  PlanData? _trialPlanData;
  PlanData? _monthlyPlanData;
  UserDetailsModel? _userDetailsModel;
  String? discountText;
  bool _loadingPlans = true;
  PlanData? locale_planeId;

  bool get _hasUsedTrial => (_userDetailsModel?.data?.isTrialUsed ?? 0) == 1;

  bool get _canShowTrial => !_hasUsedTrial && _trialPlanData != null;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    loadPlans();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> loadPlans() async {
    final appProvider = context.read<AppProvider>();

    final planModel = await appProvider.getPlans();
    final userDetails = await appProvider.getUserDetails();

    if (!mounted) return;

    final plans = planModel.data ?? [];

    // 👉 Separate trial & normal plans based on isTrialPlan
    PlanData? trialPlan;
    PlanData? monthlyPlan;

    final trialCandidates =
        plans.where((p) => (p.isTrialPlan ?? 0) == 1).toList();
    if (trialCandidates.isNotEmpty) {
      trialPlan = trialCandidates.first;
    }

    final monthlyCandidates =
        plans.where((p) => (p.isTrialPlan ?? 0) == 0).toList();
    if (monthlyCandidates.isNotEmpty) {
      monthlyPlan = monthlyCandidates.first;
    } else if (plans.isNotEmpty) {
      monthlyPlan = plans.first;
    }

    // 👉 User ne trial use kar liya? To trial hide
    final bool hasUsedTrial = (userDetails.data?.isTrialUsed ?? 0) == 1;
    if (hasUsedTrial) {
      trialPlan = null;
    }

    // Yeh monthly / normal plan UI ke liye
    locale_planeId = monthlyPlan ?? (plans.isNotEmpty ? plans.first : null);

    double? localDiscount;
    if (trialPlan != null &&
        monthlyPlan != null &&
        monthlyPlan.price != null &&
        trialPlan.price != null &&
        monthlyPlan.price! > 0) {
      final trialAmount = trialPlan.price!.toDouble();
      final price = monthlyPlan.price!.toDouble();
      final discountPercent = ((price - trialAmount) / price) * 100;
      localDiscount = discountPercent;
    }

    setState(() {
      _planModel = planModel;
      _userDetailsModel = userDetails;
      _trialPlanData = trialPlan;
      _monthlyPlanData = monthlyPlan;
      discountText =
          localDiscount != null ? localDiscount.toStringAsFixed(0) : null;
      _loadingPlans = false;
    });
  }

  void _subscribeNow() async {
    if (_loadingPlans) return;

    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    final selectedPlan = _canShowTrial ? _trialPlanData : _monthlyPlanData;

    if (selectedPlan == null || selectedPlan.gatewayPlanId == null) {
      debugPrint("❌ No selected plan / gateway_plan_id");
      return;
    }

    final user = _userDetailsModel?.data;

    await paymentProvider.createSubscription(
      planId: '${selectedPlan.id}',
      name: user?.name ?? "",
      email: user?.email ?? "",
      phone: user?.phone ?? "",
      totalCount: '1',
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    // Show loader until plans+user load
    if (_loadingPlans) {
      return const Scaffold(
        backgroundColor: appBackground,
        body: Center(
          child: CircularProgressIndicator(color: appPrimary),
        ),
      );
    }

    final trialPlan = _trialPlanData;
    final monthlyPlan = _monthlyPlanData;

    debugPrint("🔹 Trial Plan: $trialPlan");
    debugPrint("🔹 Monthly Plan: ${monthlyPlan?.price}");

    final int trialDays = trialPlan?.durationDays ?? 7;

    final double monthlyAmountValue =
        (monthlyPlan?.price ?? 0).toDouble();

    final double trialAmountValue = _canShowTrial
        ? (trialPlan?.price ?? monthlyAmountValue).toDouble()
        : monthlyAmountValue;

    final String trialAmountText = trialAmountValue.toStringAsFixed(0);
    final String monthlyAmountText = monthlyAmountValue.toStringAsFixed(0);

    final String ctaText = _canShowTrial
        ? 'Start $trialDays Days Trial @ ₹$trialAmountText'
        : 'Subscribe @ ₹$monthlyAmountText / month';

    final String topTitle = _canShowTrial
        ? 'Unlock $trialDays Days Premium for'
        : 'Get Premium access';

    final String howTitle =
        _canShowTrial ? 'HOW TRIAL WORKS?' : 'HOW PREMIUM WORKS?';

    return Scaffold(
      backgroundColor: appBackground,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios,
                                color: appPrimary),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1B4B8E),
                                  Color(0xFF2B5FB8)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Powered by ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                                Text(
                                  'Razorpay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 180,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Price Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: appPrimary.withOpacity(0.3), width: 1),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: appPrimary.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Card(
                          color: cardBg,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  topTitle,
                                  style: const TextStyle(
                                      color: textSecondary, fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      '₹',
                                      style: TextStyle(
                                        color: appGlow,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      trialAmountText,
                                      style: const TextStyle(
                                        color: appGlow,
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Then ₹${locale_planeId?.price}/month',
                                          style: const TextStyle(
                                              color: textSecondary,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Cancel anytime',
                                          style: TextStyle(
                                              color: Colors.white38,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (_canShowTrial && discountText != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        appGlow,
                                        Color(0xFFFFA500)
                                      ]),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '🎉 $discountText% OFF for first $trialDays days',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Benefits
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: const [
                          _BenefitCardWithHighlight(
                            highlightText: '24x7 AI Teacher',
                            normalText: 'that gives instant feedback',
                            icon: Icons.headset,
                          ),
                          SizedBox(height: 10),
                          _BenefitCardWithHighlight(
                            highlightText: '100+ Real life',
                            normalText: 'speaking scenario practice',
                            icon: Icons.group,
                          ),
                          SizedBox(height: 10),
                          _BenefitCardWithHighlight(
                            highlightText: 'Personalized lessons',
                            normalText: '& progress tracking',
                            icon: Icons.show_chart,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // How it works
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: cardBg,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                howTitle,
                                style: const TextStyle(
                                  color: appGlow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (_canShowTrial) ...[
                                _HowStep(
                                  number: '1',
                                  title:
                                      'Start trial by paying ₹$trialAmountText',
                                  subtitle:
                                      'Get access to all premium features today',
                                ),
                                const SizedBox(height: 8),
                                const _HowStep(
                                  number: '2',
                                  title: 'Get Unlimited talktime with AI',
                                  subtitle:
                                      'Available 24x7. No fear. No judgment',
                                ),
                                _HowStep(
                                  number: '3',
                                  title:
                                      'Then ₹$monthlyAmountText/month',
                                  subtitle:
                                      'After $trialDays days, plan auto-renews every month',
                                ),
                              ] else ...[
                                _HowStep(
                                  number: '1',
                                  title:
                                      'Subscribe for ₹$monthlyAmountText/month',
                                  subtitle:
                                      'Instant access to all premium features',
                                ),
                                const SizedBox(height: 8),
                                const _HowStep(
                                  number: '2',
                                  title: 'Get Unlimited talktime with AI',
                                  subtitle:
                                      'Available 24x7. No fear. No judgment',
                                ),
                                const SizedBox(height: 8),
                                const _HowStep(
                                  number: '3',
                                  title: 'Cancel anytime',
                                  subtitle:
                                      'Manage your subscription from settings',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // After trial info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appGlow.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'After trial, plan auto-renews for ₹$monthlyAmountText every month',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Sticky bottom CTA
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: appBackground,
                  border: Border(
                    top: BorderSide(
                        color: appGlow.withOpacity(0.3), width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: appGlow.withOpacity(0.15),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: 0.3,
                          backgroundColor: Colors.white10,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(appGlow),
                          minHeight: 3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                final scale =
                                    0.98 + (_pulseController.value * 0.04);
                                return Transform.scale(
                                  scale: scale,
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : _subscribeNow,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: appGlow,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor:
                                          appGlow.withOpacity(0.5),
                                    ),
                                    child: Text(
                                      ctaText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // loading overlay when payment API running
            if (provider.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: appPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper widgets

class _BenefitCardWithHighlight extends StatelessWidget {
  final String highlightText;
  final String normalText;
  final IconData icon;

  const _BenefitCardWithHighlight({
    required this.highlightText,
    required this.normalText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appGlow.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: appGlow, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: highlightText,
                      style: const TextStyle(
                        color: appGlow,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: ' $normalText',
                      style: const TextStyle(
                        color: textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowStep extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _HowStep({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [appGlow, Color(0xFFFFA500)]),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: appGlow.withOpacity(0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                    color: textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import '../../models/planModel.dart';
// import '../../models/razerPay_plane_model.dart';
// import '../../models/user_details_model.dart';
// import '../../provider/app_provider.dart';
// import '../../provider/payment_method/paymentProvider.dart';

// // Theme constants matching the app's cyan + black design
// const Color appPrimary = Color(0xFF00BFFF); // cyan accent
// const Color appBackground = Color(0xFF0A0A0A); // black
// const Color cardBg = Color(0xFF0F0F0F); // dark card
// const Color textPrimary = Colors.white;
// const Color textSecondary = Colors.white70;
// const Color appGlow = Color(0xFF80FFFF); // glow highlight (matches app theme)

// /// Trial / Subscribe screen with sticky CTA and benefits.
// class TrialStartScreen extends StatefulWidget {
//   const TrialStartScreen({super.key});

//   @override
//   State<TrialStartScreen> createState() => _TrialStartScreenState();
// }

// class _TrialStartScreenState extends State<TrialStartScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _pulseController;
//   final razorpayService = RazorpaySubscriptionService();
// PlanModel _planModel=PlanModel();

//   RazorpayPlansResponse? _plans;
//   PlanItem? _trialPlan;
//   PlanItem? _monthlyPlan;
//   UserDetailsModel _userDetailsModel=UserDetailsModel();


//   @override
//   void initState() {
//     super.initState();
//     razorpayService.initRazorpay();

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);

//     loadPlans();
//   }

//   @override
//   void dispose() {
//     razorpayService.dispose();
//     _pulseController.dispose();

//     super.dispose();
//   }
//  String ?discountText;
//   Future<void> loadPlans() async {

//             _planModel = await context.read<AppProvider>().getPlans();

//             _userDetailsModel=await context.read<AppProvider>().getUserDetails();

//     final paymentProvider =
//         Provider.of<PaymentProvider>(context, listen: false);

//     final fetchedPlans = await paymentProvider.getPlans();

//     if (!mounted) return;

//     setState(() {
//       _plans = fetchedPlans;

//       if (_plans?.items != null && _plans!.items!.isNotEmpty) {
//         // Find trial plan → daily with interval 7
//         _trialPlan = _plans!.items!.firstWhere(
//           (p) => p.period == 'daily' && p.interval == 7,
//           orElse: () => _plans!.items!.first,
//         );

//         // Find monthly plan → monthly with interval 1
//         _monthlyPlan = _plans!.items!.firstWhere(
//           (p) => p.period == 'monthly' && p.interval == 1,
//           orElse: () => _plans!.items!.last,
//         );

// // Both are PlanItem?
// final trial = _trialPlan;
// final monthly = _monthlyPlan;

// // Get amounts in rupees (Razorpay gives paise)
// final double trialAmount =
//     (trial?.item?.amount ?? 0) / 100; // e.g. 2
// final double monthlyAmount =
//     (monthly?.item?.amount ?? 1) / 100; // e.g. 299

// // Now you can do numeric math, including %
// final double discountPercent =
//     ((monthlyAmount - trialAmount) / monthlyAmount) * 100;

//  discountText = "${discountPercent.toStringAsFixed(0)}% OFF";

//       }
//     });

//     if (_plans != null) {
//       debugPrint("Total plans: ${_plans!.count}");
//       debugPrint(
//           "Trial plan: ${_trialPlan?.id} amount: ${_trialPlan?.item?.amount}");
//       debugPrint(
//           "Monthly plan: ${_monthlyPlan?.id} amount: ${_monthlyPlan?.item?.amount}");
//     }
//   }

//   void _subscribeNow() async {
//     final paymentProvider =
//         Provider.of<PaymentProvider>(context, listen: false);

//     // Use trial plan for this CTA (you can switch to _monthlyPlan if needed)
//     final selectedPlanId = _trialPlan?.id;
//     // final id=!.id.toString();

//     if (selectedPlanId == null) {
//       debugPrint("❌ No plan loaded yet");
//       return;
//     }

//     await paymentProvider.createSubscription(
//       planId: selectedPlanId,
//       name:  _userDetailsModel.data!.name ?? "",
//         email: _userDetailsModel.data!.email ?? "",
//         phone: _userDetailsModel.data!.phone ?? "",
//       totalCount: '1',
//       context: context,
//     );
  
  
//   }


//     Future<void> startSubscription() async {
//           final selectedPlanId = _trialPlan?.id;

//     razorpayService.setContext(context); // Pass context for navigation after payment success
//     String? subscriptionId = await razorpayService.createSubscription(selectedPlanId!);

//     if (subscriptionId != null) {
//       razorpayService.openCheckout(subscriptionId);
//     } else {
//       print("Failed to create subscription");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     // Use dynamic amounts from Razorpay; fall back to defaults if null
//     final double trialAmountValue =
//         _trialPlan?.item?.amount != null ? _trialPlan!.item!.amount! / 100 : 2.0;
//     final double monthlyAmountValue = _monthlyPlan?.item?.amount != null
//         ? _monthlyPlan!.item!.amount! / 100
//         : 299.0;

//     final String trialAmountText = trialAmountValue.toStringAsFixed(0);
//     final String monthlyAmountText = monthlyAmountValue.toStringAsFixed(0);

//     return Scaffold(
//       backgroundColor: appBackground,
//       body: WillPopScope(
//         onWillPop: () async {
//           // Close app instead of going back
//           SystemNavigator.pop();
//           return false;
//         },
//         child: Stack(
//           children: [
//             SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 120),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Top bar with gradient accent
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12.0, vertical: 8),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               SystemNavigator.pop();
//                             },
//                             icon: const Icon(Icons.arrow_back_ios,
//                                 color: appPrimary),
//                           ),
//                           const Spacer(),
//                           // Razorpay badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(colors: [
//                                 Color(0xFF1B4B8E),
//                                 Color(0xFF2B5FB8)
//                               ]),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Text('Powered by ',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 11)),
//                                 Text('Razorpay',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 11)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Logo / hero
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SizedBox(
//                         height: 180,
//                         child: Image.asset(
//                           'assets/images/logo.png',
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),

//                     // Price Card with gradient border
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: appPrimary.withOpacity(0.3), width: 1),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: appPrimary.withOpacity(0.15),
//                               blurRadius: 12,
//                               spreadRadius: 2,
//                             )
//                           ],
//                         ),
//                         child: Card(
//                           color: cardBg,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           elevation: 0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   'Unlock 7 Days Premium for',
//                                   style: TextStyle(
//                                       color: textSecondary, fontSize: 14),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     const Text(
//                                       '₹',
//                                       style: TextStyle(
//                                         color: appGlow,
//                                         fontSize: 26,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       trialAmountText,
//                                       style: const TextStyle(
//                                         color: appGlow,
//                                         fontSize: 64,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Then ₹$monthlyAmountText/month',
//                                           style: const TextStyle(
//                                               color: textSecondary,
//                                               fontSize: 13),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         const Text(
//                                           'Cancel anytime',
//                                           style: TextStyle(
//                                               color: Colors.white38,
//                                               fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 // Offer badge
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 8),
//                                   decoration: BoxDecoration(
//                                     gradient: const LinearGradient(colors: [
//                                       appGlow,
//                                       Color(0xFFFFA500)
//                                     ]),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Text(
//                                     '🎉 $discountText% OFF for first 7 days',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // Benefits
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         children: const [
//                           _BenefitCardWithHighlight(
//                             highlightText: '24x7 AI Teacher',
//                             normalText: 'that gives instant feedback',
//                             icon: Icons.headset,
//                           ),
//                           SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: '100+ Real life',
//                             normalText: 'speaking scenario practice',
//                             icon: Icons.group,
//                           ),
//                           SizedBox(height: 10),
//                           _BenefitCardWithHighlight(
//                             highlightText: 'Personalized lessons',
//                             normalText: '& progress tracking',
//                             icon: Icons.show_chart,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     // How trial works
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Card(
//                         color: cardBg,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'HOW TRIAL WORKS?',
//                                 style: TextStyle(
//                                   color: appGlow,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               _HowStep(
//                                 number: '1',
//                                 title:
//                                     'Start trial by paying ₹$trialAmountText',
//                                 subtitle:
//                                     'Get access to all premium features today',
//                               ),
//                               const SizedBox(height: 8),
//                               const _HowStep(
//                                 number: '2',
//                                 title: 'Get Unlimited talktime with AI',
//                                 subtitle:
//                                     'Available 24x7. No fear. No judgment',
//                               ),
//                               const SizedBox(height: 8),
//                               _HowStep(
//                                 number: '3',
//                                 title: 'Then ₹$monthlyAmountText/month',
//                                 subtitle:
//                                     'After 7 days, plan auto-renews every month',
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 18),

//                     // After trial info
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: cardBg,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: appGlow.withOpacity(0.2),
//                             width: 1,
//                           ),
//                         ),
//                         child: Text(
//                           'After trial, plan auto-renews for ₹$monthlyAmountText every month',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: textSecondary,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),

//             // Sticky bottom CTA with pulsing button
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: appBackground,
//                   border: Border(
//                     top: BorderSide(
//                         color: appGlow.withOpacity(0.3), width: 1),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: appGlow.withOpacity(0.15),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     )
//                   ],
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: SafeArea(
//                   top: false,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(2),
//                         child: LinearProgressIndicator(
//                           value: 0.3,
//                           backgroundColor: Colors.white10,
//                           valueColor:
//                               const AlwaysStoppedAnimation<Color>(appGlow),
//                           minHeight: 3,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: AnimatedBuilder(
//                               animation: _pulseController,
//                               builder: (context, child) {
//                                 final scale = 0.98 +
//                                     (_pulseController.value * 0.04);
//                                 return Transform.scale(
//                                   scale: scale,
//                                   child: ElevatedButton(
//                                     onPressed: provider.isLoading
//                                         ? null
//                                         : _subscribeNow,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: appGlow,
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 14),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12),
//                                       ),
//                                       elevation: 4,
//                                       shadowColor:
//                                           appGlow.withOpacity(0.5),
//                                     ),
//                                     child: Text(
//                                       'Start 7 Days Trial @ ₹$trialAmountText',
//                                       style: const TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // loading overlay (for subscription API calls)
//             if (provider.isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: CircularProgressIndicator(color: appPrimary),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // *** Helper Widgets ***

// class _BenefitCardWithHighlight extends StatelessWidget {
//   final String highlightText;
//   final String normalText;
//   final IconData icon;

//   const _BenefitCardWithHighlight({
//     required this.highlightText,
//     required this.normalText,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: const Color(0xFF1C1C1E),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: appGlow.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: appGlow, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: highlightText,
//                       style: const TextStyle(
//                         color: appGlow,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                     TextSpan(
//                       text: ' $normalText',
//                       style: const TextStyle(
//                         color: textPrimary,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HowStep extends StatelessWidget {
//   final String number;
//   final String title;
//   final String subtitle;

//   const _HowStep({
//     required this.number,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             gradient:
//                 const LinearGradient(colors: [appGlow, Color(0xFFFFA500)]),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: appGlow.withOpacity(0.4),
//                 blurRadius: 6,
//                 spreadRadius: 1,
//               )
//             ],
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: textPrimary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: textSecondary,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
