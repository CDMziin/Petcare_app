import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breed_model.dart';
import 'breed_detail_screen.dart';

class BreedListScreen extends StatefulWidget {
  @override
  State<BreedListScreen> createState() => _BreedListScreenState();
}

class _BreedListScreenState extends State<BreedListScreen> {
  List<BreedModel> breeds = [];
  List<BreedModel> filteredBreeds = [];
  final TextEditingController _searchController = TextEditingController();
  Set<String> favoriteNames = {};
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
    _loadFavorites();
    _searchController.addListener(_filterBreeds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBreeds() async {
    final String data = await rootBundle.loadString('assets/breeds/breeds.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      breeds = jsonResult.map((e) => BreedModel.fromJson(e)).toList();
      filteredBreeds = List.from(breeds);
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteNames = prefs.getStringList('favoriteBreeds')?.toSet() ?? {};
    });
  }

  Future<void> _toggleFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteNames.contains(name)) {
        favoriteNames.remove(name);
      } else {
        favoriteNames.add(name);
      }
      prefs.setStringList('favoriteBreeds', favoriteNames.toList());
    });
    _filterBreeds();
  }

  void _filterBreeds() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBreeds = breeds.where((breed) {
        final matchesSearch = breed.name.toLowerCase().contains(query);
        final matchesFavorite = !showOnlyFavorites || favoriteNames.contains(breed.name);
        return matchesSearch && matchesFavorite;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (breeds.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Switch(
              value: showOnlyFavorites,
              onChanged: (val) {
                setState(() {
                  showOnlyFavorites = val;
                });
                _filterBreeds();
              },
              activeColor: Colors.amber,
            ),
            const SizedBox(width: 8),
            Text(
              "Mostrar só favoritos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        SizedBox(height: 6),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Buscar raça...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Identificação de raça por IA em breve!')),
            );
          },
          icon: Icon(Icons.camera_alt),
          label: Text('Identificar Raça por Foto'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[300],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          showOnlyFavorites ? 'Suas Raças Favoritas' : 'Raças Populares',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...filteredBreeds.map((breed) => Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Image.asset(
                  breed.image,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
                title: Text(breed.name),
                trailing: IconButton(
                  icon: Icon(
                    favoriteNames.contains(breed.name) ? Icons.star : Icons.star_border,
                    color: favoriteNames.contains(breed.name) ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(breed.name),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BreedDetailScreen(breed: breed),
                    ),
                  );
                },
              ),
            )),
        if (filteredBreeds.isEmpty)
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Nenhuma raça encontrada.')),
          ),
      ],
    );
  }
}
