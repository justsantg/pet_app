import 'package:flutter/material.dart';
import 'chatbot.dart'; // Asegúrate de que la ruta sea correcta según tu estructura de carpetas

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con el Bot'),
        backgroundColor: const Color.fromRGBO(150, 95, 212, 1.000),
        foregroundColor: const Color.fromRGBO(139, 212, 80, 1.000), // Color del AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8bd450), // Color de inicio del degradado
              const Color(0xFF965fd4), // Color de fin del degradado
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ChatBot(), // Aquí se incluye el widget ChatBot
      ),
    );
  }
}