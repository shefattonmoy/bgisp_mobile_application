import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bgisp/models/Metadata/metadata_model.dart'; // Adjust path as needed

class MetadataApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_metadata/';

  // Get all metadata records
  static Future<List<Metadata>> getMetadata() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isEmpty) {
          print('No metadata records found in response');
        }

        return jsonResponse.map((data) => Metadata.fromJson(data)).toList();
      } else {
        throw Exception(
          'Failed to load metadata. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get metadata by ID
  static Future<Metadata> getMetadataById({required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint?id=$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        return Metadata.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load metadata. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Search metadata by title or other fields
  static Future<List<Metadata>> searchMetadata({required String query}) async {
    try {
      // First get all metadata records
      final allMetadata = await getMetadata();

      // Filter based on query (search in title, abstract, and other fields)
      return allMetadata
          .where(
            (metadata) =>
                (metadata.title?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ||
                (metadata.abstract?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false) ||
                (metadata.datasetType?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false) ||
                (metadata.datasetLanguage?.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Filter metadata by dataset type
  static Future<List<Metadata>> filterByDatasetType({
    required String datasetType,
  }) async {
    try {
      final allMetadata = await getMetadata();
      return allMetadata
          .where(
            (metadata) =>
                metadata.datasetType?.toLowerCase() ==
                datasetType.toLowerCase(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Filter metadata by language
  static Future<List<Metadata>> filterByLanguage({
    required String language,
  }) async {
    try {
      final allMetadata = await getMetadata();
      return allMetadata
          .where(
            (metadata) =>
                metadata.datasetLanguage?.toLowerCase() ==
                language.toLowerCase(),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
