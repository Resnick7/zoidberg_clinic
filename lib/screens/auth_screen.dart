import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/translation_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isDecapodianMode = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Iniciar sesión con Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Si el inicio de sesión es exitoso, el StreamBuilder en main.dart redirigirá a la pantalla principal
    } on FirebaseAuthException catch (e) {
      // Manejar errores de autenticación
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No se encontró un usuario con ese email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Contraseña incorrecta.';
      } else {
        errorMessage = 'Error al iniciar sesión: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translateText(errorMessage, _isDecapodianMode)),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translateText('Error inesperado: $e', _isDecapodianMode)),
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
        title: Text(translateText('ClinicHealth del Dr. Zoidberg', _isDecapodianMode)),
        centerTitle: true,
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
      // SOLUCIÓN: Agregar resizeToAvoidBottomInset
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // SOLUCIÓN: Envolver todo en SingleChildScrollView
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              elevation: 8,
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
                      translateText('¡Bienvenido a mi clínica!', _isDecapodianMode),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB71C1C),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translateText('"¿Por qué no Zoidberg como tu doctor?"', _isDecapodianMode),
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: translateText('Email', _isDecapodianMode),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: translateText('Contraseña', _isDecapodianMode),
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
                          translateText('Iniciar Sesión', _isDecapodianMode),
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translateText('Ingresa con tu cuenta de doctor', _isDecapodianMode),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}