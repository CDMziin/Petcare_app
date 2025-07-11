import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

class ReminderProvider extends ChangeNotifier {
  List<ReminderModel> _reminders = [];
  List<ReminderModel> get reminders => _reminders;
  static const _storageKey = 'reminders';

  ReminderProvider() { _loadReminders(); }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey) ?? [];
    _reminders = data.map((e) => ReminderModel.fromJson(json.decode(e))).toList();
    notifyListeners();
  }

  Future<void> addReminder(ReminderModel rem) async {
    _reminders.add(rem);
    await _save();
    notifyListeners();
  }

  Future<void> updateReminder(ReminderModel rem) async {
    final idx = _reminders.indexWhere((r) => r.id == rem.id);
    if (idx >= 0) _reminders[idx] = rem;
    await _save();
    notifyListeners();
  }

  Future<void> removeReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _reminders.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, data);
  }
}