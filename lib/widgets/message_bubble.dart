// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isFading; // 👈 add this

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUser,
    this.isFading = false, // 👈 default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color normalColor = isUser ? Colors.blue[800]! : Colors.green[800]!;
    final Color fadedColor = Colors.grey[500]!;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'You' : 'AI Teacher',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isUser ? normalColor : Colors.green[800],
              ),
            ),
            const SizedBox(height: 4),

            // 🎨 Fade animation for message text
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: TextStyle(
                fontSize: 16,
                color: isFading ? fadedColor : normalColor,
              ),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}




/// Reusable attractive SnackBar based on correctness
void showResultSnackBar(BuildContext context, 
   String message,
   bool isCorrect, // true = green, false = red
   {bool showIndicator = false} // optional loading indicator
) {
  // Colors automatically based on correctness
  final Color borderColor = isCorrect ?
   Colors.greenAccent : Colors.redAccent;
  final List<Color> gradientColors = isCorrect
      ? [Color(0xFF00FF7F), Color(0xFF00C851)] // green gradient
      : [Color(0xFFFF4D4D), Color(0xFFB30000)]; // red gradient
  final Color textColor = Colors.white;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: showIndicator ? Duration(seconds: 5) : Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIndicator) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
