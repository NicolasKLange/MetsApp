import 'package:flutter/material.dart';

//Classe do card com as metas
class CardMetsStyle extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;

  const CardMetsStyle({
    Key? key,
    required this.title,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 30,
        left: 30,
        top: 20,
      ), // Espaço externo do card
      padding: EdgeInsets.all(15), // Espaço interno do card
      decoration: BoxDecoration(
        color: Color(0xFFEFE9E0),
        borderRadius: BorderRadius.circular(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF0F9E99),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                startDate,
                style: TextStyle(color: Color(0xFF0F9E99), fontSize: 16),
              ),
              Spacer(),
              Text(
                endDate,
                style: TextStyle(color: Color(0xFF0F9E99), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFF0F9E99),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
