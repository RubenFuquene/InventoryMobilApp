import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/models/producto.dart';
import 'package:control_inventarios_app/services/categoria_services.dart';
import 'package:control_inventarios_app/services/producto_services.dart';
import 'package:flutter/material.dart';

class CrearProductoDialog extends StatefulWidget {
  final Producto? producto; // Producto opcional si es para editar

  const CrearProductoDialog({super.key, this.producto});

  @override
  _CrearProductoDialogState createState() => _CrearProductoDialogState();
}

class _CrearProductoDialogState extends State<CrearProductoDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService productoService = ProductoService();
  late int _selectedCategoriaId = 0;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      // Llenado de campos si es edición
      _nombreController.text = widget.producto!.nombre;
      _descripcionController.text = widget.producto!.descripcion;
      _precioController.text = widget.producto!.precio.toString();
      _selectedCategoriaId = widget.producto!.categoriaId;
    }
    _cargarCategorias();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.producto == null ? 'Crear Producto' : 'Editar Producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedCategoriaId == 0 ? null : _selectedCategoriaId,
              hint: const Text('Seleccionar categoría'),
              items: _categorias.map((categoria) => DropdownMenuItem<int>(
                value: categoria.id,
                child: Text(categoria.nombre),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoriaId = value!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una categoría';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final nombre = _nombreController.text;
            final descripcion = _descripcionController.text;
            final precio = int.tryParse(_precioController.text) ?? 0;

            Producto producto = Producto(
              id: widget.producto?.id ?? 0, // ID del producto (0 si es nuevo)
              nombre: nombre,
              descripcion: descripcion,
              precio: precio,
              categoriaId: _selectedCategoriaId, // ID de la categoría
            );

            try {
              if (widget.producto == null) {
                await productoService.crearProducto(producto);
              } else {
                await productoService.editarProducto(producto);
              }
              Navigator.pop(context);
            } catch (e) {
              // Error al crear el producto
              print('Error al crear producto: $e');
              // Muestra un mensaje de error al usuario
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al crear producto')),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
