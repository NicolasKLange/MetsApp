// Tela com os detalhes da meta
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MetaDetalhesScreen extends StatelessWidget {
  final Map<String, dynamic> meta;

  MetaDetalhesScreen({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      //App bar do aplicativo
      appBar: AppBar(
        backgroundColor: Color(0XFF0F9E99),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'M',
                style: TextStyle(
                  color: Color(0XFFEFE9E0),
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              Text(
                'ets',
                style: TextStyle(
                  color: Color(0XFFEFE9E0),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              //Espaço entre o texto e icon
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0XFFEFE9E0)),
                onPressed: () => _showOptionsModal(context),
              ),
            ],
          ),
        ),
        //Retira o botão de voltar
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta['nome_meta'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Data Início: ${meta['data_inicio']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Data Término: ${meta['data_fim']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Dias da Meta: ${meta['dias_meta'].join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
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
                onPressed:
                    () => forgetAccountWithGoogle(
                      context,
                    ), // Passa o context aqui
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
              ElevatedButton.icon(
                onPressed:
                    () => signUserOutWithEmailAndPassword(
                      context,
                    ), // Passa o context aqui
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

  // Método de logout (email e senha)
  void signUserOutWithEmailAndPassword(BuildContext context) {
    FirebaseAuth.instance.signOut();
    // Fazer logout e voltar para a tela de login
    Navigator.of(context).pushReplacementNamed('authPage');
  }

  // Método de logout (esquecer a conta Google logada)
  void forgetAccountWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      // Fazer logout e voltar para a tela de login
      Navigator.of(context).pushReplacementNamed('authPage');
    } catch (e) {
      // Se der erro no logout, aparece uma mensagem de erro
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao deslogar: $e")));
    }
  }
}
