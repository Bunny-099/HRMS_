import 'package:flutter/material.dart';
import 'package:hrms/theme/soft_theme.dart';
import 'package:hrms/widgets/soft_ui.dart';

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
      backgroundColor: SoftTheme.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SoftCard(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Salary Structure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SoftTheme.textColor,
                    ),
                  ),
                  SoftCard(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Earnings',
                      amount: totalEarnings,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Deductions',
                      amount: totalDeductions,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildSummaryCard(
                title: 'Net Salary',
                amount: netSalary,
                color: SoftTheme.primaryColor,
              ),
              const SizedBox(height: 30),
              
              // Salary components list
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earnings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SoftTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: salaryComponents.where((component) => component.type == 'Earning').length,
                        itemBuilder: (context, index) {
                          final earningComponents = salaryComponents.where((component) => component.type == 'Earning').toList();
                          final component = earningComponents[index];
                          return _buildComponentCard(component);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Deductions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SoftTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: salaryComponents.where((component) => component.type == 'Deduction').length,
                        itemBuilder: (context, index) {
                          final deductionComponents = salaryComponents.where((component) => component.type == 'Deduction').toList();
                          final component = deductionComponents[index];
                          return _buildComponentCard(component);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required double amount, required Color color}) {
    return SoftCard(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: SoftTheme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentCard(SalaryComponent component) {
    return SoftCard(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                component.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: SoftTheme.textColor,
                ),
              ),
            ),
            Text(
              '₹${component.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: component.type == 'Earning' 
                    ? Colors.green 
                    : Colors.red,
              ),
            ),
          ],
        ),
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