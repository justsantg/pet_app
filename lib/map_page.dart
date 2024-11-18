import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LocationData? _currentLocation;
  final Location _locationService = Location();
  List<LatLng> _additionalPoints = [];
  final TextEditingController _placeController = TextEditingController();
  LatLng? _enteredLocation;
  List<LatLng> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadSavedLocations(); // Cargar ubicaciones guardadas al iniciar
  }

  Future<void> _getLocation() async {
    final hasPermission = await _locationService.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _locationService.requestPermission();
    }

    try {
      final locationData = await _locationService.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }

    _locationService.onLocationChanged.listen((LocationData result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  Future<void> _searchPlace() async {
    final placeName = _placeController.text;
    final url = 'https://nominatim.openstreetmap.org/search?q=$placeName&format=json&addressdetails=1&limit=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      if (results.isNotEmpty) {
        final location = results[0];
        final lat = double.parse(location['lat']);
        final lon = double.parse(location['lon']);
        setState(() {
          _enteredLocation = LatLng(lat, lon);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se encontraron resultados.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al buscar el lugar.")),
      );
    }
  }

  // Función para mostrar el diálogo con la ubicación actual
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ubicación Actual"),
          content: Text(
            "Latitud: ${_currentLocation?.latitude}\n"
            "Longitud: ${_currentLocation?.longitude}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  // Función para guardar la ubicación actual
  Future<void> _saveLocation() async {
    if (_currentLocation != null) {
      setState(() {
        _savedLocations.add(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
           });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ubicación guardada.")),
      );

      // Aquí puedes agregar la lógica para guardar en Firestore si es necesario.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede guardar la ubicación. Intenta de nuevo.")),
      );
    }
  }

  // Función para mostrar las ubicaciones guardadas
  void _showSavedLocationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ubicaciones Guardadas"),
          content: SizedBox(
            width: 300,
            height: 200,
            child: ListView.builder(
              itemCount: _savedLocations.length,
              itemBuilder: (context, index) {
                final location = _savedLocations[index];
                return ListTile(
                  title: Text("Lat: ${location.latitude}, Lon: ${location.longitude}"),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  // Función para generar puntos adicionales aleatorios
  void _generateAdditionalPoints() {
    setState(() {
      if (_currentLocation != null) {
        double lat = _currentLocation!.latitude! + (0.01 * (1 - 2 * (0.5 - (new DateTime.now().millisecondsSinceEpoch % 1000) / 1000)));
        double lon = _currentLocation!.longitude! + (0.01 * (1 - 2 * (0.5 - (new DateTime.now().millisecondsSinceEpoch % 1000) / 1000)));
        _additionalPoints.add(LatLng(lat, lon));
      }
    });
  }

  // Aquí deberías implementar la función para cargar ubicaciones guardadas
  Future<void> _loadSavedLocations() async {
    // Lógica para cargar ubicaciones desde Firestore o cualquier otra fuente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map OpenStreetMap')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: _placeController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar lugar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchPlace,
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveLocation, // Llama a la función para guardar ubicaciones
                  child: const Text('Guardar Ubicación'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _showSavedLocationsDialog, // Muestra ubicaciones guardadas
                  child: const Text('Ver Ubicaciones'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(
                      center: _enteredLocation ??
                          LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          ),
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(
                              _currentLocation!.latitude!,
                              _currentLocation!.longitude!,
                            ),
                            builder: (ctx) => GestureDetector(
                              onTap: () {
                                _showLocationDialog(); // Muestra el diálogo con la ubicación
                              },
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ),
                          if (_enteredLocation != null)
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _enteredLocation!,
                              builder: (ctx) => const Icon(
                                Icons.location_on,
                                color: Colors.purple,
                                size: 40,
                                                              ),
                            ),
                          ..._additionalPoints.map((point) => Marker(
                                width: 80.0,
                                height: 80.0,
                                point: point,
                                builder: (ctx) => const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              )),
                          ..._savedLocations.map((point) => Marker(
                                width: 80.0,
                                height: 80.0,
                                point: point,
                                builder: (ctx) => const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await _getLocation();
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _generateAdditionalPoints, // Genera puntos adicionales
            child: const Icon(Icons.add_location_alt),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MapPage()));
}