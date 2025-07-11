import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pet_provider.dart';
import '../providers/reminder_provider.dart';
import '../models/reminder_model.dart';
import '../models/pet_model.dart';
import 'add_edit_pet_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProv = Provider.of<PetProvider>(context);
    final remProv = Provider.of<ReminderProvider>(context);
    final pets = petProv.pets;
    final reminders = remProv.reminders;
    final tips = ['Escove o pelo diariamente', 'Ofereça água fresca sempre', 'Passeie 30 min hoje'];

    return Scaffold(
      appBar: AppBar(title: Text('Início')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lembretes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lembretes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: Icon(Icons.add), onPressed: () => _showAddReminder(context, pets)),
                ],
              ),
              ...reminders.map((r) => Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: r.done,
                        onChanged: (v) { r.done = v!; remProv.updateReminder(r); },
                      ),
                      title: Text(r.title),
                      subtitle: Text(
                        '${pets.firstWhere((p) => p.id == r.petId).name} • ${DateFormat('dd/MM/yyyy').format(r.date)}'
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => remProv.removeReminder(r.id),
                      ),
                    ),
                  )),
              SizedBox(height: 16),

              // Dicas Rápidas
              Text('Dicas Rápidas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tips.length,
                  itemBuilder: (_, i) => Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 12),
                    child: Card(
                      color: Colors.amber[50],
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(tips[i], style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Atividade dos Pets
              Text('Atividade dos Pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...pets.map((pet) {
                final progress = 0.7; // Exemplo estático ou substituir por valor real
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: pet.imageUrl.startsWith('assets/')
                          ? AssetImage(pet.imageUrl)
                          : FileImage(File(pet.imageUrl)) as ImageProvider,
                    ),
                    title: Text(pet.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: progress),
                        SizedBox(height: 4),
                        Text('Atividade: ${(progress * 100).toInt()}%'),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddReminder(BuildContext context, List<PetModel> pets) {
    final titleCtrl = TextEditingController();
    PetModel? selected;
    DateTime date = DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Novo Lembrete'),
        content: StatefulBuilder(builder: (c, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: InputDecoration(labelText: 'Título')),
            DropdownButton<PetModel>(
              hint: Text('Selecione o pet'),
              value: selected,
              items: pets.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (v) => setState(() => selected = v),
            ),
            Row(children: [
              Text(DateFormat('dd/MM/yyyy').format(date)),
              TextButton(onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100)
                );
                if (d != null) setState(() => date = d);
              }, child: Text('Selecionar'))
            ])
          ],
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          TextButton(onPressed: () {
            if (titleCtrl.text.isNotEmpty && selected != null) {
              final rem = ReminderModel(
                id: UniqueKey().toString(),
                title: titleCtrl.text,
                petId: selected!.id,
                date: date,
              );
              Provider.of<ReminderProvider>(context, listen: false).addReminder(rem);
              Navigator.pop(context);
            }
          }, child: Text('Salvar'))
        ],
      ),
    );
  }
}