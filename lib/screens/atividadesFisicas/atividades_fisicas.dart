import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AtividadesFisicasScreen extends StatefulWidget {
  const AtividadesFisicasScreen({super.key});

  @override
  State<AtividadesFisicasScreen> createState() =>
      _AtividadesFisicasScreenState();
}

class _AtividadesFisicasScreenState extends State<AtividadesFisicasScreen> {
  // Lista de bool para cada dia da semana
  List<bool> daysChecked = List.generate(7, (_) => false);

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

      body: Column(
        children: [
          const SizedBox(height: 70),
          // Título da meta
          Center(
            child: Text(
              'Atividades Físicas',
              style: TextStyle(
                color: Color(0XFF0F9E99),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Icon da meta
          Icon(
            Icons.directions_run_rounded,
            color: Color(0XFF0F9E99),
            size: 50,
          ),
          const SizedBox(height: 30),

          // Dias da semana
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 30),
            child: Row(
              children: [
                Text(
                  'Dom',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Seg',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Ter',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Qua',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  'Qui',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Sex',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'Sáb',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0XFF0F9E99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          // Caixa de texto para marcar
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Row(
              //Lista com sete checkBox
              children: List.generate(7, (index) {
                return Row(
                  children: [
                    const SizedBox(width: 8),
                    //Aumentar o tamanho do checkBox
                    Transform.scale(
                      scale: 1.5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Checkbox(
                          value: daysChecked[index],
                          onChanged: (bool? value) {
                            setState(() {
                              daysChecked[index] = value!;
                            });
                          },
                          activeColor: Color(0XFF0F9E99),
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            // Borda quando desmarcado
                            color: Color(0XFF0F9E99),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          // Botão de voltar para tela anterior
          Container(
            decoration: BoxDecoration(
              color: Color(0XFF0F9E99),
              borderRadius: BorderRadius.circular(5),
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
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Text(
                  'Voltar',
                  style: TextStyle(
                    color: Color(0XFFEFE9E0),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
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
