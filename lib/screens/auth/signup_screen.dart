import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/widgets/soft_ui.dart'; // Kept intact to avoid breaking imports
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 🟢 Upgraded Dialog to match dark theme without touching logic
  void _showDialog(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
            ),
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

  // 🔐 SIGNUP FUNCTION (BACKEND LOGIC & VALIDATIONS 100% PRESERVED)
  Future<void> _signup() async {
    if (_nameController.text.isEmpty) {
      _showDialog('Error', 'Please enter your full name');
      return;
    }

    if (_emailController.text.isEmpty) {
      _showDialog('Error', 'Please enter your email');
      return;
    }

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
        Uri.parse("https://unelevated-rotundly-rashad.ngrok-free.dev/api/auth/register"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": _nameController.text.trim(),
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
    // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across App)
    const Color bgDarkStart = Color(0xFF090D16);
    const Color bgDarkEnd = Color(0xFF111827);
    const Color textWhite = Colors.white;
    const Color textMuted = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgDarkStart,
      body: Stack(
        children: [
          // 1. Deep Midnight Ambient Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // 🟢 2. Subtle Ambient Glow Orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.10),
              ),
            ),
          ),

          // 3. Main Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minimalist Frosted Glass Logo
                      _buildLogoSection(),
                      const SizedBox(height: 20),

                      const Text(
                        'E-Smart HR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textWhite,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create New Account',
                        style: TextStyle(
                          fontSize: 15,
                          color: textMuted.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 🟢 4. MAIN FROSTED GLASS SIGNUP CARD
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name
                                _buildTextField(
                                  controller: _nameController,
                                  hintText: 'Full Name',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 16),

                                // Email
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'Email Address',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // Phone Number
                                _buildTextField(
                                  controller: _phoneController,
                                  hintText: 'Phone Number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 16),

                                // Emergency Phone Number
                                _buildTextField(
                                  controller: _emergencyPhoneController,
                                  hintText: 'Emergency Phone Number',
                                  icon: Icons.local_hospital_outlined,
                                  keyboardType: TextInputType.phone,
                                  helperText: "Enter a family member's phone number",
                                ),
                                const SizedBox(height: 16),

                                // Password
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: !_passwordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  hintText: 'Confirm Password',
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: !_confirmPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _confirmPasswordVisible = !_confirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // 🟢 Sleek Matte White Action Button
                                _buildSleekButton(
                                  text: 'Sign Up',
                                  onTap: _signup,
                                ),
                                const SizedBox(height: 20),

                                // Login link
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: RichText(
                                      text: const TextSpan(
                                        text: 'Already have an account? ',
                                        style: TextStyle(
                                          color: textMuted,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }

  // --- Helper Widgets For Glassmorphic Aesthetic ---

  Widget _buildLogoSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/app_logo/logo.jpeg',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.business_center_rounded,
                size: 38,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? helperText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          helperText: helperText,
          helperStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
          prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Sleek Matte White Button that matches LoginScreen exactly
  Widget _buildSleekButton({required String text, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.white.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (onTap != null)
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: onTap == null ? Colors.white38 : const Color(0xFF090D16),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}