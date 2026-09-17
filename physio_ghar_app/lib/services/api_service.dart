import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/therapist_profile_model.dart';
import '../models/patient_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  static Future<TherapistProfileModel> fetchProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/profile'));
    if (response.statusCode == 200) {
      return TherapistProfileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  static Future<void> updateProfile(TherapistProfileModel profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  static Future<List<PatientModel>> fetchPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients'));
    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((model) => PatientModel.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  static Future<void> addSessionNote(String patientId, SessionNoteModel note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/$patientId/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': note.date,
        'note': note.note,
        'exercises': note.exercises,
        'next_session_plan': note.nextSessionPlan,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add session note');
    }
  }

  static Future<void> updateSessionNote(String patientId, SessionNoteModel note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/$patientId/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': note.date,
        'note': note.note,
        'exercises': note.exercises,
        'next_session_plan': note.nextSessionPlan,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update session note');
    }
  }
}