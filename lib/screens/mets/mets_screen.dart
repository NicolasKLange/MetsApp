import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:mets_app/assets/componentes/card/card_dashboard_mets.dart';
import 'package:mets_app/database/database.dart';

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

  // Atualização na função createMets para salvar a meta
  Future<String?> createMets(BuildContext context) async {
    TextEditingController nameMetsController = TextEditingController();
    TextEditingController dateMetsController = TextEditingController();
    List<String> selectedDays = [];

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void toggleDay(String day) {
              setState(() {
                if (selectedDays.contains(day)) {
                  selectedDays.remove(day);
                } else {
                  selectedDays.add(day);
                }
              });
            }

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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameMetsController,
                    decoration: InputDecoration(
                      hintText: 'Nome da meta',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dateMetsController,
                    decoration: InputDecoration(
                      hintText: 'Data final da meta',
                      border: InputBorder.none,
                    ),
                    inputFormatters: [MaskedInputFormatter('00/00/0000')],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            ['Dom', 'Seg', 'Ter', 'Qua'].map((day) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: GestureDetector(
                                  onTap: () => toggleDay(day),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedDays.contains(day)
                                              ? Color(0XFF0F9E99)
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            ['Qui', 'Sex', 'Sab'].map((day) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: GestureDetector(
                                  onTap: () => toggleDay(day),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedDays.contains(day)
                                              ? Color(0XFF0F9E99)
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    if (nameMetsController.text.isNotEmpty &&
                        dateMetsController.text.isNotEmpty) {
                      await DatabaseMethods().saveMeta(
                        nameMetsController.text,
                        dateMetsController.text,
                        selectedDays,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFF0F9E99),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
              ],
            );
          },
        );
      },
    );
  }
}
