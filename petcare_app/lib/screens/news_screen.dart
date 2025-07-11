import 'package:flutter/material.dart';
import 'tips_list_screen.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TipsListScreen(
      title: "Artigos e Notícias",
      assetPath: "assets/articles/articles.json",
    );
  }
}
