import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final news = [
      {'title': 'Saúde do pet', 'date': DateTime.now().subtract(Duration(days: 1))},
      {'title': 'Alimentação balanceada', 'date': DateTime.now().subtract(Duration(days: 2))},
      {'title': 'Adote um amigo', 'date': DateTime.now().subtract(Duration(days: 3))},
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Notícias')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: news.map((item) => Card(
            child: ListTile(
              title: Text(item['title'] as String),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(item['date'] as DateTime)),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
