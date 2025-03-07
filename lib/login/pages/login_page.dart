import '../pages/forgot_password_page.dart';
import '../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../assets/componentes/image_style/square_tile.dart';
import '../../assets/componentes/text_fields/text_fields_login.dart';
import '../../assets/componentes/buttons/button_login.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Controladores para coletar os dados
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isloading = false;

  //Método sign in usuário (email e senha)
  signUserIn() async {
    setState(() {
      isloading = true;
    });
    //Circulo de carregamento
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Verificação de email e senha para login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Erro de login
      showErrorMessage(e.code);
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
    setState(() {
      isloading = true;
    });
  }

  // Mensagem de erro de login no topo da tela
  void showErrorMessage(String message) {
    Get.snackbar(
      'Erro de Login',
      'Verifique seu email ou senha',
      backgroundColor: const Color(0xFF2B3649),
      colorText: const Color(0xFFEDE8E8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: SafeArea(
        child: Center(
          //SingleChildScrollView para scroll da página
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
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
                //Texto de boas vindas
                const Text(
                  "Bem vindo de volta",
                  style: TextStyle(
                    color: Color(0xFF0F9E99),
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                //TextFields para email
                Textfields(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 13),
                //TextFields para senha
                Textfields(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 13),
                //Função de esqueceu a senha
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    //Desixar no fim da linha
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswoardPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(
                            color: Color(0xFF0F9E99),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //Sign in button
                ButtonLogin(text: "Sign In", onTap: signUserIn),
                const SizedBox(height: 30),
                //Divisor (linha para separar)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFF135452),
                        ),
                      ),
                      //Texto entre os divisores
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Ou tente fazer login com ",
                          style: TextStyle(
                            color: Color(0xFF0F9E99),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xFF135452),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //SignIn com google
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/assets/images/signInGoogle.png',
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                //Não possui conta? Registre-se
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não tem conta?",
                      style: TextStyle(color: Color(0xFF0F9E99), fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Registre-se",
                        style: TextStyle(
                          color: Color(0xFF0F9E99),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
