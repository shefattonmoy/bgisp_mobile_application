import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bgisp/models/Gallery/gallery_model.dart';

class GalleryApi {
  // Update this with your Django backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://your-server-ip:8000'; // For real device

  static const String apiEndpoint = '/api/get_gallery/';

  // Get all gallery items with language support
  static Future<List<GalleryItem>> getGalleryItems({
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
          print('No gallery items found in response');
        }

        return jsonResponse.map((data) => GalleryItem.fromJson(data)).toList();
      } else {
        throw Exception(
          'Failed to load gallery items. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Get gallery item by ID with language support
  static Future<GalleryItem> getGalleryItemById({
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
        return GalleryItem.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to load gallery item. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Search gallery items by title or details
  static Future<List<GalleryItem>> searchGalleryItems({
    required String query,
    String language = 'en',
  }) async {
    try {
      // First get all gallery items
      final allGalleryItems = await getGalleryItems(language: language);

      // Filter based on query
      return allGalleryItems
          .where(
            (item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.shortDetails.toLowerCase().contains(query.toLowerCase()),
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
