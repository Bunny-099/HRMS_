class Payslip {
  final String employeeName;
  final int month;
  final int year;

  final Attendance attendance;
  final Earnings earnings;
  final Deductions deductions;

  final double monthlySalary;
  final double netSalary;

  Payslip({
    required this.employeeName,
    required this.month,
    required this.year,
    required this.attendance,
    required this.earnings,
    required this.deductions,
    required this.monthlySalary,
    required this.netSalary,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      employeeName: json['employeeName'],
      month: json['month'],
      year: json['year'],
      attendance: Attendance.fromJson(json['attendance']),
      earnings: Earnings.fromJson(json['earnings']),
      deductions: Deductions.fromJson(json['deductions']),
      monthlySalary: (json['monthlySalary'] ?? 0).toDouble(),
      netSalary: (json['netSalary'] ?? 0).toDouble(),
    );
  }
}

// ================= ATTENDANCE =================
class Attendance {
  final int presentDays;
  final int leaveDays;
  final int lopDays;

  Attendance({
    required this.presentDays,
    required this.leaveDays,
    required this.lopDays,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      presentDays: json['presentDays'] ?? 0,
      leaveDays: json['leaveDays'] ?? 0,
      lopDays: json['lopDays'] ?? 0,
    );
  }
}

// ================= EARNINGS =================
class Earnings {
  final double basic;
  final double hra;
  final double allowances;

  Earnings({
    required this.basic,
    required this.hra,
    required this.allowances,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      basic: (json['basic'] ?? 0).toDouble(),
      hra: (json['hra'] ?? 0).toDouble(),
      allowances: (json['allowances'] ?? 0).toDouble(),
    );
  }
}
class Deductions {
  final double lop;
  final double tax;
  final double pf;

  Deductions({
    required this.lop,
    required this.tax,
    required this.pf,
  });

  factory Deductions.fromJson(Map<String, dynamic> json) {
    return Deductions(
      lop: (json['lop'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      pf: (json['pf'] ?? 0).toDouble(),
    );
  }
}

