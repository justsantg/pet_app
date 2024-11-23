import 'package:flutter/material.dart';
import 'chatbot.dart'; // Asegúrate de que la ruta sea correcta según tu estructura de carpetas

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con el Bot'),
        backgroundColor: const Color(0xFF965FD4),
        foregroundColor: const Color(0xFF8BD450), // Color del AppBar
      ),
      body: Container(
        color: Colors.black, // Fondo negro
        child: Chatbot(), // Aquí se incluye el widget ChatBot
      ),
    );
  }
}