import 'package:flutter/material.dart';
import 'dart:async'; // Para simular un retraso en la respuesta

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String message) {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "message": message});
    });
    
    _controller.clear();
    _getBotResponse(message);
  }

  Future<void> _getBotResponse(String message) async {
    // Simulamos un tiempo de respuesta
    await Future.delayed(Duration(seconds: 1));

    String response;
    if (message.contains("mascota") || message.contains("cita")) {
      response = "¿Qué información necesitas sobre tus mascotas o citas?";
    } else if (message.contains("precio") || message.contains("servicio")) {
      response = "Los precios de los servicios para mascotas varían. ¿Qué servicio te interesa?";
    } else if (message.contains("agendar") || message.contains("cita")) {
      response = "Claro, ¿qué tipo de cita deseas agendar y para cuándo?";
    } else if (message.contains("gracias")) {
      response = "¡De nada! Si necesitas más ayuda, aquí estoy.";
    } else if (message.contains("adiós")) {
      response = "¡Hasta luego! Espero verte pronto.";
    } else {
      response = "Lo siento, no entiendo tu pregunta. ¿Puedes reformularla?";
    }

    setState(() {
      _messages.add({"sender": "bot", "message": response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Align(
                  alignment: _messages[index]["sender"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _messages[index]["sender"] == "user"
                          ? Colors.blueAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _messages[index]["message"]!,
                      style: TextStyle(
                        color: _messages[index]["sender"] == "user"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
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
                  decoration: InputDecoration(
                    hintText: 'Escribe mensajes como mascota, cita, precio aquí...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onSubmitted: (value) {
                    _sendMessage(value);
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_controller.text);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}