import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignAppointmentPage extends StatelessWidget {
  final List<Map<String, dynamic>> pets;

  const AssignAppointmentPage({super.key, required this.pets, required String petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Cita'),
        backgroundColor: const Color.fromRGBO(150, 95, 212, 1.000), // Color de la AppBar
        foregroundColor: const Color(0xFF8BD450), // Color del texto
      ),
      body: Container(
        color: Colors.black, // Fondo negro
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: const Color(0xFF1d1a2f), // Color del card
                    child: ListTile(
                      title: Text(pet['name'], style: const TextStyle(color: Colors.white)), // Cambiar el color del texto
                      subtitle: Text('${pet['type']} - Age: ${pet['age']}', style: const TextStyle(color: Colors.white)), // Cambiar el color del texto
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showAppointmentDialog(context, pet);
                        },
                        child: const Text('Asignar Cita', style: TextStyle(color: Colors.white)), // Cambiar el color del texto
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1d1a2f), // Color de fondo del botón
                          foregroundColor: const Color(0xFF8bd450), // Color del texto
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white), // Cambiar el color de la línea divisoria
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Citas Asignadas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Cambiar el color del texto
              ),
            ),
            Expanded(
              child: _buildAppointmentsList(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDialog(BuildContext context, Map<String, dynamic> pet) {
    final TextEditingController dateController = TextEditingController();
    String selectedType = 'Chequeo'; // Valor por defecto

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Asignar Cita para ${pet['name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Fecha de la cita (DD/MM/YYYY)'),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedType,
                items: <String>['Chequeo', 'Vacuna', 'Emergencia']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedType = newValue;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('appointments').add({
                    'petId': pet['id'], // ID de la mascota
                    'petName': pet['name'], // Nombre de la mascota
                    'date': dateController.text, // Fecha de la cita
                    'type': selectedType, // Tipo de cita
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cita confirmada para ${pet['name']} el ${dateController.text} (Tipo: $selectedType)'),
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al asignar cita: $e');
                }
              },
              child: const Text('Asignar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
                          ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay citas asignadas.'));
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final appointmentData = appointment.data() as Map<String, dynamic>?;

            String appointmentType = (appointmentData != null && appointmentData.containsKey('type'))
                ? appointmentData['type'] 
                : 'No especificado'; // Valor por defecto si no existe

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(appointmentData?['petName'] ?? 'Sin nombre'),
                subtitle: Text('Fecha: ${appointmentData?['date'] ?? 'Sin fecha'} - Tipo: $appointmentType'), // Mostrar el tipo de cita
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditAppointmentDialog(context, appointment);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteAppointment(context, appointment.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditAppointmentDialog(BuildContext context, QueryDocumentSnapshot appointment) {
    final TextEditingController dateController = TextEditingController(text: appointment['date']);
    final appointmentData = appointment.data() as Map<String, dynamic>?;

    String selectedType = (appointmentData != null && appointmentData.containsKey('type'))
        ? appointmentData['type'] 
        : 'Chequeo'; // Valor por defecto

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Cita para ${appointment['petName']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Fecha de la cita (DD/MM/YYYY)'),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedType,
                items: <String>['Chequeo', 'Vacuna', 'Emergencia']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedType = newValue; // Actualizar el tipo seleccionado
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('appointments').doc(appointment.id).update({
                    'date': dateController.text, // Nueva fecha de la cita
                    'type': selectedType, // Nuevo tipo de cita
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cita actualizada para ${appointment['petName']} el ${dateController.text} (Tipo: $selectedType)'),
                      duration: const Duration(seconds: 3),
                    ),
                  );

                  Navigator.of(context).pop(); // Cerrar el diálogo
                } catch (e) {
                  print('Error al actualizar la cita: $e');
                }
              },
              child: const Text('Actualizar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAppointment(BuildContext context, String appointmentId) async {
    try {
      await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita eliminada.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error al eliminar la cita: $e');
    }
  }
}