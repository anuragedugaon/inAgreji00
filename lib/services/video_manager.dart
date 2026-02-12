import 'package:video_player/video_player.dart';

// class VideoManager {
//   static VideoPlayerController? controller;

//   static Future<void> initialize() async {
//     controller = VideoPlayerController.asset("assets/video/ai_teacher.mp4");
//     await controller?.initialize();
//     controller?.setLooping(true);
//   }
// }
// import 'package:video_player/video_player.dart';


class VideoManager {
  static VideoPlayerController? controller;

  static Future<void> initialize() async {
    controller = VideoPlayerController.asset(
      "assets/video/ai_teacher.mp4",
    );

    await controller!.initialize();
    controller!.setLooping(true);
    controller!.pause(); // default idle
  }

  static void dispose() {
    controller?.dispose();
    controller = null;
  }
}
