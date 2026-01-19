class FocalPerson {
  final int id;
  final String name;
  final String designation;
  final String organization;
  final String? phone;
  final String? email;
  final String? imagePath;

  // Additional fields from Django model (not in API response)
  final String? nameBn;
  final String? designationBn;
  final DateTime? createdAt;

  FocalPerson({
    required this.id,
    required this.name,
    required this.designation,
    required this.organization,
    this.phone,
    this.email,
    this.imagePath,

    // Additional fields
    this.nameBn,
    this.designationBn,
    this.createdAt,
  });

  factory FocalPerson.fromJson(Map<String, dynamic> json) {
    return FocalPerson(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'No Name',
      designation: json['designation'] as String? ?? 'No Designation',
      organization: json['organization'] as String? ?? 'No Organization',
      phone: json['phone']?.toString(),
      email: json['email'],
      imagePath: json['image'],

      // Additional fields initialization
      nameBn: null, // Not in API response
      designationBn: null, // Not in API response
      createdAt: null, // Not in API response
    );
  }

  // Full constructor with all fields
  factory FocalPerson.fromCompleteJson(Map<String, dynamic> json) {
    return FocalPerson(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'No Name',
      designation: json['designation'] as String? ?? 'No Designation',
      organization: json['organization'] as String? ?? 'No Organization',
      phone: json['phone']?.toString().trim(),
      email: json['email']?.toString().trim(),
      imagePath: json['image'],

      // Complete fields from Django model
      nameBn: json['name_bn'],
      designationBn: json['designation_bn'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'organization': organization,
      'phone': phone,
      'email': email,
      'image': imagePath,
    };
  }

  Map<String, dynamic> toCompleteJson() {
    return {
      'id': id,
      'name': name,
      'name_bn': nameBn,
      'designation': designation,
      'designation_bn': designationBn,
      'phone': phone,
      'email': email,
      'organization': organization,
      'image': imagePath,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Get contact info as formatted string
  String get contactInfo {
    String info = '';
    if (phone != null && phone!.isNotEmpty) {
      info += 'Phone: $phone';
    }
    if (email != null && email!.isNotEmpty) {
      if (info.isNotEmpty) info += '\n';
      info += 'Email: $email';
    }
    return info.isEmpty ? 'No contact information' : info;
  }

  @override
  String toString() {
    return 'FocalPerson{id: $id, name: $name, designation: $designation}';
  }
}
