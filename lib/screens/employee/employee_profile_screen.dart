import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_documents_screen.dart';
import 'package:hrms/screens/employee/employee_status_screen.dart';
import 'package:hrms/services/employee_service.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hrms/screens/dashboards/admin/admin_set_salary_screen.dart';

const String baseUrl = "https://zenzio-hrms-akbyh6edccc6czgz.centralindia-01.azurewebsites.net";

class EmployeeProfileScreen extends StatefulWidget {
  final String? userId;
  final bool isAdminView;

  const EmployeeProfileScreen({
    super.key,
    this.userId,
    this.isAdminView = false,
  });

  static const String id = 'employee_profile_screen';

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen>
    with TickerProviderStateMixin {
  bool isEditing = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Future<void> pickAndUploadImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    if (!mounted) return;
    setState(() {
      _selectedImage = File(picked.path);
    });

    try {
      await EmployeeService.uploadProfileImage(picked.path);
      await _loadProfile(); // refresh profile data
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    }
  }

  Future<void> _saveProfile() async {
    if (widget.isAdminView) return; // 🔒 HARD BLOCK

    try {
      await EmployeeService.updateProfile(
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await _loadProfile(); // reload updated data

      if (!mounted) return;
      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    }
  }

  Map<String, dynamic>? employee;
  bool isLoading = true;
  String? error;

  late TabController _tabController;
  late String name;
  late String email;
  late String phone;
  late String department;
  late String role;
  late String status;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

    fullNameController = TextEditingController();
    phoneController = TextEditingController();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = widget.isAdminView && widget.userId != null
          ? await EmployeeService.getEmployeeById(widget.userId!)
          : await EmployeeService.getMyProfile();

      if (!mounted) return;

      if (data == null) {
        setState(() {
          error = 'Profile not found';
          isLoading = false;
        });
        return;
      }

      setState(() {
        employee = data;

        name = data['fullName'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        department = data['department'] ?? '';
        role = data['role'] ?? 'Employee';
        status = data['isApproved'] == true ? 'Approved' : 'Pending';

        fullNameController.text = name;
        phoneController.text = phone;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Failed to load profile';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFACD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFACD),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/app_logo/logo.jpeg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF69B4),
                          ),
                        ),
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF69B4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isAdminView)
                    isEditing
                        ? Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: _saveProfile,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    fullNameController.text = name;
                                    phoneController.text = phone;
                                    isEditing = false;
                                  });
                                },
                              ),
                            ],
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFFFF69B4),
                            ),
                            onPressed: () {
                              setState(() => isEditing = true);
                            },
                          ),
                ],
              ),
            ),

            // Profile picture and basic info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (!widget.isAdminView && isEditing)
                        ? pickAndUploadImage
                        : null,
                    child: Container(
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
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : (employee?['profileImage'] != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        "$baseUrl${employee!['profileImage']}",
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                      ),
                      child:
                          _selectedImage == null &&
                              employee?['profileImage'] == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Color(0xFFFF69B4),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: status == 'Approved'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),

                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 14,
                        color: status == 'Approved'
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (widget.isAdminView) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SoftButton(
                  text: 'Set Salary',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminSetSalaryScreen(
                          employeeId: widget.userId!,
                          employeeName: name,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Tab bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(12),
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
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFFF69B4),
                  unselectedLabelColor: const Color(0xFFFF69B4),
                  indicator: BoxDecoration(
                    color: const Color(0xFFFF69B4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: const [
                    Tab(text: 'Info'),
                    Tab(text: 'Job'),
                    Tab(text: 'Docs'),
                    Tab(text: 'Status'),
                  ],
                ),
              ),
            ),

            // Tab content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Personal Information Tab
                    _buildPersonalInfoTab(),

                    // Job Information Tab
                    _buildJobInfoTab(),

                    // Documents Tab
                    _buildDocumentsTab(),

                    // Status Tab
                    _buildStatusTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Personal Information', [
            _buildEditableRow('Full Name', fullNameController),

            _buildInfoRow('Email', email),
            _buildEditableRow('Phone', phoneController),
            _buildInfoRow('Department', department),
          ]),
        ],
      ),
    );
  }

  Widget _buildJobInfoTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Job Information', [
            _buildInfoRow('Position', role),
            _buildInfoRow('Department', department),

            _buildInfoRow('Hire Date', 'Jan 15, 2020'),
            _buildInfoRow('Employment Type', 'Full-time'),
            _buildInfoRow('Manager', 'Jane Smith'),
          ]),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: (!widget.isAdminView && isEditing)
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(),
                    ),
                  )
                : Text(
                    controller.text,
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

  Widget _buildDocumentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Documents', [
          _buildDocumentRow('ID Proof', Icons.picture_as_pdf, 'Verified'),
          _buildDocumentRow('Certificates', Icons.picture_as_pdf, 'Pending'),
          _buildDocumentRow('Contract', Icons.picture_as_pdf, 'Verified'),
          _buildDocumentRow('Tax Documents', Icons.picture_as_pdf, 'Verified'),
        ]),
        const SizedBox(height: 20),
        SoftButton(
          text: 'View All Documents',
          onTap: widget.isAdminView
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmployeeDocumentsScreen(),
                    ),
                  );
                },
        ),
      ],
    );
  }

  Widget _buildStatusTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Employment Status', [
          _buildInfoRow('Current Status', status),
          _buildInfoRow('Employment Type', 'Full-time'),
          _buildInfoRow('Start Date', 'Jan 15, 2020'),
          _buildInfoRow('Probation Period', 'Completed'),
        ]),
        const SizedBox(height: 20),
        SoftButton(
          text: 'View Status Details',
          onTap: widget.isAdminView
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmployeeStatusScreen(),
                    ),
                  );
                },
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF69B4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(children: children),
          ),
        ],
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
              style: const TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String name, IconData icon, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF69B4)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Verified'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: status == 'Verified' ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
