import 'package:flutter/material.dart';

class GrammarMasterScreen extends StatelessWidget {
  const GrammarMasterScreen({super.key});

  // Define theme constants for reusability
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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Grammar Mastery",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔹 Flow Chart (Sentences > Verbs/Nouns > Present/Pronouns)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNode("Sentences", isActive: true),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNode("Verbs", isActive: true),
                      _buildNode("Nouns", isActive: false),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          _buildCheckNode("Present", isCompleted: true),
                          const SizedBox(height: 12),
                          _buildCheckNode("", isCompleted: false), // Empty placeholder
                        ],
                      ),
                      Column(
                        children: [
                          _buildCheckNode("", isCompleted: false),
                          const SizedBox(height: 12),
                          _buildNode("Pronouns", isActive: false),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle confirmation action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(color: kAccent, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                  shadowColor: kAccent.withOpacity(0.5),
                ),
                child: const Text(
                  "Confirm ping",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kAccent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 🔹 Builds a node (bubble style with glow)
  Widget _buildNode(String label, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: isActive ? kAccent.withOpacity(0.15) : Colors.transparent,
            border: Border.all(
              color: isActive ? kAccent : Colors.grey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: kAccent.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? kAccent : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Builds a check node (completed task with a tick mark)
  Widget _buildCheckNode(String label, {bool isCompleted = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isCompleted ? kAccent.withOpacity(0.2) : Colors.grey.shade800,
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.lock,
            color: isCompleted ? kAccent : Colors.grey,
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isCompleted ? kAccent : Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
  }
}
