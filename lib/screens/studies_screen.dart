import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';

class StudiesScreen extends StatefulWidget {
  const StudiesScreen({super.key});

  @override
  State<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends State<StudiesScreen> {
  bool _isDecapodianMode = false;

  // Referencia a la colección de estudios en Firestore
  final CollectionReference studies = FirebaseFirestore.instance.collection('studies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Estudios Médicos', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenedor con mensaje (implementa frases típicas del personaje)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_shared, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    translateText('"¡Aquí guardo todos los estudios importantes! ¡Muy profesional!"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // StreamBuilder para obtener estudios en tiempo real desde Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // CONSULTA SIMPLIFICADA: Obtener todos los estudios sin filtrar
              stream: studies.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Manejo de errores
                if (snapshot.hasError) {
                  print('Error en StreamBuilder: ${snapshot.error}');
                  return Text(translateText('Error al cargar estudios', _isDecapodianMode));
                }

                // Indicador de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Verificar si hay documentos
                if (snapshot.data!.docs.isEmpty) {
                  print('No se encontraron documentos en la colección studies');
                  return Center(
                    child: Text(translateText('No hay estudios registrados', _isDecapodianMode)),
                  );
                }

                print('Número de estudios recibidos: ${snapshot.data!.docs.length}');

                // Convertir documentos a lista de mapas
                List<Map<String, dynamic>> studiesList = snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  print('Procesando estudio: ${data.toString()}');
                  return data;
                }).toList();

                // Construir la lista de estudios
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: studiesList.length,
                  itemBuilder: (context, index) {
                    final study = studiesList[index];
                    print('Mostrando estudio: ${study['study']}');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.assignment, color: Color(0xFFB71C1C), size: 30),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        study['study'] ?? 'Sin nombre de estudio',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB71C1C),
                                        ),
                                      ),
                                      Text(translateText('Paciente: ${study['patient'] ?? 'Sin paciente'}', _isDecapodianMode)),
                                      Text(translateText('Fecha: ${study['date'] ?? 'Sin fecha'}', _isDecapodianMode)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Contenedor con resultado del estudio
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translateText('Resultado:', _isDecapodianMode),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(translateText(study['result'] ?? 'Sin resultado', _isDecapodianMode)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudyDialog(context);
        },
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddStudyDialog(BuildContext context) {
    final patientController = TextEditingController();
    final studyController = TextEditingController();
    final dateController = TextEditingController();
    final resultController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translateText('Agregar Nuevo Estudio', _isDecapodianMode)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: patientController,
                  decoration: InputDecoration(
                    labelText: translateText('Nombre del Paciente', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: studyController,
                  decoration: InputDecoration(
                    labelText: translateText('Tipo de Estudio', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: translateText('Fecha', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                    hintText: 'DD/MM/AAAA',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: resultController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: translateText('Resultado', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translateText('Cancelar', _isDecapodianMode)),
            ),
            TextButton(
              onPressed: () async {
                if (patientController.text.isNotEmpty &&
                    studyController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    resultController.text.isNotEmpty) {

                  print('Guardando estudio sin doctorId');

                  try {
                    // GUARDAR ESTUDIO SIN CAMPO doctorId
                    await studies.add({
                      'patient': patientController.text,
                      'study': studyController.text,
                      'date': dateController.text,
                      'result': resultController.text,
                      // No incluimos doctorId porque no es necesario
                    });

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateText('Estudio agregado con éxito', _isDecapodianMode))),
                    );
                  } catch (e) {
                    print('Error al guardar estudio: $e');
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateText('Error al agregar estudio: $e', _isDecapodianMode))),
                    );
                  }
                }
              },
              child: Text(translateText('Guardar', _isDecapodianMode)),
            ),
          ],
        );
      },
    );
  }
}