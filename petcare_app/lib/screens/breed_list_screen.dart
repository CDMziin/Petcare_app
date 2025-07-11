import 'package:flutter/material.dart';

class BreedListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final breeds = ['Pug', 'Bulldog', 'Labrador', 'Vira-lata', 'Beagle', 'Poodle'];
    return Scaffold(
      appBar: AppBar(title: Text('Raças')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: breeds.length,
          itemBuilder: (_, i) => Card(
            child: ListTile(
              leading: Icon(Icons.pets, color: Colors.brown[700]),
              title: Text(breeds[i]),
            ),
          ),
        ),
      ),
    );
  }
}
