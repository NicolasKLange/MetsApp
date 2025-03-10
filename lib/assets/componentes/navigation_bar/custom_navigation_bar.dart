import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      // Tema da NavigationBar
      data: const NavigationBarThemeData(
        // Tamanho e cor dos ícones da NavigationBar
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(
            size: 30,
            color: Color(0xFFEFE9E0), // Ícones não selecionados
          ),
        ),
        // Indicador da aba selecionada
        indicatorColor: Color.fromARGB(99, 255, 255, 255),
        backgroundColor: Color(0xFF0F9E99), 

        // Texto da navigationBar
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 15,
            color: Color(0xFFEFE9E0),
          ),
        ),
      ),
      child: NavigationBar(
        // Atualiza a opção selecionada
        onDestinationSelected: onDestinationSelected,
        // Mostra qual opção está selecionada
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(
              Icons.dashboard_rounded,
              color: Color(0xFFEFE9E0),
            ),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_rounded),
            selectedIcon: Icon(
              Icons.list_rounded,
              color: Color(0xFFEFE9E0),
            ),
            label: "Metas",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(
              Icons.person_2,
              color: Color(0xFFEFE9E0), 
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}