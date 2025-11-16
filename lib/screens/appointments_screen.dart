import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';
import '../services/notification_service.dart'; // ESTE
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
  final NotificationService _notificationService = NotificationService(); // AGREGAR ESTA LÍNEA
  final _patientController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDecapodianMode = false;

  final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

  // Función actualizada con capability de notificaciones
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

    // Intentar obtener permiso de notificaciones
    final notificationResult = await _notificationCapability.requestNotificationAccess();

    // Preparar datos de la cita
    Timestamp dateTimestamp = Timestamp.fromDate(_selectedDate);
    String timeString = '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    String qrCode = 'QR-${DateTime.now().millisecondsSinceEpoch}';

    try {
      // Guardar cita en Firestore
      await appointments.add({
        'patient': _patientController.text,
        'reason': _reasonController.text,
        'date': dateTimestamp,
        'time': timeString,
        'qrCode': qrCode,
      });

      _patientController.clear();
      _reasonController.clear();

      // Manejar resultado de notificaciones
      if (notificationResult.success) {
        // Programar notificación (aquí integrarías flutter_local_notifications)
        await _scheduleNotification(_selectedDate, timeString, _patientController.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(translateText('¡Cita agendada con notificación! ¿Por qué no Zoidberg como doctor?', _isDecapodianMode)),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Cita guardada pero sin notificación
        await _handleNotificationFailure(notificationResult);
      }
    } catch (e) {
      print('Error al guardar cita: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translateText('Error al agendar cita: $e', _isDecapodianMode)),
            backgroundColor: Colors.red,
          ),
        );
      }
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


  Future<void> _handleNotificationFailure(NotificationAccessResult result) async {
    String message = '';
    bool showSettingsOption = false;

    switch (result.reason) {
      case NotificationAccessReason.notSupported:
        message = 'Cita guardada. Las notificaciones no están disponibles en este dispositivo.';
        break;
      case NotificationAccessReason.permanentlyDenied:
        message = 'Cita guardada sin notificación. Habilita los permisos en Configuración.';
        showSettingsOption = true;
        break;
      case NotificationAccessReason.denied:
        message = 'Cita guardada sin notificación.';
        break;
      case NotificationAccessReason.granted:
        break;
    }

    if (mounted) {
      if (showSettingsOption) {
        _showNotificationPermissionDialog(message);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(translateText(message, _isDecapodianMode))),
              ],
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showNotificationPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translateText('Permiso de Notificaciones', _isDecapodianMode)),
        content: Text(translateText(message, _isDecapodianMode)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(translateText('Entendido', _isDecapodianMode)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text(translateText('Abrir Configuración', _isDecapodianMode)),
          ),
        ],
      ),
    );
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
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    data['id'] = doc.id;
                    return data;
                  }).toList();

                  return ListView.builder(
                    itemCount: appointmentsList.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentsList[index];
                      DateTime appointmentDate = (appointment['date'] as Timestamp).toDate();

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Color(0xFFB71C1C)),
                          title: Text(appointment['patient']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appointment['reason']),
                              Text(translateText('Fecha: ${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}', _isDecapodianMode)),
                              Text(translateText('QR: ${appointment['qrCode']}', _isDecapodianMode)),
                            ],
                          ),
                          trailing: Text(
                            appointment['time'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
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

