import 'package:flutter/material.dart';
import 'dart:async'; // Para simular un retraso en la respuesta

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
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
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
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

   Widget _buildMessageBubble(Map<String, String> message) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Align(
      alignment: message['sender'] == "Usuario" ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: message['sender'] == "Usuario" ? const Color(0xFF8BD450) : const Color(0xFF965FD4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: message['sender'] == "Usuario" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['sender']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: message['sender'] == "Usuario" ? Colors.blue[800] : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              message['message']!,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    ),
  );
}


  void _sendMessage(String message) {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"sender": "Usuario", "message": message});
    });

    _controller.clear();
    _getBotResponse(message);
  }

  Future<void> _getBotResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1));

    String response;

    String lowerMessage = message.toLowerCase();

    if (lowerMessage.contains("cuidado de mascotas")) {
      response = "Visita a tu veterinario de confianza regularmente, atiende las necesidades nutricionales de tu mascota, quedate atento a las vacunas de tu mascota, entrena y juega con ella regularmente, manten a tu mascota limpia y entregales todo tu amor.";
    } else if (lowerMessage.contains("agendar cita")) {
      response = "Las citas ayudan a detectar posibles problemas de salud en tu mascota y, con suerte, evitar que se conviertan en algo grave, Por favor, para agendar una cita, comunícate con nosotros al numero 300455668.";
    } else if (lowerMessage.contains("vacunas")) {
      response = "Las vacunas son esenciales para la salud de tu mascota,  Las vacunas protegen a su mascota de enfermedades altamente contagiosas y mortales y mejoran su calidad de vida en general. Asegúrate de seguir el calendario de vacunación.";
    } else if (lowerMessage.contains("consejos de salud")) {
      response = "Lo más vital es que siempre tengan disponible agua fresca, limpia y potable, así como una alimentación específica que logre nutrirlo de acuerdo a sus necesidades energéticas, de edad, raza, estilo de vida o estado de salud en el que se encuentre y según lo indique su médico veterinario zootecnista.";
    } else if (lowerMessage.contains("gracias")) {
      response = "¡De nada! Si necesitas más información, no dudes en preguntar.";
    } else if (lowerMessage.contains("adiós")) {
      response = "¡Hasta luego! Cuida bien de tu mascota.";
    } else {
      response = "Lo siento, no entiendo tu pregunta. ¿Puedes reformularla?";
    }

    setState(() {
      _messages.add({"sender": "Bot", "message": response});
    });
  }
}