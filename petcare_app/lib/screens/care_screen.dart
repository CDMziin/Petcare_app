import 'package:flutter/material.dart';
import 'tips_list_screen.dart';

class CareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TipsListScreen(
      title: "Dicas de Cuidados",
      assetPath: "assets/tips/tips.json",
    );
  }
}
