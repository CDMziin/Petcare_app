import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/pet_model.dart';

class AddEditPetScreen extends StatefulWidget {
  final PetModel? pet;
  final Function(PetModel) onSave;
  AddEditPetScreen({this.pet, required this.onSave});
  @override
  _AddEditPetScreenState createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _breed;
  static const List<String> _breeds = ['Pug', 'Bulldog', 'Labrador', 'Vira-lata'];
  late String _description;
  late DateTime _birthDate;
  late String _size;
  late double _weight;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _name = widget.pet?.name ?? '';
    _breed = widget.pet?.breed ?? '';
    _description = widget.pet?.description ?? '';
    _birthDate = widget.pet?.birthDate ?? DateTime.now();
    _size = widget.pet?.size ?? '';
    _weight = widget.pet?.weight ?? 0.0;
  }

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _pickedImage = img);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(2000), lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final imgPath = _pickedImage?.path ?? widget.pet?.imageUrl ?? '';
      final pet = PetModel(
        id: widget.pet?.id ?? UniqueKey().toString(),
        name: _name,
        breed: _breed,
        imageUrl: imgPath,
        description: _description,
        birthDate: _birthDate,
        size: _size,
        weight: _weight,
      );
      widget.onSave(pet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(_birthDate);
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet == null ? 'Adicionar Pet' : 'Editar Pet')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: Stack(alignment: Alignment.bottomRight, children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _pickedImage != null
                        ? FileImage(File(_pickedImage!.path))
                        : (widget.pet != null && widget.pet!.imageUrl.isNotEmpty
                            ? AssetImage(widget.pet!.imageUrl)
                            : null) as ImageProvider?,
                    child: _pickedImage == null && (widget.pet?.imageUrl.isEmpty ?? true)
                        ? Icon(Icons.pets, size: 40, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    right: 0, bottom: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 16),
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (v) => v!.isEmpty ? 'Digite o nome' : null,
              onSaved: (v) => _name = v!,
            ),
            DropdownButtonFormField<String>(
              value: _breed.isNotEmpty ? _breed : null,
              decoration: InputDecoration(labelText: 'Raça'),
              items: _breeds.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
              onChanged: (v) => setState(() => _breed = v!),
              validator: (v) => v == null || v.isEmpty ? 'Selecione a raça' : null,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
              onSaved: (v) => _description = v!,
            ),
            SizedBox(height: 12),
            Row(children: [Expanded(child: Text('Nascido em: $dateStr')), TextButton(onPressed: _pickDate, child: Text('Selecionar'))]),
            TextFormField(
              initialValue: _size,
              decoration: InputDecoration(labelText: 'Porte'),
              onSaved: (v) => _size = v!,
            ),
            TextFormField(
              initialValue: _weight.toString(),
              decoration: InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (v == null || double.tryParse(v) == null) ? 'Peso inválido' : null,
              onSaved: (v) => _weight = double.parse(v!),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('Salvar')),
          ]),
        ),
      ),
    );
  }
}