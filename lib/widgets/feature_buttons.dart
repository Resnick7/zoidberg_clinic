import 'package:flutter/material.dart';
import '../policies/app_policy.dart';

class FeatureButtons extends StatelessWidget {
  final AppPolicy policy;

  const FeatureButtons({Key? key, required this.policy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de notificaciones (solo si la política lo permite)
        if (policy.shouldShowNotificationButton())
          ElevatedButton.icon(
            icon: const Icon(Icons.notifications),
            label: const Text('Notificaciones'),
            onPressed: () => _handleNotifications(context),
          ),

        const SizedBox(height: 16),

        // Botón de cámara (solo si la política lo permite)
        if (policy.shouldShowCameraButton())
          ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Cámara'),
            onPressed: () => _handleCamera(context),
          ),
      ],
    );
  }

  void _handleNotifications(BuildContext context) async {
    if (policy.shouldRequestNotificationPermission()) {
      final result = await policy.notificationCapability.requestNotificationAccess();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  void _handleCamera(BuildContext context) async {
    final result = await policy.cameraCapability.requestCameraAccess();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.message)),
    );
  }
}