import 'package:flutter/material.dart';
import 'package:games_store_app/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Games Store',
      home: LoadingPage(),
    );
  }
}
