import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class EmployeeStatusScreen extends StatefulWidget {
  static const String id = 'employee_status_screen';
  
  const EmployeeStatusScreen({super.key});

  @override
  State<EmployeeStatusScreen> createState() => _EmployeeStatusScreenState();
}

class _EmployeeStatusScreenState extends State<EmployeeStatusScreen> {
  // Sample employee status data
  EmployeeStatus employeeStatus = EmployeeStatus(
    currentStatus: 'Active',
    employmentType: 'Full-time',
    startDate: '2020-01-15',
    probationPeriod: 'Completed',
    noticePeriod: 'None',
    contractEndDate: '2025-01-15',
    department: 'IT',
    position: 'Software Engineer',
    manager: 'Jane Smith',
    location: 'Head Office',
    workSchedule: '9:00 AM - 6:00 PM',
    lastReviewDate: '2023-12-15',
    nextReviewDate: '2024-06-15',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Employee Status',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.edit_note_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Status summary card
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: (employeeStatus.currentStatus == 'Active' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (employeeStatus.currentStatus == 'Active' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Status: ${employeeStatus.currentStatus}',
                          style: TextStyle(
                            fontSize: 16,
                            color: employeeStatus.currentStatus == 'Active' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        employeeStatus.position,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employeeStatus.department,
                        style: const TextStyle(
                          fontSize: 15,
                          color: GlassTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Status details
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusSection('Employment Details', [
                          _buildStatusRow('Employment Type', employeeStatus.employmentType),
                          _buildStatusRow('Start Date', employeeStatus.startDate),
                          _buildStatusRow('Probation Period', employeeStatus.probationPeriod),
                          _buildStatusRow('Notice Period', employeeStatus.noticePeriod),
                          _buildStatusRow('Contract End Date', employeeStatus.contractEndDate),
                        ]),
                        
                        _buildStatusSection('Job Information', [
                          _buildStatusRow('Department', employeeStatus.department),
                          _buildStatusRow('Position', employeeStatus.position),
                          _buildStatusRow('Manager', employeeStatus.manager),
                          _buildStatusRow('Location', employeeStatus.location),
                          _buildStatusRow('Work Schedule', employeeStatus.workSchedule),
                        ]),
                        
                        _buildStatusSection('Review Information', [
                          _buildStatusRow('Last Review Date', employeeStatus.lastReviewDate),
                          _buildStatusRow('Next Review Date', employeeStatus.nextReviewDate),
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

  Widget _buildStatusSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
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
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: GlassTheme.textMuted,
                fontWeight: FontWeight.w400,
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

class EmployeeStatus {
  final String currentStatus;
  final String employmentType;
  final String startDate;
  final String probationPeriod;
  final String noticePeriod;
  final String contractEndDate;
  final String department;
  final String position;
  final String manager;
  final String location;
  final String workSchedule;
  final String lastReviewDate;
  final String nextReviewDate;

  EmployeeStatus({
    required this.currentStatus,
    required this.employmentType,
    required this.startDate,
    required this.probationPeriod,
    required this.noticePeriod,
    required this.contractEndDate,
    required this.department,
    required this.position,
    required this.manager,
    required this.location,
    required this.workSchedule,
    required this.lastReviewDate,
    required this.nextReviewDate,
  });
}
