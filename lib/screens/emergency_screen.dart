// Pantalla de emergencia - Implementa el requerimiento de botón de emergencia
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import 'dart:math';


class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // Lista de frases de emergencia (implementa frases aleatorias)
  final List<String> _emergencyPhrases = [
    "¡Hooray! ¡Una emergencia médica!",
    "¡No se preocupen, soy un doctor!",
    "¿Necesita medicina? ¿Por qué no Zoidberg?",
    "¡Mis garras están listas para operar!",
    "¡Emergencia! ¡Alguien necesita mis habilidades médicas!",
    "¡No hay problema que mis pinzas no puedan solucionar!",
    "¡Doctor Zoidberg al rescate!",
    "¡Woop woop woop! ¡Emergencia médica!",
  ];

  String _currentPhrase = '';
  bool _isPressed = false;
  bool _isDecapodianMode = false;

  // Función para generar una frase aleatoria
  void _generatePhrase() {
    setState(() {
      _isPressed = true;
      _currentPhrase = _emergencyPhrases[Random().nextInt(_emergencyPhrases.length)];
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Botón de Emergencia', _isDecapodianMode)),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 80,
                color: Color(0xFFB71C1C),
              ),
              const SizedBox(height: 20),
              Text(
                translateText('Botón de Emergencia Médica', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                translateText('"¡Presiona en caso de emergencia para obtener sabiduría médica!"', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botón de emergencia circular (implementa interacción táctil)
              GestureDetector(
                onTap: _generatePhrase,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isPressed ? Colors.red.shade800 : const Color(0xFFB71C1C),
                    boxShadow: _isPressed ? [] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      translateText('EMERGENCIA', _isDecapodianMode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Contenedor con la frase generada
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _currentPhrase.isEmpty ? translateText('Presiona el botón para obtener consejos médicos', _isDecapodianMode) : translateText(_currentPhrase, _isDecapodianMode),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
