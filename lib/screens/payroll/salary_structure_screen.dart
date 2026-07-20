import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class SalaryStructureScreen extends StatefulWidget {
  static const String id = 'salary_structure_screen';
  
  const SalaryStructureScreen({super.key});

  @override
  State<SalaryStructureScreen> createState() => _SalaryStructureScreenState();
}

class _SalaryStructureScreenState extends State<SalaryStructureScreen> {
  // Sample salary structure data
  List<SalaryComponent> salaryComponents = [
    SalaryComponent(
      name: 'Basic Salary',
      amount: 25000,
      type: 'Earning',
    ),
    SalaryComponent(
      name: 'House Rent Allowance',
      amount: 12500,
      type: 'Earning',
    ),
    SalaryComponent(
      name: 'Dearness Allowance',
      amount: 5000,
      type: 'Earning',
    ),
    SalaryComponent(
      name: 'Medical Allowance',
      amount: 2500,
      type: 'Earning',
    ),
    SalaryComponent(
      name: 'Transport Allowance',
      amount: 3000,
      type: 'Earning',
    ),
    SalaryComponent(
      name: 'Provident Fund',
      amount: 3000,
      type: 'Deduction',
    ),
    SalaryComponent(
      name: 'Professional Tax',
      amount: 200,
      type: 'Deduction',
    ),
    SalaryComponent(
      name: 'Income Tax',
      amount: 2500,
      type: 'Deduction',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double totalEarnings = salaryComponents
        .where((component) => component.type == 'Earning')
        .fold(0, (sum, component) => sum + component.amount);
        
    double totalDeductions = salaryComponents
        .where((component) => component.type == 'Deduction')
        .fold(0, (sum, component) => sum + component.amount);
        
    double netSalary = totalEarnings - totalDeductions;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Salary Structure',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.info_outline_rounded, color: Colors.white),
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
                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Earnings',
                        amount: totalEarnings,
                        color: GlassTheme.successAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Deductions',
                        amount: totalDeductions,
                        color: GlassTheme.errorAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSummaryCard(
                  title: 'Net Salary',
                  amount: netSalary,
                  color: GlassTheme.accentGlow,
                  isLarge: true,
                ),
                const SizedBox(height: 32),
                
                // Salary components list
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Earnings', GlassTheme.successAccent),
                        _buildComponentsList('Earning'),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Deductions', GlassTheme.errorAccent),
                        _buildComponentsList('Deduction'),
                        const SizedBox(height: 20),
                      ],
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

  Widget _buildComponentsList(String type) {
    final components = salaryComponents.where((c) => c.type == type).toList();
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: components.map((c) => _buildComponentRow(c)).toList(),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required double amount, required Color color, bool isLarge = false}) {
    return GlassCard(
      borderRadius: 20,
      padding: EdgeInsets.all(isLarge ? 24 : 16),
      child: Column(
        children: [
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isLarge ? 28 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: GlassTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentRow(SalaryComponent component) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              component.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            '₹${component.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: component.type == 'Earning' 
                  ? GlassTheme.successAccent 
                  : GlassTheme.errorAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class SalaryComponent {
  final String name;
  final double amount;
  final String type; // 'Earning' or 'Deduction'

  SalaryComponent({
    required this.name,
    required this.amount,
    required this.type,
  });
}
