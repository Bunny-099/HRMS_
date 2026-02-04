import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'mark_attendance_screen.dart';
import 'attendance_history_screen.dart';
import '../leave/apply_leave_screen.dart';
import '../leave/leave_status_screen.dart';
import 'holiday_calendar_screen.dart';

class AttendanceLeaveHomeScreen extends StatefulWidget {
  static const String id = 'attendance_leave_home_screen';
  
  const AttendanceLeaveHomeScreen({super.key});

  @override
  State<AttendanceLeaveHomeScreen> createState() => _AttendanceLeaveHomeScreenState();
}

class _AttendanceLeaveHomeScreenState extends State<AttendanceLeaveHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/app_logo/logo.jpeg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFACD),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: const Color(0xFFFFFACD),
                            offset: Offset(-4, -4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF69B4),
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'Attendance & Leave',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFACD),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: const Color(0xFFFFFACD),
                          offset: Offset(-4, -4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFF69B4),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 20),
              
              // Action buttons grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.0,
                  children: [
                    _buildActionCard(
                      icon: Icons.access_time,
                      title: 'Mark Attendance',
                      subtitle: 'Clock in/out',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MarkAttendanceScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.history,
                      title: 'Attendance History',
                      subtitle: 'View records',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AttendanceHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.work,
                      title: 'Apply Leave',
                      subtitle: 'Request time off',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplyLeaveScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.check_circle,
                      title: 'Leave Status',
                      subtitle: 'Track requests',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LeaveStatusScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.calendar_today,
                      title: 'Holiday Calendar',
                      subtitle: 'View holidays',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HolidayCalendarScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: const Color(0xFFFFFACD),
            offset: Offset(-6, -6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: const Color(0xFFFF69B4),
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFFFF69B4),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}