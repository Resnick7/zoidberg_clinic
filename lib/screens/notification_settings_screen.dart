import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/translation_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isDecapodianMode = false;
  String _selectedNotificationTime = '1_day'; // Valor por defecto
  bool _isLoading = true;

  final Map<String, String> _timeOptions = {
    '10_seconds': '10 segundos (Demo)',
    '30_seconds': '30 segundos (Demo)',
    '1_minute': '1 minuto (Demo)',
    '5_minutes': '5 minutos (Demo)',
    '1_hour': '1 hora',
    '12_hours': '12 horas',
    '1_day': '1 día antes',
    '2_days': '2 días antes',
    '1_week': '1 semana antes',
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedNotificationTime = prefs.getString('notification_time') ?? '1_day';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_time', _selectedNotificationTime);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(translateText('Configuración guardada', _isDecapodianMode)),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Duration _getDurationFromKey(String key) {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('Configuración de Notificaciones', _isDecapodianMode)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta informativa
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        translateText(
                          'Configura cuánto tiempo antes de la cita deseas recibir una notificación recordatoria.',
                          _isDecapodianMode,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Título
            Text(
              translateText('Tiempo de anticipación', _isDecapodianMode),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              translateText(
                'Las opciones de "Demo" son para pruebas y presentaciones',
                _isDecapodianMode,
              ),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            // Opciones de tiempo
            Card(
              child: Column(
                children: _timeOptions.entries.map((entry) {
                  final isDemo = entry.key.contains('seconds') || entry.key.contains('minute');

                  return RadioListTile<String>(
                    value: entry.key,
                    groupValue: _selectedNotificationTime,
                    onChanged: (value) {
                      setState(() {
                        _selectedNotificationTime = value!;
                      });
                      _saveSettings();
                    },
                    title: Row(
                      children: [
                        Text(
                          translateText(entry.value, _isDecapodianMode),
                          style: TextStyle(
                            fontWeight: _selectedNotificationTime == entry.key
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (isDemo) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: const Text(
                              'DEMO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    activeColor: const Color(0xFFB71C1C),
                    subtitle: _selectedNotificationTime == entry.key
                        ? Text(
                      translateText('Seleccionado', _isDecapodianMode),
                      style: const TextStyle(
                        color: Color(0xFFB71C1C),
                        fontSize: 12,
                      ),
                    )
                        : null,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de ejemplo
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          translateText('Ejemplo', _isDecapodianMode),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getExampleText(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón de prueba
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.notification_add),
                label: Text(translateText('Enviar notificación de prueba', _isDecapodianMode)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getExampleText() {
    final now = DateTime.now();
    final duration = _getDurationFromKey(_selectedNotificationTime);
    final appointmentTime = now.add(duration);

    final formattedDate = '${appointmentTime.day}/${appointmentTime.month}/${appointmentTime.year}';
    final formattedTime = '${appointmentTime.hour}:${appointmentTime.minute.toString().padLeft(2, '0')}';

    return translateText(
      'Si agendas una cita para el $formattedDate a las $formattedTime, '
          'recibirás una notificación ${_timeOptions[_selectedNotificationTime]}.',
      _isDecapodianMode,
    );
  }

  Future<void> _sendTestNotification() async {
    // Aquí puedes enviar una notificación de prueba inmediata
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                translateText(
                  'Notificación de prueba enviada. Revisa tus notificaciones.',
                  _isDecapodianMode,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );

    // Aquí integrarías el servicio de notificaciones para enviar una inmediata
    // await NotificationService().sendTestNotification();
  }
}