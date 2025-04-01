// Tela com os detalhes da meta
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mets_app/database/database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MetaDetalhesScreen extends StatefulWidget {
  final Map<String, dynamic> meta;
  final String userId;

  MetaDetalhesScreen({required this.meta, required this.userId});

  @override
  _MetaDetalhesScreenState createState() => _MetaDetalhesScreenState();
}

class _MetaDetalhesScreenState extends State<MetaDetalhesScreen> {
  late Map<String, bool> diasSelecionados;
  final List<String> diasDaSemana = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb",
  ];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    diasSelecionados = Map<String, bool>.from(widget.meta['dias_meta']);
    diasSelecionados.updateAll((key, value) => false);
  }

  Future<void> atualizarDiaMeta(
    String metaId,
    String dia,
    bool novoValor,
  ) async {
    final userDoc = _firestore.collection('Users').doc(widget.userId);
    final metaDoc = userDoc.collection('Metas').doc(metaId);

    try {
      await metaDoc.update({'dias_meta.$dia': novoValor});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao atualizar meta: $e")));
    }
  }

  void toggleDia(String dia) {
    if (!widget.meta['dias_meta'].containsKey(dia)) return;

    setState(() {
      diasSelecionados[dia] = !diasSelecionados[dia]!;
    });

    atualizarDiaMeta(widget.meta['id'], dia, diasSelecionados[dia]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
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
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.logout, color: Color(0XFFEFE9E0)),
                onPressed: () => _showOptionsModal(context),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 170),
                Text(
                  widget.meta['nome_meta'],
                  style: TextStyle(
                    color: Color(0XFF0F9E99),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                //Deletar meta
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 65, 75, 74),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _showIconPicker,
              child: Icon(
                IconData(
                  widget.meta['icon'] ?? Icons.help_outline.codePoint,
                  fontFamily: 'MaterialIcons',
                ),
                color: Color(0XFF0F9E99),
                size: 50,
              ),
            ),

            const SizedBox(height: 40),
            // Dias da semana para realizar a meta
            Center(
              child: Wrap(
                spacing: 10,
                children:
                    diasDaSemana.map((dia) {
                      bool isSelected =
                          widget.meta['dias_meta'].containsKey(dia) &&
                          widget.meta['dias_meta'][dia] == true;
                      bool isChecked = diasSelecionados[dia] ?? false;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dia,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Color(0XFF0F9E99) : Colors.grey,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5, // Aumenta o tamanho do Checkbox
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Checkbox(
                                value: isChecked,
                                onChanged:
                                    isSelected
                                        ? (value) => toggleDia(dia)
                                        : null,
                                activeColor: Color(0XFF0F9E99),
                                checkColor: Color(0XFFEFE9E0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color:
                                      isSelected
                                          ? Color(0XFF0F9E99)
                                          : Colors
                                              .grey, // Borda quando desmarcado
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 50),

            Text(
              'Resultado Ótimo',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0F9E99),
              ),
            ),
            const SizedBox(height: 50),

            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: calcularProgresso().clamp(
                0.0,
                1.0,
              ), // Garante que fique entre 0 e 1
              center: Text(
                "${(calcularProgresso() * 100).toInt()}%",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0F9E99),
                ),
              ),
              progressColor: Color(0XFF0F9E99),
              backgroundColor: Color(0xFF135452),
              circularStrokeCap: CircularStrokeCap.round,
            ),

            const SizedBox(height: 70),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF0F9E99),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 7.0,
                  horizontal: 13.0,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Dialog para confirmar exclusão da meta
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0XFFEFE9E0),
          title: Column(
            children: [
              Row(
                children: [
                  Text("Excluir Meta"),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.cancel_outlined, color: Color(0XFF0F9E99)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
          content: Text("Tem certeza que deseja excluir esta meta?"),
          actions: [
            TextButton(
              onPressed: () async {
                await DatabaseMethods().deleteMeta(
                  widget.userId,
                  widget.meta['id'],
                );
                Navigator.pop(context); // Fecha o diálogo após a exclusão
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0XFF0F9E99),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  'Excluir',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0XFFEFE9E0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Atualizar a página
  void _atualizarIcone(String metaId, IconData icon) async {
    await DatabaseMethods().updateMetaIcon(widget.userId, metaId, icon);
    setState(() {
      widget.meta['icon'] =
          icon.codePoint; // Atualiza a interface com o novo ícone
    });
  }

  // Função para abrir dialog com os icons para o usuario escolher
  void _showIconPicker() {
    List<IconData> icones = [
      Icons.fitness_center,
      Icons.directions_run,
      Icons.book,
      Icons.music_note,
      Icons.work,
      Icons.nature_people,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Escolha um ícone"),
          content: Wrap(
            spacing: 10,
            children:
                icones.map((icon) {
                  return IconButton(
                    icon: Icon(icon, size: 40, color: Colors.teal),
                    onPressed: () {
                      _atualizarIcone(widget.meta['id'], icon);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  // Função para calcular o progresso semanal da meta
  double calcularProgresso() {
    int totalDiasPlanejados =
        widget.meta['dias_meta'].values.where((v) => v == true).length;
    int diasConcluidos = diasSelecionados.values.where((v) => v == true).length;

    if (totalDiasPlanejados == 0) return 0.0; // Evitar divisão por zero

    return diasConcluidos / totalDiasPlanejados;
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
