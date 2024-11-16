import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/vaccine_checkup_page.dart';
import 'pet_gestion.dart';

// Reemplaza estos valores con tu configuración de Firebase
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyDDOCZPSAjIKQ7iq2dVt2OjLzUTaXPwJIo",
  appId: "1:483134690799:web:xxxxxxxxxxxxxx",
  messagingSenderId: "483134690799",
  projectId: "petapp-a9d6f",
  storageBucket: "petapp-a9d6f.appspot.com",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions); // Proporciona las opciones aquí
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Mascotas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetListPage()),
                );
              },
              child: const Text('Ir a Gestión de Mascotas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí podrías pasar un ID de mascota si es necesario
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VaccineCheckupPage(petId: '1', pets: [],)),
                );
              },
              child: const Text('Ir a Asignar Vacuna/Chequeo'),
            ),
          ],
        ),
      ),
    );
  }
}