// import 'package:flutter/material.dart';

// class PaymentMethodScreen extends StatefulWidget {
//   const PaymentMethodScreen({super.key});

//   @override
//   State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
// }

// class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
//   // Selected Payment Option
//   String selectedMethod = "Credit Card"; // Default selection

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
//         backgroundColor: kBackground,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: kBorder),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Icon(Icons.lock, color: kBorder, size: 28),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//         child: Column(
//           children: [
//             // ✅ Title
//             const Text(
//               "Payment Method",
//               style: TextStyle(
//                 color: kBorder,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),

//             const SizedBox(height: 30),

//             // ✅ Payment Options
//             _buildPaymentOption("UPI"),
//             const SizedBox(height: 16),
//             _buildPaymentOption("Credit Card"),
//             const SizedBox(height: 16),
//             _buildPaymentOption("Paytm"),

//             const Spacer(),

//             // ✅ Confirm Payment Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: Handle confirm payment
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Selected: $selectedMethod")),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: const BorderSide(color: kBorder, width: 1.5),
//                   ),
//                   elevation: 8,
//                   shadowColor: kGlow.withOpacity(0.6),
//                 ),
//                 child: const Text(
//                   "Confirm Payment",
//                   style: TextStyle(
//                     color: kBorder,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
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
//           // TODO: Add navigation
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: "Track"),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: "Lessons"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   /// ✅ Builds a single payment option card
//   Widget _buildPaymentOption(String method) {
//     final bool isSelected = selectedMethod == method;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedMethod = method;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         decoration: BoxDecoration(
//           color: kCardFill,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? kBorder : Colors.white54,
//             width: 1.5,
//           ),
//           boxShadow: isSelected
//               ? [
//             BoxShadow(
//               color: kGlow.withOpacity(0.5),
//               blurRadius: 10,
//               spreadRadius: 2,
//             )
//           ]
//               : [],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               method,
//               style: TextStyle(
//                 color: isSelected ? kBorder : kText,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if (isSelected)
//               const Icon(Icons.check, color: kBorder, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/payment_method/paymentProvider.dart';





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/provider/payment_method/paymentProvider.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/provider/payment_method/paymentProvider.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/provider/payment_method/paymentProvider.dart';
import 'package:inangreji_flutter/models/wallet_balance_model.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  static const Color kBackground = Colors.black;
  static const Color kBorder = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);
  static const Color kText = Colors.white;
  static const Color kCardFill = Color(0xFF1C1C1E);

  final TextEditingController _accountNameController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _coinsController = TextEditingController();

  bool _isWithdrawing = false;
  bool _loading = true;

  WalletBalanceModel? _walletInfo;
  int _coinsToWithdraw = 0;

  // ---------- Getters based on wallet API ----------

  /// API se aane wala conversion_rate (fallback 1)
  int get _conversionRate {
    final rate = _walletInfo?.conversionRate ?? 1;
    return rate <= 0 ? 1 : rate;
  }

  /// Total earned coins (API: earned_coins)
  int get earnedCoins => (_walletInfo?.earnedCoins ?? 0).floor();

  /// Max jitne coins withdraw ho sakte (API: withdrawable_coins)
  int get maxWithdrawableCoins =>
      (_walletInfo?.withdrawableCoins ?? 0).floor();

  /// Minimum withdrawal (API: min_withdrawal)
  int get minWithdrawCoins => _walletInfo?.minWithdrawal ?? 10;

  /// Wallet balance (₹) (API: wallet_balance)
  double get walletRupees => _walletInfo?.walletBalance ?? 0;

  /// Selected coins -> ₹ me convert
  double get withdrawableAmount =>
      _coinsToWithdraw == 0 ? 0 : _coinsToWithdraw / _conversionRate;

  bool get _isFormValid {
    return _accountNameController.text.trim().isNotEmpty &&
        _bankNameController.text.trim().isNotEmpty &&
        _accountNumberController.text.trim().isNotEmpty &&
        _ifscController.text.trim().isNotEmpty &&
        _coinsToWithdraw >= minWithdrawCoins &&
        _coinsToWithdraw <= maxWithdrawableCoins;
  }

  @override
  void initState() {
    super.initState();
    _loadWalletFromApi();
  }

  Future<void> _loadWalletFromApi() async {
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
    _accountNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _coinsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();

    return Scaffold(
      backgroundColor: kBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kBorder),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Withdraw Earnings",
          style: TextStyle(
            color: kBorder,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: kBorder),
            )
          : _walletInfo == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Failed to load wallet details.",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadWalletFromApi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBorder,
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 22),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Coins & Money card (now from wallet API)
                              _buildBalanceCard(),

                              const SizedBox(height: 24),

                              const Text(
                                "Bank Details",
                                style: TextStyle(
                                  color: kText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _accountNameController,
                                label: "Account Holder Name",
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _bankNameController,
                                label: "Bank Name",
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _accountNumberController,
                                label: "Account Number",
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                controller: _ifscController,
                                label: "IFSC Code",
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                "Withdraw Amount",
                                style: TextStyle(
                                  color: kText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _coinsController,
                                label:
                                    "Coins to withdraw (Min $minWithdrawCoins, Max $maxWithdrawableCoins)",
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final v =
                                      int.tryParse(value.trim()) ?? 0;
                                  setState(() {
                                    if (v < 0) {
                                      _coinsToWithdraw = 0;
                                    } else if (v > maxWithdrawableCoins) {
                                      _coinsToWithdraw =
                                          maxWithdrawableCoins;
                                      _coinsController.text =
                                          maxWithdrawableCoins.toString();
                                      _coinsController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: _coinsController
                                                .text.length),
                                      );
                                    } else {
                                      _coinsToWithdraw = v;
                                    }
                                  });
                                },
                              ),

                              const SizedBox(height: 6),
                              Text(
                                "You will receive: ₹${withdrawableAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),

                              const Spacer(),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      (_isWithdrawing || !_isFormValid)
                                          ? null
                                          : () =>
                                              _onWithdraw(paymentProvider),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor:
                                        Colors.white12,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: kBorder, width: 1.5),
                                    ),
                                    elevation: 10,
                                    shadowColor:
                                        kGlow.withOpacity(0.6),
                                  ),
                                  child: _isWithdrawing
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(kBorder),
                                          ),
                                        )
                                      : Text(
                                          !_isFormValid
                                              ? "Enter details & min $minWithdrawCoins coins"
                                              : "Withdraw ₹${withdrawableAmount.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            color: kBorder,
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // ---------- UI helpers ----------

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: kText),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kBorder),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kBorder, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        fillColor: kCardFill,
        filled: true,
      ),
    );
  }

  /// Top balance card – ab pure wallet/balance API se
  Widget _buildBalanceCard() {
    final withdrawableCoins = maxWithdrawableCoins;
    final pending = (_walletInfo?.pendingWithdrawals ?? 0).toStringAsFixed(0);
    final available =
        (_walletInfo?.availableForWithdrawal ?? 0).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: kCardFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: kGlow.withOpacity(0.45),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Left: coins icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kBorder, width: 1.5),
                ),
                child: const Icon(
                  Icons.monetization_on,
                  color: kBorder,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),

              // Middle: coins info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Earned Coins",
                      style: TextStyle(
                        color: kText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$earnedCoins coins",
                      style: const TextStyle(
                        color: kBorder,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Balance: ₹${walletRupees.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Max withdrawable",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$withdrawableCoins coins",
                    style: const TextStyle(
                      color: kBorder,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.white12, height: 16),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Conversion: $_conversionRate coin = ₹1",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Pending: $pending",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "Available: $available",
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Withdraw API call ----------
Future<void> _onWithdraw(PaymentProvider paymentProvider) async {
  final accountName = _accountNameController.text.trim();
  final bankName = _bankNameController.text.trim();
  final accountNumber = _accountNumberController.text.trim();
  final ifsc = _ifscController.text.trim();

  if (!_isFormValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all details & valid coins"),
      ),
    );
    return;
  }

  setState(() => _isWithdrawing = true);

  final appProvider = context.read<AppProvider>();

  final success = await appProvider.requestWithdrawal(
    coins: _coinsToWithdraw,
    accountHolderName: accountName,
    bankName: bankName,
    accountNumber: accountNumber,
    ifscCode: ifsc,
    upiId: null,
    context: context,
  );

  setState(() => _isWithdrawing = false);

  if (success && mounted) {
    Navigator.pop(context, true); // wallet screen ko refresh signal
  }
}




}



