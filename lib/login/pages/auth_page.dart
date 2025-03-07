import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/home/home_screen.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Verifica se tem usuário no Firebase
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Se o usuário possuir conta, será redirecionado para a Home Screen
          if(snapshot.hasData) {
            return HomeScreen();
          }
          // Se o usuário nçao possuir conta, será redirecionado para a tela de resgistrar
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}