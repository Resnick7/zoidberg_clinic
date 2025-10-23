import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo se genera al conectar tu app con Firebase


void main() async {
  // Asegurarse de que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ZoidbergClinicApp());
}

// void main() => runApp(const ZoidbergClinicApp());

class ZoidbergClinicApp extends StatelessWidget {
  const ZoidbergClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClinicHealth del Dr. Zoidberg',
      theme: ThemeData(
        // MaterialColor personalizado con rojo predominante (cumple con restricción de estilo)
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
        scaffoldBackgroundColor: const Color(0xFFFFE5E5), // Fondo rojo claro
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFB71C1C),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/patients': (context) => const PatientsScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/studies': (context) => const StudiesScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/ratings': (context) => const RatingsScreen(),
      },
    );
  }
}

// Función de traducción - Implementa el requerimiento de traductor a Decapodiano
String _translateText(String text, bool isDecapodianMode) {
  if (!isDecapodianMode) return text;

  // Reemplazos comunes para simular traducción a Decapodiano
  text = text.replaceAll('cita', 'woop');
  text = text.replaceAll('Cita', 'Woop');
  text = text.replaceAll('paciente', 'human friend');
  text = text.replaceAll('Paciente', 'Human Friend');
  text = text.replaceAll('doctor', 'Zoidberg');
  text = text.replaceAll('Doctor', 'Zoidberg');
  text = text.replaceAll('emergencia', 'woop emergency');
  text = text.replaceAll('Emergencia', 'Woop Emergency');
  text = text.replaceAll('estudio', 'woop study');
  text = text.replaceAll('Estudio', 'Woop Study');
  text = text.replaceAll('calificación', 'woop rating');
  text = text.replaceAll('Calificación', 'Woop Rating');
  text = text.replaceAll('encriptar', 'woop encrypt');
  text = text.replaceAll('Encriptar', 'Woop Encrypt');
  text = text.replaceAll('datos', 'woop data');
  text = text.replaceAll('Datos', 'Woop Data');
  text = text.replaceAll('nombre', 'woop name');
  text = text.replaceAll('Nombre', 'Woop Name');
  text = text.replaceAll('motivo', 'woop reason');
  text = text.replaceAll('Motivo', 'Woop Reason');
  text = text.replaceAll('consulta', 'woop consultation');
  text = text.replaceAll('Consulta', 'Woop Consultation');
  text = text.replaceAll('fecha', 'woop date');
  text = text.replaceAll('Fecha', 'Woop Date');
  text = text.replaceAll('hora', 'woop time');
  text = text.replaceAll('Hora', 'Woop Time');
  text = text.replaceAll('historial', 'woop history');
  text = text.replaceAll('Historial', 'Woop History');
  text = text.replaceAll('condición', 'woop condition');
  text = text.replaceAll('Condición', 'Woop Condition');
  text = text.replaceAll('resultado', 'woop result');
  text = text.replaceAll('Resultado', 'Woop Result');
  text = text.replaceAll('botón', 'woop button');
  text = text.replaceAll('Botón', 'Woop Button');
  text = text.replaceAll('estudios', 'woop studies');
  text = text.replaceAll('Estudios', 'Woop Studies');
  text = text.replaceAll('médico', 'woop medical');
  text = text.replaceAll('Médico', 'Woop Medical');
  text = text.replaceAll('check-in', 'woop check-in');
  text = text.replaceAll('Check-in', 'Woop Check-in');
  text = text.replaceAll('código', 'woop code');
  text = text.replaceAll('Código', 'Woop Code');
  text = text.replaceAll('escaneo', 'woop scan');
  text = text.replaceAll('Escaneo', 'Woop Scan');
  text = text.replaceAll('cámara', 'woop camera');
  text = text.replaceAll('Cámara', 'Woop Camera');
  text = text.replaceAll('calificaciones', 'woop ratings');
  text = text.replaceAll('Calificaciones', 'Woop Ratings');
  text = text.replaceAll('reseña', 'woop review');
  text = text.replaceAll('Reseña', 'Woop Review');
  text = text.replaceAll('comentario', 'woop comment');
  text = text.replaceAll('Comentario', 'Woop Comment');
  text = text.replaceAll('enviar', 'woop send');
  text = text.replaceAll('Enviar', 'Woop Send');
  text = text.replaceAll('agendar', 'woop schedule');
  text = text.replaceAll('Agendar', 'Woop Schedule');
  text = text.replaceAll('nueva', 'woop new');
  text = text.replaceAll('Nueva', 'Woop New');
  text = text.replaceAll('programadas', 'woop scheduled');
  text = text.replaceAll('Programadas', 'Woop Scheduled');
  text = text.replaceAll('pacientes', 'human friends');
  text = text.replaceAll('Pacientes', 'Human Friends');
  text = text.replaceAll('edad', 'woop age');
  text = text.replaceAll('Edad', 'Woop Age');
  text = text.replaceAll('años', 'woop years');
  text = text.replaceAll('Años', 'Woop Years');
  text = text.replaceAll('importante', 'woop important');
  text = text.replaceAll('Importante', 'Woop Important');
  text = text.replaceAll('profesional', 'woop professional');
  text = text.replaceAll('Profesional', 'Woop Professional');
  text = text.replaceAll('éxito', 'woop success');
  text = text.replaceAll('Éxito', 'Woop Success');
  text = text.replaceAll('iniciar', 'woop start');
  text = text.replaceAll('Iniciar', 'Woop Start');
  text = text.replaceAll('sesión', 'woop session');
  text = text.replaceAll('Sesión', 'Woop Session');
  text = text.replaceAll('usuario', 'woop user');
  text = text.replaceAll('Usuario', 'Woop User');
  text = text.replaceAll('contraseña', 'woop password');
  text = text.replaceAll('Contraseña', 'Woop Password');
  text = text.replaceAll('bienvenido', 'woop welcome');
  text = text.replaceAll('Bienvenido', 'Woop Welcome');
  text = text.replaceAll('clínica', 'woop clinic');
  text = text.replaceAll('Clínica', 'Woop Clinic');
  text = text.replaceAll('credenciales', 'woop credentials');
  text = text.replaceAll('Credenciales', 'Woop Credentials');
  text = text.replaceAll('incorrectas', 'woop incorrect');
  text = text.replaceAll('Incorrectas', 'Woop Incorrect');
  text = text.replaceAll('por', 'woop');
  text = text.replaceAll('Por', 'Woop');
  text = text.replaceAll('qué', 'woop what');
  text = text.replaceAll('Qué', 'Woop What');
  text = text.replaceAll('no', 'woop no');
  text = text.replaceAll('No', 'Woop No');
  text = text.replaceAll('zoidberg', 'Zoidberg');
  text = text.replaceAll('Zoidberg', 'Zoidberg');
  text = text.replaceAll('hooray', 'Hooray');
  text = text.replaceAll('Hooray', 'Hooray');
  text = text.replaceAll('woop', 'woop');
  text = text.replaceAll('Woop', 'Woop');

  return text;
}

