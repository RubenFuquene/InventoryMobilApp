import 'package:control_inventarios_app/models/producto.dart';

class Movimiento {
  final int id;
  final int productoId;
  final Producto? producto;
  final String tipoMovimiento;
  final int cantidad;
  final DateTime? fechaMovimiento;
  final String? descripcion;

  Movimiento({
    required this.id,
    required this.productoId,
    this.producto,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fechaMovimiento,
    this.descripcion,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      id: json['Id'] as int,
      productoId: json['ProductoId'] as int,
      producto: json['Producto'] != null ? Producto.fromJson(json['Producto']) : null,
      tipoMovimiento: json['TipoMovimiento'] as String,
      cantidad: json['Cantidad'] as int,
      fechaMovimiento: DateTime.parse(json['FechaMovimiento'] as String),
      descripcion: json['Descripcion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ProductoId': productoId,
      'TipoMovimiento': tipoMovimiento,
      'Cantidad': cantidad,
      'FechaMovimiento': fechaMovimiento?.toIso8601String(),
      'Descripcion': descripcion,
    };
  }
}
