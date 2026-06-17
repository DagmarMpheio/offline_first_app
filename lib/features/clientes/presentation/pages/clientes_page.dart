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
        title: Text(
          'Clientes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),

      body: clientes.when(
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum cliente cadastrado',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final cliente = lista[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      cliente.nome.isNotEmpty
                          ? cliente.nome[0].toUpperCase()
                          : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  title: Text(
                    cliente.nome,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(cliente.telefone),

                  onTap: () {
                    _mostrarFormulario(context, ref, cliente: cliente);
                  },

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ref.read(clienteNotifierProvider).delete(cliente);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cliente excluído com sucesso!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },

        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.blue)),

        error: (error, stack) => Center(child: Text(error.toString())),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
    final nomeController = TextEditingController(text: cliente?.nome ?? '');

    final telefoneController = TextEditingController(
      text: cliente?.telefone ?? '',
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(cliente == null ? 'Novo Cliente' : 'Editar Cliente'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
              ),

              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.phone,
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

            ElevatedButton.icon(
              icon: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (cliente == null) {
                  final novo = Cliente(
                    nome: nomeController.text,
                    telefone: telefoneController.text,
                  );
                  /*   ..nome = nomeController.text
                    ..telefone = telefoneController.text; */

                  await ref.read(clienteNotifierProvider).add(novo);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cliente criado com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  cliente.nome = nomeController.text;
                  cliente.telefone = telefoneController.text;

                  await ref.read(clienteNotifierProvider).update(cliente);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cliente actualizado com sucesso!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },

              label: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
