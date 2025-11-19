import '../capabilities/notification_capability.dart';
import '../capabilities/camera_capability.dart';

class AppPolicy {
  final NotificationCapability notificationCapability;
  final CameraCapability cameraCapability;

  AppPolicy({
    required this.notificationCapability,
    required this.cameraCapability,
  });

  // === POLÍTICAS DE NOTIFICACIONES ===
  bool shouldShowNotificationButton() {
    return notificationCapability.supportsNotifications();
  }

  bool shouldRequestNotificationPermission() {
    return notificationCapability.requirePermissionDialog();
  }

  // === POLÍTICAS DE CÁMARA ===
  bool shouldShowCameraButton() {
    return cameraCapability.hasCameraHardware();
  }

  bool shouldShowCameraPermissionDialog() {
    return cameraCapability.hasCameraHardware();
  }

  // === POLÍTICAS COMBINADAS ===
  bool shouldShowAllFeatures() {
    return shouldShowNotificationButton() && shouldShowCameraButton();
  }
}