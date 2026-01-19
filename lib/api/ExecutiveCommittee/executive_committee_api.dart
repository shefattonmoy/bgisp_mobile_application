import 'dart:convert';
import 'package:bgisp/models/ExecutiveCommittee/executive_committe_model.dart';
import 'package:http/http.dart' as http;

class ExecutiveCommitteeApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_executive_committees/';

  // Get all executive committee members with language support
  static Future<List<ExecutiveCommittee>> getExecutiveCommittees({
    String language = 'en',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint?lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          print('No executive committee members found in response');
        }

        return jsonResponse
            .map((data) => ExecutiveCommittee.fromJson(data))
            .toList();
      } else {
        throw Exception(
          'Failed to load executive committees. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get committee member by ID with language support
  static Future<ExecutiveCommittee> getCommitteeMemberById({
    required int id,
    String language = 'en',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint?id=$id&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        return ExecutiveCommittee.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load committee member. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Search committee members by designation with language support
  static Future<List<ExecutiveCommittee>> searchCommitteeMembers({
    required String query,
    String language = 'en',
  }) async {
    try {
      // First get all committee members
      final allMembers = await getExecutiveCommittees(language: language);

      // Filter based on query
      return allMembers
          .where(
            (member) => member.designation.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get image URL
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    return '$baseUrl$imagePath';
  }
}
