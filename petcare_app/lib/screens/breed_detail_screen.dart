import 'package:flutter/material.dart';
import '../models/breed.dart';

class BreedDetailScreen extends StatelessWidget {
  final Breed breed;
  const BreedDetailScreen({Key? key, required this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Origem:', style: Theme.of(context).textTheme.titleMedium),
          Text(breed.origin),
          const SizedBox(height: 12),

          Text('Porte:', style: Theme.of(context).textTheme.titleMedium),
          Text(breed.size),
          const SizedBox(height: 12),

          Text('Temperamento:', style: Theme.of(context).textTheme.titleMedium),
          Text(breed.temperament.join(', ')),
          const SizedBox(height: 12),

          Text('Descrição:', style: Theme.of(context).textTheme.titleMedium),
          Text(breed.description),
        ]),
      ),
    );
  }
}