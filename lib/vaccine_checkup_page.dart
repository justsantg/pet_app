import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VaccineCheckupPage extends StatefulWidget {
  final List<Map<String, dynamic>> pets; // Lista de mascotas

  const VaccineCheckupPage({Key? key, required this.pets, required String petId}) : super(key: key);

  @override
  _VaccineCheckupPageState createState() => _VaccineCheckupPageState();
}

class _VaccineCheckupPageState extends State<VaccineCheckupPage> {
  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final CollectionReference _checkupCollection = FirebaseFirestore.instance.collection('checkups');

  String? _selectedPetId; // ID de la mascota seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Vacuna/Chequeo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Selecciona una mascota'),
              value: _selectedPetId,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPetId = newValue;
                });
              },
              items: widget.pets.map<DropdownMenuItem<String>>((pet) {
                return DropdownMenuItem<String>(
                  value: pet['id'],
                  child: Text(pet['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _vaccineNameController,
              decoration: const InputDecoration(labelText: 'Nombre de la Vacuna/Chequeo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _frequencyController,
              decoration: const InputDecoration(labelText: 'Frecuencia (ej. "cada 6 meses")'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _assignVaccineCheckup,
              child: const Text('Asignar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _assignVaccineCheckup() async {
    if (_selectedPetId != null && _vaccineNameController.text.isNotEmpty && _frequencyController.text.isNotEmpty) {
      await _checkupCollection.add({
        'petId': _selectedPetId,
        'vaccineName': _vaccineNameController.text,
        'frequency': _frequencyController.text,
        'dateAssigned': DateTime.now(),
      });
      Navigator.pop(context); // Regresar a la pantalla anterior
    } else {
      // Mostrar un mensaje de error si falta información
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una mascota y completa todos los campos.')),
      );
    }
  }
}