import 'package:flutter/material.dart';

// Classe do card com as metas, com titulo, data de inicio e fim da meta
class CardMetsStyle extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final double progress;

  const CardMetsStyle({
    Key? key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFEFE9E0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.4),
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
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: Color(0xFF0F9E99),
            minHeight: 5,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}


