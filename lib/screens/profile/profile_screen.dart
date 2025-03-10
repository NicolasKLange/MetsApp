import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mets_app/database/database.dart';
import 'package:pick_color/pick_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Controllers
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController nomeController = TextEditingController();

  //Database
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseMethods _userDatabase = DatabaseMethods();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  //Avatar
  Color avatarColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          //Card com dados do usuário
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Color(0xFFEFE9E0),
              borderRadius: BorderRadius.circular(15),
              //Sombra do card
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF135452).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  
                  child: Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0XFF0F9E99),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: _pickColor,
                          child: Container(
                            //sombra no avatar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF577096),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: avatarColor,
                              child: Text(
                                nomeController.text.isNotEmpty
                                    ? nomeController.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                  ),
                ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF135452),
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Digite seu nome',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        //Campo CPF
                        child: TextField(
                          controller: cpfController,
                          decoration: const InputDecoration(
                            labelText: 'CPF',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF135452),
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'xxx.xxx.xxx-xx',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MaskedInputFormatter('000.000.000-00'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        //Campo data de nascimento
                        child: TextField(
                          controller: dataNascimentoController,
                          decoration: const InputDecoration(
                            labelText: 'Data nascimento',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF135452),
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: 'DD/MM/AAAA',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [MaskedInputFormatter('00/00/0000')],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _initializeProfile() async {
    await _userDatabase.initializeUserProfile(user!.email!, userId);

    final userProfile = await _userDatabase.getUserProfile(userId);
    setState(() {
      nomeController.text = userProfile['name'] ?? '';
      cpfController.text = userProfile['cpf'] ?? '';
      dataNascimentoController.text = userProfile['birthdate'] ?? '';

      // Carregar a cor escolhida para o Firebase
      if (userProfile['avatarColor'] != null) {
        avatarColor = Color(int.parse(userProfile['avatarColor']));
      }
    });
  }

  //Editar dados de perfil
  Future<void> _updateProfile() async {
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'name': nomeController.text,
      'cpf': cpfController.text.isEmpty ? null : cpfController.text,
      'birthdate':
          dataNascimentoController.text.isEmpty ? null : dataNascimentoController.text,
      'avatarColor':
          avatarColor.value.toString(), // Salvar a cor como uma String
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  // Método para selecionar uma cor do avatar
  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Escolha uma cor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: avatarColor,
              onColorChanged: (Color color) {
                setState(() {
                  avatarColor = color;
                });
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
                _updateProfile();
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
