import 'dart:convert';
import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/soft_theme.dart'; // Kept intact to avoid breaking imports
import 'package:hrms/widgets/soft_ui.dart'; // Kept intact to avoid breaking imports

class AdminSetSalaryScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  const AdminSetSalaryScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<AdminSetSalaryScreen> createState() => _AdminSetSalaryScreenState();
}

class _AdminSetSalaryScreenState extends State<AdminSetSalaryScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _salaryCtrl = TextEditingController();

  bool _loading = false;

  // 🔐 BACKEND LOGIC 100% PRESERVED - NOT TOUCHED AT ALL
  Future<void> _setSalary() async {
    print("EMPLOYEE ID FROM UI: ${widget.employeeId}");

    if (_salaryCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      final response = await _api.post('/salary', {
        'employeeId': widget.employeeId,
        'salary': int.parse(_salaryCtrl.text.trim()),
      });

      // ✅ response IS http.Response → decode it
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Salary set successfully')),
        );

        _salaryCtrl.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to set salary')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Server error')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Sleek Dark Glassmorphism Color Tokens
    const Color bgDarkStart = Color(0xFF090D16);
    const Color bgDarkEnd = Color(0xFF111827);
    const Color textWhite = Colors.white;
    const Color textMuted = Color(0xFF94A3B8);
    const Color accentEmerald = Color(0xFF10B981); // Finance/Salary aesthetic

    return Scaffold(
      backgroundColor: bgDarkStart,
      extendBodyBehindAppBar: true, // Allows blur to cover behind AppBar

      // 🟢 1. FROSTED GLASS APP BAR
      appBar: AppBar(
        backgroundColor: bgDarkStart.withOpacity(0.75),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Set Salary',
          style: TextStyle(
            color: textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // 🟢 2. MAIN BODY
      body: Stack(
        children: [
          // Deep Midnight Ambient Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // Subtle Emerald Ambient Glow Orb (Salary vibe)
          Positioned(
            top: 50,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentEmerald.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.06),
              ),
            ),
          ),

          // Scrollable Content
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

                      // 🟢 3. MAIN FROSTED GLASS CARD
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Employee Avatar Glow Placeholder
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentEmerald.withOpacity(0.15),
                                    border: Border.all(
                                      color: accentEmerald.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.payments_rounded,
                                    size: 40,
                                    color: accentEmerald,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Dynamic Title
                                Text(
                                  widget.employeeName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: textWhite,
                                    letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Set Monthly Compensation',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textMuted.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Salary Input Field
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Monthly Salary Amount',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.8),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _salaryCtrl,
                                  hintText: 'e.g. 50000',
                                  icon: Icons.account_balance_wallet_outlined,
                                  keyboardType: TextInputType.number,
                                ),

                                const SizedBox(height: 32),

                                // Save Button
                                _buildSleekButton(
                                  text: _loading ? 'Saving...' : 'Save Salary',
                                  onTap: _loading ? null : _setSalary,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w400),
          prefixIcon: Icon(icon, color: const Color(0xFF10B981), size: 22), // Emerald icon
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

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
                color: Colors.white.withOpacity(0.15),
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