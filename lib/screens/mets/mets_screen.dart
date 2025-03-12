import 'package:flutter/material.dart';
import 'package:mets_app/assets/componentes/card/card_dashboard_mets.dart';

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
                        color: Color(0xFF135452).withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: GestureDetector(
                      // Adicionar função para criar meta
                      onTap: () {},
                      child: Icon(Icons.add, color: Color(0XFFEFE9E0)),
                    ),
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
                        DashboardCardMets(
                          title: 'Atividades Físicas',
                          icon: Icons.abc,
                          route: '/atividadesFisicas',
                        ),
                        DashboardCardMets(
                          title: 'Meditar',
                          icon: Icons.media_bluetooth_off,
                          route: '/meditar',
                        ),
                        DashboardCardMets(
                          title: 'Leitura',
                          icon: Icons.media_bluetooth_off,
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
}
