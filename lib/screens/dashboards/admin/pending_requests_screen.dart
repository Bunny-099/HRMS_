import 'package:flutter/material.dart';
import 'package:hrms/services/admin_service.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  List pendingEmployees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingEmployees();
  }

  Future<void> _loadPendingEmployees() async {
    final data = await AdminService.getPendingEmployees();
    setState(() {
      pendingEmployees = data;
      loading = false;
    });
  }

  Future<void> _approveEmployee(String userId) async {
    try {
      await AdminService.approveEmployee(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee approved successfully')),
      );

      _loadPendingEmployees(); // refresh list
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Approval failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Employee Requests')),
body: loading
    ? const Center(child: CircularProgressIndicator())
    : RefreshIndicator(
        onRefresh: _loadPendingEmployees, // 🔥 PULL TO REFRESH
        child: pendingEmployees.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No pending requests')),
                ],
              )
            : ListView.builder(
                itemCount: pendingEmployees.length,
                itemBuilder: (context, index) {
                  final emp = pendingEmployees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(emp['name']),
                      subtitle: Text(emp['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () =>
                                _approveEmployee(emp['_id']),
                            child: const Text('Approve'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Reject feature coming soon',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),

    );
  }
}
