import 'package:flutter/material.dart';

Widget dayContainer(String day) {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          day,
          style: TextStyle(
            color: Color(0XFF0F9E99),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }