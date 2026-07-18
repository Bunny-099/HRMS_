import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmployeeService {
  static const String baseUrl = "https://unelevated-rotundly-rashad.ngrok-free.dev/api";

  static Future<Map<String, dynamic>?> getMyProfile() async {
    final token = await TokenHelper.getToken();

final response = await http.get(
  Uri.parse("$baseUrl/users/me"),
  headers: {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  },
);

if (response.statusCode == 200) {
  return jsonDecode(response.body);
} else {
  throw Exception('Failed to load profile: ${response.statusCode}');
}

  }
  static Future<void> updateProfile({
  required String fullName,
  required String phone,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/users/update-profile'),
    headers: await _authHeaders(),
    body: jsonEncode({
      'fullName': fullName,
      'phone': phone,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Update failed');
  }
}

  static Future<void> uploadProfileImage(String filePath) async {
  final token = await TokenHelper.getToken();

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/users/upload-profile'),

  );

  request.headers['Authorization'] = 'Bearer $token';

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      filePath,
    ),
  );

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception('Image upload failed');
  }
}
static Future<Map<String, String>> _authHeaders() async {
  final token = await TokenHelper.getToken();

  return {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
}


  static Future<Map<String, dynamic>> getDashboardStatus() async {
  final token = await TokenHelper.getToken();

  final response = await http.get(
    Uri.parse("$baseUrl/employee/dashboard-status"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
      'Failed to load dashboard status: ${response.statusCode}',
    );
  }
}
static Future<Map<String, dynamic>> getEmployeeById(String userId) async {
  final token = await TokenHelper.getToken();

  final response = await http.get(
   Uri.parse('$baseUrl/admin/employee/$userId'),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load employee');
  }
}


}