// import 'package:flutter/material.dart';

// class PaymentMethodScreen extends StatefulWidget {
//   const PaymentMethodScreen({super.key});

//   @override
//   State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
// }

// class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
//   // Selected Payment Option
//   String selectedMethod = "UPI"; // Default selection

//   // Theme Colors
//   static const Color kBackground = Colors.black;
//   static const Color kBorder = Colors.cyanAccent;
//   static const Color kGlow = Color(0xFF80FFFF);
//   static const Color kText = Colors.white;
//   static const Color kCardFill = Color(0xFF1C1C1E);

//   // For demo: you can pass these from previous screen
//   final String _planName = "InAngreji Premium";
//   final double _amount = 249.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         backgroundColor: kBackground,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: kBorder),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Icon(Icons.lock, color: kBorder, size: 22),
//             SizedBox(width: 6),
//             Text(
//               "Secure Checkout",
//               style: TextStyle(
//                 color: kBorder,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//           ],
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header text
//             const Text(
//               "Payment Method",
//               style: TextStyle(
//                 color: kText,
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               "Choose how you want to pay for your InAngreji Premium plan.",
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 13,
//                 height: 1.4,
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Plan summary card
//             _buildSummaryCard(),

//             const SizedBox(height: 24),

//             const Text(
//               "Select a payment option",
//               style: TextStyle(
//                 color: kText,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Payment options
//             _buildPaymentOption(
//               method: "UPI",
//               subtitle: "Google Pay, PhonePe, Paytm UPI, BHIM, etc.",
//               icon: Icons.account_balance_wallet_outlined,
//             ),
//             const SizedBox(height: 14),
//             _buildPaymentOption(
//               method: "Credit Card",
//               subtitle: "Visa, MasterCard, RuPay, international cards.",
//               icon: Icons.credit_card,
//             ),
//             const SizedBox(height: 14),
//             _buildPaymentOption(
//               method: "Paytm",
//               subtitle: "Pay using Paytm wallet or Paytm UPI.",
//               icon: Icons.payment_rounded,
//             ),

