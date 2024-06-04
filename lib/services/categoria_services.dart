import 'dart:convert';
import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class CategoriaService {
  static const String baseUrl = 'http://10.0.2.2:5114/api/categorias';

  final AuthService _authService = AuthService();

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<List<Categoria>> getCategorias() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener categorías');
    }
  }

  Future<void> crearCategoria(String nombre, String descripcion) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'descripcion': descripcion,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear categoría');
    }
  }

  Future<void> editarCategoria(int id, String nombre, String descripcion) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
      }),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al editar categoría');
    }
  }
}
