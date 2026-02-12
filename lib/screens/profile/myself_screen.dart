import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:inangreji_flutter/screens/ai_teacher/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/app_provider.dart';

class MyselfScreen extends StatefulWidget {
  const MyselfScreen({Key? key}) : super(key: key);

  @override
  State<MyselfScreen> createState() => _MyselfScreenState();
}

class _MyselfScreenState extends State<MyselfScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // NEW FIELDS ADDED
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referalCode = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  String? _selectedGender;

  final AIService _aiService = AIService();
TextEditingController _cityController = TextEditingController();

List<Map<String, dynamic>> _cities = [];
  bool _isFetchingCities = true;
Map<String, dynamic>? _selectedCity; // keep map instead of just name

  @override
  void initState() {
    super.initState();

      _fetchCities();
      _startSpeakingInstruction();
   
  }

  /// 🧠 Speak localized instruction
  Future<void> _startSpeakingInstruction() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final text = appProvider.translate("about_yourself") == "about_yourself"
        ? "Tell us about yourself. Please enter your details."
        : appProvider.translate("about_yourself");
    unawaited(_aiService.speakText(text));
  }

  /// 🏙️ Fetch Cities API
  Future<void> _fetchCities() async {
    try {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      if (mounted) setState(() => _isFetchingCities = true);
      final cityList = await appProvider.getCities();

      print(cityList);

      if (mounted) {
        setState(() {
           _cities = cityList
        .map<Map<String, dynamic>>((e) => {
              'id': e['id'],
              'name': e['name']?.toString() ?? 'Unknown',
            })
        .toList();
          _isFetchingCities = false;
        });
      }

      debugPrint("✅ Cities loaded (${_cities.length})");
    } catch (e) {
      debugPrint("❌ Error loading cities: $e");
      if (mounted) setState(() => _isFetchingCities = false);
    }
  }

  /// 🎤 Replay instruction
  void _replayInstruction() {
    _aiService.stopSpeaking();
    _startSpeakingInstruction();
  }

/// ▶️ Handle Continue (with Signup)
Future<void> _handleContinue() async {
  final appProvider = Provider.of<AppProvider>(context, listen: false);

  // 1️⃣ Validate all fields
  if (_nameController.text.isEmpty ||
      _ageController.text.isEmpty ||
      _selectedGender == null ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty ||
      
      _selectedCity == null) {
    _showWarning("Please fill all fields before continuing.");
    return;
  }

  // Check if password is at least 6 characters
if (_passwordController.text.length < 6) {
  _showWarning("Password must be at least 6 characters long.");
  return;
}

  if (_passwordController.text != _confirmPasswordController.text) {
    _showWarning("Passwords do not match.");
    return;
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
    _showWarning("Please enter a valid email address.");
    return;
  }
  if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(_phoneTextController.text)) {
    _showWarning("Please enter a valid phone number.");
    return;
  }

  // 2️⃣ Call signup/register API
  final isRegistered = await appProvider.register(
    name: _nameController.text,
    age: _ageController.text,
    gender: _selectedGender!,
    email: _emailController.text,
    password: _passwordController.text,
    city:"${ _selectedCity!['id']}"!,
    context: context, 
    referralCode: _referalCode.text,
    phone: _phoneTextController.text,
  );

  // 3️⃣ Handle API response
  if (isRegistered) {
    final successMsg = appProvider.translate("lets_continue") == "lets_continue"
        ? "Registration successful! Let's continue."
        : appProvider.translate("lets_continue");                           
        Navigator.pushReplacementNamed(context, '/login');



    await _aiService.speakText(
      successMsg,
      onComplete: () {
      },
    );
  } else {
    _showWarning("Registration failed. Please try again.");
  }
}


  void _showWarning(String msg) {
    _aiService.speakText(msg);
  
  }

  @override
  void deactivate() {
    _aiService.stopSpeaking();
    super.deactivate();
  }

  @override
  void dispose() {
    _aiService.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context); // listen for locale

    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushReplacementNamed(context, '/level');
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _replayInstruction,
              icon: const Icon(Icons.mic, color: Colors.cyan, size: 28),
              tooltip: 'Replay Voice',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
              
                  /// Title
                  Text(
                    // appProvider.translate("about_you_title") ==
                    //         "about_you_title"
                    //     ? "Tell us about\nyourself"
                    //     : appProvider.translate("about_you_title"),
                    "inAngreji, Sign Up",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 40),
              
                  // Name
                  _buildTextField(
                    controller: _nameController,
                    label: "Name",
                    hint: "Enter your name",
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),
              
                  // Age
                  _buildTextField(
                    controller: _ageController,
                    label: "Age",
                    hint: "Enter your age",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
              
                  // GENDER SECTION ADDED
                  _buildGenderSelection(),
                  const SizedBox(height: 20),
              
                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    hint: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                   const SizedBox(height: 20),
                  // Email
                          // Phone
                  _buildTextField(
                    controller: _phoneTextController,
                    label: "Phone",
                    hint: "Enter your phone number",
                    keyboardType: TextInputType.phone,
                  ),
                   const SizedBox(height: 20),
                  // City Dropdown
                  _buildCityDropdown(appProvider),
                   const SizedBox(height: 20),

                      _buildTextField(
                    controller: _referalCode,
                    label: "Referal Code",
                    hint: "Enter your referal code",
                    keyboardType: TextInputType.emailAddress,
                  ),
                   const SizedBox(height: 20),
              
                  // Password
                  _buildPasswordField(
                    controller: _passwordController,
                    label: "Password",
                    hint: "Enter your password",
                  ),
                  const SizedBox(height: 20),
              
                  // Confirm Password
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    hint: "Re-enter your password",
                  ),
                 
              
                  const SizedBox(height: 50),
              
                  /// Continue Button
                  GestureDetector(
                    onTap: _handleContinue,
                    child:    // Login Button
                  appProvider.sinLoding
                      ? const CircularProgressIndicator(
                          color: Colors.blueAccent)
                      :Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Colors.deepOrange, Colors.orange],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
              
              /// Already have account? Login
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              


                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//   /// 🏙️ City Dropdown
