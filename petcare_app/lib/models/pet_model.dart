class PetModel {
  final String id;
  final String name;
  final String description;
  final DateTime birthDate;
  final String breed;
  final String size;
  final double weight;
  final String imageUrl;

  PetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.birthDate,
    required this.breed,
    required this.size,
    required this.weight,
    required this.imageUrl,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // SERIALIZAÇÃO
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'birthDate': birthDate.toIso8601String(),
    'breed': breed,
    'size': size,
    'weight': weight,
    'imageUrl': imageUrl,
  };

  static PetModel fromJson(Map<String, dynamic> json) => PetModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    birthDate: DateTime.parse(json['birthDate']),
    breed: json['breed'] ?? '',
    size: json['size'] ?? '',
    weight: (json['weight'] as num).toDouble(),
    imageUrl: json['imageUrl'] ?? '',
  );
}
