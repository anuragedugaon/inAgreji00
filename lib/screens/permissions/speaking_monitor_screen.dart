import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // ✅ For speedometer UI

class SpeakingMonitorScreen extends StatelessWidget {
  const SpeakingMonitorScreen({super.key});

  // Theme Colors
  static const Color kBackground = Colors.black;
  static const Color kAccent = Colors.cyanAccent;
  static const Color kText = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Title
              const Text(
                "Speaking\nSpeed Monitor",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kAccent,
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Speedometer Gauge
              SizedBox(
                height: 250,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 200,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.15,
                        cornerStyle: CornerStyle.bothCurve,
                        thicknessUnit: GaugeSizeUnit.factor,
                        color: Colors.grey.shade800,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: 148,
                          width: 0.15,
                          sizeUnit: GaugeSizeUnit.factor,
                          gradient: const SweepGradient(
                            colors: [Colors.cyanAccent, Colors.blueAccent],
                            stops: [0.25, 0.75],
                          ),
                          cornerStyle: CornerStyle.bothCurve,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "148",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: kAccent,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "WPM",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          positionFactor: 0.1,
                          angle: 90,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Comparison Box
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kAccent, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: kAccent.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  "Compared to average learner\n+18 WPM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: kAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
