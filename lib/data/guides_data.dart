class GuidesData {
  final String? guideId;
  final String title;
  final String content;
  final String authorId;
  final String publicationDate;
  final List<String> images;
  final List<String> links;
  final double latitude;
  final double longitude;
  final bool isApproved;

  GuidesData({
    this.guideId,
    required this.title,
    required this.content,
    required this.authorId,
    required this.publicationDate,
    required this.images,
    required this.links,
    required this.latitude,
    required this.longitude,
    required this.isApproved,
  });

  factory GuidesData.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    double latitude = 0.0;
    double longitude = 0.0;

    if (location is Map<String, dynamic>) {
      latitude = (location['latitude'] as num?)?.toDouble() ?? 0.0;
      longitude = (location['longitude'] as num?)?.toDouble() ?? 0.0;
    }

    return GuidesData(
      guideId: json['guide_id'] as String?,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['author_id'] ?? '',
      publicationDate: json['publication_date'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      links: List<String>.from(json['links'] ?? []),
      latitude: latitude,
      longitude: longitude,
      isApproved: json['is_approved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guide_id': guideId,
      'title': title,
      'content': content,
      'author_id': authorId,
      'publication_date': publicationDate,
      'images': images,
      'links': links,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'is_approved': isApproved,
    };
  }
}
