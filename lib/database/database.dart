import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // ========== PERFIL DO USUÁRIO ==========

  // Inicializar o perfil do usuário ao criar conta
  Future<void> initializeUserProfile(String email, String userId) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'name': email,
        'birthdate': null,
        'id': userId,
      });
    }
  }

  // Atualizar informações do perfil do usuário
  Future<void> updateUserProfile(
    String name,
    String? birthdate,
    String userId,
  ) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    await userDoc.update({'name': name, 'birthdate': birthdate});
  }

  // Obter informações do perfil do usuário
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('Users').doc(userId).get();
  }

  // ========== Metas ==========

  // Salvar meta no Firebase
  Future<void> saveMeta(
    String nomeMeta,
    String dataFim,
    List<String> diasMeta,
  ) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final metasCollection = userDoc.collection('Metas');

    await metasCollection.add({
      'nome_meta': nomeMeta,
      'data_inicio':
          DateTime.now()
              .toIso8601String(), // Data atual que o usuário criou a meta
      'data_fim': dataFim,
      'dias_meta': diasMeta,
    });
  }

  // Coletando todas as metas do usuário
  Future<List<Map<String, dynamic>>> getMetas() async {
  final userDoc = _firestore.collection('Users').doc(userId);
  final metasCollection = userDoc.collection('Metas');
  final querySnapshot = await metasCollection.get();

  return querySnapshot.docs.map((doc) {
    return {
      'id': doc.id,
      'nome_meta': doc['nome_meta'],
      'data_inicio': doc['data_inicio'],
      'data_fim': doc['data_fim'],
      'dias_meta': List<String>.from(doc['dias_meta']),
    };
  }).toList();
}
}
