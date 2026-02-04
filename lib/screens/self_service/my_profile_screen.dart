import 'package:flutter/material.dart';


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
                        color: const Color(0xFFFFFACD),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFFFACD),
                            offset: Offset(-4, -4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Color(0xFFFF69B4),
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'My Profile',
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
                          color: Color(0xFFFFFACD),
                          offset: Offset(-4, -4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: Color(0xFFFF69B4),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Profile picture and info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFFFFACD),
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Color(0xFFFF69B4),
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFFACD),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFFFACD),
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Color(0xFFFF69B4),
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'John Doe',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    Text(
                      'Office Staff',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Profile details
              Expanded(
                child: SingleChildScrollView(
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
                      const SizedBox(height: 20),
                      _buildInfoSection('Job Information', [
                        _buildInfoRow('Employee ID', 'EMP001'),
                        _buildInfoRow('Department', 'Operations'),
                        _buildInfoRow('Position', 'Office Staff'),
                        _buildInfoRow('Joining Date', '15 Jan 2020'),
                        _buildInfoRow('Manager', 'Jane Smith'),
                      ]),
                      const SizedBox(height: 20),
                      _buildInfoSection('Emergency Contact', [
                        _buildInfoRow('Contact Name', 'Jane Doe'),
                        _buildInfoRow('Relationship', 'Spouse'),
                        _buildInfoRow('Phone', '+1 234 567 8901'),
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

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFFACD),
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Color(0xFFFF69B4),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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