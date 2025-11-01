import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/appointments_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/main_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/ratings_screen.dart';
import 'screens/studies_screen.dart';
import 'screens/view_appointments_screen.dart';

import 'services/firebase_service.dart';
import 'services/translation_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Inicializar notificaciones
  // await NotificationService().initNotifications();

  runApp(const ZoidbergClinicApp());
}

class ZoidbergClinicApp extends StatelessWidget {
  const ZoidbergClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClinicHealth del Dr. Zoidberg',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFB71C1C, {
          50: const Color(0xFFFFEBEE),
          100: const Color(0xFFFFCDD2),
          200: const Color(0xFFEF9A9A),
          300: const Color(0xFFE57373),
          400: const Color(0xFFEF5350),
          500: const Color(0xFFF44336),
          600: const Color(0xFFE53935),
          700: const Color(0xFFD32F2F),
          800: const Color(0xFFC62828),
          900: const Color(0xFFB71C1C),
        }),
        scaffoldBackgroundColor: const Color(0xFFFFE5E5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
        ),
      ),
      // Usar StreamBuilder para manejar el estado de autenticación
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Si el usuario está autenticado, mostrar la pantalla principal
          if (snapshot.hasData) {
            return const MainScreen();
          }
          // Si no, mostrar la pantalla de login
          return const AuthScreen();
        },
      ),
      routes: {
        '/main': (context) => const MainScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/studies': (context) => const StudiesScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/ratings': (context) => const RatingsScreen(),
        '/view_appointments': (context) => const ViewAppointmentsScreen(),
      },
    );
  }
}