import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/tip_model.dart';

// Esta é uma HomeScreen ilustrativa, para personalizar com seus dados reais.
class HomeScreen extends StatelessWidget {
  final String userName;
  final List<PetModel> pets;
  final List<String> lembretes;
  final TipModel? quickTip;
  final String? ultimoArtigo;
  final double atividadePetSemana; // valor 0-1 para exemplo de gráfico

  HomeScreen({
    this.userName = "Pedro",
    List<PetModel>? pets,
    List<String>? lembretes,
    this.quickTip,
    this.ultimoArtigo = "Como dar banho em cães",
    this.atividadePetSemana = 0.75,
  })  : pets = pets ??
            [
              PetModel(name: "Rex", image: "assets/pets/rex.jpg"),
              PetModel(name: "Mia", image: "assets/pets/mia.jpg"),
            ],
        lembretes = lembretes ??
            [
              "Vacina do Rex: 12/07",
              "Consulta da Mia: 15/07",
              "Banho no petshop: 20/07"
            ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PetCare"),
        backgroundColor: Colors.brown[200],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          // Mensagem personalizada
          Text(
            "Bem-vindo, $userName! 👋",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Aqui está um resumo do seu PetCare hoje:",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),

          SizedBox(height: 24),

          // Card: Pets cadastrados
          if (pets.isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(pets.first.image),
                  radius: 28,
                ),
                title: Text(pets.map((p) => p.name).join(", ")),
                subtitle: Text("Seus pets cadastrados"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Vai para perfil
                },
              ),
            ),

          SizedBox(height: 14),

          // Card: Lembretes
          Card(
            color: Colors.yellow[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.amber[800]),
                      SizedBox(width: 8),
                      Text("Lembretes", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...lembretes.map((l) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text("• $l"),
                      )),
                  if (lembretes.isEmpty)
                    Text("Nenhum lembrete para hoje."),
                ],
              ),
            ),
          ),

          SizedBox(height: 14),

          // Card: Dica rápida
          Card(
            color: Colors.blue[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
              title: Text("Dica rápida"),
              subtitle: Text(quickTip?.title ?? "Mantenha água fresca disponível para seu pet!"),
              onTap: () {
                // Abrir detalhes da dica
              },
            ),
          ),

          SizedBox(height: 14),

          // Card: Último artigo
          Card(
            color: Colors.brown[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.article, color: Colors.brown[600]),
              title: Text("Última notícia"),
              subtitle: Text(ultimoArtigo ?? "Cães e gatos podem ser amigos?"),
              onTap: () {
                // Abrir artigos
              },
            ),
          ),

          SizedBox(height: 14),

          // Card: Gráfico de atividade (mock)
          Card(
            color: Colors.green[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.show_chart, color: Colors.green[600]),
                      SizedBox(width: 10),
                      Text("Atividade dos pets na semana"),
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: atividadePetSemana,
                    minHeight: 15,
                    backgroundColor: Colors.green[100],
                    color: Colors.green[500],
                  ),
                  SizedBox(height: 6),
                  Text("${(atividadePetSemana * 100).toInt()}% da meta semanal batida"),
                ],
              ),
            ),
          ),

          SizedBox(height: 26),

          // Navegação rápida
          Text("Acessos rápidos:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _quickNavButton(context, Icons.add, "Novo Pet", () {
                // Navega para cadastro/add pet
              }),
              _quickNavButton(context, Icons.pets, "Raças", () {
                // Navega para raças
              }),
              _quickNavButton(context, Icons.favorite, "Favoritos", () {
                // Navega para favoritos
              }),
              _quickNavButton(context, Icons.article, "Artigos", () {
                // Navega para artigos
              }),
            ],
          ),

          SizedBox(height: 32),
          Center(child: Text("PetCare © ${DateTime.now().year}", style: TextStyle(color: Colors.brown[200])))
        ],
      ),
    );
  }

  Widget _quickNavButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Material(
          color: Colors.brown[100],
          shape: const CircleBorder(),
          child: IconButton(
            icon: Icon(icon, color: Colors.brown[800]),
            iconSize: 36,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
