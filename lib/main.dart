import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/assign_appointment_page.dart';
import 'map_page.dart';
import 'pet_gestion.dart';
import 'chat_page.dart';

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
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Mascotas',
      theme: ThemeData(
        primaryColor: const Color(0xFF3f6d4e), // Color primario
        // Puedes definir otros colores para el tema si lo deseas
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false, // Quitar el banner de depuración
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetApp'),
        backgroundColor: const Color.fromRGBO(150, 95, 212, 1.000),
        foregroundColor: const Color.fromRGBO(139, 212, 80, 1.000), // Color del AppBar
      ),
      body: Container(
        color: Colors.black, // Fondo negro
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildElevatedButton(
                context,
                'Ir a Gestión de Mascotas',
                Icons.pets,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PetListPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildElevatedButton(
                context,
                'Ir a Asignar Vacuna/Chequeo',
                Icons.medical_services,
                () async {
                  final listPets = await _fetchPets();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignAppointmentPage(pets: listPets, petId: '',),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildElevatedButton(
                context,
                'Ir al Mapa',
                Icons.map,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildElevatedButton(
                context,
                'Ir al Chat con Nuestro Chatbot',
                Icons.chat,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildElevatedButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(text, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1d1a2f), // Color de fondo del botón
        foregroundColor: const Color(0xFF8bd450), // Color del texto del botón
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
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