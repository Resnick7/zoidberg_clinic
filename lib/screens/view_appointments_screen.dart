import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';

class ViewAppointmentsScreen extends StatefulWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  State<ViewAppointmentsScreen> createState() => _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState extends State<ViewAppointmentsScreen> {
  bool _isDecapodianMode = false;

  final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

  // Función para determinar el color según la fecha de la cita
  Color _getAppointmentColor(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);

    // Si la cita es hoy
    if (difference.inDays == 0) {
      return Colors.red;
    }
    // Si la cita es en los próximos 7 días
    else if (difference.inDays > 0 && difference.inDays <= 7) {
      return Colors.yellow;
    }
    // Si la cita es en más de 7 días
    else if (difference.inDays > 7) {
      return Colors.green;
    }
    // Si la cita ya pasó
    else {
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
            // Asegurarse de que data no sea nulo
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
            data['id'] = doc.id;
            return data;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointmentsList.length,
            itemBuilder: (context, index) {
              final appointment = appointmentsList[index];

              // Manejar seguro de la fecha
              DateTime appointmentDate;
              if (appointment['date'] is Timestamp) {
                appointmentDate = (appointment['date'] as Timestamp).toDate();
              } else {
                appointmentDate = DateTime.now();
              }

              Color appointmentColor = _getAppointmentColor(appointmentDate);

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
                              // Mostrar QR de forma segura
                              if (appointment['qrImageUrl'] != null)
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
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  appointment['qrCode']?.toString() ?? 'QR no generado',
                                ),

                              // Mostrar estado de check-in si existe
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
    );
  }
}