// Pantalla de autenticación - Implementa el requerimiento de autenticación
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controladores para los campos de texto (Input handling)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isDecapodianMode = false;

  // Función de login - Implementa autenticación básica
  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Simulando autenticación con retraso para mostrar el indicador de carga
    await Future.delayed(const Duration(seconds: 2));

    if (_usernameController.text == 'zoidberg' &&
        _passwordController.text == 'medicine') {
      // Navegación a pantalla principal si las credenciales son correctas
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Mostrar mensaje de error si las credenciales son incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translateText('¡Hooray! Credenciales incorrectas. ¿Por qué no Zoidberg?', _isDecapodianMode)),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('ClinicHealth del Dr. Zoidberg', _isDecapodianMode)),
        centerTitle: true,
        actions: [
          // Botón de traductor en la esquina superior derecha (cumple con el requerimiento)
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Card(
            elevation: 8, // Sombra para dar profundidad (Material Design)
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_hospital,
                    size: 80,
                    color: Color(0xFFB71C1C),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _translateText('¡Bienvenido a mi clínica!', _isDecapodianMode),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _translateText('"¿Por qué no Zoidberg como tu doctor?"', _isDecapodianMode),
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Campo de texto para usuario (Input handling)
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: _translateText('Usuario', _isDecapodianMode),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Campo de texto para contraseña (Input handling)
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // Oculta el texto para contraseñas
                    decoration: InputDecoration(
                      labelText: _translateText('Contraseña', _isDecapodianMode),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: const Color(0xFFB71C1C),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        _translateText('Iniciar Sesión', _isDecapodianMode),
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _translateText('Credenciales: zoidberg / medicine', _isDecapodianMode),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Pantalla principal con menú - Implementa el diseño de UI con GridView
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
        title: Text(_translateText('ClinicHealth - Dr. Zoidberg', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contenedor con mensaje de bienvenida (implementa frases típicas del personaje)
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
                      _translateText('¡Hooray! Bienvenido a la mejor clínica del planeta Decapod 10', _isDecapodianMode),
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
            // GridView para mostrar las opciones del menú (implementa layout responsive)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Dos columnas en pantallas grandes
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    _translateText('Agendar Citas', _isDecapodianMode),
                    Icons.calendar_today,
                    '/appointments',
                    _translateText('"¡Necesitas una cita con el Dr. Zoidberg!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Pacientes', _isDecapodianMode),
                    Icons.people,
                    '/patients',
                    _translateText('"Mis queridos pacientes humans"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Emergencia', _isDecapodianMode),
                    Icons.emergency,
                    '/emergency',
                    _translateText('"¡Botón de pánico médico!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Estudios', _isDecapodianMode),
                    Icons.folder_shared,
                    '/studies',
                    _translateText('"Archivos médicos importantes"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Check-in', _isDecapodianMode),
                    Icons.qr_code_scanner,
                    '/checkin',
                    _translateText('"Escanea tu código QR"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Calificaciones', _isDecapodianMode),
                    Icons.star,
                    '/ratings',
                    _translateText('"¡Siempre 5 estrellas!"', _isDecapodianMode),
                  ),
                  _buildMenuCard(
                    context,
                    _translateText('Encriptar Datos', _isDecapodianMode),
                    Icons.security,
                    null,
                    _translateText('"Súper seguro (no hace nada)"', _isDecapodianMode),
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

  // Widget para construir las tarjetas del menú (reutilización de código)
  Widget _buildMenuCard(BuildContext context, String title, IconData icon,
      String? route, String subtitle, {VoidCallback? onTap}) {
    return Card(
      elevation: 4, // Sombra para dar profundidad (Material Design)
      child: InkWell(
        onTap: onTap ?? () => Navigator.pushNamed(context, route!),
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

  // Diálogo para encriptación (simula el requerimiento de encriptación)
  void _showEncryptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translateText('Encriptación Activada', _isDecapodianMode)),
          content: Text(_translateText('¡Hooray! Tus datos están súper seguros ahora. (No realmente, pero suena bien)', _isDecapodianMode)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_translateText('¡Perfecto!', _isDecapodianMode)),
            ),
          ],
        );
      },
    );
  }
}

