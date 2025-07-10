import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breed_model.dart';

class BreedDetailScreen extends StatefulWidget {
  final BreedModel breed;
  const BreedDetailScreen({required this.breed});

  @override
  State<BreedDetailScreen> createState() => _BreedDetailScreenState();
}

class _BreedDetailScreenState extends State<BreedDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteNames = prefs.getStringList('favoriteBreeds') ?? [];
    setState(() {
      isFavorite = favoriteNames.contains(widget.breed.name);
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteNames = prefs.getStringList('favoriteBreeds') ?? [];
    setState(() {
      if (isFavorite) {
        favoriteNames.remove(widget.breed.name);
        isFavorite = false;
      } else {
        favoriteNames.add(widget.breed.name);
        isFavorite = true;
      }
      prefs.setStringList('favoriteBreeds', favoriteNames);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.breed.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(widget.breed.image, height: 170, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 18),
            Text(widget.breed.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 18),
            Text("Dicas de cuidados:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...widget.breed.tips.map((tip) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.pets, size: 22),
                  title: Text(tip),
                )),
            if (widget.breed.curiosities.isNotEmpty)
              ...[
                SizedBox(height: 18),
                Text("Curiosidades:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...widget.breed.curiosities.map((c) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.lightbulb_outline, size: 22),
                      title: Text(c),
                    )),
              ]
          ],
        ),
      ),
    );
  }
}
