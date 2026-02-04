class Payslip {
  final String id;
  final String employeeName;
  final String employeeId;
  final int month;
  final int year;
  final double netSalary;

  Payslip({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.month,
    required this.year,
    required this.netSalary,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      id: json['_id'],
      employeeName: json['employee']['name'],
      employeeId: json['employee']['employeeId'],
      month: json['month'],
      year: json['year'],
      netSalary: (json['netSalary'] as num).toDouble(),
    );
  }
}
