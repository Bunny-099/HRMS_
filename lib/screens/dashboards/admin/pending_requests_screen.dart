import 'dart:ui'; // 🟢 ADDED for Glassmorphic blur
import 'package:flutter/material.dart';
import 'package:hrms/services/admin_service.dart';

enum PendingRequestType { employee, leave }

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  // 🔐 EXACT LOGIC AND STATE VARIABLES (NOT TOUCHED)
  PendingRequestType selectedType = PendingRequestType.employee;

  List pendingEmployees = [];
  List pendingLeaves = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final employees = await AdminService.getPendingEmployees();
    final leaves = await AdminService.getPendingLeaves();

    setState(() {
      pendingEmployees = employees;
      pendingLeaves = leaves;
    });
  }

  Future<void> _refreshEmployees() async {
    final data = await AdminService.getPendingEmployees();
    setState(() => pendingEmployees = data);
  }

  Future<void> _refreshLeaves() async {
    final data = await AdminService.getPendingLeaves();
    setState(() => pendingLeaves = data);
  }

  Future<void> _approveEmployee(String userId) async {
    await AdminService.approveEmployee(userId);

    setState(() {
      pendingEmployees.removeWhere((e) => e['_id'] == userId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee approved')));

    _refreshEmployees();
  }

  Future<void> _rejectEmployee(String userId) async {
    await AdminService.rejectEmployee(userId, 'Rejected');

    setState(() {
      pendingEmployees.removeWhere((e) => e['_id'] == userId);
    });

    _refreshEmployees();
  }

  Future<void> _approveLeave(String leaveId) async {
    await AdminService.approveLeave(leaveId);
    _refreshLeaves();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave approved')));
  }

  Future<void> _rejectLeave(String leaveId) async {
    await AdminService.rejectLeave(leaveId);
    _refreshLeaves();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave rejected')));
  }

  // 🟢 Custom Glass Card Wrapper (Replacing standard Material Card)
  Widget _buildGlassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Deep Midnight Background (Instead of solid color)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF090D16), Color(0xFF111827), Color(0xFF0A0F1D)],
        ),
      ),
      child: Stack(
        children: [
          // 2. Subtle Glowing Orbs
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.08), // Violet
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.06), // Blue
              ),
            ),
          ),

          // 3. Your Exact Layout Structure wrapped in Transparent Scaffold
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.transparent, // Let gradient show through
              appBar: AppBar(
                backgroundColor: Colors.white.withOpacity(0.03), // Glassy AppBar
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  'Pending Requests',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                bottom: TabBar(
                  indicatorColor: const Color(0xFF3B82F6), // Sleek blue indicator
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  onTap: (index) {
                    setState(() {
                      selectedType = index == 0
                          ? PendingRequestType.employee
                          : PendingRequestType.leave;
                    });
                  },
                  tabs: const [
                    Tab(text: 'Employees'),
                    Tab(text: 'Leaves'),
                  ],
                ),
              ),
              body: selectedType == PendingRequestType.employee
                  ? _buildEmployeeList()
                  : _buildLeaveList(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPLOYEE LIST =================
  Widget _buildEmployeeList() {
    if (pendingEmployees.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshEmployees,
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF1E293B),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(
              child: Text(
                'No pending employees',
                style: TextStyle(color: Colors.white70), // Text color updated
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshEmployees,
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFF1E293B),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pendingEmployees.length,
        itemBuilder: (context, index) {
          final emp = pendingEmployees[index];
          // 🟢 Replaced standard Card with _buildGlassCard
          return _buildGlassCard(
            child: ListTile(
              title: Text(
                emp['name'] ?? emp['fullName'] ?? 'Employee',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                emp['email'] ?? '-',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)), // Adjusted to Emerald
                    onPressed: () => _approveEmployee(emp['_id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Color(0xFFEF4444)), // Adjusted to Red
                    onPressed: () => _rejectEmployee(emp['_id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= LEAVE LIST =================
  Widget _buildLeaveList() {
    if (pendingLeaves.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshLeaves,
        color: const Color(0xFF3B82F6),
        backgroundColor: const Color(0xFF1E293B),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(
              child: Text(
                'No pending leaves',
                style: TextStyle(color: Colors.white70), // Text color updated
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLeaves,
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFF1E293B),
      child: ListView.builder(
        itemCount: pendingLeaves.length,
        itemBuilder: (context, index) {
          final leave = pendingLeaves[index];
          // 🟢 Replaced standard Card with _buildGlassCard
          return _buildGlassCard(
            child: ListTile(
              title: Text(
                leave['employee'] != null
                    ? leave['employee']['fullName'] ?? 'Employee'
                    : 'Employee',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${leave['leaveType'] ?? 'Leave'} | '
                    '${leave['fromDate'] != null ? leave['fromDate'].split("T")[0] : '--'} '
                    '→ '
                    '${leave['toDate'] != null ? leave['toDate'].split("T")[0] : '--'}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Color(0xFF10B981)), // Adjusted to Emerald
                    onPressed: () => _approveLeave(leave['_id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Color(0xFFEF4444)), // Adjusted to Red
                    onPressed: () => _rejectLeave(leave['_id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}