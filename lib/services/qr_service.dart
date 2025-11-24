import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class QRService {
  static Future<Map<String, String>> generateQRCode(String appointmentId) async {
    try {
      // Generar un token único para esta cita
      final token = const Uuid().v4();
      // Crear el contenido del QR: un JSON con el ID de la cita y el token
      final qrData = jsonEncode({
        'appointmentId': appointmentId,
        'token': token,
      });

      // Generar la URL de la imagen del QR
      final response = await http.get(
        Uri.parse('https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrData'),
      );

      if (response.statusCode == 200) {
        return {
          'imageUrl': 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrData',
          'token': token,
          'qrData': qrData,
        };
      } else {
        throw Exception('Error al generar QR: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en QRService: $e');
      throw Exception('Error al generar QR: $e');
    }
  }
}