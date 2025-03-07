import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../assets/componentes/text_fields/text_fields_login.dart';

class ForgotPasswoardPage extends StatefulWidget {
  const ForgotPasswoardPage({super.key});

  @override
  State<ForgotPasswoardPage> createState() => _ForgotPasswoardPageState();
}

class _ForgotPasswoardPageState extends State<ForgotPasswoardPage> {
  final emailController = TextEditingController();

  //Coletar o email
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Mensagem de erro no topo da tela
  void showErrorMessage(String message) {
    Get.snackbar(
      'Erro de Login',
      'Este email não possui conta',
      backgroundColor: const Color(0xFF2B3649),
      colorText: const Color(0xFFEDE8E8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
    );
  }

  //Função para aleterar senha
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0F9E99),
            content: Text(
              'Link para aleterar senha enviado! Olhe seu email',
              style: TextStyle(color: const Color(0xFFEDE8E8), fontSize: 17),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFE9E0),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFEFE9E0),
      body: Column(
        children: [
          const SizedBox(height: 50),
          //Logo do app com borda arredondada
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //Sombra no quadrado de login com Google
              boxShadow: [
                BoxShadow(
                  color: Color(0XFF135452).withOpacity(0.5),
                  blurRadius: 10.0,
                  offset: const Offset(2, 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'lib/assets/images/logoMetsApp.png',
                height: 130,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Digite seu email para aleterar a senha',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F9E99),
                fontSize: 25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Textfields(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
          ),
          const SizedBox(height: 30),
          MaterialButton(
            onPressed: passwordReset,
            child: Container(
              padding: const EdgeInsets.only(top: 17, bottom: 17),
              margin: const EdgeInsets.symmetric(horizontal: 120),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0XFF135452).withOpacity(0.5),
                    blurRadius: 10.0,
                    offset: const Offset(2, 7),
                  ),
                ],
                color: const Color(0xFF0F9E99),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Alterar senha",
                  style: const TextStyle(
                    color: Color(0xFFEFE9E0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18, 
                  ),
                ),  
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'Voltar para página de login',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0F9E99),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
