import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/tip_model.dart';
import 'tip_detail_screen.dart';

class TipsListScreen extends StatefulWidget {
  @override
  State<TipsListScreen> createState() => _TipsListScreenState();
}

class _TipsListScreenState extends State<TipsListScreen> {
  List<TipModel> tips = [];
  List<TipModel> filteredTips = [];
  String selectedCategory = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  List<String> get categories {
    final cats = tips.map((tip) => tip.category).toSet().toList();
    cats.sort();
    return ['Todas', ...cats];
  }

  @override
  void initState() {
    super.initState();
    _loadTips();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTips() async {
    final String data = await rootBundle.loadString('assets/tips/tips.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      tips = jsonResult.map((e) => TipModel.fromJson(e)).toList();
      filteredTips = List.from(tips);
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTips =
          tips.where((tip) {
            final matchCategory =
                (selectedCategory == 'Todas' ||
                    tip.category == selectedCategory);
            final matchSearch =
                tip.title.toLowerCase().contains(query) ||
                tip.summary.toLowerCase().contains(query) ||
                tip.content.toLowerCase().contains(query);
            return matchCategory && matchSearch;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Dicas e Artigos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                items:
                    categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                decoration: InputDecoration(
                  labelText: "Categoria",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val!;
                  });
                  _applyFilters();
                },
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar dica/artigo',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
        ...filteredTips.map(
          (tip) => Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Image.asset(
                tip.image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
              title: Text(tip.title),
              subtitle: Text(tip.summary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TipDetailScreen(tip: tip)),
                );
              },
            ),
          ),
        ),
        if (filteredTips.isEmpty)
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Nenhuma dica ou artigo encontrado.')),
          ),
      ],
    );
  }
}
