import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _reasonController = TextEditingController();

  String leaveType = 'CL';
  DateTime? fromDate;
  DateTime? toDate;
  bool loading = false;

  Future<void> pickDate(bool isFrom) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        isFrom ? fromDate = picked : toDate = picked;
      });
    }
  }

  Future<void> applyLeave() async {
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select dates')),
      );
      return;
    }

    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/leaves/apply'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'leaveType': leaveType,
        'fromDate': fromDate!.toIso8601String(),
        'toDate': toDate!.toIso8601String(),
        'reason': _reasonController.text,
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave applied successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to apply leave')),
      );
    }
  }
final Map<String, String> leaveTypeMap = {
  'CL': 'Casual Leave',
  'SL': 'Sick Leave',
  'PL': 'Paid Leave',
  'WFH': 'Work From Home',
};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
DropdownButtonFormField<String>(
  value: leaveType,
  decoration: const InputDecoration(labelText: 'Leave Type'),
  items: leaveTypeMap.entries.map((entry) {
    return DropdownMenuItem<String>(
      value: entry.key,          // backend value
      child: Text(entry.value),  // UI text
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      leaveType = value!;
    });
  },
),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDate(true),
                    child: Text(fromDate == null
                        ? 'From Date'
                        : fromDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => pickDate(false),
                    child: Text(toDate == null
                        ? 'To Date'
                        : toDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : applyLeave,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Apply Leave'),
            ),
          ],
        ),
      ),
    );
  }
}
