import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool _isDecapodianMode = false;

  // Referencia a la colección de pacientes (sin filtros)
  final CollectionReference patients = FirebaseFirestore.instance.collection('patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Historial de Pacientes', _isDecapodianMode)),
        actions: [
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
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    translateText('"¡Estos son mis queridos pacientes! ¿No son geniales?"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // CONSULTA SIMPLIFICADA: Obtener todos los pacientes sin filtrar
              stream: patients.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Manejo de errores
                if (snapshot.hasError) {
                  print('Error en StreamBuilder: ${snapshot.error}');
                  return Text(translateText('Error al cargar pacientes', _isDecapodianMode));
                }

                // Indicador de carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Verificar si hay documentos
                if (snapshot.data!.docs.isEmpty) {
                  print('No se encontraron documentos en la colección patients');
                  return Center(
                    child: Text(translateText('No hay pacientes registrados', _isDecapodianMode)),
                  );
                }

                print('Número de documentos recibidos: ${snapshot.data!.docs.length}');

                // Convertir documentos a lista de mapas
                List<Map<String, dynamic>> patientsList = snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id;
                  print('Procesando paciente: ${data.toString()}');
                  return data;
                }).toList();

                // Construir la lista de pacientes
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patientsList.length,
                  itemBuilder: (context, index) {
                    final patient = patientsList[index];
                    print('Mostrando paciente: ${patient['name']}');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, color: Color(0xFFB71C1C), size: 30),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient['name'] ?? 'Sin nombre',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFB71C1C),
                                        ),
                                      ),
                                      Text(translateText('Edad: ${patient['age'] ?? 0} años', _isDecapodianMode)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                    translateText('Condición:', _isDecapodianMode),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(translateText(patient['condition'] ?? 'Sin condición', _isDecapodianMode)),
                                  const SizedBox(height: 8),
                                  Text(
                                    translateText('Historial:', _isDecapodianMode),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(translateText(patient['history'] ?? 'Sin historial', _isDecapodianMode)),
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
          _showAddPatientDialog(context);
        },
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final conditionController = TextEditingController();
    final historyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translateText('Agregar Nuevo Paciente', _isDecapodianMode)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: translateText('Nombre', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: translateText('Edad', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: conditionController,
                  decoration: InputDecoration(
                    labelText: translateText('Condición', _isDecapodianMode),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: historyController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: translateText('Historial', _isDecapodianMode),
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
                if (nameController.text.isNotEmpty &&
                    ageController.text.isNotEmpty &&
                    conditionController.text.isNotEmpty &&
                    historyController.text.isNotEmpty) {

                  print('Guardando paciente sin doctorId');

                  try {
                    // GUARDAR PACIENTE SIN CAMPO doctorId
                    await patients.add({
                      'name': nameController.text,
                      'age': int.parse(ageController.text),
                      'condition': conditionController.text,
                      'history': historyController.text,
                      // No incluimos doctorId porque no es necesario
                    });

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateText('Paciente agregado con éxito', _isDecapodianMode))),
                    );
                  } catch (e) {
                    print('Error al guardar paciente: $e');
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(translateText('Error al agregar paciente: $e', _isDecapodianMode))),
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