import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/auth/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';
import 'package:inangreji_flutter/screens/splash/splash_screen_2.dart';
import '../../provider/payment_method/paymentProvider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }



// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final appProvider = Provider.of<AppProvider>(context);
//     final backgroundColor = const Color(0xFF0A0E21);
//     final primaryColor = Colors.white;
//     final glowColor = Colors.blueAccent.withOpacity(0.7);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "inAngreji",
//                     style: TextStyle(
//                       color: primaryColor,
//                       fontSize: 42,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5,
//                       shadows: [
//                         Shadow(
//                           color: glowColor,
//                           blurRadius: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 60),

//                   // Email Field
//                   _buildInputField(
//                     hint: "Email",
//                     icon: Icons.email_outlined,
//                     controller: emailController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       } else if (!value.contains('@')) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                     glowColor: glowColor,
//                     textColor: primaryColor,
//                   ),
//                   const SizedBox(height: 25),

//                   // Password Field
//                   _buildInputField(
//                     hint: "Password",
//                     icon: Icons.lock_outline,
//                     controller: passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                     glowColor: glowColor,
//                     textColor: primaryColor,
//                     isPassword: true,
//                   ),
//                   // Forgot Password
              
//                                 const SizedBox(height: 10),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {

//         Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
//     );

//                         },
//                         child: Text(
//                           "Forgot Password?",
//                           style: TextStyle(
//                             color: primaryColor.withOpacity(0.8),
//                             fontSize: 14,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
              
                
//                   const SizedBox(height: 40),

//                   // Login Button
//                   appProvider.isLoading
//                       ? const CircularProgressIndicator(
//                           color: Colors.blueAccent)
//                       :
                      
//                        Container(
//                           width: double.infinity,
//                           height: 55,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: glowColor,
//                                 blurRadius: 25,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                             gradient: const LinearGradient(
//                               colors: [
//                                 Colors.blueAccent,
//                                 Colors.lightBlueAccent
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () async {
//                               // 🧠 Validate inputs before calling API
//                               if (_formKey.currentState!.validate()) {
//                                 final success = await appProvider.login(
//                                   emailController.text.trim(),
//                                   passwordController.text.trim(),
//                                   context
//                                 );

                              
                               
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                             child: const Text(
//                               "Login",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ),
//                         ),
                 
                 
//                   const SizedBox(height: 20),

                
//               GestureDetector(
//   onTap: () {
//     Navigator.pushReplacementNamed(context, '/myself');
//   },
//   child: Padding(
//     padding: const EdgeInsets.only(top: 16.0),
//     child: Text(
//       "Don't have an account? Create one",
//       style: TextStyle(
//         color: Colors.cyan,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//   ),
// ),

//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required String hint,
//     required IconData icon,
//     required Color glowColor,
//     required Color textColor,
//     required TextEditingController controller,
//     required String? Function(String?) validator,
//     bool isPassword = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: glowColor,
//             blurRadius: 20,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         validator: validator,
//         style: TextStyle(color: textColor, fontSize: 16),
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: textColor.withOpacity(0.8)),
//           hintText: hint,
//           hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
//           filled: true,
//           fillColor: const Color(0xFF1D1E33),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:inangreji_flutter/screens/auth/forgot_password_screen.dart';
// import 'package:inangreji_flutter/screens/auth/phone_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

import 'phone_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final backgroundColor = const Color(0xFF0A0E21);
    final primaryColor = Colors.white;
    final glowColor = Colors.blueAccent.withOpacity(0.7);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "inAngreji",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: glowColor,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Email Field
                  _buildInputField(
                    hint: "Email",
                    icon: Icons.email_outlined,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    glowColor: glowColor,
                    textColor: primaryColor,
                  ),
                  const SizedBox(height: 25),

                  // Password Field
                  _buildInputField(
                    hint: "Password",
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    glowColor: glowColor,
                    textColor: primaryColor,
                    isPassword: true,
                  ),

                  const SizedBox(height: 10),

                  // Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.8),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Login Button
                  appProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blueAccent)
                      : Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: glowColor,
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.lightBlueAccent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await appProvider.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  context,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 30),

                  // OR Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: primaryColor.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: primaryColor.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: primaryColor.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Phone Login Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PhoneLoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(
                        Icons.phone_android,
                        color: Colors.blueAccent,
                      ),
                      label: const Text(
                        "Login with Phone Number",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Create Account
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/myself');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Don't have an account? Create one",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required Color glowColor,
    required Color textColor,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: glowColor,
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: textColor.withOpacity(0.8)),
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          filled: true,
          fillColor: const Color(0xFF1D1E33),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}