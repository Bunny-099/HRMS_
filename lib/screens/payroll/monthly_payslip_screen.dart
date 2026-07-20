import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
import 'payslip_pdf_download_screen.dart';
import 'dart:convert';
import 'package:hrms/models/payslip_model.dart';
import 'package:hrms/services/api_services.dart';

class MonthlyPayslipScreen extends StatefulWidget {
  static const String id = 'monthly_payslip_screen';

  const MonthlyPayslipScreen({super.key});

  @override
  State<MonthlyPayslipScreen> createState() => _MonthlyPayslipScreenState();
}

class _MonthlyPayslipScreenState extends State<MonthlyPayslipScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchPayslip();
  }

  Future<void> _fetchPayslip() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _api.get(
        '/payslips/me?month=$selectedMonth&year=$selectedYear',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          payslip = Payslip.fromJson(data);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Payslip not found';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load payslip';
        _loading = false;
      });
    }
  }

  final ApiService _api = ApiService();
  Payslip? payslip;
  bool _loading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: GlassBackground(child: Center(child: CircularProgressIndicator())));
    }

    if (_error != null) {
      return Scaffold(body: GlassBackground(child: Center(child: Text(_error!, style: const TextStyle(color: Colors.white)))));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: 'Monthly Payslip',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PayslipPdfDownloadScreen(payslip: payslip!),
                ),
              );
            },
            icon: const Icon(Icons.file_download_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Payslip header summary
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Payslip for $selectedMonth / $selectedYear',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_outline_rounded, size: 16, color: GlassTheme.textMuted),
                          const SizedBox(width: 8),
                          Text(
                            payslip!.employeeName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: GlassTheme.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sections
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchPayslip,
                    color: GlassTheme.accentGlow,
                    backgroundColor: GlassTheme.bgDarkEnd,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Attendance', Colors.blueAccent),
                          GlassCard(
                            borderRadius: 20,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                _buildPayslipItem('Present Days', payslip!.attendance.presentDays.toDouble(), isAmount: false),
                                _buildPayslipItem('Leave Days', payslip!.attendance.leaveDays.toDouble(), isAmount: false),
                                _buildPayslipItem('LOP Days', payslip!.attendance.lopDays.toDouble(), isAmount: false),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSectionHeader('Earnings', GlassTheme.successAccent),
                          GlassCard(
                            borderRadius: 20,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                _buildPayslipItem('Basic Salary', payslip!.earnings.basic),
                                _buildPayslipItem('HRA', payslip!.earnings.hra),
                                _buildPayslipItem('Allowances', payslip!.earnings.allowances),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSectionHeader('Deductions', GlassTheme.errorAccent),
                          GlassCard(
                            borderRadius: 20,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                _buildPayslipItem('LOP Deduction', payslip!.deductions.lop),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Net salary total
                          GlassCard(
                            borderRadius: 24,
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Net Salary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '₹${payslip!.netSalary.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: GlassTheme.successAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPayslipItem(String label, double value, {bool isAmount = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          Text(
            isAmount ? '₹${value.toStringAsFixed(0)}' : value.toStringAsFixed(0),
            style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
