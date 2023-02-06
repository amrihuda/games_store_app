import 'package:flutter/material.dart';

class GenrePage extends StatelessWidget {
  const GenrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Genre Page")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
