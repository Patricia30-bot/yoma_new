import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YOMA ULTIMATE"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "Bem-vinda ao YOMA 💜",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
