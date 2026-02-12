// import 'package:flutter/material.dart';

// class MyProfileScreen extends StatelessWidget {
//   const MyProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Theme colors
//     const Color backgroundColor = Colors.black;
//     const Color borderColor = Colors.cyanAccent;
//     const Color glowColor = Color(0xFF80FFFF);
//     const Color textColor = Colors.white;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: borderColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Profile Settings",
//           style: TextStyle(
//             color: borderColor,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // ✅ Profile Card
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1C1C1E),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: borderColor, width: 1.5),
//                 boxShadow: [
//                   BoxShadow(
//                     color: glowColor.withOpacity(0.5),
//                     blurRadius: 12,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   // Profile Avatar
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage("assets/images/avatar.png"), // ✅ Replace with your image asset
//                   ),
//                   const SizedBox(height: 16),

//                   // Name
//                   const Text(
//                     "Abhishek Tiwary",
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 6),

//                   // Email
//                   const Text(
//                     "abhi2420@gmail.com",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // Level
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: borderColor, width: 1),
//                     ),
//                     child: const Text(
//                       "Level 5",
//                       style: TextStyle(color: borderColor, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 40),

//             // ✅ Save Changes Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // TODO: Add save changes functionality
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: backgroundColor,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     side: const BorderSide(color: borderColor, width: 1.5),
//                   ),
//                   elevation: 6,
//                   shadowColor: glowColor.withOpacity(0.6),
//                 ),
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(
//                     color: borderColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:provider/provider.dart';
import '../../models/user_details_model.dart';
// <-- your model path

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  UserDetailsModel? userDetails;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final data = await provider.getUserDetails();

    setState(() {
      userDetails = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.black;
    const Color borderColor = Colors.cyanAccent;
    const Color glowColor = Color(0xFF80FFFF);
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: borderColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Profile Settings",
          style: TextStyle(
            color: borderColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Profile Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage("assets/images/avatar.png"),
                        ),
                        const SizedBox(height: 16),

                        // NAME (DYNAMIC)
                        Text(
                          userDetails?.data?.name ??
                              "User Name",
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // EMAIL (DYNAMIC)
                        Text(
                          userDetails?.data?.email ?? "Loading...",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // LEVEL (DYNAMIC)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Text(
                            userDetails?.data?.levelName ?? "No Level",
                            style: const TextStyle(
                                color: borderColor, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Save Changes Button (NO CHANGE)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                              const BorderSide(color: borderColor, width: 1.5),
                        ),
                        elevation: 6,
                        shadowColor: glowColor.withOpacity(0.6),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: borderColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
