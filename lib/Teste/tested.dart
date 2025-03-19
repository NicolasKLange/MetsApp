import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Tela com as metas do usuario
class MetasScreenTeste extends StatefulWidget {
  const MetasScreenTeste({super.key});

  @override
  _MetasScreenTeste createState() => _MetasScreenTeste();
}

class _MetasScreenTeste extends State<MetasScreenTeste> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getMetas() async {
    try {
      final userDoc = _firestore.collection('Users').doc(userId);
      final metasCollection = userDoc.collection('Metas');
      final querySnapshot = await metasCollection.get();

      if (querySnapshot.docs.isEmpty) {
        print('Nenhuma meta encontrada!');
      } else {
        print('Metas encontradas: ${querySnapshot.docs.length}');
      }

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'nome_meta': doc['nome_meta'],
          'data_inicio': doc['data_inicio'],
          'data_fim': doc['data_fim'],
          'dias_meta': List<String>.from(doc['dias_meta']),
        };
      }).toList();
    } catch (e) {
      print('Erro ao carregar metas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Metas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getMetas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Erro ao carregar as metas: ${snapshot.error}');
            return Center(child: Text('Erro ao carregar metas'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma meta encontrada'));
          }

          final metas = snapshot.data!;

          return ListView.builder(
            itemCount: metas.length,
            itemBuilder: (context, index) {
              final meta = metas[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(meta['nome_meta']),
                  subtitle: Text('Término: ${meta['data_fim']}'),
                  onTap: () {
                    // Navegar para a tela de detalhes da meta
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MetaDetalhesScreen(meta: meta),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  
}

// Tela com os detalhes da meta
class MetaDetalhesScreen extends StatelessWidget {
  final Map<String, dynamic> meta;

  MetaDetalhesScreen({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Meta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta['nome_meta'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Data Início: ${meta['data_inicio']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Data Término: ${meta['data_fim']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Dias da Meta: ${meta['dias_meta'].join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

