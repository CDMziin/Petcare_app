import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';
import 'add_edit_pet_screen.dart';

class ProfileScreenMain extends StatefulWidget {
  @override
  State<ProfileScreenMain> createState() => _ProfileScreenMainState();
}

class _ProfileScreenMainState extends State<ProfileScreenMain> {
  List<PetModel> userPets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petsJson = prefs.getStringList('userPets') ?? [];
    setState(() {
      userPets = petsJson.map((pet) => PetModel.fromJson(jsonDecode(pet))).toList();
    });
  }

  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();
    final petsJson = userPets.map((pet) => jsonEncode(pet.toJson())).toList();
    await prefs.setStringList('userPets', petsJson);
  }

  void _addOrEditPet(PetModel pet) {
    setState(() {
      final idx = userPets.indexWhere((p) => p.id == pet.id);
      if (idx >= 0) {
        userPets[idx] = pet;
      } else {
        userPets.add(pet);
      }
    });
    _savePets();
  }

  void _removePet(PetModel pet) {
    setState(() {
      userPets.removeWhere((p) => p.id == pet.id);
    });
    _savePets();
  }

  void _showPetProfile(PetModel pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PetProfileScreen(
          pet: pet,
          onEdit: (updatedPet) => _addOrEditPet(updatedPet),
          onDelete: () {
            _removePet(pet);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Seus Pets',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...userPets.map((pet) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: pet.imageUrl.startsWith('assets/')
                      ? AssetImage(pet.imageUrl)
                      : FileImage(File(pet.imageUrl)) as ImageProvider,
                ),
                title: Text(pet.name),
                subtitle: Text(pet.breed),
                onTap: () => _showPetProfile(pet),
              ),
            )),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditPetScreen(
                  onSave: (pet) => _addOrEditPet(pet),
                ),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text('Adicionar novo pet'),
        ),
      ],
    );
  }
}

class PetProfileScreen extends StatelessWidget {
  final PetModel pet;
  final Function(PetModel) onEdit;
  final VoidCallback onDelete;

  const PetProfileScreen({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditPetScreen(
                    pet: pet,
                    onSave: (updatedPet) {
                      onEdit(updatedPet);
                      Navigator.pop(context); // Fecha o AddEditPetScreen
                      Navigator.pop(context); // Volta para lista
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Remover Pet'),
                  content: Text('Tem certeza que deseja remover este pet?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('Remover'),
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context); // Fecha o AlertDialog
                        Navigator.pop(context); // Volta para lista de pets
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: pet.imageUrl.startsWith('assets/')
                  ? AssetImage(pet.imageUrl)
                  : FileImage(File(pet.imageUrl)) as ImageProvider,
            ),
            SizedBox(height: 16),
            Text(pet.name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(pet.description, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 24),
            ProfileDetail(label: 'Nascimento', value: '${pet.birthDate.day}/${pet.birthDate.month}/${pet.birthDate.year}'),
            ProfileDetail(label: 'Idade', value: '${pet.age} anos'),
            ProfileDetail(label: 'Raça', value: pet.breed),
            ProfileDetail(label: 'Porte', value: pet.size),
            ProfileDetail(label: 'Peso', value: '${pet.weight} kg'),
          ],
        ),
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 4, child: Text(value)),
        ],
      ),
    );
  }
}
