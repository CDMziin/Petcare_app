import 'package:flutter/foundation.dart';

class ReminderModel {
  final String id;
  final String petId;
  final String title;
  final DateTime date;
  bool done;

  ReminderModel({
    required this.id,
    required this.petId,
    required this.title,
    required this.date,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'title': title,
    'date': date.toIso8601String(),
    'done': done,
  };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json['id'],
    petId: json['petId'],
    title: json['title'],
    date: DateTime.parse(json['date']),
    done: json['done'],
  );
}
