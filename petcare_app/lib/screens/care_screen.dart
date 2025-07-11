import 'package:flutter/material.dart';

class CareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cares = [
      'Vacinação em dia',
      'Banho mensal',
      'Escovação diária',
      'Limpeza de ouvido',
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Cuidados')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: cares.length,
          itemBuilder: (_, i) => Card(
            child: ListTile(
              leading: Icon(Icons.check_circle_outline, color: Colors.brown[700]),
              title: Text(cares[i]),
            ),
          ),
        ),
      ),
    );
  }
}