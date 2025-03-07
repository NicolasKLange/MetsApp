import 'package:flutter/material.dart';

class Textfields extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const Textfields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<Textfields> createState() => _TextfieldsState();
}

class _TextfieldsState extends State<Textfields> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          //Sombra no textField
          boxShadow: [
            BoxShadow(
              color: Color(0XFF135452).withOpacity(0.5),
              blurRadius: 10.0,
              offset: const Offset(2, 7),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0XFF0F9E99)),
              borderRadius: BorderRadius.circular(15.0),
            ),
            fillColor: const Color(0XFFEFE9E0),
            filled: true,
            hintText: widget.hintText,
            //Cor do hintText
            hintStyle: const TextStyle(color: Colors.grey),
            //Icon para visualizar senha
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0XFF0F9E99),
                      ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    )
                    : null,
          ),
        ),
      ),
    );
  }
}
