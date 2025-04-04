import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:mets_app/database/database.dart';
import 'package:mets_app/screens/mets/detalhes.dart';

class MetsScreen extends StatefulWidget {
  const MetsScreen({super.key});

  @override
  _MetsScreen createState() => _MetsScreen();
}

class _MetsScreen extends State<MetsScreen> {
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
      backgroundColor: const Color(0xFFEFE9E0),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('Users')
                .doc(userId)
                .collection('Metas')
                .snapshots(), // Escuta mudanças em tempo real
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar metas'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                right: 30.0,
                left: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          'Minhas Metas',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F9E99),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            createMets(context);
                          },
                          child: Icon(
                            Icons.add,
                            color: Color(0xFF0F9E99),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final metas =
              snapshot.data!.docs.map((doc) {
                return {
                  'id': doc.id,
                  'nome_meta': doc['nome_meta'],
                  'data_inicio': doc['data_inicio'],
                  'data_fim': doc['data_fim'],
                  'dias_meta': Map<String, bool>.from(doc['dias_meta']), 
                };
              }).toList();

          return Padding(
            padding: const EdgeInsets.only(top: 60.0, right: 30.0, left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'Minhas Metas',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F9E99),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          createMets(context);
                        },
                        child: Icon(
                          Icons.add,
                          color: Color(0xFF0F9E99),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: 1,
                    ),
                    itemCount: metas.length,
                    itemBuilder: (context, index) {
                      
                      final meta = metas[index];
                     

                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFE9E0),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15.0),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MetaDetalhesScreen(meta: meta, userId: userId,),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  meta['nome_meta'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF0F9E99),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Término: ${meta['data_fim']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Atualização na função createMets para salvar a meta
  Future<String?> createMets(BuildContext context) async {
    TextEditingController nameMetsController = TextEditingController();
    TextEditingController dateFinishMetsController = TextEditingController();
    TextEditingController dateStartMetsController = TextEditingController();
    List<String> selectedDays = [];

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void toggleDay(String day) {
              setState(() {
                if (selectedDays.contains(day)) {
                  selectedDays.remove(day);
                } else {
                  selectedDays.add(day);
                }
              });
            }

            return AlertDialog(
              backgroundColor: Color(0XFFEFE9E0),
              title: Row(
                children: [
                  Text(
                    'Criar meta',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF0F9E99),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.cancel_outlined, color: Color(0XFF0F9E99)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameMetsController,
                    decoration: InputDecoration(
                      hintText: 'Nome da meta',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dateStartMetsController,
                    decoration: InputDecoration(
                      hintText: 'Data inicio da meta',
                      border: InputBorder.none,
                    ),
                    inputFormatters: [MaskedInputFormatter('00/00/0000')],
                  ),
                  
                  SizedBox(height: 10),
                  TextField(
                    controller: dateFinishMetsController,
                    decoration: InputDecoration(
                      hintText: 'Data final da meta',
                      border: InputBorder.none,
                    ),
                    inputFormatters: [MaskedInputFormatter('00/00/0000')],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            ['Dom', 'Seg', 'Ter', 'Qua'].map((day) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: GestureDetector(
                                  onTap: () => toggleDay(day),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedDays.contains(day)
                                              ? Color(0XFF0F9E99)
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            ['Qui', 'Sex', 'Sab'].map((day) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: GestureDetector(
                                  onTap: () => toggleDay(day),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          selectedDays.contains(day)
                                              ? Color(0XFF0F9E99)
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      day,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                    if (nameMetsController.text.isNotEmpty &&
                        dateStartMetsController.text.isNotEmpty &&
                        dateFinishMetsController.text.isNotEmpty) {
                      await DatabaseMethods().saveMeta(
                        nameMetsController.text,
                        dateStartMetsController.text,
                        dateFinishMetsController.text,
                        selectedDays,
                      );
                      setState(() {}); // Atualiza a tela
                      Navigator.of(context).pop();
                    }
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFF0F9E99),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      'Criar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0XFFEFE9E0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
