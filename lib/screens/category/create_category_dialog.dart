import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/services/categoria_services.dart';
import 'package:flutter/material.dart';

class CrearCategoriaDialog extends StatefulWidget {
  final Categoria? categoria; // Categoria opcional si es para editar

  const CrearCategoriaDialog({super.key, this.categoria});

  @override
  _CrearCategoriaDialogState createState() => _CrearCategoriaDialogState();
}

class _CrearCategoriaDialogState extends State<CrearCategoriaDialog> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final CategoriaService categoriaService = CategoriaService();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      // Llenado de campos si es edición
      _nombreController.text = widget.categoria!.nombre;
      _descripcionController.text = widget.categoria!.descripcion;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.categoria == null ? 'Crear Categoría' : 'Editar Categoría'),
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
            
            try {
              if (widget.categoria == null) {
                await categoriaService.crearCategoria(nombre, descripcion);
              } else {
                await categoriaService.editarCategoria(
                  widget.categoria!.id,
                  nombre,
                  descripcion,
                );
              }
              
              Navigator.pop(context);
            } catch (e) {
              // Error al crear la categoría
              print('Error al crear categoría: $e');
              // Muestra un mensaje de error al usuario
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al crear categoría')),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
