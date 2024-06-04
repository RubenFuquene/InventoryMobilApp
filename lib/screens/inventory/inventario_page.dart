import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/models/producto.dart';
import 'package:control_inventarios_app/screens/inventory/create_movement_dialog.dart';
import 'package:control_inventarios_app/screens/inventory/create_product_dialog.dart';
import 'package:control_inventarios_app/services/categoria_services.dart';
import 'package:control_inventarios_app/services/producto_services.dart';
import 'package:flutter/material.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService _productoService = ProductoService();

  // Estados para los filtros
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  Categoria? _categoriaSeleccionada;
  String _busqueda = '';

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

  void _filtrarPorCategoria(Categoria? categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
    });
  }

  void _buscarProducto(String busqueda) {
    setState(() {
      _busqueda = busqueda;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filtros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Filtrar por categoría:'),
                      const SizedBox(width: 16),
                      DropdownButton<Categoria>(
                        value: _categoriaSeleccionada,
                        items: _categorias.map((categoria) {
                          return DropdownMenuItem<Categoria>(
                            value: categoria,
                            child: Text(categoria.nombre),
                          );
                        }).toList(),
                        onChanged: _filtrarPorCategoria,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Buscar producto:'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          onChanged: _buscarProducto,
                          decoration: const InputDecoration(
                            labelText: 'Nombre o descripción',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                ],
              ),
            ),

            // Lista de productos
            FutureBuilder<List<Producto>>(
              future: Future.microtask(() => _productoService.filtrarProductos(
                _productos, // Lista de productos completa
                categoriaId: _categoriaSeleccionada?.id,
                busqueda: _busqueda,
              )),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final productos = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ListTile(
                        title: Text(producto.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Alineación horizontal
                          children: [
                            Text('${_categorias.firstWhere((categoria) => categoria.id == producto.categoriaId).nombre} - \$ ${producto.precio}'),
                            const SizedBox(height: 4), // Espacio vertical entre elementos
                            Text('Stock: ${producto.stock}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón Editar
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CrearProductoDialog(producto: producto),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            const SizedBox(width: 4),
                            // Botón Agregar Movimiento
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CrearMovimientoDialog(producto: producto),
                                );
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error al obtener productos: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CrearProductoDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
