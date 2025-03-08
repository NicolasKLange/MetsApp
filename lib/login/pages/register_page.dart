import '../services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../assets/componentes/image_style/square_tile.dart';
import '../../assets/componentes/text_fields/text_fields_login.dart';
import '../../assets/componentes/buttons/button_login.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Controladores para inserir os dados
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Variáveis para mostrar/ocultar senha
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isloading = false;

  // Método sign in do usuário utilizando email e senha
  signUserUp() async {
    // Circulo de carregamento
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Try para verificação de senha
    try {
      // Verifica se a senha possui no mínimo 6 caracteres
      if (passwordController.text.length < 6) {
        Navigator.pop(context);
        showErrorMessagePassword('A senha deve ter no mínimo 6 caracteres');
        return;
      }

      // Verificar se as senhas coincidem
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(
          context,
        ); // Fechar o carregamento se a criação do usuário for bem-sucedido
      } else {
        Navigator.pop(context); // Fechar o carregamento antes do erro
        showErrorMessage('Senhas não coincidem');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Fechar o carregamento em caso de erro
      showErrorMessage(e.message ?? 'Erro desconhecido');
    } catch (e) {
      Navigator.pop(context); // Fechar o carregamento em caso de erro genérico
      showErrorMessage(e.toString());
    }
  }

  // Mensagem de erro relatando que a senha deve ter no mínimo 6 caracteres
  void showErrorMessagePassword(String message) {
    Get.snackbar(
      'Erro de Login',
      'Senha deve conter no mínimo 6 caracteres',
      backgroundColor: const Color(0xFF2B3649),
      colorText: const Color(0xFFEDE8E8),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
    );
  }

  // Mensagem de erro relatando que as senhas que não coencidem
  void showErrorMessage(String message) {
    Get.snackbar(
      'Erro de Login',
      '',
      backgroundColor: const Color(0xFF135452),
      colorText: const Color(0xFFEFE9E0),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(8.0),
      duration: const Duration(seconds: 3),
      messageText: Text(
        'Senhas não coencidem, tente novamente',
        style: TextStyle(fontSize: 15, color: Color(0xFFEFE9E0)),
      ),
    );
  }

  //Criar conta nova para o usuário
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
                const SizedBox(height: 25),
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
                const SizedBox(height: 25),
                const Text(
                  "Vamos criar uma conta para você!",
                  style: TextStyle(
                    color: Color(0xFF0F9E99),
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 35),
                //TextFields para email
                Textfields(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //TextFields para senha
                Textfields(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //TextFields para Confirmar senha
                Textfields(
                  controller: confirmPasswordController,
                  hintText: "Confirmar senha",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 25),
                //Sign up buttonR
                ButtonLogin(text: "Sign Up", onTap: signUserUp),

                const SizedBox(height: 25),
                //Divisor (linha para separar)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0XFF135452),
                        ),
                      ),
                      //Texto entre os divisores
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Ou tente fazer login com",
                          style: TextStyle(
                            color: Color(0xFF0F9E99),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0XFF135452),
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
                //Já possui conta? Faça login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Já possui uma conta?",
                      style: TextStyle(color: Color(0xFF0F9E99), fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Faça Login",
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
