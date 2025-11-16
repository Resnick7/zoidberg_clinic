import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> scheduleAppointmentNotification({
    required int id,
    required String patientName,
    required DateTime appointmentDate,
    required String time,
    Duration? customDuration, // Agregar parámetro opcional
  }) async {
    // Usar duración personalizada o predeterminada
    final duration = customDuration ?? const Duration(days: 1);
    final scheduledDate = appointmentDate.subtract(duration);

    // Si la fecha programada ya pasó, programar para 5 segundos después (demo)
    final now = DateTime.now();
    final actualScheduledDate = scheduledDate.isBefore(now)
        ? now.add(const Duration(seconds: 5))
        : scheduledDate;

    await _notifications.zonedSchedule(
      id,
      '🦀 Recordatorio de Cita',
      'Cita próxima: $patientName a las $time',
      tz.TZDateTime.from(actualScheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'appointments_channel',
          'Citas Médicas',
          channelDescription: 'Notificaciones de citas programadas',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFFB71C1C),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }



  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> sendTestNotification() async {
    await _notifications.show(
      999999, // ID único para pruebas
      '🦀 Notificación de Prueba',
      '¡Tus notificaciones están funcionando correctamente!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Pruebas',
          channelDescription: 'Canal para notificaciones de prueba',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFFB71C1C),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

}