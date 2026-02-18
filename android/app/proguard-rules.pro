# Proguard / R8 rules for InAngreji (Flutter + plugins)

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-dontwarn io.flutter.**

# Kotlin (avoid metadata stripping warnings)
-dontwarn kotlin.**

# Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Lottie
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

# ExoPlayer (video_player, just_audio)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# Flutter Sound (best-effort)
-keep class com.dooboolab.** { *; }
-dontwarn com.dooboolab.**
-keep class com.canardoux.** { *; }
-dontwarn com.canardoux.**

# Baseflow plugins (permission_handler, connectivity_plus, path_provider)
-keep class com.baseflow.** { *; }
-dontwarn com.baseflow.**

# FlutterCommunity Plus (share_plus, url_launcher, etc.)
-keep class dev.fluttercommunity.plus.** { *; }
-dontwarn dev.fluttercommunity.plus.**
