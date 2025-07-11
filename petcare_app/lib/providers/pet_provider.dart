import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';

class PetProvider extends ChangeNotifier {
  List<PetModel> _pets = [];
  List<PetModel> get pets => _pets;
  static const _storageKey = 'pets';
  PetProvider() { _loadPets(); }
  Future<void> _loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey) ?? [];
    _pets = data.map((e) => PetModel.fromJson(json.decode(e))).toList();
    notifyListeners();
  }
  Future<void> addPet(PetModel pet) async {
    final idx = _pets.indexWhere((p) => p.id == pet.id);
    if (idx >= 0) _pets[idx] = pet; else _pets.add(pet);
    await _savePets(); notifyListeners();
  }
  Future<void> removePet(String id) async {
    _pets.removeWhere((p) => p.id == id);
    await _savePets(); notifyListeners();
  }
  Future<void> _savePets() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _pets.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, data);
  }
}