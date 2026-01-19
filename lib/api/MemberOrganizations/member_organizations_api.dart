import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/MemebrOrganizations/member_organizations_model.dart';

class OrganizationApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_member_organizations/';

  static Future<List<MemberOrganization>> getMemberOrganizations({
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

        return jsonResponse
            .map((data) => MemberOrganization.fromJson(data))
            .toList();
      } else {
        throw Exception(
          'Failed to load organizations. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  static Future<List<MemberOrganization>> searchOrganizations({
    required String query,
    String language = 'en',
  }) async {
    try {
      final allOrganizations = await getMemberOrganizations(language: language);

      return allOrganizations
          .where(
            (org) => org.orgName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  static String getOrganizationImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    return '$baseUrl$imagePath';
  }
}
