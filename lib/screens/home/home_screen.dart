import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: Center(child: Text('Home')),
      appBar: AppBar(
        backgroundColor: Color(0XFFEFE9E0),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('M', style: TextStyle(color: Color(0XFF0F9E99), fontWeight: FontWeight.bold, fontSize: 35),),
              Text('ets', style: TextStyle(color: Color(0XFF0F9E99), fontWeight: FontWeight.bold, fontSize: 30),),
              //Espaço entre o texto e icon
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0XFF0F9E99)),
                onPressed: () => _showOptionsModal(context),
              ),
            ],
          ),
        ),
        //Retira o botão de voltar
        automaticallyImplyLeading: false,
      ),
    );
  }

  //Modal para o usuário fazer logout do aplicativo
  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      //Arredondamento das bordas do modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0XFFEFE9E0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Color(0xFF2B3649)),
                ),
              ),
              //Botão para chamar função de logout (esquecer email do google)
              ElevatedButton.icon(
                onPressed: forgetAccountWithGoogle,
                icon: const Icon(Icons.email, color: Color(0XFF0F9E99)),
                label: const Text(
                  'Esquecer e-mail cadastrado',
                  style: TextStyle(color: Color(0XFF0F9E99)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade50,
                  elevation: 0,
                  side: BorderSide(color: Color(0XFF0F9E99)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              //Botão para chamar função de logout (email e senha)
              ElevatedButton.icon(
                onPressed: signUserOutWithEmailAndPassword,
                icon: const Icon(Icons.logout, color: Color(0XFF0F9E99)),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0XFF0F9E99)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade50,
                  elevation: 0,
                  side: BorderSide(color: Color(0XFF0F9E99)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Médodo de logout (email e senha)
  void signUserOutWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
    //Fazer logout e voltar para a tela de login
    Navigator.pushReplacementNamed(context, 'authPage');
  }

  //Médodo de logout (esquecer a conta Google logada)
  void forgetAccountWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      //Fazer logout e voltar para a tela de login
      Navigator.pushReplacementNamed(context, 'authPage');
    } catch (e) {
      //Se der erro no logout apaprece uma mensagem de erro
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao deslogar: $e")));
    }
  }
}
