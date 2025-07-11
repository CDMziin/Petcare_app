import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../models/pet_model.dart';
import 'add_edit_pet_screen.dart';
import 'pet_profile_screen.dart';

class ProfileScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final petProv = Provider.of<PetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Seus Pets', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...petProv.pets.map((pet) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: pet.imageUrl.startsWith('assets/')
                        ? AssetImage(pet.imageUrl)
                        : FileImage(File(pet.imageUrl)) as ImageProvider,
                  ),
                  title: Text(pet.name),
                  subtitle: Text(pet.breed),
                  onTap: () => _showPetProfile(context, pet),
                ),
              )),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar novo pet'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditPetScreen(onSave: (pet) {
                petProv.addPet(pet); Navigator.pop(context);
              })),
            ),
          ),
        ],
      ),
    );
  }

  void _showPetProfile(BuildContext context, PetModel pet) {
    final petProv = Provider.of<PetProvider>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PetProfileScreen(
        pet: pet,
        onEdit: (updated) { petProv.addPet(updated); Navigator.pop(context); Navigator.pop(context); },
        onDelete: () { petProv.removePet(pet.id); Navigator.pop(context); },
      )),
    );
  }
}
