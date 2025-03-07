
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mets_app/login/pages/auth_page.dart';
import 'package:mets_app/screens/home/home_screen.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Inicializando o Firebase no aplicativo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MetsApp());
}

class MetsApp extends StatelessWidget {
  const MetsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mets App',
      initialRoute: 'authPage',
      //Rotas das páginas do aplicativo
      routes: {
        'authPage': (context) => const AuthPage(),
        '/homePage': (context) => const HomeScreen(),
      },
    );
  }
}