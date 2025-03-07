import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  
  const SquareTile({
    super.key, 
    required this.imagePath, 
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          //Sombra no quadrado de login com Google
          boxShadow: [
            BoxShadow(
              color:  Color(0XFF135452).withOpacity(0.5),
              blurRadius: 10.0, 
              offset: const Offset(2, 7), 
            ),
          ],
          //Borda arredondada
          borderRadius: BorderRadius.circular(16),
          color: Color(0XFFEFE9E0),
        ),
        //Imagem
        child: Image.asset(
          imagePath,
          height: 35,
        ),
      ),
    );
  }
}
