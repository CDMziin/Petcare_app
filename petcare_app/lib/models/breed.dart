import 'package:cloud_firestore/cloud_firestore.dart';

class Breed {
  final String id;
  final String name;
  final String description;
  final String origin;              // novo
  final String size;                // novo
  final List<String> temperament;   // novo

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.size,
    required this.temperament,
  });

  factory Breed.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Breed(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      origin: data['origin'] ?? '',
      size: data['size'] ?? '',
      temperament: List<String>.from(data['temperament'] ?? []),
    );
  }
}