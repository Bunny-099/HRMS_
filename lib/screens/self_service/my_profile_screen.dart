import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class MyProfileScreen extends StatefulWidget {
  static const String id = 'my_profile_screen';
  
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'My Profile',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.edit_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Profile summary card
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 3),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Office Staff',
                        style: TextStyle(
                          fontSize: 14,
                          color: GlassTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GlassTheme.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GlassTheme.success.withOpacity(0.2)),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            color: GlassTheme.successAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Profile details
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoSection('Personal Information', [
                          _buildInfoRow('Full Name', 'John Doe'),
                          _buildInfoRow('Email', 'john.doe@company.com'),
                          _buildInfoRow('Phone', '+1 234 567 8900'),
                          _buildInfoRow('Date of Birth', '01 Jan 1990'),
                          _buildInfoRow('Gender', 'Male'),
                        ]),
                        const SizedBox(height: 24),
                        _buildInfoSection('Job Information', [
                          _buildInfoRow('Employee ID', 'EMP001'),
                          _buildInfoRow('Department', 'Operations'),
                          _buildInfoRow('Position', 'Office Staff'),
                          _buildInfoRow('Joining Date', '15 Jan 2020'),
                          _buildInfoRow('Manager', 'Jane Smith'),
                        ]),
                        const SizedBox(height: 24),
                        _buildInfoSection('Emergency Contact', [
                          _buildInfoRow('Contact Name', 'Jane Doe'),
                          _buildInfoRow('Relationship', 'Spouse'),
                          _buildInfoRow('Phone', '+1 234 567 8901'),
                        ]),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: GlassTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
