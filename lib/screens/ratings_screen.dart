// Pantalla de calificaciones - Implementa el requerimiento de sistema de ratings
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import 'dart:math';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  int _selectedRating = 5; // Siempre 5 estrellas (cumple con el requerimiento)
  final _commentController = TextEditingController();

  // Lista de reseñas existentes
  final List<Map<String, dynamic>> _reviews = [
    {
      'patient': 'Philip J. Fry',
      'rating': 5,
      'comment': '¡El Dr. Zoidberg es increíble! Sus pinzas son muy hábiles.',
    },
    {
      'patient': 'Turanga Leela',
      'rating': 5,
      'comment': 'Excelente atención médica. ¡Hooray por Zoidberg!',
    },
    {
      'patient': 'Bender Rodriguez',
      'rating': 5,
      'comment': 'Para ser un doctor barato, es bastante bueno.',
    },
  ];
  bool _isDecapodianMode = false;

  // Función para enviar una reseña
  void _submitReview() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _reviews.insert(0, {
          'patient': 'Paciente Anónimo',
          'rating': 5, // Siempre 5 estrellas (cumple con el requerimiento)
          'comment': _commentController.text,
        });
      });

      _commentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translateText('¡Gracias por tu reseña de 5 estrellas!', _isDecapodianMode))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Calificaciones', _isDecapodianMode)),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contenedor con calificación promedio (siempre 5 estrellas)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        '5.0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translateText('"¡Siempre 5 estrellas! ¿Por qué no Zoidberg?"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Formulario para dejar una reseña
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translateText('Deja tu reseña', _isDecapodianMode),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(translateText('Calificación:', _isDecapodianMode)),
                    const SizedBox(height: 8),
                    // Estrellas de calificación (siempre 5 estrellas)
                    Row(
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          size: 40,
                          color: Colors.yellow,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translateText('(Automáticamente 5 estrellas)', _isDecapodianMode),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para comentario (Input handling)
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: translateText('Tu comentario', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                        hintText: translateText('Comparte tu experiencia con el Dr. Zoidberg', _isDecapodianMode),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitReview,
                        child: Text(translateText('Enviar Reseña', _isDecapodianMode)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              translateText('Reseñas de Pacientes', _isDecapodianMode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Lista de reseñas (implementa scrolling con ListView.builder)
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review['patient'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB71C1C),
                                ),
                              ),
                              const Spacer(),
                              // Estrellas de calificación
                              Row(
                                children: List.generate(review['rating'], (index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(translateText(review['comment'], _isDecapodianMode)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
