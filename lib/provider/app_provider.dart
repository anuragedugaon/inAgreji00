// lib/provider/app_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inangreji_flutter/models/planModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reward_model.dart';
import '../models/user_details_model.dart';
import '../models/wallet_balance_model.dart';
import '../services/api_client.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';

import '../widgets/message_bubble.dart';
import 'payment_method/paymentProvider.dart';

class AppProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Map<String, String> _localizedStrings = {};
  UserDetailsModel userDetails = UserDetailsModel();

  Locale get locale => _locale;
  String translate(String key) => _localizedStrings[key] ?? key;

  bool _isLoading = false;
  bool _sinLoding=false;
  
  String? _token;

  bool get isLoading => _isLoading;
  bool get sinLoding=> _sinLoding;
  String? get token => _token;


  // ---------------- REWARDS (Mock / Local for now) ---------------- //


  int _rewardCoins = 0; // user ke coins rewards store ke liye
  int get rewardCoins => _rewardCoins;

  bool _rewardsLoading = false;
  bool get rewardsLoading => _rewardsLoading;

  String? _rewardsError;
  String? get rewardsError => _rewardsError;



Future<bool> login(String email, String password, BuildContext context) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await ApiClient.postRequest(
      '/api/login',
      {'email': email, 'password': password},
    );

    debugPrint("🔹 Login Response: $response");

    if (response['success'] == true) {
      _token = response['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      _isLoading = false;
      notifyListeners();
      debugPrint("✅ Login successful");

        if (response['success']) {
                                  // After login, fetch user details and check subscription
         final paymentProvider = context.read<PaymentProvider>();

                                  // Check subscription status from backend (best effort).
            final hasSubscription = await paymentProvider.checkSubscriptionStatus(context: context);


                                  if (hasSubscription) {
                                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(context, '/trial-start', (route) => false);
                                  }
        }

      return true;
    } else {    showResultSnackBar(context, response['message'],false);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();

    debugPrint("❌ Login error: $e");

    String message = "Something went wrong";

    // ---- Status Code Based Messages ----
    if (e.toString().contains("400")) {
      message = "Bad request. Please check your input.";
    } 
    else if (e.toString().contains("401")) {
      message = "Unauthorized. Email or password is incorrect.";
    }
    else if (e.toString().contains("403")) {
      message = "Your email is not verified.";
    }
    else if (e.toString().contains("404")) {
      message = "Server not found.";
    }
    else if (e.toString().contains("500")) {
      message = "Server error. Please try again later.";
    }
    else if (e.toString().contains("timeout")) {
      message = "Connection timeout. Check your internet.";
    }
    else if (e.toString().contains("SocketException")) {
      message = "No internet connection.";
    }

    showResultSnackBar(context, message,false);
    return false;
  }
}

// Add these methods to your AppProvider class

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'package:inangreji_flutter/provider/payment_method/paymentProvider.dart';

// Send OTP Method
Future<bool> sendOtp(String phone, BuildContext context) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await ApiClient.postRequest(
      '/api/login/send-otp',
      {'phone': phone},
    );

    debugPrint("🔹 Send OTP Response: $response");

    if (response['success'] == true) {
      _isLoading = false;
      notifyListeners();
      
      showResultSnackBar(
        context, 
        response['message'] ?? "OTP sent successfully!", 
        true
      );
      
      debugPrint("✅ OTP sent successfully");
      return true;
    } else {
      showResultSnackBar(
        context, 
        response['message'] ?? "Failed to send OTP", 
        false
      );
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();

    debugPrint("❌ Send OTP error: $e");

    String message = "Something went wrong";

    if (e.toString().contains("400")) {
      message = "Invalid phone number.";
    } 
    else if (e.toString().contains("404")) {
      message = "Please register your phone number.";
    }
    else if (e.toString().contains("500")) {
      message = "Server error. Please try again later.";
    }
    else if (e.toString().contains("timeout")) {
      message = "Connection timeout. Check your internet.";
    }
    else if (e.toString().contains("SocketException")) {
      message = "No internet connection.";
    }

    showResultSnackBar(context, message, false);
    return false;
  }
}

