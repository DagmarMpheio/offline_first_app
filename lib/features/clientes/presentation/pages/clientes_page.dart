import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_first_app/features/clientes/data/models/cliente.dart';
import 'package:offline_first_app/features/clientes/providers/cliente_provider.dart';

// Página principal para exibir a lista de clientes e permitir operações de CRUD.
class ClientesPage extends ConsumerWidget {
  const ClientesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientes = ref.watch(clientesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),

      body: clientes.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente cadastrado'),
            );
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final cliente = lista[index];

              return ListTile(
                title: Text(cliente.nome),
                subtitle: Text(cliente.telefone),

                onTap: () {
                  _mostrarFormulario(
                    context,
                    ref,
                    cliente: cliente,
                  );
                },

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await ref
                        .read(clienteNotifierProvider)
                        .delete(cliente);
                  },
                ),
              );
            },
          );
        },

        loading: () =>
            const Center(
              child: CircularProgressIndicator(),
            ),

        error: (error, stack) =>
            Center(
              child: Text(error.toString()),
            ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormulario(context, ref);
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  static void _mostrarFormulario(
    BuildContext context,
    WidgetRef ref, {
    Cliente? cliente,
  }) {
    final nomeController =
        TextEditingController(
          text: cliente?.nome ?? '',
        );

    final telefoneController =
        TextEditingController(
          text: cliente?.telefone ?? '',
        );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            cliente == null
                ? 'Novo Cliente'
                : 'Editar Cliente',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),

              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
              ),
            ],
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

                if (cliente == null) {
                  final novo = Cliente()
                    ..nome = nomeController.text
                    ..telefone = telefoneController.text;

                  await ref
                      .read(clienteNotifierProvider)
                      .add(novo);

                } else {

                  cliente.nome = nomeController.text;
                  cliente.telefone = telefoneController.text;

                  await ref
                      .read(clienteNotifierProvider)
                      .update(cliente);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },

              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}