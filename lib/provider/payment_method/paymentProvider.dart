import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/razerPay_plane_model.dart';
import '../../widgets/message_bubble.dart';

class PaymentProvider extends ChangeNotifier {
  late Razorpay _razorpay;
  BuildContext? _context;
    final keyId = "rzp_test_RnvfnV6owmQUzo";
    final secretKey = "KiOjpqQT9MlOawUKhM6TE43z";
  String baseUrl = "https://admin.inangreji.in/api/"; // ⚠️ change your domain

  bool isLoading = false;
  String paymentStatus = "";
  String paymentId = "";
  String? subscriptionId; // 🚀 store subscription id
  String? planIds; // 🚀 store trial id

  // 🚀 Initialize Razorpay listeners
  PaymentProvider() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }





    
  // 🔥 1) Create Subscription using PHP
// 🔥 Create Subscription
Future<void> createSubscription({
  required String planId,
  required String name,
  required String email,
  required String phone,
  required String totalCount,
  BuildContext? context,
}) async {
  _context = context;
  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('auth_token');

  try {
    isLoading = true;
    planIds = planId;
    notifyListeners();

    final res = await http.post(
      Uri.parse("${baseUrl}create-subscription"),
      headers: {
        'Authorization': 'Bearer $storedToken',
      },
      body: {
        "plan_id": planId,
      },
    );

    final data = jsonDecode(res.body);
    debugPrint("Create Subscription Response: $data");

    // Case 1: User already has a subscription or trial active 🚫
    // if (data["success"] == tr) {
    //   paymentStatus = "You already have a subscription!";
      
    //   if (context != null) {
    //     showResultSnackBar(
    //       // ignore: use_build_context_synchronously
    //       context,
    //       "⚠️ You already have an active subscription!",
    //       true,
    //       showIndicator: false,
    //     );

    //     // Optional: Store sub_active flag

    //     // Redirect user to home
    //     Future.delayed(const Duration(seconds: 1), () {
    //       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //     });
    //   }

    //   isLoading = false;
    //   notifyListeners();
    //   return; // ❌ Stop processing here
    // }
final subscriptionData = data["data"];
final razorpay = subscriptionData?["razorpay_subscription"];
final String? razorSubId = razorpay?["id"];
final String? razorPlanId = razorpay?["plan_id"];
final String? razorStatus = razorpay?["status"];

    // Case 2: Subscription created successfully
    final gatewayId = razorSubId;

    if (gatewayId != null) {
      subscriptionId = gatewayId;
      if (context != null) {
        showResultSnackBar(
          context,
          "✅ Subscription created! Opening payment...",
          true,
          showIndicator: true,
        );
      }
      _openSubscriptionCheckout(name: name, email: email, phone: phone);
    } else {
      paymentStatus = "Subscription Creation Failed ❌";
      if (context != null) {
        showResultSnackBar(
          context,
          "❌ Subscription creation failed",
          false,
          showIndicator: false,
        );
      }
    }
  } catch (e) {
    paymentStatus = "Server Error ❗";
    debugPrint("Subscription Creation Failed: $e");

    if (context != null) {
      showResultSnackBar(
        context,
        "❌ Error: ${e.toString()}",
        false,
        showIndicator: false,
      );
    }
  }

  isLoading = false;
  notifyListeners();
}


  // 🚪 2) Open Razorpay Subscription Checkout
  void _openSubscriptionCheckout({
    required String name,
    required String email,
    required String phone,
  }) {
    var options = {
      "key": keyId,  // ⚠️ Replace
      "subscription_id": subscriptionId,
      "name": name,
      "description": "Subscription Payment",
      "prefill": {
        "contact": phone,
         "email": email},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("CHECKOUT ERROR: $e");
    }
  }

  // 🎉 3) On Successful Payment
  void _handleSuccess(PaymentSuccessResponse response) async {
    paymentId = response.paymentId!;
    paymentStatus = "Subscription Payment Successful 🎉";
  //       print('Razorpay Response ==> "  ${jsonDecode(response.toString())} r"');
  //       Map<String, dynamic> data = {
  //   "payment_id": response.paymentId,
  //   "order_id": response.orderId,
  //   "signature": response.signature,
  // };

  debugPrint("Razorpay Payment Success ==> ${response.paymentId}");
  debugPrint("Razorpay Order ID ==> ${response.orderId}");
  debugPrint("Razorpay Signature ==> ${response.signature}");



    await verifySubscription(
      paymentId: response.paymentId!,
      signature: response.signature,
      subscriptionId: subscriptionId,
      context: _context,
    );
    notifyListeners();
  }

  // ❌ 4) On Failed Payment
  void _handleError(PaymentFailureResponse response) {
    paymentStatus = "Subscription Payment Failed ❌";
    notifyListeners();
  }

  // 💰 5) Wallet Payments
  void _handleExternalWallet(ExternalWalletResponse response) {
    paymentStatus = "Wallet Selected: ${response.walletName}";
    notifyListeners();
  }

  // 🔐 6) Verify Subscription Payment with PHP
 
 
 
 Future<void> verifySubscription({
  required String paymentId,
  required String? signature,
  required String? subscriptionId,
  BuildContext? context,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('auth_token');

  debugPrint("Verifying Subscription: ${{
    "razorpay_subscription_id": subscriptionId,
    "razorpay_payment_id": paymentId,
    "razorpay_signature": signature,
    "plan_id": planIds,
  }}");

  try {
    final res = await http.post(
      Uri.parse("${baseUrl}verify-payment"),
      headers: {
        'Authorization': 'Bearer $storedToken',
        'Accept': 'application/json',
      },
      body: {
        "razorpay_subscription_id": subscriptionId,
        "razorpay_payment_id": paymentId,
        "razorpay_signature": signature,
        "plan_id": planIds,
      },
    );

    debugPrint("Verify Subscription Raw Response: ${res.body}");

    final decoded = jsonDecode(res.body);

    // 🔹 Top level fields
    final bool success = decoded['success'] == true;
    final String backendMessage =
        decoded['message']?.toString() ?? 'Unknown response';

    // 🔹 Nested data object (can be null)
    final data = decoded['data'] ?? {};

    // ✅ Now read from inside "data"
    final isSubscribed =
        data["is_subscribed"]?.toString() == "1"; // ← correct place
    final String subscriptionStatus =
        data["subscription_status"]?.toString() ?? '';
    final String? subscriptionIdFromApi =
        data["subscription_id"]?.toString();
    final plan = data["plan"] ?? {};
    final period = data["period"] ?? {};

    debugPrint("Verify Subscription Parsed: success=$success, "
        "is_subscribed=$isSubscribed, status=$subscriptionStatus, "
        "subscription_id=$subscriptionIdFromApi, plan=$plan, period=$period");

    if (success && isSubscribed) {
      paymentStatus = "Subscription Verified ✔ ($subscriptionStatus)";

      if (context != null) {
        showResultSnackBar(
          context,
          backendMessage.isNotEmpty
              ? backendMessage
              : "✅ Payment Verified Successfully!",
          true,
          showIndicator: false,
        );

        // Persist subscription active flag so app routing knows user is subscribed

        // Navigate to home and clear previous routes so user doesn't return to splash/trial
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } else {
      paymentStatus = "Verification Failed ❌";
      if (context != null) {
        showResultSnackBar(
          context,
          "❌ Verification Failed: $backendMessage",
          false,
          showIndicator: false,
        );
      }
    }
  } catch (e) {
    paymentStatus = "Verification Server Error ❗";
    if (context != null) {
      showResultSnackBar(
        context,
        "❌ Verification Error: ${e.toString()}",
        false,
        showIndicator: false,
      );
    }
  }

  notifyListeners();
}


// Future<RazorpayPlansResponse?> getPlans() async {
//   try {


//     final authString = base64Encode(utf8.encode("$keyId:$secretKey"));

//     final response = await http.get(
//       Uri.parse("https://api.razorpay.com/v1/plans"),
//       headers: {
//         "Authorization": "Basic $authString",
//       },
//     );

//     if (response.statusCode == 200) {
//       print("Plans Response: ${response.body}");

//       final jsonData = jsonDecode(response.body);
//       final model = RazorpayPlansResponse.fromJson(jsonData);

//       return model;
//     } else {
//       print("⚠️ API Error: ${response.statusCode} — ${response.body}");
//       return null;
//     }
//   } catch (e) {
//     print("❌ Exception: $e");
//     return null;
//   }
// }



  /// Check subscription status for the logged-in user.
  ///
  /// NOTE: This uses a generic endpoint `${baseUrl}subscription-status`. If your
  /// backend uses a different path or response shape, adjust accordingly.
 
Future<bool> checkSubscriptionStatus({BuildContext? context}) async {
  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('auth_token');

  try {
    final res = await http.get(
      Uri.parse("${baseUrl}subscription/status"),
      headers: {
        'Authorization': 'Bearer $storedToken',
      },
    );

    final data = jsonDecode(res.body);
    debugPrint('Subscription status response: $data');

    if (data is Map<String, dynamic>) {
      final int isSub = int.tryParse(data["is_subscribed"]?.toString() ?? '0') ?? 0;
      final subscriptionStatus = data["subscription_status"]?.toString() ?? "none";

      if (isSub == 1) {
        // Save subscription flag in local storage
        // // If subscription object exists, extract ID
        // if (data.containsKey('subscription') &&
        //     data['subscription'] is Map &&
        //     data['subscription']['gateway_subscription_id'] != null) {
        //   subscriptionId =
        //       data['subscription']['gateway_subscription_id'].toString();
        // }

        if (context != null) {
          // showResultSnackBar(
          //   context,
          //   "🎉 Subscription active ($subscriptionStatus)",
          //   true,
          //   showIndicator: false,
          // );
        }

        return true; // USER SUBSCRIBED 🔥
      }
    }

    // If not subscribed
    await prefs.setBool('sub_active', false);
   
    return false;
  } catch (e) {
    debugPrint('Error checking subscription: $e');

 

    return false;
  }
}


}





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpaySubscriptionService {
  // --------------------------------------------------------
  // REQUIRED KEYS (PUT SECRET ON YOUR SYSTEM ONLY)
  // --------------------------------------------------------
  final String keyId = "rzp_test_RnvfnV6owmQUzo";
  final String keySecret = "KiOjpqQT9MlOawUKhM6TE43z"; // <--- ADD YOUR SECRET
  final String planId = "plan_RnvlUeZSzfwAHK";

  late Razorpay _razorpay;
  BuildContext? _context;

  // --------------------------------------------------------
  // INITIALIZE RAZORPAY LISTENERS
  // --------------------------------------------------------
  void initRazorpay() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  /// Store context for use in payment callbacks
  void setContext(BuildContext context) {
    _context = context;
  }

  // --------------------------------------------------------
  // 1. CREATE SUBSCRIPTION USING API
  // --------------------------------------------------------
  Future<String?> createSubscription(String plan) async {
    final String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    final url = Uri.parse("https://api.razorpay.com/v1/subscriptions");

    final response = await http.post(
      url,
      headers: {
        "Authorization": basicAuth,
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "plan_id": plan,
        "customer_notify": true,
        "total_count": 12,
        "quantity": 1
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data["id"]; // subscription_id
    } else {
      return null;
    }
  }

  // --------------------------------------------------------
  // 2. OPEN CHECKOUT FOR SUBSCRIPTION
  // --------------------------------------------------------
  void openCheckout(String subscriptionId) {
    var options = {
      'key': keyId,
      'subscription_id': subscriptionId,
      'name': 'Your App Name',
      'description': 'Subscription Plan',
      'prefill': {
        'email': 'test@example.com',
        'contact': '9999999999',
      },
      'remember_customer': true,
    };

    _razorpay.open(options);
  }

  // --------------------------------------------------------
  // CALLBACKS (SUCCESS / ERROR)
  // --------------------------------------------------------
  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    print("PAYMENT SUCCESS: ${response.paymentId}");
    
    // Mark subscription as active in SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sub_active', true);
    } catch (_) {}
    
    // Navigate to home and clear navigation stack if context is available
    if (_context != null) {
      Navigator.pushNamedAndRemoveUntil(_context!, '/home', (route) => false);
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    print("PAYMENT FAILED: ${response.code} - ${response.message}");
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: ${response.walletName}");
  }
}
