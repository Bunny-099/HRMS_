import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
import 'salary_structure_screen.dart';
import 'monthly_payslip_screen.dart';

class PayrollHomeScreen extends StatefulWidget {
  static const String id = 'payroll_home_screen';

  const PayrollHomeScreen({super.key});

  @override
  State<PayrollHomeScreen> createState() => _PayrollHomeScreenState();
}

class _PayrollHomeScreenState extends State<PayrollHomeScreen> {
  final ApiService _api = ApiService();

  double? netSalary;
  int? lopDays;
  int? presentDays;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPayrollSummary();
  }

  Future<void> _fetchPayrollSummary() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final now = DateTime.now();

      final response = await _api.get(
        '/payroll/summary?month=${now.month}&year=${now.year}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          netSalary = (data['salary']['netSalary'] ?? 0).toDouble();
          lopDays = data['salary']['absent'] ?? 0;
          presentDays = data['salary']['present'] ?? 0;
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load payroll';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: GlassBackground(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: GlassBackground(child: Center(child: Text(_error!, style: const TextStyle(color: Colors.white)))),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Payroll',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Payroll summary card
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Text(
                        'Current Month Estimate',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '₹${netSalary?.toStringAsFixed(0) ?? '--'}',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Net Salary',
                        style: TextStyle(
                          fontSize: 15,
                          color: GlassTheme.successAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Actions Title
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons grid
                Expanded(
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildActionCard(
                        icon: Icons.account_balance_rounded,
                        title: 'Salary Structure',
                        subtitle: 'View components',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SalaryStructureScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.receipt_long_rounded,
                        title: 'Monthly Payslip',
                        subtitle: 'View details',
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MonthlyPayslipScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.file_download_rounded,
                        title: 'Download PDF',
                        subtitle: 'Save to device',
                        color: GlassTheme.errorAccent,
                        onTap: () {
                          // TODO: Implement download logic
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
