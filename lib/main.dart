import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Mascotas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PetListPage(),
    );
  }
}