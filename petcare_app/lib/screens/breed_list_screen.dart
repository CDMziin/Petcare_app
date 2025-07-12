import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/breed.dart';
import 'breed_detail_screen.dart';

class BreedListScreen extends StatelessWidget {
  final DataService _service = DataService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Breed>>(
      stream: _service.streamBreeds(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final breeds = snap.data ?? [];
        if (breeds.isEmpty) {
          return const Center(child: Text('Nenhuma raça encontrada.'));
        }
        return ListView.builder(
          itemCount: breeds.length,
          itemBuilder: (_, i) {
            final breed = breeds[i];
            return ListTile(
              leading: const Icon(Icons.pets, size: 36),
              title: Text(
                breed.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                breed.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BreedDetailScreen(breed: breed),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}