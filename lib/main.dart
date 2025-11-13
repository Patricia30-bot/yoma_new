import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // será gerado pelo FlutterFire CLI
import 'package:yoma_ultimate/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔍 Teste de conexão com Firebase
  try {
    final app = Firebase.app();
    print('🔥 Firebase conectado: ${app.name}');
  } catch (e) {
    print('❌ Erro ao conectar Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: Home(),
    );
  }
}
