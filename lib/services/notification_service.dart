// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   Future<void> initNotifications() async {
//     // No necesitamos inicializar nada para esta versión simplificada
//   }
//
//   Future<void> checkForUpcomingAppointments() async {
//     // Obtener citas próximas
//     final now = DateTime.now();
//     final tomorrow = now.add(const Duration(days: 1));
//     final nextWeek = now.add(const Duration(days: 7));
//
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('appointments')
//         .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
//         .where('date', isLessThanOrEqualTo: Timestamp.fromDate(nextWeek))
//         .get();
//
//     for (var doc in snapshot.docs) {
//       final appointment = doc.data() as Map<String, dynamic>;
//       final appointmentDate = (appointment['date'] as Timestamp).toDate();
//
//       // Calcular diferencia en días
//       final difference = appointmentDate.difference(now);
//
//       // Si la cita es hoy o mañana, mostrar notificación
//       if (difference.inDays <= 1) {
//         String urgency = difference.inDays == 0 ? 'hoy' : 'mañana';
//         String title = 'Cita $urgency';
//         String body = '${appointment['patient']} - ${appointment['time']}';
//
//         _showNotification(title, body);
//       }
//     }
//   }
//
//   void _showNotification(String title, String body) {
//     // Mostrar un diálogo simple en lugar de una notificación del sistema
//     showDialog(
//       context: null,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }