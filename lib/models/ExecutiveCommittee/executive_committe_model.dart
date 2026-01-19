class ExecutiveCommittee {
  final int id;
  final String designation;
  final String committeeRole;
  final String organization;
  final String? imagePath;

  // Additional fields from Django model (not in API response)
  final String? designationBn;
  final String? committeeRoleBn;
  final DateTime? createdAt;

  ExecutiveCommittee({
    required this.id,
    required this.designation,
    required this.committeeRole,
    required this.organization,
    this.imagePath,

    // Additional fields
    this.designationBn,
    this.committeeRoleBn,
    this.createdAt,
  });

  factory ExecutiveCommittee.fromJson(Map<String, dynamic> json) {
    return ExecutiveCommittee(
      id: json['id'] as int,
      designation: json['designation'] ?? 'No Designation',
      committeeRole: json['committee_role'] as String? ?? 'No Role',
      organization: json['organization'] as String? ?? 'No Organization',
      imagePath: json['image'],

      // Additional fields initialization
      designationBn: null, // Not in API response
      committeeRoleBn: null, // Not in API response
      createdAt: null, // Not in API response
    );
  }

  // Full constructor with all fields
  factory ExecutiveCommittee.fromCompleteJson(Map<String, dynamic> json) {
    return ExecutiveCommittee(
      id: json['id'] as int,
      designation: json['designation'],
      committeeRole: json['committee_role'] as String? ?? 'No Role',
      organization: json['organization'] as String? ?? 'No Organization',
      imagePath: json['image'],

      // Complete fields from Django model
      designationBn: json['designation_bn'],
      committeeRoleBn: json['committee_role_bn'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'designation': designation,
      'committee_role': committeeRole,
      'organization': organization,
      'image': imagePath,
    };
  }

  Map<String, dynamic> toCompleteJson() {
    return {
      'id': id,
      'designation': designation,
      'committee_role': committeeRole,
      'committee_role_bn': committeeRoleBn,
      'designation_bn': designationBn,
      'organization': organization,
      'image': imagePath,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ExecutiveCommittee{id: $id, designation: $designation, organization: $organization, role: $committeeRole}';
  }
}
