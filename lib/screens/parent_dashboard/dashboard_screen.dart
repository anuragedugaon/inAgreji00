// import 'package:flutter/material.dart';
// import 'package:inangreji_flutter/routes/app_routes.dart';

// import 'child_progress_screen.dart';

// class ParentDashboardScreen extends StatefulWidget {
//   const ParentDashboardScreen({super.key});

//   @override
//   State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
// }

// class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
//   // 🎨 Theme Colors
//   static const Color kBackgroundStart = Color(0xFF000000);
//   static const Color kBackgroundEnd = Color(0xFF0047AB);
//   static const Color kAccent = Colors.cyanAccent;

//   int _selectedIndex = 0;

//   // 🧭 Navigation items with linked routes
//   final List<Map<String, dynamic>> _navItems = [
//     {
//       'icon': Icons.bar_chart_rounded,
//       'label': 'Progress',
//       'route': AppRoutes.progress, // navigates to ChildProgressScreen
//     },
//     {
//       'icon': Icons.schedule_rounded,
//       'label': 'Schedule',
//       'route': AppRoutes.schedule, // navigates to ScheduleScreen
//     },
//     {
//       'icon': Icons.notifications_active_rounded,
//       'label': 'Announcement',
//       'route': AppRoutes.announce, // navigates to NotificationsScreen
//     },
//     {
//       'icon': Icons.settings_rounded,
//       'label': 'Settings',
//       'route': AppRoutes.parentSettings, // navigates to ParentSettingsScreen
//     },
//   ];

//   // 🧭 Handle bottom nav item tap
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     // Navigate to the respective screen using routes
//     Navigator.pushNamed(context, _navItems[index]['route']);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [kBackgroundStart, kBackgroundEnd],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
       
//         // appBar: AppBar(
//         //   title: const Text(
//         //     "Parent Dashboard",
//         //     style: TextStyle(color: kAccent, fontWeight: FontWeight.bold),
//         //   ),
//         //   backgroundColor: Colors.transparent,
//         //   elevation: 0,
//         //   centerTitle: true,
//           // leading: IconButton(
//           //   icon: const Icon(Icons.arrow_back_ios, color: kAccent),
//           //   onPressed: () {
//           //     Navigator.pushReplacementNamed(context, AppRoutes.home);
//           //   },
//           // ),
//         // ),
       
//         body:ChildProgressScreen(),
        
//         //  Center(
//         //   child: Column(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: const [
//         //       Icon(Icons.family_restroom, color: kAccent, size: 100),
//         //       SizedBox(height: 16),
//         //       Text(
//         //         "Welcome, Parent!",
//         //         style: TextStyle(
//         //           color: Colors.white70,
//         //           fontSize: 22,
//         //           fontWeight: FontWeight.w500,
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),

//         // 🧭 Bottom Navigation Bar
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           backgroundColor: Colors.black,
//           selectedItemColor: kAccent,
//           unselectedItemColor: Colors.white70,
//           showUnselectedLabels: true,
//           items: _navItems
//               .map(
//                 (item) => BottomNavigationBarItem(
//                   icon: Icon(item['icon']),
//                   label: item['label'],
//                 ),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

// 🔹 Import your screens
import 'announcement_screen.dart';
import 'child_progress_screen.dart';
import 'schedule_screen.dart';
import 'parent_settings_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  // 🎨 Theme Colors
  static const Color kBackgroundStart = Color(0xFF000000);
  static const Color kBackgroundEnd = Color(0xFF0047AB);
  static const Color kAccent = Colors.cyanAccent;

  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = const [
      ChildProgressScreen(),
      ScheduleScreen(),
      AnnouncementScreen(),
      ParentSettingsScreen(),
    ];
  }

  // 🧭 Bottom navigation handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kBackgroundStart, kBackgroundEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // 🧠 IndexedStack = no screen move
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),

        // // 🧭 Bottom Navigation
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: _selectedIndex,
        //   onTap: _onItemTapped,
        //   backgroundColor: Colors.black,
        //   selectedItemColor: kAccent,
        //   unselectedItemColor: Colors.white70,
        //   showUnselectedLabels: true,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.bar_chart_rounded),
        //       label: 'Progress',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.schedule_rounded),
        //       label: 'Schedule',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.notifications_active_rounded),
        //       label: 'Announcement',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings_rounded),
        //       label: 'Settings',
        //     ),
        //   ],
        // ),
     
     
      ),
    );
  }
}
