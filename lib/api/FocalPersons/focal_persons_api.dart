import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/FocalPersons/focal_persons_model.dart';

class FocalPersonApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_focal_persons/';

  // Get all focal persons with language support
  static Future<List<FocalPerson>> getFocalPersons({
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

        if (jsonResponse.isEmpty) {}

        return jsonResponse.map((data) => FocalPerson.fromJson(data)).toList();
      } else {
        throw Exception(
          'Failed to load focal persons. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get focal person by ID with language support
  static Future<FocalPerson> getFocalPersonById({
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
        return FocalPerson.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load focal person. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Search focal persons by name, designation, or organization
  static Future<List<FocalPerson>> searchFocalPersons({
    required String query,
    String language = 'en',
  }) async {
    try {
      final allFocalPersons = await getFocalPersons(language: language);

      // Filter based on query
      return allFocalPersons
          .where(
            (person) =>
                person.name.toLowerCase().contains(query.toLowerCase()) ||
                person.designation.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                person.organization.toLowerCase().contains(query.toLowerCase()),
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
