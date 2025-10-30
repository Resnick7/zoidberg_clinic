// Pantalla de estudios médicos - Implementa el requerimiento de espacio para guardar estudios médicos
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import 'dart:math';

class StudiesScreen extends StatefulWidget {
  const StudiesScreen({super.key});

  @override
  State<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends State<StudiesScreen> {
  // Lista de estudios médicos (simula base de datos de estudios)
  final List<Map<String, dynamic>> _studies = [
    {
      'patient': 'Philip J. Fry',
      'study': 'Radiografía cerebral',
      'date': '15/09/2025',
      'result': 'Cerebro presente pero inactivo',
    },
    {
      'patient': 'Turanga Leela',
      'study': 'Examen ocular',
      'date': '20/09/2025',
      'result': 'Un ojo perfectamente funcional',
    },
    {
      'patient': 'Bender Rodriguez',
      'study': 'Análisis de alcohol en sangre',
      'date': '22/09/2025',
      'result': 'Niveles óptimos para funcionamiento',
    },
  ];
  bool _isDecapodianMode = false;

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
          // Lista de estudios médicos (implementa scrolling con ListView.builder)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _studies.length,
              itemBuilder: (context, index) {
                final study = _studies[index];
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
                                    translateText(study['study'], _isDecapodianMode),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB71C1C),
                                    ),
                                  ),
                                  Text(translateText('Paciente: ${study['patient']}', _isDecapodianMode)),
                                  Text(translateText('Fecha: ${study['date']}', _isDecapodianMode)),
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
                              Text(translateText(study['result'], _isDecapodianMode)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(translateText('¡Hooray! Función para subir nuevos estudios próximamente', _isDecapodianMode))),
          );
        },
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}