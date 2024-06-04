import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/models/movimiento.dart';
import 'package:control_inventarios_app/models/producto.dart';
import 'package:control_inventarios_app/services/categoria_services.dart';
import 'package:control_inventarios_app/services/movimiento_services.dart';
import 'package:control_inventarios_app/services/producto_services.dart';
import 'package:flutter/material.dart';

class CrearMovimientoDialog extends StatefulWidget {
  final Producto? producto;

  const CrearMovimientoDialog({super.key, this.producto});

  @override
  // ignore: library_private_types_in_public_api
  _CrearMovimientoDialogState createState() => _CrearMovimientoDialogState();
}

class _CrearMovimientoDialogState extends State<CrearMovimientoDialog> {
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService _productoService = ProductoService();
  final MovimientoService movimientoService = MovimientoService();

  final TextEditingController _cantidadController = TextEditingController();
  String _selectedTipoMovimiento = 'entrada';
  String _selectedDesc = 'traslado';
  String? _selectedCategoria;
  final DateTime _fechaMovimiento = DateTime.now();
  Producto? _selectedProducto;

  List<Categoria> _categorias = [];
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _cargarProductos();
  }

  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaService.getCategorias();
      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
    }
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await _productoService.obtenerProductos();
      setState(() {
        _productos = productos;
      });
    } catch (e) {
      print('Error al cargar productos: $e');
    }
  }

  void _registrarMovimiento() async {
    // Implementar la lógica para registrar el movimiento en la API
    // Ejemplo:
    try {
      final movimiento = Movimiento(
        productoId: widget.producto == null ? _selectedProducto!.id : widget.producto!.id,
        tipoMovimiento: _selectedTipoMovimiento,
        cantidad: int.parse(_cantidadController.text),
        fechaMovimiento: _fechaMovimiento,
        descripcion: _selectedDesc,
        id: 0,
      );

      await movimientoService.registrarMovimiento(movimiento);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movimiento registrado correctamente'),
        ),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar Movimiento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.producto == null) ...[
              DropdownButtonFormField<String?>(
                value: _selectedCategoria,
                items: _categorias.map((categoria) => DropdownMenuItem(
                  value: categoria.id.toString(),
                  child: Text(categoria.nombre),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoria = value;
                    _selectedProducto = null;
                  });
                },
                hint: const Text('Seleccionar categoría'),
              ),
              const SizedBox(height: 16),
              // Widget para el producto (dependiendo de la categoría seleccionada)
              if (_selectedCategoria != null) ...[
                DropdownButtonFormField<Producto?>(
                  value: _selectedProducto,
                  items: _productoService.filtrarProductos(_productos, categoriaId:int.tryParse(_selectedCategoria!)).map((producto) => DropdownMenuItem(
                    value: producto,
                    child: Text(producto.nombre),
                  )).toList(),
                  onChanged: (producto) {
                    setState(() {
                      _selectedProducto = producto;
                    });
                  },
                  hint: const Text('Seleccionar producto'),
                ),
                if (_selectedProducto != null)
                  Text('Producto seleccionado: ${_selectedProducto!.nombre}'),
              ],
            ] else ...[
              Text('Producto: ${widget.producto!.nombre}'),
            ],
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTipoMovimiento,
              items: const [
                DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                DropdownMenuItem(value: 'salida', child: Text('Salida')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTipoMovimiento = value!;
                  _selectedDesc = 'traslado';
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDesc,
              items: [
                if (_selectedTipoMovimiento == 'entrada') ...[
                  const DropdownMenuItem(value: 'compra', child: Text('Compra')),
                  const DropdownMenuItem(value: 'traslado', child: Text('Traslado')),
                ],
                if (_selectedTipoMovimiento == 'salida') ...[
                  const DropdownMenuItem(value: 'venta', child: Text('Venta')),
                  const DropdownMenuItem(value: 'avería', child: Text('Avería')),
                  const DropdownMenuItem(value: 'traslado', child: Text('Traslado')),
                ]
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDesc = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registrarMovimiento,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
