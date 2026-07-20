import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
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
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'My Leaves'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlassTheme.accentGlow,
        child: const Icon(Icons.add_rounded, color: Colors.white),
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
      body: GlassBackground(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: GlassTheme.accentGlow))
            : leaves.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_rounded, size: 64, color: Colors.white.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        const Text(
                          'No leaves found',
                          style: TextStyle(color: GlassTheme.textMuted, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 80),
                      itemCount: leaves.length,
                      itemBuilder: (context, index) {
                        return LeaveStatusCard(leave: leaves[index]);
                      },
                    ),
                  ),
      ),
    );
  }
}
