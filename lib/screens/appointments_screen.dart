import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _patientController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDecapodianMode = false;

  final CollectionReference appointments = FirebaseFirestore.instance.collection('appointments');

  void _scheduleAppointment() async {
    if (_patientController.text.isNotEmpty && _reasonController.text.isNotEmpty) {
      Timestamp dateTimestamp = Timestamp.fromDate(_selectedDate);
      String timeString = '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      String qrCode = 'QR-${DateTime.now().millisecondsSinceEpoch}';

      try {
        // GUARDAR CITA SIN CAMPO doctorId
        await appointments.add({
          'patient': _patientController.text,
          'reason': _reasonController.text,
          'date': dateTimestamp,
          'time': timeString,
          'qrCode': qrCode,
          // No incluimos doctorId porque no es necesario
        });

        _patientController.clear();
        _reasonController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translateText('¡Cita agendada! ¿Por qué no Zoidberg como doctor?', _isDecapodianMode))),
        );
      } catch (e) {
        print('Error al guardar cita: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translateText('Error al agendar cita: $e', _isDecapodianMode))),
        );
      }
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
                              // MODIFICACIÓN: Selector de fecha sin límite de un año
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(), // Permitir desde hoy en adelante
                                lastDate: DateTime(2100), // Permitir hasta el año 2100 (casi sin límite)
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
                // CONSULTA SIMPLIFICADA: Obtener todas las citas sin filtrar
                stream: appointments.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('Error en StreamBuilder: ${snapshot.error}');
                    return Text(translateText('Error al cargar citas', _isDecapodianMode));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    print('No se encontraron documentos en la colección appointments');
                    return Center(
                      child: Text(translateText('No hay citas programadas', _isDecapodianMode)),
                    );
                  }

                  print('Número de citas recibidas: ${snapshot.data!.docs.length}');

                  List<Map<String, dynamic>> appointmentsList = snapshot.data!.docs.map((DocumentSnapshot doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    data['id'] = doc.id;
                    print('Procesando cita: ${data.toString()}');
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