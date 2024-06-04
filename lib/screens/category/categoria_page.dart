import 'package:control_inventarios_app/models/categoria.dart';
import 'package:control_inventarios_app/screens/category/create_category_dialog.dart';
import 'package:control_inventarios_app/services/categoria_services.dart';
import 'package:flutter/material.dart';

class CategoriaPage extends StatelessWidget {
  final CategoriaService categoriaService = CategoriaService();

  CategoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: FutureBuilder<List<Categoria>>(
        future: categoriaService.getCategorias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final categorias = snapshot.data!;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return ListTile(
                  title: Text(categoria.nombre),
                  subtitle: Text(categoria.descripcion),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CrearCategoriaDialog(categoria: categoria),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CrearCategoriaDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
