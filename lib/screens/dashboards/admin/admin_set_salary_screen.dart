import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/soft_theme.dart';
import 'package:hrms/widgets/soft_ui.dart';

class AdminSetSalaryScreen extends StatefulWidget {
  const AdminSetSalaryScreen({super.key});

  @override
  State<AdminSetSalaryScreen> createState() => _AdminSetSalaryScreenState();
}

class _AdminSetSalaryScreenState extends State<AdminSetSalaryScreen> {
  final ApiService _api = ApiService();

  final TextEditingController _employeeIdCtrl = TextEditingController();
  final TextEditingController _salaryCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _setSalary() async {
    if (_employeeIdCtrl.text.isEmpty || _salaryCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }

    try {
      setState(() => _loading = true);

      final response = await _api.post('/salary/set', {
        'employeeId': _employeeIdCtrl.text.trim(),
        'monthlySalary': int.parse(_salaryCtrl.text.trim()),
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salary set successfully')),
        );
        _employeeIdCtrl.clear();
        _salaryCtrl.clear();
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
            SoftCard(
              child: TextField(
                controller: _employeeIdCtrl,
                decoration: const InputDecoration(
                  hintText: 'Employee ID',
                  border: InputBorder.none,
                ),
              ),
            ),

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
