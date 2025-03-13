import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:mets_app/assets/componentes/buttons/button_save.dart';
import 'package:mets_app/assets/componentes/profile_controller/profile_controller.dart';

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
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Profile Controller
  final ProfileController _profileController = ProfileController();

  //Avatar
  Color avatarColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    // Inicializar o perfil via controller
    _profileController.initializeProfile(
      userId: userId,
      nomeController: nomeController,
      cpfController: cpfController,
      dataNascimentoController: dataNascimentoController,
      onColorLoaded: (color) {
        setState(() {
          avatarColor = color;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 70),
          //Card com dados do usuário
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Color(0xFFEFE9E0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF135452).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            // Título da página
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Perfil',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0XFF0F9E99),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Avatar do usuário com inicial do nome
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _profileController.pickColor(
                        context: context,
                        avatarColor: avatarColor,
                        onColorSelected: (color) {
                          setState(() {
                            avatarColor = color;
                          });
                        },
                        onSave: () {
                          _profileController.updateProfile(
                            userId: userId,
                            context: context,
                            nomeController: nomeController,
                            cpfController: cpfController,
                            dataNascimentoController: dataNascimentoController,
                            avatarColor: avatarColor,
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF135452).withOpacity(0.4),
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
                const SizedBox(height: 40),

                // Campo nome do usuário
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Nome',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0XFF135452),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    // Campo CPF
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'CPF',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color(0XFF135452),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: cpfController,
                              decoration: InputDecoration(
                                hintText: 'xxx.xxx.xxx-xx',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskedInputFormatter('000.000.000-00'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Campo data de nascimento
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Data de nascimento',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0XFF135452),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                            TextField(
                              controller: dataNascimentoController,
                              decoration: InputDecoration(
                                hintText: 'DD/MM/AAAA',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskedInputFormatter('00/00/0000'),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Botão de salvar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ButtonSave(
                      text: "Salvar",
                      onTap: () async {
                        await _profileController.updateProfile(
                          userId: userId,
                          context: context,
                          nomeController: nomeController,
                          cpfController: cpfController,
                          dataNascimentoController: dataNascimentoController,
                          avatarColor: avatarColor,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
