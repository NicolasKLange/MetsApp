import 'package:flutter/material.dart';
import 'package:mets_app/assets/componentes/card/card_dashboard_mets.dart';
import 'package:mets_app/assets/componentes/days_style/days_style.dart';

class MetsScreen extends StatefulWidget {
  const MetsScreen({super.key});

  @override
  State<MetsScreen> createState() => _MetsScreenState();
}

class _MetsScreenState extends State<MetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFE9E0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 55),
            child: Row(
              children: [
                Text(
                  'Suas metas',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF0F9E99),
                  ),
                ),
                Spacer(),
                // Icon para adicionar meta pessoal
                Container(
                  decoration: BoxDecoration(
                    color: Color(0XFF0F9E99),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      String? nome = await createMets(context);
                    },
                    icon: Icon(Icons.add, color: Color(0XFFEFE9E0)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 50, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      childAspectRatio: 1,
                      children: [
                        // Adicionar as metas criadas pelo usuario, sendo possivel modificar o icon da meta quando ir para a tela da meta 
                        DashboardCardMets(
                          title: 'Atividades Físicas',
                          icon: Icons.directions_run_rounded,
                          route: '/atividadesFisicasScreen',
                        ),
                        DashboardCardMets(
                          title: 'Meditar',
                          icon: Icons.media_bluetooth_off,
                          route: '/meditar',
                        ),
                        DashboardCardMets(
                          title: 'Leitura',
                          icon: Icons.book,
                          route: '/leitura',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> createMets(BuildContext context) async {
    // Controllers
    TextEditingController nameMetsController = TextEditingController();
    TextEditingController dateMetsController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0XFFEFE9E0),
          title: Row(
            children: [
              Text(
                'Criar meta',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF0F9E99),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.cancel_outlined, color: Color(0XFF0F9E99)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          // Campo de texto para nome da meta
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFEFE9E0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 2.0,
                    bottom: 2.0,
                  ),
                  child: TextField(
                    controller: nameMetsController,
                    decoration: InputDecoration(
                      hintText: 'Nome da meta',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Campo de texto para data final da meta
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFEFE9E0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(1, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    top: 2.0,
                    bottom: 2.0,
                  ),
                  child: TextField(
                    controller: dateMetsController,
                    decoration: InputDecoration(
                      hintText: 'Data final da meta',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 17.0,
                      bottom: 13.0,
                      left: 3.0,
                    ),
                    child: Text(
                      'Selecione os dias',
                      style: TextStyle(
                        color: Color(0XFF0F9E99),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // Dias da semana para realizar a meta
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dayContainer('Dom'),
                  SizedBox(width: 6),
                  dayContainer('Seg'),
                  SizedBox(width: 6),
                  dayContainer('Ter'),
                  SizedBox(width: 6),
                  dayContainer('Qua'),
                  SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dayContainer('Qui'),
                  SizedBox(width: 6),
                  dayContainer('Sex'),
                  SizedBox(width: 6),
                  dayContainer('Sab'),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Color(0XFF0F9E99),
                borderRadius: BorderRadius.circular(10),
              ),
              //Adicionar função para criar meta no database
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 15.0,
                    left: 15.0,
                    top: 5.0,
                    bottom: 5.0,
                  ),
                  child: Text(
                    'Criar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0XFFEFE9E0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
