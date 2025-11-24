import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import '../policies/app_policy.dart';
import '../capabilities/camera_capability.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'dart:math';

class CheckInScreen extends StatefulWidget {
  final AppPolicy appPolicy;

  const CheckInScreen({super.key, required this.appPolicy});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String _scannedCode = '';
  bool _isScanning = false;
  bool _isDecapodianMode = false;
  String _statusMessage = '';

  Future<void> _simulateQRScan() async {
    setState(() {
      _isScanning = true;
      _statusMessage = translateText('Verificando permisos de cámara...', _isDecapodianMode);
    });

    try {
      // Usar la policy en lugar de la capability directamente
      final result = await widget.appPolicy.cameraCapability.requestCameraAccess();

      if (result.success) {
        setState(() {
          _statusMessage = translateText('Escaneando código QR...', _isDecapodianMode);
        });
        // El escaneo se manejará con el widget MobileScanner
      } else {
        setState(() {
          _isScanning = false;
          _statusMessage = translateText(result.message, _isDecapodianMode);
        });
        await _handleCameraAccessFailure(result);
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = translateText('Error: $e', _isDecapodianMode);
      });
    }
  }

  Future<void> _verifyQRCode(String qrData) async {
    try {
      // Decodificar el JSON del QR
      final Map<String, dynamic> decodedData = jsonDecode(qrData);
      final appointmentId = decodedData['appointmentId'];
      final token = decodedData['token'];

      // Buscar la cita en Firestore
      final appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!appointmentDoc.exists) {
        setState(() {
          _statusMessage = translateText('Cita no encontrada', _isDecapodianMode);
        });
        return;
      }

      final appointment = appointmentDoc.data()!;

      // Verificar si el token coincide
      if (appointment['qrToken'] != token) {
        setState(() {
          _statusMessage = translateText('Código QR inválido', _isDecapodianMode);
        });
        return;
      }

      // Verificar si ya se hizo check-in
      if (appointment['checkedIn'] == true) {
        setState(() {
          _statusMessage = translateText('Check-in ya realizado', _isDecapodianMode);
        });
        return;
      }

      // Actualizar el estado de check-in
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'checkedIn': true});

      setState(() {
        _scannedCode = appointmentId;
        _statusMessage = translateText('¡Check-in exitoso!', _isDecapodianMode);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translateText('¡Paciente registrado! Cita: $appointmentId', _isDecapodianMode)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = translateText('Error al verificar QR: $e', _isDecapodianMode);
      });
    }
  }

  Future<void> _handleCameraAccessFailure(CameraAccessResult result) async {
    switch (result.reason) {
      case CameraAccessReason.noHardware:
        _showErrorDialog(
          translateText('Sin cámara', _isDecapodianMode),
          translateText('Este dispositivo no tiene cámara disponible.', _isDecapodianMode),
          showSettingsButton: false,
        );
        break;

      case CameraAccessReason.permanentlyDenied:
        _showErrorDialog(
          translateText('Permiso requerido', _isDecapodianMode),
          translateText('Necesitas habilitar el permiso de cámara en la configuración.', _isDecapodianMode),
          showSettingsButton: true,
        );
        break;

      case CameraAccessReason.denied:
        _showErrorDialog(
          translateText('Permiso denegado', _isDecapodianMode),
          translateText('El escaneo QR requiere acceso a la cámara.', _isDecapodianMode),
          showSettingsButton: false,
        );
        break;

      case CameraAccessReason.granted:
        break;
    }
  }

  void _showErrorDialog(String title, String message, {bool showSettingsButton = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (showSettingsButton)
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Usar capability a través de AppPolicy
                await widget.appPolicy.cameraCapability.openAppSettings();
              },
              child: Text(translateText('Abrir Configuración', _isDecapodianMode)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFB71C1C)),
            child: Text(translateText('Cerrar', _isDecapodianMode)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar la policy para decidir si mostrar el botón
    final shouldShowCameraButton = widget.appPolicy.shouldShowCameraButton();

    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Check-in de Pacientes', _isDecapodianMode)),
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
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB71C1C), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isScanning
                    ? MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final String? qrData = barcodes.first.rawValue;
                      if (qrData != null) {
                        setState(() {
                          _isScanning = false;
                        });
                        _verifyQRCode(qrData);
                      }
                    }
                  },
                )
                    : Center(
                  child: Text(
                    translateText('Área de escaneo', _isDecapodianMode),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_statusMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _simulateQRScan,
                icon: const Icon(Icons.camera_alt),
                label: Text(_isScanning
                    ? translateText('Escaneando...', _isDecapodianMode)
                    : translateText('Iniciar Escaneo', _isDecapodianMode)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (_scannedCode.isNotEmpty) ...[
                const SizedBox(height: 30),
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
              const SizedBox(height: 20),
              // Mostrar el botón solo si la política lo permite
              if (shouldShowCameraButton)
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _simulateQRScan,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(_isScanning
                      ? translateText('Escaneando...', _isDecapodianMode)
                      : translateText('Iniciar Escaneo', _isDecapodianMode)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}