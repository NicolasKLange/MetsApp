import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mets_app/assets/componentes/card/cardsMetsStyle/cards_mets_style.dart';
import 'package:mets_app/assets/componentes/navigation_bar/custom_navigation_bar.dart';
import 'package:mets_app/database/database.dart';
import 'package:mets_app/screens/mets/mets_screen.dart';
import 'package:mets_app/screens/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  Stream<DocumentSnapshot> get userStream {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                final userName = snapshot.data!['name'] ?? 'Usuário';
                return Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seja bem-vindo',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF0F9E99),
                        ),
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                          color: Color(0XFF0F9E99),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(left: 30, top: 70),
                  child: Text(
                    'Carregando...',
                    style: TextStyle(fontSize: 16, color: Color(0xFF0F9E99)),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Suas metas para o ano de 2025',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0XFF0F9E99),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _databaseMethods.getMetas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma meta cadastrada.',
                      style: TextStyle(fontSize: 18, color: Color(0XFF0F9E99)),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final meta = snapshot.data![index];
                    return CardMetsStyle(
                      title: meta['nome_meta'],
                      startDate: meta['data_inicio'],
                      endDate: meta['data_fim'],
                      progress: calculateProgress(meta['dias_meta']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double calculateProgress(Map<String, bool> diasMeta) {
    int totalDias = diasMeta.length;
    int diasConcluidos = diasMeta.values.where((done) => done).length;
    return diasConcluidos / totalDias;
  }

}


//Classe home para deixar appBar e navigationBar padronizados para o app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _opcaoSelecionada = 0;
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

      // Selecionar tela da NavigationBar
      body: IndexedStack(
        index: _opcaoSelecionada,
        children: const <Widget>[
          DashboardScreen(),
          MetsScreen(),
          ProfileScreen(),
        ],
      ),

      // NavigationBar
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _opcaoSelecionada,
        onDestinationSelected: (int index) {
          setState(() {
            _opcaoSelecionada = index;
          });
        },
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
