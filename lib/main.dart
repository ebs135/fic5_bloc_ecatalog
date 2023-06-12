import 'package:fic5_bloc_ecatalog/bloc/add_product/add_product_bloc.dart';
import 'package:fic5_bloc_ecatalog/bloc/login/login_bloc.dart';
import 'package:fic5_bloc_ecatalog/bloc/products/products_bloc.dart';
import 'package:fic5_bloc_ecatalog/bloc/register/register_bloc.dart';
import 'package:fic5_bloc_ecatalog/data/datasources/auth_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/datasources/product_datasource.dart';
import 'package:fic5_bloc_ecatalog/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(
            AuthDatasource(),
          ),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(
            AuthDatasource(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(
            ProductDataSource(),
          ),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(
            ProductDataSource(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FIC5 E-Catalog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