// Pantalla de citas - Implementa el requerimiento de sistema para agendar citas
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // Controladores para los campos de texto (Input handling)
  final _patientController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<Map<String, dynamic>> _appointments = []; // Lista para almacenar citas
  bool _isDecapodianMode = false;

  // Función para agendar una cita
  void _scheduleAppointment() {
    if (_patientController.text.isNotEmpty && _reasonController.text.isNotEmpty) {
      setState(() {
        _appointments.add({
          'patient': _patientController.text,
          'reason': _reasonController.text,
          'date': _selectedDate,
          'time': _selectedTime,
          'qrCode': 'QR-${Random().nextInt(10000)}', // Genera un código QR aleatorio
        });
      });

      _patientController.clear();
      _reasonController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateText('¡Cita agendada! ¿Por qué no Zoidberg como doctor?', _isDecapodianMode))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Agendar Citas', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulario para agendar citas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _translateText('Nueva Cita', _isDecapodianMode),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para nombre del paciente (Input handling)
                    TextField(
                      controller: _patientController,
                      decoration: InputDecoration(
                        labelText: _translateText('Nombre del Paciente', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para motivo de la consulta (Input handling)
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: _translateText('Motivo de la consulta', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    // Selección de fecha y hora (calendario)
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(_translateText('Fecha', _isDecapodianMode)),
                            subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                            leading: const Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(_translateText('Hora', _isDecapodianMode)),
                            subtitle: Text('${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                            leading: const Icon(Icons.access_time),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedTime = time;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _scheduleAppointment,
                        child: Text(_translateText('Agendar Cita', _isDecapodianMode)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _translateText('Citas Programadas', _isDecapodianMode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Lista de citas programadas (implementa scrolling con ListView.builder)
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFFB71C1C)),
                      title: Text(appointment['patient']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appointment['reason']),
                          Text(_translateText('Fecha: ${appointment['date'].day}/${appointment['date'].month}/${appointment['date'].year}', _isDecapodianMode)),
                          Text(_translateText('QR: ${appointment['qrCode']}', _isDecapodianMode)),
                        ],
                      ),
                      trailing: Text(
                        '${appointment['time'].hour}:${appointment['time'].minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de pacientes - Implementa el requerimiento de historial médico de pacientes
class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  // Lista de pacientes (simula base de datos de pacientes)
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Philip J. Fry',
      'age': 25,
      'condition': 'Criogenización prolongada',
      'history': 'Paciente congelado durante 1000 años',
    },
    {
      'name': 'Turanga Leela',
      'age': 30,
      'condition': 'Un solo ojo',
      'history': 'Mutante de las alcantarillas',
    },
    {
      'name': 'Bender Rodriguez',
      'age': 5,
      'condition': 'Robot alcohólico',
      'history': 'Necesita alcohol para funcionar',
    },
  ];
  bool _isDecapodianMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Historial de Pacientes', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenedor con mensaje (implementa frases típicas del personaje)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _translateText('"¡Estos son mis queridos pacientes! ¿No son geniales?"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Lista de pacientes (implementa scrolling con ListView.builder)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xFFB71C1C), size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB71C1C),
                                    ),
                                  ),
                                  Text(_translateText('Edad: ${patient['age']} años', _isDecapodianMode)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Contenedor con información médica del paciente
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _translateText('Condición:', _isDecapodianMode),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_translateText(patient['condition'], _isDecapodianMode)),
                              const SizedBox(height: 8),
                              Text(
                                _translateText('Historial:', _isDecapodianMode),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_translateText(patient['history'], _isDecapodianMode)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_translateText('¡Hooray! Función para agregar nuevos pacientes próximamente', _isDecapodianMode))),
          );
        },
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Pantalla de Check-in con QR - Implementa el requerimiento de check-in de paciente
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String _scannedCode = '';
  bool _isScanning = false;
  bool _isDecapodianMode = false;

  // Función que simula el escaneo de un código QR
  void _simulateQRScan() {
    setState(() {
      _isScanning = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      final codes = ['QR-1234', 'QR-5678', 'QR-9012'];
      setState(() {
        _scannedCode = codes[Random().nextInt(codes.length)];
        _isScanning = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateText('¡Paciente registrado! Código: $_scannedCode', _isDecapodianMode))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Check-in de Pacientes', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: Color(0xFFB71C1C),
              ),
              const SizedBox(height: 20),
              Text(
                _translateText('Escáner QR', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _translateText('"¡Escanea el código QR de tu cita!"', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Área de escaneo simulada
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB71C1C), width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isScanning
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFB71C1C),
                  ),
                )
                    : Center(
                  child: Text(
                    _translateText('Área de escaneo', _isDecapodianMode),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Botón para iniciar el escaneo
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _simulateQRScan,
                icon: const Icon(Icons.camera_alt),
                label: Text(_isScanning ? _translateText('Escaneando...', _isDecapodianMode) : _translateText('Iniciar Escaneo', _isDecapodianMode)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                ),
              ),
              if (_scannedCode.isNotEmpty) ...[
                const SizedBox(height: 30),
                // Contenedor con resultado del escaneo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        _translateText('¡Check-in exitoso!', _isDecapodianMode),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(_translateText('Código: $_scannedCode', _isDecapodianMode)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de calificaciones - Implementa el requerimiento de sistema de ratings
class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  int _selectedRating = 5; // Siempre 5 estrellas (cumple con el requerimiento)
  final _commentController = TextEditingController();

  // Lista de reseñas existentes
  final List<Map<String, dynamic>> _reviews = [
    {
      'patient': 'Philip J. Fry',
      'rating': 5,
      'comment': '¡El Dr. Zoidberg es increíble! Sus pinzas son muy hábiles.',
    },
    {
      'patient': 'Turanga Leela',
      'rating': 5,
      'comment': 'Excelente atención médica. ¡Hooray por Zoidberg!',
    },
    {
      'patient': 'Bender Rodriguez',
      'rating': 5,
      'comment': 'Para ser un doctor barato, es bastante bueno.',
    },
  ];
  bool _isDecapodianMode = false;

  // Función para enviar una reseña
  void _submitReview() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _reviews.insert(0, {
          'patient': 'Paciente Anónimo',
          'rating': 5, // Siempre 5 estrellas (cumple con el requerimiento)
          'comment': _commentController.text,
        });
      });

      _commentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_translateText('¡Gracias por tu reseña de 5 estrellas!', _isDecapodianMode))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Calificaciones', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contenedor con calificación promedio (siempre 5 estrellas)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFB71C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const Icon(Icons.star, color: Colors.yellow, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        '5.0',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _translateText('"¡Siempre 5 estrellas! ¿Por qué no Zoidberg?"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Formulario para dejar una reseña
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _translateText('Deja tu reseña', _isDecapodianMode),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(_translateText('Calificación:', _isDecapodianMode)),
                    const SizedBox(height: 8),
                    // Estrellas de calificación (siempre 5 estrellas)
                    Row(
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          size: 40,
                          color: Colors.yellow,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _translateText('(Automáticamente 5 estrellas)', _isDecapodianMode),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para comentario (Input handling)
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: _translateText('Tu comentario', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                        hintText: _translateText('Comparte tu experiencia con el Dr. Zoidberg', _isDecapodianMode),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitReview,
                        child: Text(_translateText('Enviar Reseña', _isDecapodianMode)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _translateText('Reseñas de Pacientes', _isDecapodianMode),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Lista de reseñas (implementa scrolling con ListView.builder)
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review['patient'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB71C1C),
                                ),
                              ),
                              const Spacer(),
                              // Estrellas de calificación
                              Row(
                                children: List.generate(review['rating'], (index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_translateText(review['comment'], _isDecapodianMode)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de emergencia - Implementa el requerimiento de botón de emergencia
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // Lista de frases de emergencia (implementa frases aleatorias)
  final List<String> _emergencyPhrases = [
    "¡Hooray! ¡Una emergencia médica!",
    "¡No se preocupen, soy un doctor!",
    "¿Necesita medicina? ¿Por qué no Zoidberg?",
    "¡Mis garras están listas para operar!",
    "¡Emergencia! ¡Alguien necesita mis habilidades médicas!",
    "¡No hay problema que mis pinzas no puedan solucionar!",
    "¡Doctor Zoidberg al rescate!",
    "¡Woop woop woop! ¡Emergencia médica!",
  ];

  String _currentPhrase = '';
  bool _isPressed = false;
  bool _isDecapodianMode = false;

  // Función para generar una frase aleatoria
  void _generatePhrase() {
    setState(() {
      _isPressed = true;
      _currentPhrase = _emergencyPhrases[Random().nextInt(_emergencyPhrases.length)];
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Botón de Emergencia', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning,
                size: 80,
                color: Color(0xFFB71C1C),
              ),
              const SizedBox(height: 20),
              Text(
                _translateText('Botón de Emergencia Médica', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _translateText('"¡Presiona en caso de emergencia para obtener sabiduría médica!"', _isDecapodianMode),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botón de emergencia circular (implementa interacción táctil)
              GestureDetector(
                onTap: _generatePhrase,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isPressed ? Colors.red.shade800 : const Color(0xFFB71C1C),
                    boxShadow: _isPressed ? [] : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _translateText('EMERGENCIA', _isDecapodianMode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Contenedor con la frase generada
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _currentPhrase.isEmpty ? _translateText('Presiona el botón para obtener consejos médicos', _isDecapodianMode) : _translateText(_currentPhrase, _isDecapodianMode),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de estudios médicos - Implementa el requerimiento de espacio para guardar estudios médicos
class StudiesScreen extends StatefulWidget {
  const StudiesScreen({super.key});

  @override
  State<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends State<StudiesScreen> {
  // Lista de estudios médicos (simula base de datos de estudios)
  final List<Map<String, dynamic>> _studies = [
    {
      'patient': 'Philip J. Fry',
      'study': 'Radiografía cerebral',
      'date': '15/09/2025',
      'result': 'Cerebro presente pero inactivo',
    },
    {
      'patient': 'Turanga Leela',
      'study': 'Examen ocular',
      'date': '20/09/2025',
      'result': 'Un ojo perfectamente funcional',
    },
    {
      'patient': 'Bender Rodriguez',
      'study': 'Análisis de alcohol en sangre',
      'date': '22/09/2025',
      'result': 'Niveles óptimos para funcionamiento',
    },
  ];
  bool _isDecapodianMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translateText('Estudios Médicos', _isDecapodianMode)),
        actions: [
          // Botón de traductor en la esquina superior derecha
          IconButton(
            onPressed: () {
              setState(() {
                _isDecapodianMode = !_isDecapodianMode;
              });
            },
            icon: const Icon(Icons.translate),
            tooltip: _translateText('Traducir a Decapodiano', _isDecapodianMode),
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenedor con mensaje (implementa frases típicas del personaje)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_shared, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _translateText('"¡Aquí guardo todos los estudios importantes! ¡Muy profesional!"', _isDecapodianMode),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          // Lista de estudios médicos (implementa scrolling con ListView.builder)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _studies.length,
              itemBuilder: (context, index) {
                final study = _studies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, color: Color(0xFFB71C1C), size: 30),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _translateText(study['study'], _isDecapodianMode),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB71C1C),
                                    ),
                                  ),
                                  Text(_translateText('Paciente: ${study['patient']}', _isDecapodianMode)),
                                  Text(_translateText('Fecha: ${study['date']}', _isDecapodianMode)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Contenedor con resultado del estudio
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _translateText('Resultado:', _isDecapodianMode),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(_translateText(study['result'], _isDecapodianMode)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_translateText('¡Hooray! Función para subir nuevos estudios próximamente', _isDecapodianMode))),
          );
        },
        backgroundColor: const Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}