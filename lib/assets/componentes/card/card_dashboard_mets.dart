import 'package:flutter/material.dart';

// Classe para os cards na tela de dashoard de metas (Título, Icon, Rota)
class DashboardCardMets extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const DashboardCardMets({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Decoração do card, com borda e sombra
      decoration: BoxDecoration(
        color: const Color(0xFFEFE9E0),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // InkWell para navegar para a respectiva tela
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        // Alinhamento do texto e icon dentro do card
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: const Color(0xFF0F9E99)),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0F9E99),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
