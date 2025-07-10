class BreedModel {
  final String name;
  final String image;
  final String description;
  final List<String> tips;
  final List<String> curiosities;

  BreedModel({
    required this.name,
    required this.image,
    required this.description,
    required this.tips,
    required this.curiosities,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      tips: List<String>.from(json['tips']),
      curiosities: List<String>.from(json['curiosities'] ?? []),
    );
  }
}
