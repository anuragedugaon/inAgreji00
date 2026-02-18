import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/routes/app_routes.dart';
import 'package:inangreji_flutter/services/api_client.dart';
import 'package:inangreji_flutter/widgets/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Toggle states
  bool micAccess = true;
  bool notifications = true;
  bool language = true;

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kText = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () => Navigator.pop(context, AppRoutes.menu),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Mic Access Toggle
            _buildToggleRow("Mic Access", micAccess, (value) {
              setState(() => micAccess = value);
            }),
            const SizedBox(height: 20),

            // ✅ Notifications Toggle
            _buildToggleRow("Notifications", notifications, (value) {
              setState(() => notifications = value);
            }),
            const SizedBox(height: 20),

            // ✅ Language Toggle
            _buildToggleRow("Language", language, (value) {
              setState(() => language = value);
            }),
 const SizedBox(height: 20),

            _buildLogoutRow(() async {
              print("Logout clicked!");
              await clearAllPrefs();

              // your logout logic:
              Navigator.pushReplacementNamed(context, "/login");
            }),
            const SizedBox(height: 20),

            _buildDeleteAccountRow(() async {
              final confirm = await _showDeleteConfirmDialog(context);
              if (confirm != true) return;
              await _deleteAccount(context);
            }),
            const Spacer(),
            

            // ✅ Version Footer
            const Text(
              "Version 1.0.1",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  
  
  Future<void> clearAllPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("All SharedPreferences data cleared!");
}

  Future<bool?> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kBackground,
          title: const Text(
            "Delete Account",
            style: TextStyle(color: kAccent, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "This will permanently delete your account. Are you sure?",
            style: TextStyle(color: kText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel", style: TextStyle(color: kText)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  Future<int?> _resolveUserId(BuildContext context) async {
    final appProvider = context.read<AppProvider>();
    final existingId = appProvider.userDetails.data?.id;
    if (existingId != null) return existingId;

    final details = await appProvider.getUserDetails();
    return details.data?.id;
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      showResultSnackBar(context, "Please login again.", false);
      return;
    }

    final userId = await _resolveUserId(context);
    if (userId == null) {
      showResultSnackBar(context, "Unable to find user ID.", false);
      return;
    }

    try {
      showResultSnackBar(
        context,
        "Deleting account...",
        true,
        showIndicator: true,
      );

      final response = await ApiClient.postAiRequestWithAuth(
        '/delete-account',
        {'user_id': userId},
        token,
      );

      final success = response['success'] == true;
      final message = response['message'] ??
          (success ? "Account deleted successfully." : "Delete failed.");
      showResultSnackBar(context, message, success);

      if (success) {
        await clearAllPrefs();
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch (e) {
      showResultSnackBar(context, "Delete failed. Please try again.", false);
    }
  }
  /// ✅ Toggle Row Builder
  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: kAccent, fontSize: 16),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: kAccent,
          inactiveTrackColor: Colors.grey.shade700,
        ),
      ],
    );
  }

Widget _buildLogoutRow(VoidCallback onLogout) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Logout",
        style: TextStyle(color: kAccent, fontSize: 16),
      ),

      // LOGOUT BUTTON
      ElevatedButton(
        onPressed: onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Sign Out"),
      ),
    ],
  );
}

Widget _buildDeleteAccountRow(VoidCallback onDelete) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Delete Account",
        style: TextStyle(color: Colors.redAccent, fontSize: 16),
      ),

      ElevatedButton(
        onPressed: onDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Delete"),
      ),
    ],
  );
}


}
