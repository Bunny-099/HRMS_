import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_helper.dart';
import '../constants/api_constants.dart';

class HolidayService {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<List<dynamic>> getHolidays() async {
    final token = await TokenHelper.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/holidays'), // This matches the backend requirement drafted
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data is List ? data : (data['holidays'] ?? []);
      } else {
        // Fallback or empty if not implemented yet
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
