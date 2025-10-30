// Pantalla de Check-in con QR - Implementa el requerimiento de check-in de paciente

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import 'dart:math';


// Antes tenía _translateText, por si larga error

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String _scannedCode = '';
  bool _isScanning = false;
  bool _isDecapodianMode = false;

  // Función que simula el escaneo de un código QR
  void _simulateQRScan() {
    setState(() {
      _isScanning = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      final codes = ['QR-1234', 'QR-5678', 'QR-9012'];
      setState(() {
        _scannedCode = codes[Random().nextInt(codes.length)];
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translateText('¡Paciente registrado! Código: $_scannedCode', _isDecapodianMode))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Check-in de Pacientes', _isDecapodianMode)),
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
                Icons.qr_code_scanner,
                size: 80,
                color: Color(0xFFB71C1C),
              ),
              const SizedBox(height: 20),
              Text(
                translateText('Escáner QR', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                translateText('"¡Escanea el código QR de tu cita!"', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Área de escaneo simulada
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB71C1C), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isScanning
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFB71C1C),
                  ),
                )
                    : Center(
                  child: Text(
                    translateText('Área de escaneo', _isDecapodianMode),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Botón para iniciar el escaneo
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _simulateQRScan,
                icon: const Icon(Icons.camera_alt),
                label: Text(_isScanning ? translateText('Escaneando...', _isDecapodianMode) : translateText('Iniciar Escaneo', _isDecapodianMode)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (_scannedCode.isNotEmpty) ...[
                const SizedBox(height: 30),
                // Contenedor con resultado del escaneo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        translateText('¡Check-in exitoso!', _isDecapodianMode),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(translateText('Código: $_scannedCode', _isDecapodianMode)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
