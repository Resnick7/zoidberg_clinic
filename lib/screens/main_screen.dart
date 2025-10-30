// Pantalla principal con menú - Implementa el diseño de UI con GridView

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';
import 'appointments_screen.dart';
import 'patients_screen.dart';
import 'emergency_screen.dart';
import 'studies_screen.dart';
import 'checkin_screen.dart';
import 'ratings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isDecapodianMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translateText('ClinicHealth - Dr. Zoidberg', _isDecapodianMode)),
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
          IconButton(
            onPressed: () {
              // Cerrar sesión
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.medical_services, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      translateText('¡Hooray! Bienvenido a la mejor clínica del planeta Decapod 10', _isDecapodianMode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    translateText('Agendar Citas', _isDecapodianMode),
                    Icons.calendar_today,
                    const AppointmentsScreen(),
                    translateText('"¡Necesitas una cita con el Dr. Zoidberg!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Pacientes', _isDecapodianMode),
                    Icons.people,
                    const PatientsScreen(),
                    translateText('"Mis queridos pacientes humans"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Emergencia', _isDecapodianMode),
                    Icons.emergency,
                    const EmergencyScreen(),
                    translateText('"¡Botón de pánico médico!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Estudios', _isDecapodianMode),
                    Icons.folder_shared,
                    const StudiesScreen(),
                    translateText('"Archivos médicos importantes"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Check-in', _isDecapodianMode),
                    Icons.qr_code_scanner,
                    const CheckInScreen(),
                    translateText('"Escanea tu código QR"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Calificaciones', _isDecapodianMode),
                    Icons.star,
                    const RatingsScreen(),
                    translateText('"¡Siempre 5 estrellas!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    translateText('Encriptar Datos', _isDecapodianMode),
                    Icons.security,
                    null,
                    translateText('"Súper seguro (no hace nada)"', _isDecapodianMode),
                    onTap: () => _showEncryptionDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon,
      Widget? screen, String subtitle, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap ?? () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: const Color(0xFFB71C1C)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEncryptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translateText('Encriptación Activada', _isDecapodianMode)),
          content: Text(translateText('¡Hooray! Tus datos están súper seguros ahora. (No realmente, pero suena bien)', _isDecapodianMode)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translateText('¡Perfecto!', _isDecapodianMode)),
            ),
          ],
        );
      },
    );
  }
}