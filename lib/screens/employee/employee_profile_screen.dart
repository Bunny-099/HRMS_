import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_documents_screen.dart';
import 'package:hrms/screens/employee/employee_status_screen.dart';
import 'package:hrms/services/employee_service.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
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
        body: GlassBackground(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (error != null) {
      return Scaffold(
        body: GlassBackground(child: Center(child: Text(error!, style: const TextStyle(color: Colors.white)))),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: 'Profile',
        actions: [
          if (!widget.isAdminView)
            isEditing
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_rounded, color: GlassTheme.successAccent),
                        onPressed: _saveProfile,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: GlassTheme.errorAccent),
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
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    onPressed: () {
                      setState(() => isEditing = true);
                    },
                  ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Profile picture and basic info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (!widget.isAdminView && isEditing)
                          ? pickAndUploadImage
                          : null,
                      child: Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.1), width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
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
                            child: _selectedImage == null && employee?['profileImage'] == null
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 50,
                                    color: Colors.white.withOpacity(0.5),
                                  )
                                : null,
                          ),
                          if (!widget.isAdminView && isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: GlassTheme.accentGlow,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 14,
                        color: GlassTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: (status == 'Approved' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: (status == 'Approved' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: status == 'Approved' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 13,
                              color: status == 'Approved' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              if (widget.isAdminView) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassButton(
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
                const SizedBox(height: 24),
              ],

              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: GlassTheme.textMuted,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Info'),
                    Tab(text: 'Job'),
                    Tab(text: 'Docs'),
                    Tab(text: 'Status'),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPersonalInfoTab(),
                      _buildJobInfoTab(),
                      _buildDocumentsTab(),
                      _buildStatusTab(),
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

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
      physics: const BouncingScrollPhysics(),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: GlassTheme.textMuted),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: (!widget.isAdminView && isEditing)
                ? TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlassTheme.accentGlow)),
                    ),
                  )
                : Text(
                    controller.text,
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

  Widget _buildDocumentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard('Documents', [
          _buildDocumentRow('ID Proof', Icons.picture_as_pdf_rounded, 'Verified'),
          _buildDocumentRow('Certificates', Icons.picture_as_pdf_rounded, 'Pending'),
          _buildDocumentRow('Contract', Icons.picture_as_pdf_rounded, 'Verified'),
          _buildDocumentRow('Tax Documents', Icons.picture_as_pdf_rounded, 'Verified'),
        ]),
        const SizedBox(height: 24),
        GlassButton(
          text: 'View All Documents',
          isPrimary: false,
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
        const SizedBox(height: 24),
        GlassButton(
          text: 'View Status Details',
          isPrimary: false,
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
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Column(children: children),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: GlassTheme.textMuted),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String name, IconData icon, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: GlassTheme.errorAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (status == 'Verified' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: (status == 'Verified' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.2)),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                color: status == 'Verified' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
