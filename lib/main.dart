import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// Handler para mensajes en background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("🔔 Mensaje en background: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Registrar handler global de background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FCMTestPage(),
    );
  }
}

class FCMTestPage extends StatefulWidget {
  const FCMTestPage({super.key});

  @override
  State<FCMTestPage> createState() => _FCMTestPageState();
}

class _FCMTestPageState extends State<FCMTestPage> {
  String? _token;
  String _messages = "Esperando mensajes...";

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    // Pedir permisos en Android 13+ y iOS
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🟢 Permisos: ${settings.authorizationStatus}");

    // Obtener token del dispositivo
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() => _token = token);
    print("📱 Token: $token");

    // Escuchar mensajes en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔥 Mensaje en foreground: ${message.notification?.title}");
      setState(() {
        _messages =
        "Título: ${message.notification?.title}\nCuerpo: ${message.notification?.body}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test FCM")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📱 Token del dispositivo:"),
            SelectableText(_token ?? "Generando..."),
            const SizedBox(height: 20),
            const Text("📩 Último mensaje recibido:"),
            Text(_messages),
          ],
        ),
      ),
    );
  }
}
