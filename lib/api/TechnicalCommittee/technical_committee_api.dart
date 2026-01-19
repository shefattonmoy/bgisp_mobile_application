import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bgisp/models/TechnicalCommittee/technical_committee_model.dart';

class TechnicalCommitteeApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_technical_committees/';

  // Get all technical committee members with language support
  static Future<List<TechnicalCommittee>> getTechnicalCommittees({
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
          print('No technical committee members found in response');
        }

        return jsonResponse
            .map((data) => TechnicalCommittee.fromJson(data))
            .toList();
      } else {
        throw Exception(
          'Failed to load technical committees. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get committee member by ID with language support
  static Future<TechnicalCommittee> getCommitteeMemberById({
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
        return TechnicalCommittee.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load committee member. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Search committee members by name with language support
  static Future<List<TechnicalCommittee>> searchCommitteeMembers({
    required String query,
    String language = 'en',
  }) async {
    try {
      // First get all committee members
      final allMembers = await getTechnicalCommittees(language: language);

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
