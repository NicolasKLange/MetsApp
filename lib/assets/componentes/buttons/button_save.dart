import 'package:flutter/material.dart';

class ButtonSave extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const ButtonSave({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black45.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(1, 5),
            ),
          ],
          color: const Color(0xFF0F9E99),
        ),
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
