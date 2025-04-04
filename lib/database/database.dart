import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // ========== PERFIL DO USUÁRIO ==========

  // Inicializar o perfil do usuário ao criar conta
  Future<void> initializeUserProfile(String email, String userId) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({'name': email, 'birthdate': null, 'id': userId});
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
  Future<void> deleteMeta(String userId, String metaId) async {
    try {
      final userDoc = _firestore.collection('Users').doc(userId);
      final metaDoc = userDoc.collection('Metas').doc(metaId);

      // Deleta a meta
      await metaDoc.delete();
    } catch (e) {
      print("Erro ao deletar meta: $e");
    }
  }

  Future<void> saveMeta(
    String nomeMeta,
    String dataInicio,
    String dataFim,
    List<String> diasSelecionados, // Lista de dias selecionados
  ) async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final metasCollection = userDoc.collection('Metas');

    // Mapa com todos os dias da semana, inicialmente falsos
    Map<String, bool> diasMeta = {
      'Dom': false,
      'Seg': false,
      'Ter': false,
      'Qua': false,
      'Qui': false,
      'Sex': false,
      'Sab': false,
    };

    // Define como `true` apenas os dias selecionados pelo usuário
    for (String dia in diasSelecionados) {
      diasMeta[dia] = true;
    }

    await metasCollection.add({
      'nome_meta': nomeMeta,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'dias_meta': diasMeta,
      'icon': Icons.help_outline.codePoint,
    });
  }

  // Alterar icon
  Future<void> updateMetaIcon(String userId, String metaId, IconData icon) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .collection('Metas')
      .doc(metaId)
      .update({'icon': icon.codePoint});
}


  // Coletando todas as metas do usuário
  Future<List<Map<String, dynamic>>> getMetas() async {
    final userDoc = _firestore.collection('Users').doc(userId);
    final metasCollection = userDoc.collection('Metas');
    final querySnapshot = await metasCollection.get();

    return querySnapshot.docs.map((doc) {
      int iconCode = doc['icon']; // Recupera o código do ícone como int

      // Converte o código para IconData
      IconData icon = IconData(iconCode, fontFamily: 'MaterialIcons');

      return {
        'id': doc.id,
        'nome_meta': doc['nome_meta'],
        'data_inicio': doc['data_inicio'],
        'data_fim': doc['data_fim'],
        'dias_meta': Map<String, bool>.from(doc['dias_meta']),
        'icon': icon, 
      };
    }).toList();
  }
}
