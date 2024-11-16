import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vaccine_checkup_page.dart'; // Importa la página de chequeo/vacunas

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final CollectionReference _petCollection =
      FirebaseFirestore.instance.collection('pets');
  String? _editingPetId; // Almacena el ID de la mascota que se está editando

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet List'),
      ),
      body: Column(
        children: [
          _buildPetInputFields(),
          Expanded(child: _buildPetList()),
          _buildNavigateToVaccineButton(), // Botón para navegar a la página de vacunas
        ],
      ),
    );
  }

  Widget _buildPetInputFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Pet Name'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Pet Type'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Pet Age (e.g., "1 year" or "6 months")'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _editingPetId == null ? _addPet : _updatePet,
            child: Text(_editingPetId == null ? 'Add Pet' : 'Update Pet'),
          ),
        ],
      ),
    );
  }

  Widget _buildPetList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _petCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final listPets = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: listPets.length,
          itemBuilder: (context, index) {
            final pet = listPets[index];
            return ListTile(
              title: Text(pet['name']),
              subtitle: Text('${pet['type']} - Age: ${pet['age']}'), // Muestra la edad tal como se ingresó
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editPet(pet),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePet(pet.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNavigateToVaccineButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          final snapshot = await _petCollection.get();
          final listPets = snapshot.docs.map((doc) => {
            'id': doc.id,
            'name': doc['name'],
            'type': doc['type'],
            'age': doc['age'],
          }).toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VaccineCheckupPage(pets: listPets, petId: '1',), // Pasar la lista de mascotas
            ),
          );
        },
        child : const Text('Ir a Asignar Vacuna/Chequeo'),
      ),
    );
  }

  void _addPet() {
    if (_nameController.text.isNotEmpty && 
        _typeController.text.isNotEmpty && 
        _ageController.text.isNotEmpty) {
      _petCollection.add({
        'name': _nameController.text,
        'type': _typeController.text,
        'age': _ageController.text, // Almacena la edad como cadena
      });
      _clearInputFields();
    }
  }

  void _editPet(QueryDocumentSnapshot pet) {
    _editingPetId = pet.id;
    _nameController.text = pet['name'];
    _typeController.text = pet['type'];
    _ageController.text = pet['age']; // Carga la edad como cadena
  }

  void _updatePet() {
    if (_editingPetId != null && 
        _nameController.text.isNotEmpty && 
        _typeController.text.isNotEmpty && 
        _ageController.text.isNotEmpty) {
      _petCollection.doc(_editingPetId).update({
        'name': _nameController.text,
        'type': _typeController.text,
        'age': _ageController.text, // Almacena la edad como cadena
      });
      _clearInputFields();
      _editingPetId = null; // Restablecer el ID de edición
    }
  }

  void _deletePet(String id) {
    _petCollection.doc(id).delete();
  }

  void _clearInputFields() {
    _nameController.clear();
    _typeController.clear();
    _ageController.clear();
  }
}