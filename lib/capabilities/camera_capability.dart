import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb; // AGREGAR
import 'package:permission_handler/permission_handler.dart';

class CameraCapability {
  bool hasCameraHardware() {
    if (kIsWeb) return false; // AGREGAR
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<bool> isCameraAvailable() async {
    if (kIsWeb) return false; // AGREGAR
    if (!hasCameraHardware()) return false;
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<bool> requestCameraPermission() async {
    if (!hasCameraHardware()) return false;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<PermissionStatus> checkPermissionStatus() async {
    return await Permission.camera.status;
  }

  Future<bool> isPermissionPermanentlyDenied() async {
    final status = await Permission.camera.status;
    return status.isPermanentlyDenied;
  }

  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  Future<CameraAccessResult> requestCameraAccess() async {
    if (!hasCameraHardware()) {
      return CameraAccessResult(
        success: false,
        reason: CameraAccessReason.noHardware,
        message: 'Este dispositivo no tiene cámara',
      );
    }

    final currentStatus = await checkPermissionStatus();

    if (currentStatus.isGranted) {
      return CameraAccessResult(
        success: true,
        reason: CameraAccessReason.granted,
        message: 'Acceso a cámara concedido',
      );
    }

    if (currentStatus.isPermanentlyDenied) {
      return CameraAccessResult(
        success: false,
        reason: CameraAccessReason.permanentlyDenied,
        message: 'Debes habilitar el permiso en Configuración',
      );
    }

    final granted = await requestCameraPermission();

    if (granted) {
      return CameraAccessResult(
        success: true,
        reason: CameraAccessReason.granted,
        message: 'Acceso a cámara concedido',
      );
    } else {
      return CameraAccessResult(
        success: false,
        reason: CameraAccessReason.denied,
        message: 'Permiso de cámara denegado',
      );
    }
  }
}

class CameraAccessResult {
  final bool success;
  final CameraAccessReason reason;
  final String message;

  CameraAccessResult({
    required this.success,
    required this.reason,
    required this.message,
  });
}

enum CameraAccessReason {
  granted,
  denied,
  permanentlyDenied,
  noHardware,
}
