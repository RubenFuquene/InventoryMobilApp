import 'package:control_inventarios_app/models/categoria.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final int precio;
  final int categoriaId;
  final Categoria? categoria;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;
  final int? stock;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoriaId,
    this.categoria,
    this.fechaCreacion,
    this.fechaActualizacion,
    this.stock
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: json['precio'] as int,
      categoriaId: json['categoriaId'] as int,
      stock: json['stock'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'categoriaId': categoriaId,
  };
}
