import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewAppointmentsScreen extends StatefulWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  State<ViewAppointmentsScreen> createState() => _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState extends State<ViewAppointmentsScreen> {
  bool _isDecapodianMode = false;
  bool _isFixingQRs = false;
  int _fixedCount = 0;

  final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

  // Función para generar QR usando una API externa (QuickChart)
  Future<Map<String, String>> _generateQRCode(String appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      // Crear datos del QR
      final qrData = {
        'id': appointmentId,
        'patient': appointmentData['patient'] ?? '',
        'date': appointmentData['date'] != null
            ? (appointmentData['date'] as Timestamp).toDate().toIso8601String()
            : '',
        'time': appointmentData['time'] ?? '',
      };

      final qrDataString = jsonEncode(qrData);

      // Generar URL del QR usando QuickChart API (gratuita)
      final qrImageUrl = Uri.encodeFull(
          'https://quickchart.io/qr?text=${Uri.encodeComponent(qrDataString)}&size=300'
      );

      return {
        'qrData': qrDataString,
        'qrImageUrl': qrImageUrl,
      };
    } catch (e) {
      print('Error generando QR: $e');
      rethrow;
    }
  }

  // Función para corregir todas las citas sin QR
  Future<void> _fixAppointmentsWithoutQR() async {
    setState(() {
      _isFixingQRs = true;
      _fixedCount = 0;
    });

    try {
      // Obtener todas las citas
      final snapshot = await appointments.get();

      int fixedInBatch = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        // Verificar si la cita no tiene QR o si está incompleto
        if (data != null &&
            (data['qrImageUrl'] == null ||
                data['qrData'] == null ||
                data['qrImageUrl'].toString().isEmpty ||
                data['qrData'].toString().isEmpty)) {

          // Generar nuevo QR
          try {
            final qrInfo = await _generateQRCode(doc.id, data);

            // Actualizar el documento en Firebase
            await doc.reference.update({
              'qrData': qrInfo['qrData'],
              'qrImageUrl': qrInfo['qrImageUrl'],
              'qrFixedAt': FieldValue.serverTimestamp(),
            });

            fixedInBatch++;
            setState(() {
              _fixedCount++;
            });

            // Pequeña pausa para no saturar la API
            await Future.delayed(const Duration(milliseconds: 300));
          } catch (e) {
            print('Error corrigiendo cita ${doc.id}: $e');
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              translateText(
                'Se corrigieron $_fixedCount citas',
                _isDecapodianMode,
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              translateText('Error al corregir citas: $e', _isDecapodianMode),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFixingQRs = false;
        });
      }
    }
  }

  // Función para determinar el color según la fecha de la cita
  Color _getAppointmentColor(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);

    if (difference.inDays == 0) {
      return Colors.red;
    } else if (difference.inDays > 0 && difference.inDays <= 7) {
      return Colors.yellow;
    } else if (difference.inDays > 7) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  // Función para obtener el texto de la diferencia de tiempo
  String _getTimeDifferenceText(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);

    if (difference.inDays == 0) {
      return translateText('Hoy', _isDecapodianMode);
    } else if (difference.inDays == 1) {
      return translateText('Mañana', _isDecapodianMode);
    } else if (difference.inDays > 0 && difference.inDays < 7) {
      return translateText('En ${difference.inDays} días', _isDecapodianMode);
    } else if (difference.inDays == 7) {
      return translateText('En una semana', _isDecapodianMode);
    } else if (difference.inDays > 7) {
      return translateText('En ${difference.inDays ~/ 7} semanas', _isDecapodianMode);
    } else {
      return translateText('Fecha pasada', _isDecapodianMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Ver Citas', _isDecapodianMode)),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: appointments.orderBy('date').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(translateText('Error al cargar citas', _isDecapodianMode));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(translateText('No hay citas programadas', _isDecapodianMode)),
            );
          }

          List<Map<String, dynamic>> appointmentsList = snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
            data['id'] = doc.id;
            return data;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointmentsList.length,
            itemBuilder: (context, index) {
              final appointment = appointmentsList[index];

              DateTime appointmentDate;
              if (appointment['date'] is Timestamp) {
                appointmentDate = (appointment['date'] as Timestamp).toDate();
              } else {
                appointmentDate = DateTime.now();
              }

              Color appointmentColor = _getAppointmentColor(appointmentDate);

              // Verificar si falta QR
              bool missingQR = appointment['qrImageUrl'] == null ||
                  appointment['qrData'] == null ||
                  appointment['qrImageUrl'].toString().isEmpty;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: appointmentColor, width: 5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: appointmentColor,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment['patient']?.toString() ?? 'Paciente sin nombre',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB71C1C),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        appointment['time']?.toString() ?? 'Sin hora',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _getTimeDifferenceText(appointmentDate),
                                    style: TextStyle(
                                      color: appointmentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                translateText('Motivo:', _isDecapodianMode),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(appointment['reason']?.toString() ?? 'Sin motivo especificado'),
                              const SizedBox(height: 8),
                              Text(
                                translateText('Código QR:', _isDecapodianMode),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),

                              // Mostrar advertencia si falta QR
                              if (missingQR)
                                Row(
                                  children: [
                                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      translateText('QR faltante', _isDecapodianMode),
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              else if (appointment['qrImageUrl'] != null)
                                Row(
                                  children: [
                                    Image.network(
                                      appointment['qrImageUrl'],
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.qr_code, size: 50);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        appointment['qrData']?.toString() ?? 'QR sin datos',
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  appointment['qrCode']?.toString() ?? 'QR no generado',
                                ),

                              if (appointment.containsKey('checkedIn') && appointment['checkedIn'] == true)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        translateText('Check-in realizado', _isDecapodianMode),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isFixingQRs ? null : _fixAppointmentsWithoutQR,
        backgroundColor: _isFixingQRs ? Colors.grey : const Color(0xFFB71C1C),
        icon: _isFixingQRs
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.qr_code_scanner),
        label: Text(
          _isFixingQRs
              ? translateText('Corrigiendo... $_fixedCount', _isDecapodianMode)
              : translateText('Corregir QRs', _isDecapodianMode),
        ),
      ),
    );
  }
}