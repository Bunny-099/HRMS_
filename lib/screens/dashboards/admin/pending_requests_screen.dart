import 'package:flutter/material.dart';
import 'package:hrms/services/admin_service.dart';

enum PendingRequestType { employee, leave }

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  PendingRequestType selectedType = PendingRequestType.employee;

  List pendingEmployees = [];
  List pendingLeaves = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // 🔹 Load BOTH lists once (real-time initial load)
  Future<void> _loadInitialData() async {
    final employees = await AdminService.getPendingEmployees();
    final leaves = await AdminService.getPendingLeaves();

    setState(() {
      pendingEmployees = employees;
      pendingLeaves = leaves;
    });
  }

  // 🔹 Refresh employees only
  Future<void> _refreshEmployees() async {
    final data = await AdminService.getPendingEmployees();
    setState(() => pendingEmployees = data);
  }

  // 🔹 Refresh leaves only
  Future<void> _refreshLeaves() async {
    final data = await AdminService.getPendingLeaves();
    setState(() => pendingLeaves = data);
  }

  // 🔹 Approve employee
  Future<void> _approveEmployee(String userId) async {
    await AdminService.approveEmployee(userId);

    setState(() {
      pendingEmployees.removeWhere((e) => e['_id'] == userId);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Employee approved')));

    _refreshEmployees(); // safety refresh
  }

   // reject employee
 Future<void> _rejectEmployee(String userId) async {
  await AdminService.rejectEmployee(userId, 'Rejected');

  setState(() {
    pendingEmployees.removeWhere((e) => e['_id'] == userId);
  });

  _refreshEmployees(); // optional safety sync
}


  // 🔹 Approve leave
  Future<void> _approveLeave(String leaveId) async {
    await AdminService.approveLeave(leaveId);
    _refreshLeaves();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Leave approved')));
  }

  // 🔹 Reject leave
  Future<void> _rejectLeave(String leaveId) async {
    await AdminService.rejectLeave(leaveId);
    _refreshLeaves();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Leave rejected')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pending Requests'),
          bottom: TabBar(
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
    );
  }

  // ================= EMPLOYEE LIST =================
  Widget _buildEmployeeList() {
    if (pendingEmployees.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshEmployees,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: Text('No pending employees')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshEmployees,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pendingEmployees.length,
        itemBuilder: (context, index) {
          final emp = pendingEmployees[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(emp['name'] ?? emp['fullName'] ?? 'Employee'),
              subtitle: Text(emp['email'] ?? '-'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () => _approveEmployee(emp['_id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
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
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: Text('No pending leaves')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLeaves,
      child: ListView.builder(
        itemCount: pendingLeaves.length,
        itemBuilder: (context, index) {
          final leave = pendingLeaves[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                leave['employee'] != null
                    ? leave['employee']['fullName'] ?? 'Employee'
                    : 'Employee',
              ),
              subtitle: Text(
                '${leave['leaveType'] ?? 'Leave'} | '
                '${leave['fromDate'] != null ? leave['fromDate'].split("T")[0] : '--'} '
                '→ '
                '${leave['toDate'] != null ? leave['toDate'].split("T")[0] : '--'}',
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approveLeave(leave['_id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
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
