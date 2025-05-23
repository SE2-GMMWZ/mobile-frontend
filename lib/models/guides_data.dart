class Guide {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;

  Guide({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}