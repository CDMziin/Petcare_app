import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet_model.dart';

class AddEditPetScreen extends StatefulWidget {
  final PetModel? pet;
  final Function(PetModel) onSave;

  const AddEditPetScreen({this.pet, required this.onSave});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  DateTime? _birthDate;
  late TextEditingController _breedController;
  String? _size;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _descController = TextEditingController(text: widget.pet?.description ?? '');
    _birthDate = widget.pet?.birthDate;
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _size = widget.pet?.size;
    _weightController = TextEditingController(text: widget.pet?.weight != null ? widget.pet!.weight.toString() : '',);



  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate() && _birthDate != null) {
      final newPet = PetModel(
        id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        birthDate: _birthDate!,
        breed: _breedController.text.trim(),
        size: _size ?? '',
        weight: double.tryParse(_weightController.text) ?? 0.0,
        imageUrl: _pickedImage?.path ?? widget.pet?.imageUrl ?? 'assets/pets/avatar_default.png',
      );
      widget.onSave(newPet);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Adicionar Pet' : 'Editar Pet'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 56,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (widget.pet != null
                          ? AssetImage(widget.pet!.imageUrl)
                          : AssetImage('assets/pets/avatar_default.png')) as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.brown[200],
                      child: Icon(Icons.edit, size: 20, color: Colors.brown[800]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Pet'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Nome obrigatório' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
              ),
              SizedBox(height: 12),
              ListTile(
                title: Text(_birthDate == null
                    ? 'Data de nascimento'
                    : 'Nascimento: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(2020),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _birthDate = picked);
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Raça'),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _size,
                decoration: InputDecoration(labelText: 'Porte'),
                items: ['Pequeno', 'Médio', 'Grande']
                    .map((sz) => DropdownMenuItem(value: sz, child: Text(sz)))
                    .toList(),
                onChanged: (val) => setState(() => _size = val),
                validator: (val) => val == null || val.isEmpty ? 'Selecione o porte' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    value == null || double.tryParse(value) == null ? 'Peso inválido' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePet,
                child: Text(widget.pet == null ? 'Adicionar' : 'Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
