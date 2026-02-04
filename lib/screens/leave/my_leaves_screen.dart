import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'apply_leave_screen.dart';
import 'leave_status_screen.dart';

class MyLeavesScreen extends StatefulWidget {
  const MyLeavesScreen({super.key});

  @override
  State<MyLeavesScreen> createState() => _MyLeavesScreenState();
}

class _MyLeavesScreenState extends State<MyLeavesScreen> {
  List leaves = [];
  bool loading = true;

  Future<void> fetchLeaves() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
     Uri.parse('$baseUrl/api/leaves/my'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      leaves = data['leaves'];
    }

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Leaves')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ApplyLeaveScreen()),
          );
          if (result == true) {
            setState(() => loading = true);
            fetchLeaves();
          }
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : leaves.isEmpty
              ? const Center(child: Text('No leaves found'))
              : ListView.builder(
                  itemCount: leaves.length,
                  itemBuilder: (context, index) {
                    return LeaveStatusCard(leave: leaves[index]);
                  },
                ),
    );
  }
}
