import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class AdminService {
  static const String baseUrl = ApiConstants.baseUrl;

  // 🔹 Get pending employees (FIXED ENDPOINT)
  static Future<List<dynamic>> getPendingEmployees() async {
    final token = await TokenHelper.getToken();

    final response = await http.get(
Uri.parse("$baseUrl/admin/pending-employees"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['pendingEmployees'] ?? [];
    } else {
      return [];
    }
  }
  static Future<Map<String, String>> _authHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

  static Future<Map<String, dynamic>> getAdminStats() async {
  final token = await TokenHelper.getToken();

  final response = await http.get(
    Uri.parse("$baseUrl/admin/stats"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load admin stats");
  }
}


  // 🔹 Approve employee
  static Future<bool> approveEmployee(String userId) async {
    final token = await TokenHelper.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/admin/approve/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    

    return response.statusCode == 200;
  }
  // 🔹 Reject employee
  static Future<void> rejectEmployee(String userId, String reason) async {
  await http.post(
    Uri.parse('$baseUrl/admin/employees/$userId/reject'),
    headers: await _authHeaders(),
    body: jsonEncode({'reason': reason}),
  );
}

  // 🔹 Get pending leaves (HR)
static Future<List<dynamic>> getPendingLeaves() async {
  final token = await TokenHelper.getToken();

  final response = await http.get(
    Uri.parse("$baseUrl/leaves/pending"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['leaves'];
  } else {
    return [];
  }
}
// ✅ Approve leave
static Future<bool> approveLeave(String leaveId) async {
  final token = await TokenHelper.getToken();

  final response = await http.put(
    Uri.parse("$baseUrl/leaves/$leaveId/approve"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  return response.statusCode == 200;
}

// ✅ Reject leave
static Future<bool> rejectLeave(String leaveId) async {
  final token = await TokenHelper.getToken();

  final response = await http.put(
    Uri.parse("$baseUrl/leaves/$leaveId/reject"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  return response.statusCode == 200;
}


}
