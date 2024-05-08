import 'package:flutter/material.dart';
import 'package:todo_app/bloc/splash_bloc.dart';
import 'package:todo_app/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = 'SplashPage';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final bloc = SplashBloc();

  @override
  void initState() {
    bloc.fetchTasks();
    bloc.splashStream.listen((event) {
      Navigator.popAndPushNamed(context, HomePage.routeName, arguments: event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text('Welcome to Todo App'),
      ),
    );
  }
}
