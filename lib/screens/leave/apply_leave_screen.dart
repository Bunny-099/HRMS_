import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: GlassTheme.accentGlow,
              onPrimary: Colors.white,
              surface: GlassTheme.bgDarkEnd,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: GlassTheme.bgDarkStart,
          ),
          child: child!,
        );
      },
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
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Apply Leave'),
      body: GlassBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Leave Type Dropdown
                  const Text('Leave Type', style: TextStyle(color: GlassTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: leaveType,
                        dropdownColor: GlassTheme.bgDarkEnd,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: const InputDecoration(border: InputBorder.none),
                        items: leaveTypeMap.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            leaveType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Date Selection
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('From Date', style: TextStyle(color: GlassTheme.textMuted, fontSize: 13)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => pickDate(true),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: GlassTheme.accentGlow),
                                    const SizedBox(width: 8),
                                    Text(
                                      fromDate == null
                                          ? 'Select'
                                          : fromDate!.toLocal().toString().split(' ')[0],
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To Date', style: TextStyle(color: GlassTheme.textMuted, fontSize: 13)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => pickDate(false),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: GlassTheme.accentGlow),
                                    const SizedBox(width: 8),
                                    Text(
                                      toDate == null
                                          ? 'Select'
                                          : toDate!.toLocal().toString().split(' ')[0],
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Reason Textfield
                  const Text('Reason', style: TextStyle(color: GlassTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: TextField(
                      controller: _reasonController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'Describe your reason...',
                        hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  GlassButton(
                    text: loading ? 'Applying...' : 'Apply Leave',
                    onTap: loading ? null : applyLeave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
