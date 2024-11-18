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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return ListTile(
                  title: Text(pet['name']),
                  subtitle: Text('${pet['type']} - Age: ${pet['age']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _showAppointmentDialog(context, pet);
                    },
                    child: const Text('Asignar Cita'),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Citas Asignadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _buildAppointmentsList(context),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDialog(BuildContext context, Map<String, dynamic> pet) {
    final TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Asignar Cita para ${pet['name']}'),
          content: TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Fecha de la cita (DD/MM/YYYY)'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('appointments').add({
                    'petId': pet['id'], // ID de la mascota
                    'petName': pet['name'], // Nombre de la mascota
                    'date': dateController.text, // Fecha de la cita
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cita confirmada para ${pet['name']} el ${dateController.text}'),
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
            return ListTile(
              title: Text(appointment['petName']),
              subtitle: Text('Fecha: ${appointment['date']}'),
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
            );
          },
        );
      },
    );
  }

    void _showEditAppointmentDialog(BuildContext context, QueryDocumentSnapshot appointment) {
    final TextEditingController dateController = TextEditingController(text: appointment['date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Cita para ${appointment['petName']}'),
          content: TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Fecha de la cita (DD/MM/YYYY)'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Actualizar la cita en Firestore
                  await FirebaseFirestore.instance.collection('appointments').doc(appointment.id).update({
                    'date': dateController.text, // Nueva fecha de la cita
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cita actualizada para ${appointment['petName']} el ${dateController.text}'),
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
      // Borrar la cita de Firestore
      await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).delete();

      // Mostrar un SnackBar con la confirmación de la eliminación
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