//             const Spacer(),

//             // Secure line
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: const [
//                 Icon(Icons.https, color: Colors.white54, size: 16),
//                 SizedBox(width: 6),
//                 Text(
//                   "100% secure payments powered by your provider",
//                   style: TextStyle(
//                     color: Colors.white54,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // Confirm Payment Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _onConfirmPayment,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: const BorderSide(color: kBorder, width: 1.5),
//                   ),
//                   elevation: 10,
//                   shadowColor: kGlow.withOpacity(0.6),
//                 ),
//                 child: Text(
//                   "Pay ₹${_amount.toStringAsFixed(0)} with $selectedMethod",
//                   style: const TextStyle(
//                     color: kBorder,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),
//           ],
//         ),
//       ),

//       // // Bottom Navigation Bar (if you still want it)
//       // bottomNavigationBar: BottomNavigationBar(
//       //   backgroundColor: kCardFill,
//       //   type: BottomNavigationBarType.fixed,
//       //   selectedItemColor: kBorder,
//       //   unselectedItemColor: Colors.white70,
//       //   currentIndex: 3, // Profile highlighted
//       //   onTap: (index) {
//       //     // TODO: Add proper navigation for your app
//       //   },
//       //   items: const [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.track_changes), label: "Track"),
//       //     BottomNavigationBarItem(icon: Icon(Icons.book), label: "Lessons"),
//       //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       //   ],
//       // ),
    
    
//     );
//   }

//   /// Plan summary card
//   Widget _buildSummaryCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: kCardFill.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: kBorder.withOpacity(0.7), width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: kGlow.withOpacity(0.35),
//             blurRadius: 14,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Left: plan icon
//           Container(
//             width: 46,
//             height: 46,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: kBorder, width: 1.5),
//             ),
//             child: const Icon(
//               Icons.workspace_premium,
//               color: kBorder,
//               size: 26,
//             ),
//           ),
//           const SizedBox(width: 12),

//           // Middle: text
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _planName,
//                   style: const TextStyle(
//                     color: kText,
//                     fontSize: 15.5,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "1-month access • Auto-renewal can be managed in settings",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 11.5,
//                     height: 1.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Right: amount
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "₹${_amount.toStringAsFixed(0)}",
//                 style: const TextStyle(
//                   color: kBorder,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 "incl. taxes",
//                 style: TextStyle(
//                   color: Colors.white60,
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds a single payment option card
//   Widget _buildPaymentOption({
//     required String method,
//     required String subtitle,
//     required IconData icon,
//   }) {
//     final bool isSelected = selectedMethod == method;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedMethod = method;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         decoration: BoxDecoration(
//           color: kCardFill,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? kBorder : Colors.white54,
//             width: 1.4,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: kGlow.withOpacity(0.5),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   )
//                 ]
//               : [],
//         ),
//         child: Row(
//           children: [
//             // Icon
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected ? kBorder : Colors.white38,
//                   width: 1.2,
//                 ),
//               ),
//               child: Icon(
//                 icon,
//                 color: isSelected ? kBorder : Colors.white70,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Texts
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     method,
//                     style: TextStyle(
//                       color: isSelected ? kBorder : kText,
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 11.5,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Tick on right when selected
//             if (isSelected)
//               const Icon(Icons.check_circle, color: kBorder, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Handle Confirm Payment click
//   void _onConfirmPayment() {
//     // Yahan tum apna actual payment flow call kar sakte ho
//     // e.g. Razorpay with method info / UPI intent / Paytm SDK

//     // Example structure:
//     if (selectedMethod == "UPI") {
//       // TODO: call your UPI payment function
//       // e.g. paymentProvider.startUpiPayment(...);
//     } else if (selectedMethod == "Paytm") {
//       // TODO: call your Paytm payment function
//     } else if (selectedMethod == "Credit Card") {
//       // TODO: call your card payment function
//     }

//     // For now just show which method was selected
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Proceeding with $selectedMethod (₹${_amount.toStringAsFixed(0)})"),
//       ),
//     );
//   }
// }
