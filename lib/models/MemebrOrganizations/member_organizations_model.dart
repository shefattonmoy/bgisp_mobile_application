import 'package:bgisp/api/MemberOrganizations/member_organizations_api.dart';

class MemberOrganization {
  final int id;
  final String orgName;
  final String orgShort;
  final String description;
  final String shortName;
  final String? imagePath;

  // Fields from Django model (not in API response but included for completeness)
  final String? orgNameBn;
  final String? orgInfoBn;
  final DateTime? createdAt;
  final String? orgShortBn;

  MemberOrganization({
    required this.id,
    required this.orgName,
    required this.orgShort,
    required this.description,
    required this.shortName,
    this.imagePath,

    // Additional fields that might be useful
    this.orgNameBn,
    this.orgInfoBn,
    this.createdAt,
    this.orgShortBn,
  });

  factory MemberOrganization.fromJson(Map<String, dynamic> json) {
    return MemberOrganization(
      id: json['id'] as int,
      orgName: json['org_name'] as String? ?? 'No Name',
      orgShort: json['org_short'] as String? ?? '',
      description: json['description'] as String? ?? 'No description available',
      shortName: json['short_name'] as String? ?? '',
      imagePath: json['image_path'],

      // These fields are not in API response but we keep them in model
      orgNameBn: null, // Not in API response
      orgInfoBn: null, // Not in API response
      createdAt: null, // Not in API response
      orgShortBn: null, // Not in API response
    );
  }

  // Alternative factory constructor for complete data (if API changes)
  factory MemberOrganization.fromCompleteJson(Map<String, dynamic> json) {
    return MemberOrganization(
      id: json['id'] as int,
      orgName: json['org_name'] as String? ?? 'No Name',
      orgShort: json['org_short'] as String? ?? '',
      description: json['description'] as String? ?? 'No description available',
      shortName: json['short_name'] as String? ?? '',
      imagePath: json['image_path'],

      // Complete fields from Django model
      orgNameBn: json['org_name_bn'],
      orgInfoBn: json['org_info_bn'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      orgShortBn: json['org_short_bn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'org_name': orgName,
      'org_short': orgShort,
      'description': description,
      'short_name': shortName,
      'image_path': imagePath,
    };
  }

  Map<String, dynamic> toCompleteJson() {
    return {
      'id': id,
      'org_name': orgName,
      'org_name_bn': orgNameBn,
      'org_short': orgShort,
      'org_short_bn': orgShortBn,
      'description': description,
      'org_info_bn': orgInfoBn,
      'created_at': createdAt?.toIso8601String(),
      'short_name': shortName,
      'image_path': imagePath,
    };
  }

  // Get full image URL
  String? get fullImageUrl {
    if (imagePath == null || imagePath!.isEmpty) return null;
    return '${OrganizationApi.baseUrl}$imagePath';
  }

  @override
  String toString() {
    return 'MemberOrganization{id: $id, orgName: $orgName, orgShort: $orgShort}';
  }
}
