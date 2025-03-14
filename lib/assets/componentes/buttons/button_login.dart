import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const ButtonLogin({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          //Sombra no botão de login
          boxShadow: [
            BoxShadow(
              color:  Colors.black45.withOpacity(0.4),
              blurRadius: 10.0, 
              offset: const Offset(2, 7), 
            ),
          ],
            color: const Color(0xFF0F9E99), borderRadius: BorderRadius.circular(15)),
            
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
             color: Color(0xFFEFE9E0),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
