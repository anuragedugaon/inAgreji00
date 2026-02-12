import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:inangreji_flutter/provider/app_provider.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  
  bool isOtpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final backgroundColor = const Color(0xFF0A0E21);
    final primaryColor = Colors.white;
    final glowColor = Colors.blueAccent.withOpacity(0.7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    "Phone Login",
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
                  const SizedBox(height: 20),
                  Text(
                    isOtpSent 
                        ? "Enter the OTP sent to your phone"
                        : "Enter your phone number to continue",
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Phone Number Field
                  _buildInputField(
                    hint: "Phone Number",
                    icon: Icons.phone_outlined,
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                    glowColor: glowColor,
                    textColor: primaryColor,
                    enabled: !isOtpSent,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  
                  if (isOtpSent) ...[
                    const SizedBox(height: 25),
                    // OTP Field
                    _buildInputField(
                      hint: "Enter OTP",
                      icon: Icons.lock_outline,
                      controller: otpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        } else if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                      glowColor: glowColor,
                      textColor: primaryColor,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Resend OTP
                  if (isOtpSent)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: appProvider.isLoading
                              ? null
                              : () async {
                                  await appProvider.sendOtp(
                                    phoneController.text.trim(),
                                    context,
                                  );
                                },
                          child: Text(
                            "Resend OTP",
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

                  // Send OTP / Verify OTP Button
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
                                if (!isOtpSent) {
                                  // Send OTP
                                  final success = await appProvider.sendOtp(
                                    phoneController.text.trim(),
                                    context,
                                  );
                                  if (success) {
                                    setState(() {
                                      isOtpSent = true;
                                    });
                                  }
                                } else {
                                  // Verify OTP and Login
                                  final success = await appProvider.verifyOtpAndLogin(
                                    phoneController.text.trim(),
                                    otpController.text.trim(),
                                    context,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              isOtpSent ? "Verify OTP & Login" : "Send OTP",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(height: 20),

                  // Back to Email Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Login with Email instead",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
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
    bool enabled = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
        validator: validator,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: textColor.withOpacity(0.8)),
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          filled: true,
          fillColor: enabled ? const Color(0xFF1D1E33) : const Color(0xFF1D1E33).withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}