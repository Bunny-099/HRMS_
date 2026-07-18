import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }Future<http.Response> rawGet(String endpoint) async {
  final token = await _getToken();

  return http.get(
    Uri.parse('$baseUrl$endpoint'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
}


  Future<http.Response> get(String endpoint) async {
    final token = await _getToken();

    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
  Future<List<dynamic>> fetchEmployees() async {
  final response = await get('/admin/employees');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['employees'];
  } else {
    throw Exception('Failed to fetch employees');
  }
}


  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();

    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
