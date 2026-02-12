import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../screens/ai_teacher/ai_service.dart';
import 'video_manager.dart';
import 'dart:math';

// class TeacherAnimation extends StatelessWidget {
//   final bool isSpeaking;
//   const TeacherAnimation({super.key, required this.isSpeaking});



//   @override
//   Widget build(BuildContext context) {
//     final controller = VideoManager.controller;

//     if (isSpeaking) {
//       controller?.play();
//     } else {
//       controller?.pause();
//     }

//     return SizedBox(
//       height: 500,
//       width: 400,
//       child: Image.asset("assets/video/human_teacher2.gif"),
      
//       // controller != null && controller.value.isInitialized
//       //     ? ClipRRect(
//       //         borderRadius: BorderRadius.circular(10),
//       //         child: VideoPlayer(controller),
//       //       )
//       //     : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// ✅ Global notifiers
final mouthNotifier = ValueNotifier<String>("rest");
final isSpeakingNotifier = ValueNotifier<bool>(false);

class TeacherAnimation extends StatelessWidget {
  const TeacherAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        // ✅ Responsive teacher size
        final teacherW = min(c.maxWidth, 420.0);
        final teacherH = teacherW * (1155 / 2048); // original ratio of gif

        // ✅ Mouth position in percentage (professional way)
        const mouthX = 0.50; // 50% from left
        const mouthY = 0.23; // 23% from top
        const mouthW = 0.08; // 8% of teacher width

        return SizedBox(
          width: teacherW,
          height: teacherH,
          child: 
          // Stack(
          //   clipBehavior: Clip.none,
          //   children: [
              // ✅ TEACHER IMAGE - UNCOMMENTED!
              // Positioned.fill(
              //   child: Image.asset(
              //     "assets/teacher/human_teacher2.gif",
              //     fit: BoxFit.contain,
              //     gaplessPlayback: true,
              //   ),
              // ),

              // ✅ Mouth overlay - Ab dikhega!
              // ValueListenableBuilder<String>(
              //   valueListenable: mouthNotifier,
              //   builder: (_, mouth, __) {
              //     return Positioned(
              //       left: teacherW * mouthX - (teacherW * mouthW) / 2,
              //       top: teacherH * mouthY,
              //       width: teacherW * mouthW,
              //       child: AnimatedSwitcher(
              //         duration: const Duration(milliseconds: 80),
              //         switchInCurve: Curves.linear,
              //         switchOutCurve: Curves.linear,
              //         child:
                       Image.asset(
                        "assets/video/human_teacher2.gif",
                        // key: ValueKey(mouth),
                        fit: BoxFit.contain,
                        height: 700,
                      ),
              //       ),
              //     );
              //   },
              // ),
          //   ],
          // ),
        );
      },
    );
  }
}


// class TeacherAnimation extends StatelessWidget {
//   const TeacherAnimation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = VideoManager.controller;

//     return ValueListenableBuilder<bool>(
//       valueListenable: isSpeakingNotifier,
//       builder: (context, isSpeaking, _) {
//         if (isSpeaking) {
//           controller?.play();
//         } else {
//           controller?.pause();
//         }

//         return SizedBox(
//           height: 500,
//           width: 400,
//           child: Image.asset(
//             "assets/video/human_teacher2.gif",
//             gaplessPlayback: true,
//           ),
//         );
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class TeacherAnimation extends StatefulWidget {
//   const TeacherAnimation({super.key});

//   @override
//   State<TeacherAnimation> createState() => _TeacherAnimationState();
// }

// class _TeacherAnimationState extends State<TeacherAnimation> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = VideoManager.controller;

//     if (controller == null) {
//       return const SizedBox(
//         height: 500,
//         width: 400,
//         child: Center(child: Text("Video not loaded")),
//       );
//     }

//     return ValueListenableBuilder<bool>(
//       valueListenable: isSpeakingNotifier,
//       builder: (context, isSpeaking, _) {
//         if (!controller.value.isInitialized) {
//           return const SizedBox(
//             height: 500,
//             width: 400,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (isSpeaking) {
//           controller.play();
//         } else {
//           controller.pause();
//         }

//         return SizedBox(
//           height: 500,
//           width: 400,
//           child: AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: VideoPlayer(controller),
//           ),
//         );
//       },
//     );
//   }



// class TeacherAnimation extends StatefulWidget {
//   const TeacherAnimation({super.key});

//   @override
//   State<TeacherAnimation> createState() => _TeacherAnimationState();
// }

// class _TeacherAnimationState extends State<TeacherAnimation> {
//   VideoPlayerController? controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = VideoManager.controller;

//     // 🔊 Listen only when speaking state changes
//     isSpeakingNotifier.addListener(_handleSpeakingChange);
//   }

//   void _handleSpeakingChange() {
//     if (controller == null) return;
//     if (!controller!.value.isInitialized) return;

//     if (isSpeakingNotifier.value) {
//       // ▶️ Start speaking animation
//       controller!.play();
//     } else {
//       // ⏸ Stop + reset animation
//       controller!.pause();
//       controller!.seekTo(Duration.zero);
//     }
//   }

//   @override
//   void dispose() {
//     isSpeakingNotifier.removeListener(_handleSpeakingChange);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller == null) {
//       return const SizedBox(
//         height: 500,
//         width: 400,
//         child: Center(child: Text("Video not loaded")),
//       );
//     }

//     if (!controller!.value.isInitialized) {
//       return const SizedBox(
//         height: 500,
//         width: 400,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return SizedBox(
//       height: 500,
//       width: 400,
//       child: AspectRatio(
//         aspectRatio: controller!.value.aspectRatio,
//         child: VideoPlayer(controller!),
//       ),
//     );
//   }
// }


