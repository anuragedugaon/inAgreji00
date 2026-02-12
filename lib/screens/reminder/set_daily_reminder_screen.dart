import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/message_bubble.dart';

class SetDailyReminderScreen extends StatefulWidget {
  const SetDailyReminderScreen({super.key});

  @override
  State<SetDailyReminderScreen> createState() => _SetDailyReminderScreenState();
}

class _SetDailyReminderScreenState extends State<SetDailyReminderScreen> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 30);
  bool isLoading = true;

  // 🎨 Theme colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kGlow = Color(0xFF80FFFF);

  @override
  void initState() {
    super.initState();
    _fetchExistingReminder();
  }

  /// 🕒 Fetch existing reminder from backend
  Future<void> _fetchExistingReminder() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final reminderData = await provider.getReminder();

    if (reminderData != null && reminderData['reminder_time'] != null) {
      final timeParts = reminderData['reminder_time'].split(':');
      if (timeParts.length >= 2) {
        final hour = int.tryParse(timeParts[0]) ?? 10;
        final minute = int.tryParse(timeParts[1]) ?? 30;
        setState(() {
          selectedTime = TimeOfDay(hour: hour, minute: minute);
        });
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kAccent),
          onPressed: () {
            if (mounted) Navigator.pop(context, '/noti');
          },
        ),
        centerTitle: true,
        title: const Text(
          "Set a Daily Reminder",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 😊⏰ Emojis
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("😊", style: TextStyle(fontSize: 32)),
                      SizedBox(width: 16),
                      Text("⏰", style: TextStyle(fontSize: 32)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🕓 Current reminder time
                  Text(
                    "Current reminder time: ${selectedTime.format(context)}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ⌛ Cupertino Time Picker
                  SizedBox(
                    height: 200,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: kAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime(
                          2024,
                          1,
                          1,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        use24hFormat: false,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() {
                            selectedTime = TimeOfDay(
                              hour: newTime.hour,
                              minute: newTime.minute,
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔘 Set Reminder Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final savedToken = prefs.getString('auth_token');
                        debugPrint(
                            '🪪 Token before setting reminder: $savedToken');

                        final formattedTime =
                            "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                        debugPrint('⏰ Sending reminder time: $formattedTime');

                        // 🌀 Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(color: kAccent),
                          ),
                        );

                        // 📡 Call API
                        final success =
                            await provider.setDailyReminder(formattedTime);

                        // 🧹 Remove loader safely
                        if (mounted) Navigator.of(context).pop();

                        // ✅ Handle response
                        if (success) {
                       
                                       showResultSnackBar(context, "Reminder set successfully!",false);


                          // 🔙 Safely go back
                          if (mounted) Navigator.pop(context);
                        } else {
                      

                                           showResultSnackBar(context, "Failed to set reminder. Try again.",false);

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: kAccent, width: 1.5),
                        ),
                        elevation: 8,
                        shadowColor: kGlow.withOpacity(0.6),
                      ),
                      child: const Text(
                        "Set Reminder",
                        style: TextStyle(
                          color: kAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
