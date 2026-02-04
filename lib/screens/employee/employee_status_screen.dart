import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';

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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFFACD),
                        boxShadow: const [
                          BoxShadow(
                            color: const Color(0xFFFFFACD),
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Color(0xFFA3B1C6),
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Employee Status',
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
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFFACD),
                      boxShadow: const [
                        BoxShadow(
                          color: const Color(0xFFFFFACD),
                          offset: Offset(-3, -3),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Color(0xFFA3B1C6),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Status summary card
              SoftCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: employeeStatus.currentStatus == 'Active' 
                                ? Colors.green.withOpacity(0.2) 
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Status: ${employeeStatus.currentStatus}',
                            style: TextStyle(
                              fontSize: 16,
                              color: employeeStatus.currentStatus == 'Active' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      employeeStatus.position,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    Text(
                      employeeStatus.department,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Status details
              Expanded(
                child: SingleChildScrollView(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF69B4),
            ),
          ),
          const SizedBox(height: 10),
          SoftCard(
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFFF69B4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFFF69B4),
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