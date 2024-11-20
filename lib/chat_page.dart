import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Agrega el mensaje del usuario a la lista
    setState(() {
      _messages.add({'sender': 'User  ', 'message': _controller.text});
    });

    // Envía el mensaje a LocalAI y obtiene la respuesta
    final response = await _getResponseFromLocalAI(_controller.text);

    // Agrega la respuesta de la IA a la lista
    setState(() {
      _messages.add({'sender': 'AI', 'message': response});
      _controller.clear(); // Limpia el campo de texto
    });
  }

  Future<String> _getResponseFromLocalAI(String message) async {
    // Cambia esto por tu endpoint real de LocalAI
    final url = Uri.parse('https://your-localai-endpoint'); 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response']; // Asegúrate de que esta clave coincida con la respuesta de tu API
      } else {
        print('Error: ${response.statusCode}'); // Imprimir el código de estado
        print('Response body: ${response.body}'); // Imprimir el cuerpo de la respuesta
        return 'Error al obtener respuesta de la IA';
      }
    } catch (e) {
      print('Error: $e'); // Imprimir cualquier error que ocurra
      return 'Error al enviar el mensaje';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat con IA'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text('${message['sender']}: ${message['message']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}