// Verify OTP and Login Method
Future<bool> verifyOtpAndLogin(String phone, String otp, BuildContext context) async {
  _isLoading = true;
  notifyListeners();

  try {
    final response = await ApiClient.postRequest(
      '/api/login/verify-otp',
      {
        'phone': phone,
        'otp': otp,
      },
    );

    debugPrint("🔹 Verify OTP Response: $response");

    if (response['success'] == true) {
      _token = response['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      _isLoading = false;
      notifyListeners();
      
      debugPrint("✅ OTP verified and login successful");

      // Check subscription status and navigate
      final paymentProvider = context.read<PaymentProvider>();
      final hasSubscription = await paymentProvider.checkSubscriptionStatus(context: context);

      if (hasSubscription) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/trial-start', (route) => false);
      }

      return true;
    } else {
      showResultSnackBar(
        context, 
        response['message'] ?? "Invalid OTP", 
        false
      );
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();

    debugPrint("❌ Verify OTP error: $e");

    String message = "Something went wrong";

    if (e.toString().contains("400")) {
      message = "Invalid OTP or phone number.";
    } 
    else if (e.toString().contains("401")) {
      message = "OTP is incorrect or expired.";
    }
    else if (e.toString().contains("404")) {
      message = "User not found.";
    }
    else if (e.toString().contains("500")) {
      message = "Server error. Please try again later.";
    }
    else if (e.toString().contains("timeout")) {
      message = "Connection timeout. Check your internet.";
    }
    else if (e.toString().contains("SocketException")) {
      message = "No internet connection.";
    }

    showResultSnackBar(context, message, false);
    return false;
  }
}

/// 🔹 SIGNUP / REGISTER 
/// 


Future<bool> register({
  required String name,
  required String age,
  required String gender,
  required String email,
  required String password,
  required String city,
  required String referralCode,
  required BuildContext context,
  required String phone,
}) async {
  final prefs = await SharedPreferences.getInstance();
  String? levelId = await prefs.getString('selected_level_id');
  String? purposesId = await prefs.getString('selected_purpose_id');

  _sinLoding = true;
  notifyListeners();

  final body = {
    'name': name,
    'age': age,
    'gender': gender.toLowerCase(),
    'email': email,
    'password': password,
    'city': city, // ✅ Ab ye null nahi jaega
    'purpose_id': purposesId,
    'level_id': levelId,
    'referral_code': referralCode,
    'phone': phone,
  };

  try {
    debugPrint("🔹 Register Body: $body");

    final response = await ApiClient.postRequest('/api/register', body);

    debugPrint("🔹 Register Response: $response");

    if (response['status'] == true) {
      debugPrint("✅ Registration success");
      showResultSnackBar(
        context,
        response['message']?.toString() ?? "Registered successfully",
        true,
      );

      _sinLoding = false;
      notifyListeners();
      return true;
    } else {
      // 🔥 Backend validation errors handle karo
      String errorMessage = "";

      // 1️⃣ Errors map se messages nikalo
      if (response['errors'] is Map<String, dynamic>) {
        final errors = response['errors'] as Map<String, dynamic>;
        final List<String> messages = [];

        errors.forEach((key, value) {
          if (value is List) {
            // ["The email has already been taken."]
            messages.addAll(value.map((e) => e.toString()));
          } else if (value is String) {
            messages.add(value);
          }
        });

        if (messages.isNotEmpty) {
          // Multiple errors ko line by line dikhao
          errorMessage = messages.join('\n');
        }
      }

      // 2️⃣ Agar errors nahi mile to message field se lo
      if (errorMessage.isEmpty) {
        errorMessage = response['message']?.toString() ?? "Registration failed";
      }

      debugPrint("⚠️ Registration failed: $errorMessage");
      showResultSnackBar(context, errorMessage, false);

      _sinLoding = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    debugPrint("❌ Registration error: $e");

    _sinLoding = false;
    notifyListeners();

    String message = "Something went wrong. Please try again.";

    // Status code based error messages
    if (e.toString().contains("422")) {
      message = "Invalid data. Please check all fields.";
    } else if (e.toString().contains("409")) {
      message = "This email or phone is already registered. Please login.";
    } else if (e.toString().contains("400")) {
      message = "Bad request. Please check your input.";
    } else if (e.toString().contains("500")) {
      message = "Server error. Please try again later.";
    } else if (e.toString().contains("SocketException")) {
      message = "No internet connection.";
    } else if (e.toString().contains("timeout")) {
      message = "Connection timeout. Try again.";
    }

    showResultSnackBar(context, message, false);
    return false;
  }
}


// inside PaymentProvider

bool _isWithdrawing = false;
bool get isWithdrawing => _isWithdrawing;

// 🔥 Withdrawal Request API
// inside PaymentProvider

Future<bool> requestWithdrawal({
  required int coins, // int le rahe hain
  required String accountHolderName,
  required String bankName,
  required String accountNumber,
  required String ifscCode,
  String? upiId,
  required BuildContext context,
}) async {
  try {
    _isWithdrawing = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');

    if (storedToken == null) {
      showResultSnackBar(context, "Please login again.", false);
      _isWithdrawing = false;
      notifyListeners();
      return false;
    }

    // 👇 sab values String me convert, Map<String, String>
    final Map<String, String> body = {
      "coins": coins.toString(),
      "account_holder_name": accountHolderName,
      "bank_name": bankName,
      "account_number": accountNumber.toString(),
      "ifsc_code": ifscCode,
      "upi_id": upiId ?? "",
    };

    debugPrint("📤 Withdrawal Body: $body");

    // 👇 YAHI MAIN FIX: extra /api hata diya
    final response = await ApiClient.postRequestWithAuth(
      "/withdrawal/request", // ✅ baseUrl: https://inangreji.in/api
      body,
      storedToken,
    );

    debugPrint("📥 Withdrawal Response: $response");

    final bool success =
        response['success'] == true || response['status'] == true;

    if (success) {
      final msg = response['message']?.toString() ??
          "Withdrawal request submitted successfully!";
      showResultSnackBar(context, msg, true);

      _isWithdrawing = false;
      notifyListeners();
      return true;
    } else {
      String errorMessage =
          response['message']?.toString() ?? "Withdrawal failed!";

      if (response['errors'] is Map<String, dynamic>) {
        final firstField = response['errors'].keys.first;
        final firstError = response['errors'][firstField];

        if (firstError is List && firstError.isNotEmpty) {
          errorMessage = firstError.first;
        } else if (firstError is String) {
          errorMessage = firstError;
        }
      }

      showResultSnackBar(context, errorMessage, false);
      _isWithdrawing = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    debugPrint("❌ Withdrawal error: $e");
    showResultSnackBar(
      context,
      "Something went wrong, try again!",
      false,
    );
    _isWithdrawing = false;
    notifyListeners();
    return false;
  }
}



/// 🔹 SIGNUP / REGISTER
 
 
  // Future<bool> register({
  //   required String name, 
  //   required String age,
  //   required String gender,
  //   required String email,
  //   required String password,
  //   required String city,
  // }) async {
    // final prefs = await SharedPreferences.getInstance();
    //  String? levelId = await prefs.getString('selected_level_id');
    //     String ?purpusesid=     await prefs.getString('selected_purpose_id');


  //   _sinLoding = true;

  //   notifyListeners();
  //   var header ={
  //         'name': name,
  //         'age': age,
  //         'gender': gender,
  //         'email': email,
  //         'password': password,
  //         'city': city,
  //         'purpose_id':purpusesid,
  //         'level_id':levelId
  //       };

  //   try {
  //     debugPrint("$header");
  //     final response = await ApiClient.postRequest(
  //       '/api/register',
  //       header,
  //       );

  //     debugPrint("🔹 Register Response: $response");

  //     if (response['status'] == true) {
  //       debugPrint("✅ Registration successful");
  //        _token = response['token'];
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('auth_token', _token!);
  //       _sinLoding = false;
  //       notifyListeners();
  //       return response['status'];
  //     } else {
  //       _sinLoding = false;
  //       notifyListeners();
  //       debugPrint("⚠️ Registration failed: ${response['message']}");
  //       return false;
  //     }
  //   } catch (e) {
  //     _sinLoding = false;
  //     notifyListeners();
  //     debugPrint("❌ Registration error: $e");
  //     return false;
  //   }
  // }



/// Call the password-forget endpoint with email
/// 
 /// Request password reset
  Future<bool> requestPasswordReset(String email) async {
 _isLoading = true;
    notifyListeners();
    try {
      final res = await ApiClient.postRequest(
        "/api/forget/password",
        {
          'email': email,
        },
      );

      debugPrint("🔹 Password Reset Response: $res");
_isLoading = false;
    notifyListeners();
      if (res['status'] == "success") {

        return true;
      } else {
        debugPrint("⚠️ Password reset failed: $res");
        return false;
      }
    } catch (e) {
      _isLoading = false;
    notifyListeners();
      debugPrint("❌ Password reset error: $e");
      return false;
    } finally {
 _isLoading = false;
    notifyListeners();
        }
  }

String t(String key) {
    return _localizedStrings[key] ?? key;
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('selected_language_code') ?? 'en';

    _locale = Locale(langCode);
    await _loadLanguageFile(langCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language_code', langCode);

    _locale = Locale(langCode);
    await _loadLanguageFile(langCode);

    notifyListeners();
  }

  Future<void> _loadLanguageFile(String langCode) async {
    debugPrint("change lagauge code $langCode");
    debugPrint('LANG FILE = lib/l10n/$langCode.json');

    final jsonString =
      await         rootBundle.loadString('lib/l10n/$langCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((k, v) => MapEntry(k, v.toString()));
  }

  /// 🔒 Proper Logout Implementation
  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("No token found in storage.");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await ApiClient.postRequestWithAuth(
        '/api/logout',
        {},
        storedToken,
      );

      if (response['status'] == true) {
        await prefs.remove('auth_token');
        _token = null;
        _isLoading = false;
        notifyListeners();
        debugPrint("Logout successful.");
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        debugPrint("Logout failed: ${response['message']}");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Logout error: $e");
      return false;
    }
  }

  // Get User  Lessons
  /// 📘 Fetch User Lessons
  Future<List<dynamic>> getUserLessons() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      final response = await ApiClient.getRequestWithAuth(
        '/api/get-user-lessons',
        storedToken,
      );

      if (response['status'] == true) {
        debugPrint("✅ Lessons fetched successfully");
        _isLoading = false;
        notifyListeners();
        return response['data'] ?? [];
      } else {
        debugPrint("⚠️ Failed to fetch lessons: ${response['message']}");
        _isLoading = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching lessons: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  //Get User Lesson Units
  /// 📗 Fetch User Lesson Units
  Future<List<dynamic>> getUserLessonUnits() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      final response = await ApiClient.getRequestWithAuth(
        '/api/get-user-lesson-units',
        storedToken,
      );

      if (response['status'] == true) {
        debugPrint("✅ Lesson units fetched successfully");
        _isLoading = false;
        notifyListeners();
        return response['data'] ?? [];
      } else {
        debugPrint("⚠️ Failed to fetch lesson units: ${response['message']}");
        _isLoading = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching lesson units: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// 🌍 Fetch Countries API
  Future<Object> getCountries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // ✅ API call using the existing getRequestWithAuth
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-countries',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Response is a list (not wrapped in 'data')
      if (response is List) {
        debugPrint("✅ Countries fetched successfully (${response.length})");
        return response;
      } else {
        debugPrint("⚠️ Unexpected response type: $response");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching countries: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// 📚 Fetch Lesson Categories
  Future<List<dynamic>> getLessonCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // Make GET request
      final response = await ApiClient.getRequestWithAuth(
        '/api/lesson-category',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Validate response structure
      if (response != null && response['lessonCategorys'] != null) {
        final categories = response['lessonCategorys'];
        debugPrint("✅ Lesson categories fetched: ${categories.length}");
        return categories;
      } else {
        debugPrint("⚠️ Unexpected response format: $response");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching lesson categories: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }



  /// 🌐 Fetch Available Languages (Debug Version)
  /// 🌐 Fetch Available Languages (Fixed Version)
  Future<List<dynamic>> getLanguages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Using fallback language list.");
        _isLoading = false;
        notifyListeners();

        // 🟢 fallback for first-time users or testing
        return [
          {'code': 'EN', 'name': 'English'},
          {'code': 'HI', 'name': 'Hindi'},
          {'code': 'BN', 'name': 'Bengali'},
        ];
      }

      // ✅ Corrected endpoint spelling + auth
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-language',
        storedToken,
      );

      debugPrint("🌍 Raw Language API Response: $response");

      _isLoading = false;
      notifyListeners();

      if (response is List) {
        debugPrint("✅ Languages fetched successfully (${response.length})");
        return response;
      }

      if (response is Map<String, dynamic>) {
        if (response['data'] is List) {
          return List<dynamic>.from(response['data']);
        }
        if (response['languages'] is List) {
          return List<dynamic>.from(response['languages']);
        }
      }

      debugPrint("⚠️ Unexpected language response format: $response");
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching languages: $e");

      // ✅ Show fallback on error
      _isLoading = false;
      notifyListeners();
      return [
        {'code': 'EN', 'name': 'English'},
        {'code': 'HI', 'name': 'Hindi'},
        {'code': 'BN', 'name': 'Bengali'},
      ];
    }
  }

  /// 🎯 Fetch Available Purposes
  Future<List<dynamic>> getPurposes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getRequestWithAuth('/api/get-purposes');
      debugPrint("🌍 Raw Purpose API Response: $response");

      _isLoading = false;
      notifyListeners();

      // ✅ Check response format
      if (response is Map<String, dynamic> && response['purposes'] is List) {
        final purposes = response['purposes'];
        debugPrint("✅ Purposes fetched successfully (${purposes.length})");
        return List<dynamic>.from(purposes);
      }

      debugPrint("⚠️ Unexpected response format: $response");
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching purposes: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }




  /// 🧠 Fetch Available Levels
  Future<List<dynamic>> getLevels() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.getRequestWithAuth('/api/get-levels');
      debugPrint("🌍 Raw Levels API Response: $response");

      _isLoading = false;
      notifyListeners();

      // ✅ Extract levels list from JSON
      if (response is Map<String, dynamic> && response['levels'] is List) {
        final levels = response['levels'];
        debugPrint("✅ Levels fetched successfully (${levels.length})");
        return List<dynamic>.from(levels);
      }

      debugPrint("⚠️ Unexpected response format: $response");
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching levels: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }


  /// 🏙️ Fetch All Cities
  Future<List<dynamic>> getCities() async {
    _isLoading = true;
    notifyListeners();

    // 🔁 Fallback static cities list so the app always works
    const fallbackCities = [
      {'name': 'Bengaluru'},
      {'name': 'Mumbai'},
      {'name': 'Delhi'},
      {'name': 'Hyderabad'},
      {'name': 'Pune'},
      {'name': 'Chennai'},
      {'name': 'Kolkata'},
      {'name': 'Ahmedabad'},
    ];

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      // if (storedToken == null || storedToken.isEmpty) {
      //   debugPrint("❌ No token found. Using fallback city list.");
      //   _isLoading = false;
      //   notifyListeners();
      //   return fallbackCities;
      // }

      // ✅ API call using token
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-cities',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ The API returns a map with key 'cities'
      if (response is Map<String, dynamic> &&
          response['cities'] is List &&
          (response['cities'] as List).isNotEmpty) {
        final cities = List<dynamic>.from(response['cities']);
        debugPrint("🏙️ Cities fetched successfully (${cities.length})");
        return cities;
      } else {
        debugPrint("⚠️ Unexpected cities response: $response, using fallback city list.");
        return fallbackCities;
      }
    } catch (e) {
      debugPrint("❌ Error fetching cities: $e, using fallback city list.");
      _isLoading = false;
      notifyListeners();
      return fallbackCities;
    }
  }

  /// 🏆 Fetch Achievements
  Future<List<dynamic>> getAchievements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // ✅ Fetch data from API
      final response = await ApiClient.getRequestWithAuth(
        '/api/achievements',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Expected structure: { "achievements": [ ... ] }
      if (response is Map<String, dynamic> &&
          response['achievements'] is List) {
        final achievements = response['achievements'];
        debugPrint(
            "🏆 Achievements fetched successfully (${achievements.length})");
        return List<dynamic>.from(achievements);
      } else {
        debugPrint("⚠️ Unexpected achievements response: $response");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching achievements: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// 🧠 Fetch Idioms
  Future<List<dynamic>> getIdioms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // ✅ Call idioms API
      final response = await ApiClient.getRequestWithAuth(
        '/api/idioms',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Expected structure: { "idioms": [ ... ] }
      if (response is Map<String, dynamic> && response['idioms'] is List) {
        final idioms = response['idioms'];
        debugPrint("🧠 Idioms fetched successfully (${idioms.length})");
        return List<dynamic>.from(idioms);
      } else {
        debugPrint("⚠️ Unexpected idioms response: $response");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching idioms: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// 🎯 Fetch User Goals
  Future<List<dynamic>> getGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // ✅ Make authenticated GET request
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-goals',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Expected response: { "goals": [...] }
      if (response is Map<String, dynamic> && response['goals'] is List) {
        final goals = response['goals'];
        debugPrint("🎯 Goals fetched successfully (${goals.length})");
        return List<dynamic>.from(goals);
      } else {
        debugPrint("⚠️ Unexpected goals response format: $response");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error fetching goals: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  ///Grammar Tips
  ///  /// 🧩 Fetch Grammar Tips
  Future<List<dynamic>> getGrammarTips() async {
    _isLoading = true;
    notifyListeners();

    try {
      // ✅ Get stored token
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return [];
      }

      // ✅ API call (endpoint starts with /api)
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-grammar-tips',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      // ✅ Expected JSON format:
      // { "status": true, "message": "Grammar Tips fetched successfully", "data": [] }
      if (response is Map<String, dynamic>) {
        if (response['status'] == true) {
          debugPrint("✅ Grammar Tips fetched successfully");
          return List<dynamic>.from(response['data'] ?? []);
        } else {
          debugPrint("⚠️ Failed: ${response['message']}");
          return [];
        }
      }

      debugPrint("⚠️ Unexpected grammar tips response: $response");
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching grammar tips: $e");
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// ⏰ Set Daily Reminder (Final Fixed)
  Future<bool> setDailyReminder(String reminderTime) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');
      debugPrint("🔐 Loaded token: $storedToken");

      if (storedToken == null || storedToken.isEmpty) {
        debugPrint("❌ No auth token found. Please log in again.");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint(
          '🌐 Sending reminder to: https://inangreji.in/api/set-reminder');
      debugPrint('🕒 Reminder time: $reminderTime');

      final response = await ApiClient.postRequestWithAuth(
        '/api/set-reminder',
        {'reminder_time': reminderTime},
        storedToken.trim(),
      );

      debugPrint(
          "🔔 Reminder API Response (Full JSON): ${jsonEncode(response)}");

      _isLoading = false;
      notifyListeners();

      final message = response['message']?.toString().toLowerCase() ?? '';
      final success = response['status'] == true ||
          response['success'] == true ||
          response['status'] == 'true' ||
          response['success'] == 'true' ||
          message.contains('success');

      if (success) {
        debugPrint("✅ Reminder set successfully: $message");
        return true;
      } else {
        debugPrint("⚠️ Failed to set reminder: $message");
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("❌ Error setting reminder: $e");
      return false;
    }
  }

  /// ⏰ Get Daily Reminder (Final Fixed)
  Future<Map<String, dynamic>?> getReminder() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null || storedToken.isEmpty) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // ✅ No need to prefix /api (ApiClient already handles it)
      final response = await ApiClient.getRequestWithAuth(
        '/api/get-reminder', // keep /api here (since getRequestWithAuth expects full)
        storedToken,
      );

      debugPrint("🕒 Reminder GET Response: $response");

      _isLoading = false;
      notifyListeners();

      if (response is Map<String, dynamic> && (response['status'] ?? false)) {
        debugPrint("✅ Reminder fetched successfully");
        return response['data'];
      } else {
        debugPrint("⚠️ Failed to fetch reminder data: $response");
        return null;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("❌ Error fetching reminder: $e");
      return null;
    }
  }



Future<PlanModel> getPlans() async {
  _isLoading = true;
  notifyListeners();
   final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

  try {
    final response = await ApiClient.getRequestWithAuth('/api/plans',storedToken);
    debugPrint("🌍 Raw API Response: $response");

    _isLoading = false;
    notifyListeners();

    // Assume response is a Map<String, dynamic>
    if (response is Map<String, dynamic>) {
      // If the JSON key for list is 'data', else adapt accordingly
      return PlanModel.fromJson(response);
    } else {
      debugPrint("⚠️ Unexpected response type: ${response.runtimeType}");
      return PlanModel();
    }
  } catch (e) {
    debugPrint("❌ Error fetching plans: $e");
    _isLoading = false;
    notifyListeners();
    return PlanModel();
  }
}



Future<UserDetailsModel> getUserDetails() async {
  _isLoading = true;
  notifyListeners();

  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('auth_token');

  try {
    /// CALL API (Authenticated GET)
    final response = await ApiClient.getRequestWithAuth(
      '/api/user-details',
      storedToken,
    );

    debugPrint("🌍 Raw User Details Response: $response");

    _isLoading = false;
    notifyListeners();

    if (response is Map<String, dynamic>) {

      userDetails = UserDetailsModel.fromJson(response);
      notifyListeners();
      return userDetails;
    } else {
      debugPrint("⚠️ Unexpected response type: ${response.runtimeType}");
      return UserDetailsModel(
        success: false,
        message: "Invalid response",
      );
    }
  } catch (e) {
    debugPrint("❌ Error fetching user details: $e");

    _isLoading = false;
    notifyListeners();

    return UserDetailsModel(
      success: false,
      message: "Failed to load user details",
    );
  }
}
















  bool referralsLoading = false;
  String? referralsError;
  List<ReferralEntry> referralHistory = [];

  double get totalReferralReward {
    return referralHistory.fold(
      0.0,
      (sum, entry) => sum + (double.tryParse(entry.rewardAmount) ?? 0.0),
    );
  }

  /// 🧩 Fetch Referral History
  Future<void> fetchReferralHistory() async {
    referralsLoading = true;
    referralsError = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        referralsLoading = false;
        referralsError = "No token found. Please log in first.";
        notifyListeners();
        return;
      }

      final response = await ApiClient.getRequestWithAuth(
        '/api/referral/history',
        storedToken,
      );

      debugPrint("🎁 Referral API Response: $response");

      referralsLoading = false;

      if (response is Map<String, dynamic> &&
          response['status'] == true &&
          response['data'] is Map<String, dynamic>) {
        final data = response['data'] as Map<String, dynamic>;
        final list = data['data'] as List<dynamic>? ?? [];

        referralHistory = list
            .map((item) => ReferralEntry.fromJson(item as Map<String, dynamic>))
            .toList();

        notifyListeners();
      } else {
        referralsError = "Unexpected referral response format.";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Error fetching referral history: $e");
      referralsLoading = false;
      referralsError = "Failed to load referral history.";
      notifyListeners();
    }
  }











// lib/provider/app_provider.dart


// ...

  /// 💰 Fetch Wallet Balance + Coins Detail
  Future<WalletBalanceModel?> getWalletBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('auth_token');

      if (storedToken == null) {
        debugPrint("❌ No token found. Please log in first.");
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // GET /api/wallet/balance
      final response = await ApiClient.getRequestWithAuth(
        '/api/wallet/balance',
        storedToken,
      );

      _isLoading = false;
      notifyListeners();

      debugPrint("💰 Wallet API Response: $response");

      if (response is Map<String, dynamic> &&
          response['status'] == true &&
          response['data'] is Map<String, dynamic>) {
        final data = response['data'] as Map<String, dynamic>;
        return WalletBalanceModel.fromJson(data);
      } else {
        debugPrint("⚠️ Unexpected wallet response format: $response");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error fetching wallet balance: $e");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }



}
