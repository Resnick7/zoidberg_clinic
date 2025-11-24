import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';
import '../services/notification_service.dart';
import '../services/qr_service.dart';
import '../capabilities/notification_capability.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final NotificationCapability _notificationCapability = NotificationCapability();
  final NotificationService _notificationService = NotificationService();
  final _patientController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDecapodianMode = false;

  final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

  Future<void> _scheduleAppointment() async {
    if (_patientController.text.isEmpty || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translateText('Por favor completa todos los campos', _isDecapodianMode)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Mostrar indicador de carga
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translateText('Agendando cita...', _isDecapodianMode)),
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      // Guardar cita en Firestore
      final appointmentRef = await appointments.add({
        'patient': _patientController.text,
        'reason': _reasonController.text,
        'date': Timestamp.fromDate(_selectedDate),
        'time': '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      });

      // Obtener el ID de la cita recién creada
      final appointmentId = appointmentRef.id;

      // Generar el código QR con el ID de la cita
      final qrResult = await QRService.generateQRCode(appointmentId);

      // Actualizar el documento con la información del QR
      await appointmentRef.update({
        'qrImageUrl': qrResult['imageUrl'],
        'qrToken': qrResult['token'],
        'qrData': qrResult['qrData'],
        'checkedIn': false, // Para saber si ya se hizo check-in
      });

      _patientController.clear();
      _reasonController.clear();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translateText('¡Cita agendada exitosamente!', _isDecapodianMode)),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error al guardar cita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translateText('Error al agendar cita: $e', _isDecapodianMode)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _scheduleNotification(DateTime date, String time, String patient) async {
    try {
      // Obtener duración configurada
      final duration = await NotificationHelper.getNotificationDuration();

      await _notificationService.scheduleAppointmentNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        patientName: patient,
        appointmentDate: date,
        time: time,
        customDuration: duration, // Usar duración configurada
      );
      print('✅ Notificación programada para ${duration.inMinutes} minutos antes');
    } catch (e) {
      print('❌ Error al programar notificación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Agendar Citas', _isDecapodianMode)),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translateText('Nueva Cita', _isDecapodianMode),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _patientController,
                      decoration: InputDecoration(
                        labelText: translateText('Nombre del Paciente', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: translateText('Motivo de la consulta', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(translateText('Fecha', _isDecapodianMode)),
                            subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                            leading: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(translateText('Hora', _isDecapodianMode)),
                            subtitle: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                            leading: const Icon(Icons.access_time),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedTime = time;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _scheduleAppointment,
                        child: Text(translateText('Agendar Cita', _isDecapodianMode)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              translateText('Citas Programadas', _isDecapodianMode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: appointments.snapshots(),
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

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Color(0xFFB71C1C)),
                          title: Text(appointment['patient']?.toString() ?? 'Paciente sin nombre'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appointment['reason']?.toString() ?? 'Sin motivo especificado'),
                              Text(translateText('Fecha: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}', _isDecapodianMode)),
                              // Mostrar QR solo si existe
                              if (appointment['qrImageUrl'] != null)
                                Row(
                                  children: [
                                    Text(translateText('QR: ', _isDecapodianMode)),
                                    Image.network(
                                      appointment['qrImageUrl'],
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.qr_code, size: 50);
                                      },
                                    ),
                                  ],
                                )
                              else
                                Text(translateText('QR: No generado', _isDecapodianMode)),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                appointment['time']?.toString() ?? 'Sin hora',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // Mostrar estado de check-in solo si existe el campo
                              if (appointment['checkedIn'] == true)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
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
      ),
    );
  }
}

class NotificationHelper {
  static Future<Duration> getNotificationDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('notification_time') ?? '1_day';

    switch (key) {
      case '10_seconds':
        return const Duration(seconds: 10);
      case '30_seconds':
        return const Duration(seconds: 30);
      case '1_minute':
        return const Duration(minutes: 1);
      case '5_minutes':
        return const Duration(minutes: 5);
      case '1_hour':
        return const Duration(hours: 1);
      case '12_hours':
        return const Duration(hours: 12);
      case '1_day':
        return const Duration(days: 1);
      case '2_days':
        return const Duration(days: 2);
      case '1_week':
        return const Duration(days: 7);
      default:
        return const Duration(days: 1);
    }
  }
}