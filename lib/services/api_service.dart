import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_services.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.68.105:8000/api';

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

  static Future<int?> startSession(int classId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/classes/$classId/start-session'),
        headers: await _headers,
        body: jsonEncode({}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['session_id'];
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveAttendance(
    int sessionId,
    List<Map<String, dynamic>> attendances,
  ) async {
    try {
      final headers = await _headers;
      final response = await http
          .post(
            Uri.parse('$baseUrl/attendance'),
            headers: headers,
            body: jsonEncode({
              'session_id': sessionId,
              'attendances': attendances,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('Save attendance error: $e');
      return false;
    }
  }

  static Future<Map<String, int>> getAttendanceStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/instructor/attendance-stats'),
        headers: await _headers,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return {
          'present': data['data']['present'] ?? 0,
          'absent': data['data']['absent'] ?? 0,
          'late': data['data']['late'] ?? 0,
          'excused': data['data']['excused'] ?? 0,
        };
      }
      return {'present': 0, 'absent': 0, 'late': 0, 'excused': 0};
    } catch (e) {
      return {'present': 0, 'absent': 0, 'late': 0, 'excused': 0};
    }
  }

  static Future<Map<String, dynamic>?> getStudentProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/profile'),
        headers: await _headers,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final profile = data['data'] as Map<String, dynamic>;
        final loginType = await AuthService.getLoginType();
        profile['login_type'] = loginType; // <-- inject login_type
        return profile;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getStudentAttendance() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/attendance'),
        headers: await _headers,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['data'];
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<dynamic>> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/announcements'),
        headers: await _headers,
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['data'];
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> sendAnnouncement(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/announcements'),
        headers: await _headers,
        body: jsonEncode(payload),
      );
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

static Future<Map<String, dynamic>?> getParentProfile() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/parent/profile'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  } catch (e) {
    return null;
  }
}

static Future<Map<String, dynamic>?> getChildProfile(int childId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/parent/child/$childId'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  } catch (e) {
    return null;
  }
}

static Future<List<dynamic>> getStudentsList() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/students-list'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<List<dynamic>> getParentsList() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/parents-list'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<int> getUnreadAnnouncementCount() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/announcements/unread-count'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['unread_count'] ?? 0;
    return 0;
  } catch (e) {
    return 0;
  }
}

static Future<void> markAnnouncementsRead() async {
  try {
    await http.post(
      Uri.parse('$baseUrl/announcements/mark-read'),
      headers: await _headers,
    );
  } catch (e) {}
}

static Future<void> markAnnouncementRead(String id) async {
  try {
    await http.post(
      Uri.parse('$baseUrl/announcements/$id/mark-read'),
      headers: await _headers,
    );
  } catch (e) {}
}

static Future<void> dismissAnnouncement(String id) async {
  try {
    await http.post(
      Uri.parse('$baseUrl/announcements/$id/dismiss'),
      headers: await _headers,
    );
  } catch (e) {}
}

}
