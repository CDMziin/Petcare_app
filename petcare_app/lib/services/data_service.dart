import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/breed.dart';
import '../models/news.dart';
import '../models/care.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Breed>> streamBreeds() => _db
      .collection('breeds')
      .orderBy('name')
      .snapshots()
      .map((snap) => snap.docs.map((d) => Breed.fromFirestore(d)).toList());

  Stream<List<News>> streamNews() => _db
      .collection('news')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((d) => News.fromFirestore(d)).toList());

  Stream<List<Care>> streamCare() => _db
      .collection('care')
      .orderBy('title')
      .snapshots()
      .map((snap) => snap.docs.map((d) => Care.fromFirestore(d)).toList());
}