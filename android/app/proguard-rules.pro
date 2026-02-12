# Razorpay - Keep all Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep all Razorpay-related classes
-keepclasseswithmembernames class com.razorpay.** {
    public protected private *;
}

# Keep RazorpayCheckout
-keep public class com.razorpay.RazorpayCheckout {
    public static com.razorpay.RazorpayCheckout getInstance();
}

# Keep all constructors
-keepclasseswithmembers class com.razorpay.** {
    <init>(...);
}

# Keep all methods
-keepclasseswithmembers class com.razorpay.** {
    *** *(...);
}

# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Generic rules
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
