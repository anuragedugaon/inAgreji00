import 'package:flutter/material.dart';

class AccuracyHeatmapScreen extends StatelessWidget {
  const AccuracyHeatmapScreen({super.key});

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kText = Colors.white;

  // Fake heatmap data (rows = weeks, cols = days)
  final List<List<int>> heatmapData = const [
    [62, 78, 84, 87, 95, 97, 65],
    [84, 78, 84, 87, 95, 97, 65],
    [92, 84, 78, 87, 96, 99, 61],
    [65, 78, 84, 87, 95, 97, 92],
  ];

  Color _getHeatmapColor(int value) {
    if (value < 70) return Colors.redAccent;
    if (value < 85) return Colors.orangeAccent;
    if (value < 95) return Colors.greenAccent.shade400;
    return Colors.cyanAccent;
  }

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
        title: const Text(
          "Accuracy Heatmap",
          style: TextStyle(
            color: kAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Heatmap Grid
            Expanded(
              child: Column(
                children: [
                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("S", style: TextStyle(color: kText)),
                      Text("M", style: TextStyle(color: kText)),
                      Text("T", style: TextStyle(color: kText)),
                      Text("W", style: TextStyle(color: kText)),
                      Text("T", style: TextStyle(color: kText)),
                      Text("F", style: TextStyle(color: kText)),
                      Text("S", style: TextStyle(color: kText)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Grid with values
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: heatmapData.length * 7,
                      itemBuilder: (context, index) {
                        int row = index ~/ 7;
                        int col = index % 7;
                        int value = heatmapData[row][col];

                        return Container(
                          decoration: BoxDecoration(
                            color: _getHeatmapColor(value).withOpacity(0.2),
                            border: Border.all(color: _getHeatmapColor(value), width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: _getHeatmapColor(value),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Lesson Detail Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: kAccent, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kAccent.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: const [
                  Text(
                    "Lesson Details",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "96%",
                    style: TextStyle(
                      color: kAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Grammar - Tenses",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Accuracy Info Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAccent, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Accuracy",
                    style: TextStyle(color: kText, fontSize: 16),
                  ),
                  Text(
                    "96%",
                    style: TextStyle(color: kAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
