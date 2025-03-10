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
        'cpf': null,
        'birthdate': null,
        'id': userId, 
      });
    }
  }

  // Atualizar informações do perfil do usuário
  Future<void> updateUserProfile(
      String name, String? cpf, String? birthdate, String userId) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    await userDoc.update({
      'name': name,
      'cpf': cpf,
      'birthdate': birthdate,
    });
  }

  // Obter informações do perfil do usuário
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('Users').doc(userId).get();
  }
}