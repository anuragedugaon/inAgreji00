// lib/service/api_client.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://admin.inangreji.in"; // ✅ Base URL

  /// 🔹 Generic POST Request (No Auth)
  static Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    debugPrint('➡️ POST: $url');
    debugPrint('➡️ Body: $body');

    final response = await http.post(url, headers: headers, body: body);
    debugPrint('⬅️ Response: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  /// 🔹 Generic POST Request (With Auth)
  static Future<Map<dynamic, dynamic>> postRequestWithAuth(
      String endpoint,dynamic body, String token) async {
    final url = Uri.parse('$baseUrl/api$endpoint');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };

    debugPrint('➡️ POST (Auth): $url');
    final response = await http.post(url, headers: headers, body: body);
    debugPrint('⬅️ Response: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Auth request failed: ${response.statusCode}');
    }
  }

  /// 🔹 Generic GET Request (With or Without Auth)
  static Future<dynamic> getRequestWithAuth(String endpoint,
      [String? token]) async {
    // ✅ Automatically add /api if not present
        debugPrint('🌍 T0ken: $token');

    final formattedEndpoint =
        endpoint.startsWith('/api') ? endpoint : '/api$endpoint';
    final url = Uri.parse('$baseUrl$formattedEndpoint');

    debugPrint('🌍 GET: $url');

    final headers = {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    debugPrint('📩 Status: ${response.statusCode}');
    debugPrint('📩 Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }


/// 🔹 Generic POST Request (With Auth) — JSON FIXED
static Future<Map<String, dynamic>> postAiRequestWithAuth(
  String endpoint,
  Map<String, dynamic> body,
  String token,
) async {
  final url = Uri.parse('$baseUrl/api$endpoint');

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json', // ✅ FIX
    'Accept': 'application/json',
  };

  debugPrint('➡️ POST (Auth): $url');
  debugPrint('➡️ BODY(JSON): ${jsonEncode(body)}');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body), // ✅ FIX
  );
  debugPrint('➡️ BODY(JSON): ${jsonEncode(response.body)}');

  debugPrint('⬅️ Status: ${response.statusCode}');
  debugPrint('⬅️ Response: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception(
        'Auth request failed: ${response.statusCode} ${response.body}');
  }
}

/// 🔹 Generic POST Request (With Auth) — accepts any JSON-encodable body (Map or List)
static Future<dynamic> postAiRequestWithAuthRaw(
  String endpoint,
  dynamic body,
  String token,
) async {
  final url = Uri.parse('$baseUrl/api$endpoint');

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  debugPrint('➡️ POST (Auth RAW): $url');
  debugPrint('➡️ BODY(JSON RAW): ${jsonEncode(body)}');

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  debugPrint('⬅️ Status: ${response.statusCode}');
  debugPrint('⬅️ Response: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return response.body;
    }
  } else {
    throw Exception('Auth request failed: ${response.statusCode} ${response.body}');
  }
}


}
