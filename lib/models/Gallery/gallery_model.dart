class GalleryItem {
  final int id;
  final String title;
  final String shortDetails;
  final DateTime? createdAt;
  final String? imagePath;

  // Additional fields from Django model (not in API response)
  final String? titleBn;
  final String? shortDetailsBn;

  GalleryItem({
    required this.id,
    required this.title,
    required this.shortDetails,
    this.createdAt,
    this.imagePath,

    // Additional fields
    this.titleBn,
    this.shortDetailsBn,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      shortDetails: json['short_details'] as String? ?? 'No Description',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      imagePath: json['image'],

      // Additional fields initialization
      titleBn: null, // Not in API response
      shortDetailsBn: null, // Not in API response
    );
  }

  // Full constructor with all fields
  factory GalleryItem.fromCompleteJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      shortDetails: json['short_details'] as String? ?? 'No Description',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      imagePath: json['image'],

      // Complete fields from Django model
      titleBn: json['title_bn'],
      shortDetailsBn: json['short_details_bn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'short_details': shortDetails,
      'created_at': createdAt?.toIso8601String(),
      'image': imagePath,
    };
  }

  Map<String, dynamic> toCompleteJson() {
    return {
      'id': id,
      'title': title,
      'title_bn': titleBn,
      'short_details': shortDetails,
      'short_details_bn': shortDetailsBn,
      'created_at': createdAt?.toIso8601String(),
      'image': imagePath,
    };
  }

  // Get formatted date string
  String get formattedDate {
    if (createdAt == null) return 'Date not available';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  // Get time ago string
  String get timeAgo {
    if (createdAt == null) return '';

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'GalleryItem{id: $id, title: $title}';
  }
}
