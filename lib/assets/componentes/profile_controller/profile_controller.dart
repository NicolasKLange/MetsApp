import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mets_app/database/database.dart';

class ProfileController {
  //Database
  final DatabaseMethods _userDatabase = DatabaseMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para inicializar o perfil do usuário, com seus respectivos dados
  Future<void> initializeProfile({
    required String userId,
    required TextEditingController nomeController,
    required TextEditingController cpfController,
    required TextEditingController dataNascimentoController,
    required Function(Color) onColorLoaded,
  }) async {
    final user = _auth.currentUser;
    await _userDatabase.initializeUserProfile(user!.email!, userId);

    final userProfile = await _userDatabase.getUserProfile(userId);
    nomeController.text = userProfile['name'] ?? '';
    cpfController.text = userProfile['cpf'] ?? '';
    dataNascimentoController.text = userProfile['birthdate'] ?? '';

    if (userProfile['avatarColor'] != null) {
      onColorLoaded(Color(int.parse(userProfile['avatarColor'])));
    }
  }

  // Função para atualizar dados do perfil do usuário
  Future<void> updateProfile({
    required String userId,
    required BuildContext context,
    required TextEditingController nomeController,
    required TextEditingController cpfController,
    required TextEditingController dataNascimentoController,
    required Color avatarColor,
  }) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'name': nomeController.text,
      'cpf': cpfController.text.isEmpty ? null : cpfController.text,
      'birthdate':
          dataNascimentoController.text.isEmpty ? null : dataNascimentoController.text,
      'avatarColor': avatarColor.value.toString(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  // Função para o usuário trocar a cor do avatar
  void pickColor({
    required BuildContext context,
    required Color avatarColor,
    required Function(Color) onColorSelected,
    required VoidCallback onSave,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        Color tempColor = avatarColor;
        return AlertDialog(
          title: const Text("Escolha uma cor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: avatarColor,
              onColorChanged: (Color color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                onColorSelected(tempColor);
                onSave();
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}