//   Widget _buildCityDropdown(AppProvider appProvider) {
//     if (_isFetchingCities) {
//       return Container(
//         height: 55,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.cyan),
//           color: Colors.black26,
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 color: Colors.cyan,
//                 strokeWidth: 2,
//               ),
//             ),
//             SizedBox(width: 12),
//             Text(
//               "Loading cities...",
//               style: TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return
    
//      Container(
//       height: 55,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.cyan),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<Map<String, dynamic>>(
//           isExpanded: true,
//           dropdownColor: const Color.fromRGBO(0, 0, 0, 0.867),
//           value: _selectedCity,
//             hint: const Text(
//             "Select City",
//             style: TextStyle(color: Colors.grey),
//           ),
//        items: _cities.map((city) {
//   return DropdownMenuItem<Map<String, dynamic>>(
//     value: city, // keep the whole map as value
//     child: Text(
//       city['name'], // display the city name
//       style: const TextStyle(color: Colors.white),
//     ),
//   );
// }).toList(),

//           onChanged: (value) {
//             print("vallue off city $value");
//             setState(() => _selectedCity = value);
//           },
//         ),
//       ),
//     );
  
  
//   }



/// Searchable City Selector
Widget _buildCityDropdown(AppProvider appProvider) {
  return GestureDetector(
    onTap: () => _openCitySearchSheet(),
    child: AbsorbPointer(
      child: TextFormField(
        controller: _cityController,
        decoration: InputDecoration(
          labelText: "Select City",
          filled: true,
          fillColor: Colors.black26,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyan),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyan, width: 2),
          ),

           border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyan, width: 2),
          ),
        ),
        style: const TextStyle(color: Colors.cyan),
      ),
    ),
  );
}



void _openCitySearchSheet() {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.9),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      List<Map<String, dynamic>> filteredCities = _cities;

      TextEditingController searchController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setStateModal) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // SEARCH BAR
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setStateModal(() {
                      filteredCities = _cities
                          .where((city) => city['name']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                    hintText: "Search city...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black38,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),

                // LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = filteredCities[index];

                      return ListTile(
                        title: Text(
                          city['name'],
                          style: const TextStyle(color: Colors.cyan),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCity = city;
                            _cityController.text = city['name'];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  /// 🧾 Normal Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyan),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// 🔐 PASSWORD FIELD
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyan),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// 🚻 GENDER RADIO BUTTONS
  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(color: Colors.cyan, fontSize: 16),
          ),
          const SizedBox(height: 10),


Row(

  children: [
          // Male
          Row(
            children: [
              Radio<String>(
                value: "Male",
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
                activeColor: Colors.cyan,
              ),
              const Text("Male", style: TextStyle(color: Colors.white)),
            ],
          ),
                  const SizedBox(width: 20),

          // Female
          Row(
            children: [
              Radio<String>(
                value: "Female",
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
                activeColor: Colors.cyan,
              ),
              const Text("Female", style: TextStyle(color: Colors.white)),
            ],
          ),
                  const SizedBox(width: 20),
   // Other
          Row(
            children: [
              Radio<String>(
                value: "Other",
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
                activeColor: Colors.cyan,
              ),
              const Text("Other", style: TextStyle(color: Colors.white)),
            ],
          ),
        

],),

        
        ],
      ),
    );
  }
}
