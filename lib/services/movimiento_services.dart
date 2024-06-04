import 'dart:convert';
import 'package:control_inventarios_app/models/movimiento.dart';
import 'package:control_inventarios_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class MovimientoService {

  final AuthService _authService = AuthService();

  Future<void> registrarMovimiento(Movimiento movimiento) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5114/api/MovimientosInventario/registrarMovimiento'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(movimiento.toJson()),
    );

    if (response.statusCode == 200) {
      // Éxito al registrar el movimiento
    } else {
      // Error al registrar el movimiento
      throw Exception('Error al registrar movimiento: ${response.statusCode}');
    }
  }
}
