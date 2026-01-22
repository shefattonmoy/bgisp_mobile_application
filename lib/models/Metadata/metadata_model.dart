class Metadata {
  final int id;
  final String title;
  final String abstractInfo;
  final String? qualityAndExtent;
  final String? completeness;
  final String? datasetHistory;
  final String? productionPurpose;
  final String? processDescription;
  final String? datasetType;
  final String? datasetLanguage;
  final String? additionalInformation;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  Metadata({
    required this.id,
    required this.title,
    required this.abstractInfo,
    this.qualityAndExtent,
    this.completeness,
    this.datasetHistory,
    this.productionPurpose,
    this.processDescription,
    this.datasetType,
    this.datasetLanguage,
    this.additionalInformation,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      id: json['id'] as int,
      title: json['title'] as String,
      abstractInfo: json['abstract'] as String,
      qualityAndExtent: json['quality_and_extend'] as String?,
      completeness: json['completeness'] as String?,
      datasetHistory: json['dataset_history'] as String?,
      productionPurpose: json['production_purpose'] as String?,
      processDescription: json['process_description'] as String?,
      datasetType: json['dataset_type'] as String?,
      datasetLanguage: json['dataset_language'] as String?,
      additionalInformation: json['additional_information'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      createdBy: json['created_by'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      updatedBy: json['updated_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'abstract': abstractInfo,
      'quality_and_extend': qualityAndExtent,
      'completeness': completeness,
      'dataset_history': datasetHistory,
      'production_purpose': productionPurpose,
      'process_description': processDescription,
      'dataset_type': datasetType,
      'dataset_language': datasetLanguage,
      'additional_information': additionalInformation,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'updated_at': updatedAt?.toIso8601String(),
      'updated_by': updatedBy,
    };
  }

  // Get display fields for UI
  List<Map<String, String?>> getDisplayFields() {
    return [
      {'label': 'Title', 'value': title},
      {'label': 'Abstract', 'value': abstractInfo},
      {'label': 'Quality and Extent', 'value': qualityAndExtent},
      {'label': 'Completeness', 'value': completeness},
      {'label': 'Dataset History', 'value': datasetHistory},
      {'label': 'Production Purpose', 'value': productionPurpose},
      {'label': 'Process Description', 'value': processDescription},
      {'label': 'Dataset Type', 'value': datasetType},
      {'label': 'Dataset Language', 'value': datasetLanguage},
      {'label': 'Additional Information', 'value': additionalInformation},
    ];
  }

  // Get creation/update info
  String getCreationInfo() {
    String info = '';
    if (createdAt != null) {
      info += 'Created: ${createdAt!.toLocal().toString().split('.')[0]}';
      if (createdBy != null) {
        info += ' by $createdBy';
      }
    }
    return info;
  }

  String getUpdateInfo() {
    String info = '';
    if (updatedAt != null) {
      info += 'Updated: ${updatedAt!.toLocal().toString().split('.')[0]}';
      if (updatedBy != null) {
        info += ' by $updatedBy';
      }
    }
    return info;
  }

  @override
  String toString() {
    return 'Metadata(id: $id, title: $title)';
  }
}

class MetadataList {
  final List<Metadata> items;

  MetadataList({required this.items});

  factory MetadataList.fromJson(List<dynamic> json) {
    return MetadataList(
      items: json.map((item) => Metadata.fromJson(item)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return items.map((item) => item.toJson()).toList();
  }
}
