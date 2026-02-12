import 'package:flutter/material.dart';
import 'package:inangreji_flutter/models/planModel.dart';
import 'package:inangreji_flutter/models/user_details_model.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/payment_method/paymentProvider.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  PlanModel _planModel = PlanModel();
  UserDetailsModel _userDetailsModel = UserDetailsModel();
  String _previousPaymentStatus = "";

  @override
  void initState() {
    super.initState();

    // Fetch plans + user details when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final appProvider = context.read<AppProvider>();

      _planModel = await appProvider.getPlans();
      _userDetailsModel = await appProvider.getUserDetails();

      // Listen for payment status changes
      context.read<PaymentProvider>().addListener(_handlePaymentStatusChange);
      setState(() {});
    });
  }

  void _handlePaymentStatusChange() {
    final paymentProvider = context.read<PaymentProvider>();
    final currentStatus = paymentProvider.paymentStatus;

    // Only react if status changed
    if (currentStatus.isNotEmpty && currentStatus != _previousPaymentStatus) {
      _previousPaymentStatus = currentStatus;

      // If you want, show snackbar here
      // if (currentStatus.contains("Success") || currentStatus.contains("Verified")) {
      //   showResultSnackBar(context, currentStatus, false, showIndicator: false);
      // } else if (currentStatus.contains("Failed") || currentStatus.contains("Error")) {
      //   showResultSnackBar(context, currentStatus, true, showIndicator: true);
      // }
    }
  }

  @override
  void dispose() {
    context.read<PaymentProvider>().removeListener(_handlePaymentStatusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final paymentProvider = context.watch<PaymentProvider>();

    // Global loading from provider
    if (appProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    const backgroundColor = Colors.black;
    const cardBaseColor = Colors.cyanAccent;
    const glowColor = Color(0xFF80FFFF);

    // 🔥 All plans from API
    final allPlans = _planModel.data ?? [];

    // 🔥 Filter out Trial plan (iss line ki wajah se Trial plan nahi dikhega)
    final plans = allPlans
        .where((p) =>
            (p.name ?? '').toLowerCase() != 'trial plan'.toLowerCase())
        .toList();

    return Stack(
      children: [
        // Main content
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: cardBaseColor),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              "Choose Plan",
              style: TextStyle(
                color: cardBaseColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          body: plans.isEmpty
              ? const Center(
                  child: Text(
                    "No plans available.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final isHighlighted = plan.interval == "yearly";

                    final features = plan.features ?? [];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            cardBaseColor.withOpacity(isHighlighted ? 1.0 : 0.85),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Plan title
                            Text(
                              plan.name ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: isHighlighted
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Price (only real price, NO trial price)
                            Text(
                              "₹${plan.price ?? ''} / ${plan.interval ?? ''}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Description (optional)
                            if ((plan.description ?? "").isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  plan.description ?? "",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                            // Features list
                            if (features.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: features.map((feature) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),

                            const SizedBox(height: 20),

                            // Subscribe / Select button
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: glowColor,
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.blueAccent,
                                    Colors.lightBlueAccent
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  paymentProvider.createSubscription(
                                    planId: "${plan.id}",
                                    name: _userDetailsModel.data?.email ?? "",
                                    email: _userDetailsModel.data?.email ?? "",
                                    phone:
                                        _userDetailsModel.data?.phone ?? "",
                                    totalCount: '',
                                    context: context,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  isHighlighted ? 'Choose Premium' : 'Select',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Full-screen loading overlay (when payment is processing)
        if (paymentProvider.isLoading)
          Container(
            color: Colors.black87,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
