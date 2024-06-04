import 'package:control_inventarios_app/models/producto.dart';
import 'package:control_inventarios_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductoService {
  final String _baseUrl = 'http://10.0.2.2:5114/api/productos';

  final AuthService _authService = AuthService();

  Future<List<Producto>> obtenerProductos() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final productosJson = jsonDecode(response.body) as List<dynamic>;
      return productosJson.map((productoJson) => Producto.fromJson(productoJson)).toList();
    } else {
      throw Exception('Error al obtener productos: ${response.statusCode}');
    }
  }

  Future<void> crearProducto(Producto producto) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 201) {
      // Producto creado con éxito
    } else {
      throw Exception('Error al crear producto: ${response.statusCode}');
    }
  }

  Future<void> editarProducto(Producto producto) async {
    final token = await _authService.getToken();
    final url = Uri.parse('$_baseUrl/${producto.id}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(producto.toJson()),
    );
    if (response.statusCode == 204) {
      // Producto editado con éxito
    } else {
      throw Exception('Error al editar producto: ${response.statusCode}');
    }
  }

  List<Producto> filtrarProductos(List<Producto> productos, {int? categoriaId, String? busqueda}) {
    // Filtrar por categoría
    if (categoriaId != null) {
      productos = productos.where((producto) => producto.categoriaId == categoriaId).toList();
    }

    // Filtrar por nombre o descripción
    if (busqueda != null && busqueda.isNotEmpty) {
      productos = productos.where((producto) {
        final nombre = producto.nombre.toLowerCase();
        final descripcion = producto.descripcion.toLowerCase();
        final terminoBusqueda = busqueda.toLowerCase();
        return nombre.contains(terminoBusqueda) || descripcion.contains(terminoBusqueda);
      }).toList();
    }

    return productos;
  }
}
