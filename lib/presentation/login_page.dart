import 'package:fic5_bloc_ecatalog/bloc/login/login_bloc.dart';
import 'package:fic5_bloc_ecatalog/data/datasources/local_datasource.dart';
import 'package:fic5_bloc_ecatalog/data/models/request/login_request_model.dart';
import 'package:fic5_bloc_ecatalog/presentation/home_page.dart';
import 'package:fic5_bloc_ecatalog/presentation/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    checkAuth();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  checkAuth() async {
    final auth = await LocalDataSource().getToken();
    if (auth.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You\'re logged in'),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return const HomePage();
        }),
      ).then((value) => checkAuth());
    }
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkAuth();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('Login User'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                if (state is LoginLoaded) {
                  LocalDataSource().saveToken(state.model.accessToken);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login Success'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomePage();
                      },
                    ),
                  ).then((value) => checkAuth());
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  onPressed: () {
                    final requestModel = LoginRequestModel(
                      email: emailController!.text,
                      password: passwordController!.text,
                    );
                    context.read<LoginBloc>().add(
                          DoLoginEvent(model: requestModel),
                        );
                  },
                  child: const Text('Login'),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const RegisterPage();
                    },
                  ),
                );
              },
              child: const Text(
                'Belum punya akun? Register',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
