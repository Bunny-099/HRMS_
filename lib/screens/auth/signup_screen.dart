import 'package:flutter/material.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  void _showDialog(String title, String message, {VoidCallback? onOk}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onOk != null) onOk();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

Future<void> _signup() async {
  // Validation checks
  if (_nameController.text.isEmpty) {
    _showDialog('Error', 'Please enter your full name');
    return;
  }

  if (_emailController.text.isEmpty) {
    _showDialog('Error', 'Please enter your email');
    return;
  }

  // Email validation
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(_emailController.text.trim())) {
    _showDialog('Error', 'Please enter a valid email address');
    return;
  }

  if (_phoneController.text.isEmpty) {
    _showDialog('Error', 'Please enter your phone number');
    return;
  }

  if (_phoneController.text.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(_phoneController.text)) {
    _showDialog('Error', 'Phone number must be 10 digits');
    return;
  }

  if (_emergencyPhoneController.text.isEmpty) {
    _showDialog('Error', 'Please enter emergency phone number');
    return;
  }

  if (_emergencyPhoneController.text.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(_emergencyPhoneController.text)) {
    _showDialog('Error', 'Emergency phone number must be 10 digits');
    return;
  }

  if (_phoneController.text == _emergencyPhoneController.text) {
    _showDialog('Error', 'Emergency phone number cannot be same as phone number');
    return;
  }

  if (_passwordController.text.isEmpty) {
    _showDialog('Error', 'Please enter password');
    return;
  }

  if (_passwordController.text.length < 6) {
    _showDialog('Error', 'Password must be at least 6 characters');
    return;
  }

  if (_confirmPasswordController.text.isEmpty) {
    _showDialog('Error', 'Please confirm your password');
    return;
  }

  if (_passwordController.text != _confirmPasswordController.text) {
    _showDialog('Error', 'Passwords do not match');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse("http://13.233.98.86:4000/api/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "fullName": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "emergencyPhone": _emergencyPhoneController.text.trim(),
        "password": _passwordController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      _showDialog(
        'Success',
        data['message'] ?? 'Registration successful. Await admin approval.',
        onOk: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      );
    } else {
      _showDialog('Error', data['message'] ?? 'Signup failed');
    }
  } catch (e) {
    _showDialog('Error', 'Something went wrong');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // App logo and title
                SoftCard(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFFFFACD),
                    ),
                    child: Image.asset(
                      'assets/images/app_logo/logo.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'E-Smart HR',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create New Account',
                  style: const TextStyle(
                    fontSize: 16,
                    color: const Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Signup form - Individual fields with spacing
                Column(
                  children: [
                      // Full Name field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Email field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Phone Number field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Emergency Phone Number field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _emergencyPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Emergency Phone Number',
                              prefixIcon: Icon(Icons.local_hospital),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              helperText: 'Enter your family member\'s phone number',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Password field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(
                                  _passwordVisible 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Confirm Password field
                      SoftCard(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFACD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _confirmPasswordVisible = !_confirmPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  _confirmPasswordVisible 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Signup button
                      SoftButton(
                        text: 'Sign Up',
                        onTap: _signup,
                      ),
                      const SizedBox(height: 15),
                      
                      // Login link
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: const TextStyle(
                            color: Color(0xFFFF69B4),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
