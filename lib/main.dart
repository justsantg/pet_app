import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/assign_appointment_page.dart';
import 'map_page.dart';
import 'pet_gestion.dart';
import 'chat_page.dart'; // Asegúrate de importar tu nueva página de chat

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
    HomePage({super.key});

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
              onPressed: () async {
                final listPets = await _fetchPets();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssignAppointmentPage(pets: listPets, petId: '',),
                  ),
                );
              },
              child: const Text('Ir a Asignar Vacuna/Chequeo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
              child: const Text('Ir al Mapa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()), // Navega a la pantalla de chat
                );
              },
              child: const Text('Ir al Chat con IA'), // Botón para ir al chat
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchPets() async {
    final CollectionReference petCollection = FirebaseFirestore.instance.collection('pets');
    QuerySnapshot snapshot = await petCollection.get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      'name': doc['name'],
      'type': doc['type'],
      'age': doc['age'],
    }).toList();
  }
}