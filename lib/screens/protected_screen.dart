import 'package:control_inventarios_app/screens/category/categoria_page.dart';
import 'package:control_inventarios_app/screens/inventory/create_movement_dialog.dart';
import 'package:control_inventarios_app/screens/inventory/inventario_page.dart';
import 'package:flutter/material.dart';

class ProtectedPage extends StatelessWidget {
  const ProtectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de inventarios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriaPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60), // Ancho y alto del botón
              ),
              icon: const Icon(Icons.category), // Icono del botón de Categorías
              label: const Text(
                'Categorías',
                style: TextStyle(fontSize: 18), // Tamaño del texto
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InventarioPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60), // Ancho y alto del botón
              ),
              icon: const Icon(Icons.inventory), // Icono del botón de Consulta de Inventario
              label: const Text(
                'Consulta de Inventario',
                style: TextStyle(fontSize: 18), // Tamaño del texto
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CrearMovimientoDialog(),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60), // Ancho y alto del botón
              ),
              icon: const Icon(Icons.add), // Icono del botón de Registro de Movimientos
              label: const Text(
                'Registro de Movimientos',
                style: TextStyle(fontSize: 18), // Tamaño del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
