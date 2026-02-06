import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/soft_theme.dart';
import 'package:hrms/widgets/soft_ui.dart';

class AdminSetSalaryScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  const AdminSetSalaryScreen({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<AdminSetSalaryScreen> createState() => _AdminSetSalaryScreenState();
}

class _AdminSetSalaryScreenState extends State<AdminSetSalaryScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _salaryCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _setSalary() async {
    if (_salaryCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    try {
      setState(() => _loading = true);

      final response = await _api.post('/salary/set', {
        'employeeId': widget.employeeId, // 🔥 CORRECT
        'monthlySalary': int.parse(_salaryCtrl.text.trim()),
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salary set successfully')),
        );

        _salaryCtrl.clear();

        Navigator.pop(context); // ✅ optional but professional UX
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to set salary')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Server error')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftTheme.backgroundColor,
      appBar: AppBar(title: const Text('Set Employee Salary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Set Salary for ${widget.employeeName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 15),

            SoftCard(
              child: TextField(
                controller: _salaryCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Monthly Salary',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _setSalary,
                child: Text(_loading ? 'Saving...' : 'Save Salary'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
