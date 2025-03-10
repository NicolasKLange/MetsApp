import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      body: Center(child: Text('Metas')),
    );
  }
}
