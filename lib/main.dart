// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';

// // 🧠 App Provider
// import 'package:inangreji_flutter/provider/app_provider.dart';

// // 🧭 Routes
// import 'package:inangreji_flutter/routes/app_routes.dart';

// import 'provider/payment_method/paymentProvider.dart' ;
// import 'services/video_manager.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   // ✅ Create and preload the app provider (loads saved language)
// //   final appProvider = AppProvider();
// //   await appProvider.loadLocale();

// //   runApp(
// //     ChangeNotifierProvider.value(
// //       value: appProvider,
// //       child: const InAngrejiApp(),
// //     ),
// //   );
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final appProvider = AppProvider();
//   await appProvider.loadLocale();
//  VideoManager.initialize();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AppProvider>.value(value: appProvider),
//         ChangeNotifierProvider<PaymentProvider>(create: (_) => PaymentProvider()),
//       ],
//       child: const InAngrejiApp(),
//     ),
//   );
// }



// class InAngrejiApp extends StatelessWidget {
//   const InAngrejiApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AppProvider>(context);

//     return MaterialApp(
//       title: 'InAngreji',
//       debugShowCheckedModeBanner: false,

//       // 🌍 Language setup
//       locale: provider.locale,
//       supportedLocales: const [
//         Locale('en'),
//         Locale('hi'),
//         Locale('bn'),
//       ],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       localeResolutionCallback:
//           (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
//         if (deviceLocale != null) {
//           for (final locale in supportedLocales) {
//             if (locale.languageCode == deviceLocale.languageCode) {
//               return locale;
//             }
//           }
//         }
//         return supportedLocales.first; // default to English
//       },

//       // 🎨 Theme
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.black,
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFF00BFFF),
//           secondary: Color(0xFF00BFFF),
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white70),
//         ),
//       ),

//       // 🧭 Routes (load all from app_routes.dart)
//       routes: AppRoutes.routes,

//       // 🏁 Initial route
//       initialRoute: AppRoutes.splash1,

//       // 🌀 Optional: add smooth fade transitions for all routes
//       onGenerateRoute: (settings) {
//         final builder = AppRoutes.routes[settings.name];
//         if (builder != null) {
//           return PageRouteBuilder(
//             pageBuilder: (_, __, ___) => builder(_),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               final fade =
//                   CurvedAnimation(parent: animation, curve: Curves.easeInOut);
//               return FadeTransition(opacity: fade, child: child);
//             },
//             transitionDuration: const Duration(milliseconds: 500),
//             settings: settings,
//           );
//         }
//         // Fallback if route not found
//         return MaterialPageRoute(
//           builder: (_) => AppRoutes.routes[AppRoutes.splash1]!(_),
//         );
//       },
//     );
//   }
// }



// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// 🧠 App Provider
import 'package:inangreji_flutter/provider/app_provider.dart';

// 🧭 Routes

import 'package:inangreji_flutter/routes/app_routes.dart';
import 'config/service/connectivity_handler.dart';
import 'provider/ai_model_/ai_model_repo.dart';
import 'provider/payment_method/paymentProvider.dart';
import 'services/video_manager.dart';

// ✅ yeh import add karo
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("🔔 Background message: ${message.notification?.title}");
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//   );
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//  // Initialize local notifications
//   const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   const InitializationSettings initSettings =
//       InitializationSettings(android: androidSettings);
//   await flutterLocalNotificationsPlugin.initialize(initSettings);
  final appProvider = AppProvider();

  await appProvider.loadLocale();
  VideoManager.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: appProvider),
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
        ChangeNotifierProvider<AIModelRepo>(
          create: (_) => AIModelRepo(),
        ),
      ],
      child: const InAngrejiApp(),
    ),
  );
}


final RouteObserver<PageRoute> routeObserver =
    RouteObserver<PageRoute>();


class InAngrejiApp extends StatefulWidget {
  const InAngrejiApp({Key? key}) : super(key: key);

  @override
  State<InAngrejiApp> createState() => _InAngrejiAppState();
}

class _InAngrejiAppState extends State<InAngrejiApp> {
  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _token;

  // @override
  // void initState() {
  //   super.initState();
  //   _initFirebaseMessaging();
  // }

  // Future<void> _initFirebaseMessaging() async {
  //   // Request permissions
  //   NotificationSettings settings = await _messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   print('🔔 Permission granted: ${settings.authorizationStatus}');

  //   // Get token
  //   _token = await _messaging.getToken();
  //   print("📱 FCM Token: $_token");

  //   // Handle foreground notifications
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("📩 Foreground message: ${message.notification?.title}");
  //     _showNotification(message);
  //   });

  //   // When the user taps the notification
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("➡️ Notification clicked: ${message.notification?.title}");
  //   });
  // }

  // // Show local notification
  // Future<void> _showNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'default_channel',
  //     'General Notifications',
  //     channelDescription: 'Used for all general notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     playSound: true,
  //     showWhen: true,
  //   );

  //   const NotificationDetails platformDetails =
  //       NotificationDetails(android: androidDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     message.notification?.title ?? 'No Title',
  //     message.notification?.body ?? 'No Body',
  //     platformDetails,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'InAngreji',
      debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
  

      locale: provider.locale,
      supportedLocales: const [
          Locale('en'),
          Locale('hi'),
          Locale('bn'),
          Locale('ta'),
          Locale('te'),
          Locale('kn'),
          Locale('ml'),
          Locale('mr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
        if (deviceLocale != null) {
          for (final locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode) {
              return locale;
            }
          }
        }
        return supportedLocales.first;
      },

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00BFFF),
          secondary: Color(0xFF00BFFF),
        ),
        appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black, // ✅ AppBar black
      foregroundColor: Colors.white, // title & icons white
      elevation: 0,
      centerTitle: true,
    ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),

      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash1,

      // 🔥 Yahan wrap kar diya poore app ko
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return ConnectivityHandler(child: child);
      },

      onGenerateRoute: (settings) {
        final builder = AppRoutes.routes[settings.name];
        if (builder == null) return null;

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => builder(_),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            return FadeTransition(opacity: fade, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
          settings: settings,
        );
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Route not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          settings: settings,
        );
      },
    );
  }
}
