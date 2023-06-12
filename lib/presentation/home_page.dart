import 'package:fic5_bloc_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:fic5_bloc_ecatalog/bloc/products/products_bloc.dart';
import 'package:fic5_bloc_ecatalog/data/datasources/local_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/models/request/product_request_model.dart';
import 'package:fic5_bloc_ecatalog/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    super.initState();

    context.read<ProductsBloc>().add(GetProductsEvent());
  }

  @override
  void dispose() {
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();

    super.dispose();
  }

  checkAuth() async {
    final auth = await LocalDataSource().getToken();
    if (auth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You\'re logged out'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return const LoginPage();
        }),
      ).then((value) => checkAuth());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return const LoginPage();
                  },
                ),
              ).then((value) => checkAuth());
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        'Titel: ${state.data.reversed.toList()[index].title ?? '-'}\nDesc: ${state.data.reversed.toList()[index].description ?? '-'}',
                      ),
                      subtitle: Text('Price: ${state.data[index].price} \$'),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Product'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      titleController!.clear();
                      priceController!.clear();
                      descriptionController!.clear();

                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  BlocConsumer<AddProductBloc, AddProductState>(
                    builder: (context, state) {
                      if (state is AddProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final model = ProductRequestModel(
                            title: titleController!.text,
                            price: int.parse(priceController!.text),
                            description: descriptionController!.text,
                          );
                          context.read<AddProductBloc>().add(
                                DoAddProductEvent(
                                  model: model,
                                ),
                              );
                        },
                        child: const Text(
                          'Add',
                        ),
                      );
                    },
                    listener: (context, state) {
                      if (state is AddProductLoaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Add Product Success',
                            ),
                          ),
                        );
                        context.read<ProductsBloc>().add(GetProductsEvent());
                        titleController!.clear();
                        priceController!.clear();
                        descriptionController!.clear();
                        Navigator.pop(context);
                      }
                      if (state is AddProductError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Add product ${state.message}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
