import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_helper.dart';

class AdminService {
  static const String baseUrl = "http://13.233.98.86:4000/api";

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
      return jsonDecode(response.body);
    } else {
      return [];
    }
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
}
