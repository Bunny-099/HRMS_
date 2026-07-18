import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/screens/employee/employee_list_screen.dart';
import 'package:hrms/screens/attendance/holiday_calendar_screen.dart';
import 'package:hrms/screens/payroll/salary_structure_screen.dart';
import 'package:hrms/services/admin_service.dart';
import 'package:hrms/widgets/soft_ui.dart'; 
import 'package:hrms/screens/dashboards/admin/admin_set_salary_screen.dart'; 

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

  // 🟢 Ultra-Minimal Dark Glassmorphism Color Tokens
  final Color bgDark = const Color(0xFF0B0F19); // Flatter, deeper dark
  final Color textWhite = const Color(0xFFF8FAFC);
  final Color textMuted = const Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [

          Container(
            color: bgDark,
          ),
          Positioned(
            top: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6366F1).withOpacity(0.05),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withOpacity(0.04),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🟢 4. FROSTED GLASS WELCOME SECTION (Ultra-Minimal)
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02), // Extremely sheer
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05), // Thinner border
                              width: 0.5,
                            ),
                            // Removed BoxShadow for flat aesthetics
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Left aligned for sleekness
                            children: [
                              Row(
                                children: [
                                  // Minimal Avatar
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                    ),
                                    child: const Icon(
                                      Icons.admin_panel_settings_rounded,
                                      size: 28,
                                      color: Color(0xFFA78BFA),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome, Admin!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: textWhite,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'HR Management Dashboard',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Section Title
                    Text(
                      'Management Tools',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        letterSpacing: 1.0,
                        textBaseline: TextBaseline.alphabetic,
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
                        childAspectRatio: 1.2, // Slightly wider for minimalism
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final adminFeatures = [
                          {
                            'icon': Icons.people_alt_outlined,
                            'title': 'Employees',
                            'color': const Color(0xFF8B5CF6), // Violet
                          },
                          {
                            'icon': Icons.calendar_month_outlined,
                            'title': 'Holidays',
                            'color': const Color(0xFF10B981), // Emerald
                          },
                          {
                            'icon': Icons.access_time_rounded,
                            'title': 'Attendance',
                            'color': const Color(0xFF3B82F6), // Blue
                          },
                          {
                            'icon': Icons.receipt_long_outlined,
                            'title': 'Payroll',
                            'color': const Color(0xFFF59E0B), // Amber
                          },
                        ];

                        final feature = adminFeatures[index];

                        return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeListScreen()));
                                break;
                              case 1:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const HolidayCalendarScreen()));
                                break;
                              case 2:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()));
                                break;
                              case 3:
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EmployeeListScreen())); // Preserved existing route
                                break;
                            }
                          },
                          child: _buildMinimalFeatureCard(
                            icon: feature['icon'] as IconData,
                            title: feature['title'] as String,
                            color: feature['color'] as Color,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Quick Stats Section Title
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🟢 6. FROSTED GLASS STAT PILLS (Ultra-Minimal)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8, // Flatter pills
                      children: [
                        _buildMinimalStatCard(
                          title: 'Present',
                          value: loading ? '...' : stats!['presentToday'].toString(),
                          color: const Color(0xFF10B981),
                        ),
                        _buildMinimalStatCard(
                          title: 'Total Staff',
                          value: loading ? '...' : stats!['totalEmployees'].toString(),
                          color: const Color(0xFF8B5CF6),
                        ),
                        _buildMinimalStatCard(
                          title: 'Requests',
                          value: loading ? '...' : stats!['pendingEmployees'].toString(),
                          color: const Color(0xFFF59E0B),
                        ),
                        _buildMinimalStatCard(
                          title: "Active",
                          value: loading ? '...' : stats!['activeEmployees'].toString(),
                          color: const Color(0xFF3B82F6),
                        ),
                        _buildMinimalStatCard(
                          title: 'Absent',
                          value: '4', // Static per original code
                          color: const Color(0xFFEF4444),
                        ),
                        _buildMinimalStatCard(
                          title: 'Leaves',
                          value: '3', // Static per original code
                          color: const Color(0xFFF97316),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Ultra-Minimal Feature Card (No border, no shadow, pure transparent tint)
  Widget _buildMinimalFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // Just a hint of surface
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color.withOpacity(0.8)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textWhite.withOpacity(0.9),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Ultra-Minimal Stat Pill
  Widget _buildMinimalStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // Just a hint of surface
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: color.withOpacity(0.5), // Subtle color accent on left edge only
            width: 3,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}