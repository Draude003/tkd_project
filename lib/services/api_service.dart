import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_services.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.68.107:8000/api';

  static Future<Map<String, String>> get _headers async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<dynamic>> getMyClasses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/instructor/classes'),
        headers: await _headers,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['data'];
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getClassStudents(int classId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/classes/$classId/students'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return {'class': {}, 'students': []};
  } catch (e) {
    return {'class': {}, 'students': []};
  }
}
  
}