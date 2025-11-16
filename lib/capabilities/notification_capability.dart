import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb; // AGREGAR ESTO
import 'package:permission_handler/permission_handler.dart';

class NotificationCapability {
  bool supportsNotifications() {
    // Si es web, no soportar notificaciones (o usar API de web)
    if (kIsWeb) return false; // AGREGAR ESTA LÍNEA

    // Android e iOS siempre soportan notificaciones
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    }
    return false;
  }

  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false; // AGREGAR
    if (!supportsNotifications()) return false;

    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    if (kIsWeb) return false; // AGREGAR
    if (!supportsNotifications()) return false;

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<PermissionStatus> checkPermissionStatus() async {
    if (kIsWeb) return PermissionStatus.denied; // AGREGAR
    return await Permission.notification.status;
  }

  Future<bool> isPermissionPermanentlyDenied() async {
    if (kIsWeb) return false; // AGREGAR
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  bool requirePermissionDialog() {
    if (kIsWeb) return false; // AGREGAR
    if (Platform.isIOS) return true;
    if (Platform.isAndroid) return true;
    return false;
  }

  Future<NotificationAccessResult> requestNotificationAccess() async {
    if (!supportsNotifications()) {
      return NotificationAccessResult(
        success: false,
        reason: NotificationAccessReason.notSupported,
        message: 'Esta plataforma no soporta notificaciones',
      );
    }

    if (!requirePermissionDialog()) {
      return NotificationAccessResult(
        success: true,
        reason: NotificationAccessReason.granted,
        message: 'Notificaciones habilitadas',
      );
    }

    final currentStatus = await checkPermissionStatus();

    if (currentStatus.isGranted) {
      return NotificationAccessResult(
        success: true,
        reason: NotificationAccessReason.granted,
        message: 'Notificaciones habilitadas',
      );
    }

    if (currentStatus.isPermanentlyDenied) {
      return NotificationAccessResult(
        success: false,
        reason: NotificationAccessReason.permanentlyDenied,
        message: 'Debes habilitar las notificaciones en Configuración',
      );
    }

    final granted = await requestNotificationPermission();

    if (granted) {
      return NotificationAccessResult(
        success: true,
        reason: NotificationAccessReason.granted,
        message: 'Notificaciones habilitadas',
      );
    } else {
      return NotificationAccessResult(
        success: false,
        reason: NotificationAccessReason.denied,
        message: 'Permiso de notificaciones denegado',
      );
    }
  }
}

class NotificationAccessResult {
  final bool success;
  final NotificationAccessReason reason;
  final String message;

  NotificationAccessResult({
    required this.success,
    required this.reason,
    required this.message,
  });
}

enum NotificationAccessReason {
  granted,
  denied,
  permanentlyDenied,
  notSupported,
}
