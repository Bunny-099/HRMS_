import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/screens/employee/employee_list_screen.dart';
import 'package:hrms/screens/attendance/holiday_calendar_screen.dart';
import 'package:hrms/screens/payroll/salary_structure_screen.dart'; // Kept intact
import 'package:hrms/services/admin_service.dart';
import 'package:hrms/widgets/soft_ui.dart'; // Kept intact to avoid breaking imports
import 'package:hrms/screens/dashboards/admin/admin_set_salary_screen.dart'; // Kept intact

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Map<String, dynamic>? stats;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // 🔐 BACKEND LOGIC PRESERVED 100%
  Future<void> _loadStats() async {
    final data = await AdminService.getAdminStats();
    setState(() {
      stats = data;
      loading = false;
    });
  }

  // 🟢 Dark Glassmorphism Color Tokens (Synced across App)
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textWhite = Colors.white;
  final Color textMuted = const Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkStart,
      body: Stack(
        children: [
          // 1. Deep Midnight Ambient Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, const Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // 🟢 2. Subtle Ambient Glow Orbs for Glass Effect
          Positioned(
            top: -50,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.12), // Admin Violet Glow
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.08), // Sleek Blue Glow
              ),
            ),
          ),

          // 3. Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🟢 4. FROSTED GLASS WELCOME SECTION
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Glowing Avatar
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF8B5CF6).withOpacity(0.15),
                                  border: Border.all(
                                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 46,
                                  color: Color(0xFFC4B5FD), // Soft purple
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Welcome, Admin!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'HR Management Dashboard',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Section Title
                    const Text(
                      'HR Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🟢 5. GLASS FEATURE GRID (Routing Logic 100% PRESERVED)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final adminFeatures = [
                          {
                            'icon': Icons.people_outline_rounded,
                            'title': 'Employees',
                            'subtitle': 'Manage staff',
                            'color': const Color(0xFF8B5CF6), // Royal Violet
                          },
                          {
                            'icon': Icons.event_available_rounded,
                            'title': 'Holidays',
                            'subtitle': 'Manage holidays',
                            'color': const Color(0xFF10B981), // Emerald
                          },
                          {
                            'icon': Icons.access_time_rounded,
                            'title': 'Attendance',
                            'subtitle': 'View reports',
                            'color': const Color(0xFF3B82F6), // Azure Blue
                          },
                          {
                            'icon': Icons.payments_outlined,
                            'title': 'Payroll',
                            'subtitle': 'Manage salaries',
                            'color': const Color(0xFFF59E0B), // Amber
                          },
                        ];

                        final feature = adminFeatures[index];

                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HolidayCalendarScreen()),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()),
                                );
                                break;
                              case 3:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                                );
                                break;
                            }
                          },
                          child: _buildFeatureCard(
                            icon: feature['icon'] as IconData,
                            title: feature['title'] as String,
                            subtitle: feature['subtitle'] as String,
                            color: feature['color'] as Color,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 36),

                    // Quick Stats Section Title
                    const Text(
                      'Quick Stats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🟢 6. FROSTED GLASS STAT PILLS (Responsive Grid)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6, // Makes them look like wide sleek pills
                      children: [
                        _buildStatCard(
                          title: 'Present Today',
                          value: loading ? '...' : stats!['presentToday'].toString(),
                          icon: Icons.how_to_reg_rounded,
                          color: const Color(0xFF10B981), // Emerald
                        ),
                        _buildStatCard(
                          title: 'Total Employees',
                          value: loading ? '...' : stats!['totalEmployees'].toString(),
                          icon: Icons.groups_rounded,
                          color: const Color(0xFF8B5CF6), // Violet
                        ),
                        _buildStatCard(
                          title: 'Pending Requests',
                          value: loading ? '...' : stats!['pendingEmployees'].toString(),
                          icon: Icons.pending_actions_rounded,
                          color: const Color(0xFFF59E0B), // Amber
                        ),
                        _buildStatCard(
                          title: "Active Employees",
                          value: loading ? '...' : stats!['activeEmployees'].toString(),
                          icon: Icons.check_circle_outline_rounded,
                          color: const Color(0xFF3B82F6), // Blue
                        ),
                        _buildStatCard(
                          title: 'Absent Today',
                          value: '4', // Static per original code
                          icon: Icons.person_off_rounded,
                          color: const Color(0xFFEF4444), // Red
                        ),
                        _buildStatCard(
                          title: 'Pending Leaves',
                          value: '3', // Static per original code
                          icon: Icons.beach_access_rounded,
                          color: const Color(0xFFF97316), // Orange
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Custom Glassmorphic Feature Card
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟢 Custom Glassmorphic Stat Pill Box
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}