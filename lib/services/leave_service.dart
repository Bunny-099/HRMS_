import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_helper.dart';

class LeaveService {
  static const String baseUrl = 'https://unelevated-rotundly-rashad.ngrok-free.dev/api/leaves';

  // ================= APPLY LEAVE =================
  static Future<void> applyLeave({
    required String leaveType,
    required String fromDate,
    required String toDate,
    required String reason,
  }) async {
    final token = await TokenHelper.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/apply'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'leaveType': leaveType,
        'fromDate': fromDate,
        'toDate': toDate,
        'reason': reason,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to apply leave');
    }
  }

  // ================= MY LEAVES =================
  static Future<List<dynamic>> getMyLeaves() async {
    final token = await TokenHelper.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['leaves'];
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }
}
