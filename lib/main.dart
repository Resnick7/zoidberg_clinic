import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthTestPage(),
    );
  }
}

class AuthTestPage extends StatefulWidget {
  @override
  _AuthTestPageState createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _status = "No logueado";

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() => _status = "Usuario registrado!");
    } catch (e) {
      setState(() => _status = "Error: $e");
    }
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() => _status = "Usuario logueado!");
    } catch (e) {
      setState(() => _status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Auth Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Contraseña")),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text("Registrar")),
            ElevatedButton(onPressed: _login, child: const Text("Iniciar Sesión")),
            const SizedBox(height: 16),
            Text(_status),
          ],
        ),
      ),
    );
  }
}

