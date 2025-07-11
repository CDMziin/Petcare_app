import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pet_model.dart';
import 'add_edit_pet_screen.dart';

class PetProfileScreen extends StatelessWidget {
  final PetModel pet;
  final Function(PetModel) onEdit;
  final VoidCallback onDelete;

  PetProfileScreen({required this.pet, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(pet.birthDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () => _navigateToEdit(context)),
          IconButton(icon: Icon(Icons.delete), onPressed: () => _confirmDelete(context)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: pet.imageUrl.startsWith('assets/')
                ? AssetImage(pet.imageUrl)
                : FileImage(File(pet.imageUrl)) as ImageProvider,
          ),
          SizedBox(height: 20),
          Text(pet.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(pet.breed, style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 4),
          Text('Porte: ${pet.size}'),
          Text('Peso: ${pet.weight} kg'),
          Text('Nascido em: $dateStr'),
          SizedBox(height: 12),
          Text(pet.description, textAlign: TextAlign.center),
          Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton.icon(icon: Icon(Icons.edit), label: Text('Editar'), onPressed: () => _navigateToEdit(context)),
            ElevatedButton.icon(icon: Icon(Icons.delete), label: Text('Excluir'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => _confirmDelete(context)),
          ]),
        ]),
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditPetScreen(pet: pet, onSave: (updated) { onEdit(updated); Navigator.pop(context); } )));
  }

  void _confirmDelete(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text('Confirmar'), content: Text('Deseja realmente excluir ${pet.name}?'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')), TextButton(onPressed: () { onDelete(); Navigator.pop(context); }, child: Text('Excluir'))]));
  }
}
