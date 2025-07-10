import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.pets, size: 100, color: Colors.brown),
          SizedBox(height: 20),
          Text(
            'PETCARE',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Informações diárias sobre seus pets'),
        ],
      ),
    );
  }
}
