import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:hrms/services/api_services.dart';

class EmployeeListScreen extends StatefulWidget {
  static const String id = 'employee_list_screen';

  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();

  List<dynamic> employees = [];
  List<dynamic> filteredEmployees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final data = await apiService.fetchEmployees();
      setState(() {
        employees = data;
        filteredEmployees = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint('Fetch employees error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEmployees(String query) {
    final search = query.toLowerCase();

    setState(() {
      if (search.isEmpty) {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees.where((employee) {
          final name =
    (employee['fullName'] ?? employee['name'] ?? '').toLowerCase();

          final email = employee['email']?.toLowerCase() ?? '';

          return name.contains(search) || email.contains(search);
        }).toList();
      }
    });
  }

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
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  Text(
                    'Employee List',
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
                    child: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(12),
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
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search employees...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onChanged: _filterEmployees,
                ),
              ),
              const SizedBox(height: 20),

              // Employee count
              Row(
                children: [
                  Text(
                    '${filteredEmployees.length} Employees',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Employee list
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 18,
                        right: 10,
                        left: 10,
                      ),
                      child: _buildEmployeeCard(employee),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return SoftCard(
      child: GestureDetector(
        onTap: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EmployeeProfileScreen(
      userId: employee['_id'],
      isAdminView: true,
    ),
  ),
);
        },
child: Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: Colors.white, // ⭐ REQUIRED
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    children: [

              // Profile avatar
              Container(
                width: 50,
                height: 50,
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
                child: const Icon(Icons.person, color: Color(0xFFFF69B4)),
              ),
              const SizedBox(width: 15),

              // Employee info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
Text(
  employee['fullName'] ?? employee['name'] ?? 'No Name',
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFF69B4),
  ),
),

                    const SizedBox(height: 5),
                    const Text(
                      'Employee',
                      style: TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      employee['isApproved'] == true ? 'Active' : 'Pending',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ],
                ),
              ),

              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: employee['isApproved'] == true
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  employee['isApproved'] == true ? 'Active' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    color: employee['isApproved'] == true
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  
   } 
  }
