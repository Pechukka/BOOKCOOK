import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  static final FirestoreService _instance = FirestoreService._internal();
  FirestoreService._internal();
  static FirestoreService get instance => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── UID DEL USUARIO ACTUAL ──
  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('No user logged in');
    return uid;
  }

  // ── REFERENCIA A UNA SUBCOLECCIÓN DEL USUARIO ──
  CollectionReference _userCollection(String collectionName) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection(collectionName);
  }

  // ── GUARDAR UN DOCUMENTO ──
  Future<void> save(String collection, String id, Map<String, dynamic> data) async {
    await _userCollection(collection).doc(id).set(data);
  }

  // ── LEER TODOS LOS DOCUMENTOS ──
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    final snapshot = await _userCollection(collection).get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // ── BORRAR UN DOCUMENTO ──
  Future<void> delete(String collection, String id) async {
    await _userCollection(collection).doc(id).delete();
  }
}