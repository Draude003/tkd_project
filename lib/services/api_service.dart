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

static Future<Map<String, dynamic>?> getStudentBilling() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/student/billing'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  } catch (e) {
    return null;
  }
}

static Future<Map<String, dynamic>?> getParentBilling(String studentId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/parent/billing/$studentId'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  } catch (e) {
    return null;
  }
}

static Future<bool> uploadPaymentProof(String invoiceId, String imagePath) async {
  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/invoices/$invoiceId/upload-proof'),
    );
    final headers = await _headers;
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('proof', imagePath));
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);
    return data['success'] == true;
  } catch (e) {
    return false;
  }
}

// ─── EVALUATION ───────────────────────────────────────────

static Future<List<dynamic>> getEvaluationStudents() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/evaluation/students'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['students'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<List<dynamic>> getSkillsByBelt(String beltLevel) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/evaluation/skills/$beltLevel'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['skills'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<bool> saveEvaluation(Map<String, dynamic> payload) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/instructor/evaluation/save'),
      headers: await _headers,
      body: jsonEncode(payload),
    );
    print('SAVE EVAL STATUS: ${response.statusCode}');
    print('SAVE EVAL BODY: ${response.body}');
    final data = jsonDecode(response.body);
    return data['success'] == true;
  } catch (e) {
    print('SAVE EVAL ERROR: $e');
    return false;
  }
}

static Future<List<dynamic>> getEvaluationHistory(int studentId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/evaluation/history/$studentId'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['evaluations'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<Map<String, dynamic>?> getStudentProgress() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/student/progress'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['data'];
    return null;
  } catch (e) {
    return null;
  }
}

static Future<Map<String, dynamic>?> getLatestEvaluation(int studentId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/evaluation/latest/$studentId'),
      headers: await _headers,
    );
    print('LATEST EVAL STATUS: ${response.statusCode}');
    print('LATEST EVAL BODY: ${response.body}');
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['evaluation'];
    return null;
  } catch (e) {
    print('LATEST EVAL ERROR: $e');
    return null;
  }
}

static Future<List<dynamic>> getBeltPromotionCandidates() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/instructor/belt-promotion/candidates'),
      headers: await _headers,
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) return data['candidates'];
    return [];
  } catch (e) {
    return [];
  }
}

static Future<bool> approvePromotion(List<int> studentIds) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/instructor/belt-promotion/approve'),
      headers: await _headers,
      body: jsonEncode({'student_ids': studentIds}),
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  } catch (e) {
    return false;
  }
}
}
