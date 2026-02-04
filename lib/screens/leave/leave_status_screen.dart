import 'package:flutter/material.dart';
import '../../services/leave_service.dart';

class LeaveStatusScreen extends StatefulWidget {
  const LeaveStatusScreen({super.key});

  @override
  State<LeaveStatusScreen> createState() => _LeaveStatusScreenState();
}

class _LeaveStatusScreenState extends State<LeaveStatusScreen> {
  bool isLoading = true;
  List<dynamic> leaves = [];

  @override
  void initState() {
    super.initState();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
    final data = await LeaveService.getMyLeaves();
    setState(() {
      leaves = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFACD),
        elevation: 0,
        title: const Text(
          'Leave Status',
          style: TextStyle(color: Color(0xFFFF69B4)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFF69B4)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leaves.length,
              itemBuilder: (context, index) {
                final leave = leaves[index];
                return ListTile(
                  title: Text(leave['leaveType']),
                  subtitle: Text(leave['reason'] ?? ''),
                  trailing: Text(
                    leave['status'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
    );
  }
}
