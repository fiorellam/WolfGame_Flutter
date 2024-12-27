import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:wolf_game/presentation/widgets/dropdown_level.dart';
import 'package:wolf_game/presentation/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedValue = "Principiante"; // Valor inicial
  List<String> levelsList = ["Principiante", "Intermedio", "Avanzado", "Pro"];
  List<Map<String, String>> _players = []; // Lista de jugadores
  List<Map<String, String>> _filteredPlayers = []; // Jugadores filtrados
  Set<String> _selectedItems = {}; // Conjunto para almacenar los elementos seleccionados

  @override
  void initState() {
    super.initState();
    _loadPlayers(); // Cargar los jugadores cuando la vista se inicializa
  }

  // Función para cargar los jugadores desde el archivo JSON
  Future<void> _loadPlayers() async {
    final String response = await rootBundle.loadString('assets/usuarios.json');
    final List<dynamic> data = json.decode(response); // Decodificar el JSON
    setState(() {
      _players = data.map((item) => {
        "name": item['name'],
        "phone": item['phone']
      }).toList();
      _filteredPlayers = _players; // Inicializar la lista filtrada con todos los jugadores
    });
  }

  // Función de filtrado para los jugadores
  void _onFilter(String query) {
    setState(() {
      _filteredPlayers = _players
          .where((player) => player['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Función que maneja la selección de un jugador
  void _onSelectItem(String selectedItem) {
    setState(() {
      if (_selectedItems.contains(selectedItem)) {
        _selectedItems.remove(selectedItem);
      } else {
        _selectedItems.add(selectedItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Jugadores'),
      ),
      body: Column(
        children: [
          // Usamos el widget SearchBar
          SearchBar2(items: _players.map((player) => player['name']!).toList(), onFilter: _onFilter),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: _loadPlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar jugadores'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = _filteredPlayers[index];
                      final isSelected = _selectedItems.contains(player['name']);
                      return ListTile(
                        leading: Icon(
                          isSelected ? Icons.check_circle : Icons.check_circle_outline,
                          color: isSelected ? Colors.green : Colors.grey,
                        ),
                        title: Text(player['name']!),
                        subtitle: Text(player['phone']!),
                        trailing: Text(player['role']!),
                        onTap: () => _onSelectItem(player['name']!),
                      );
                    },
                  );
                }
              },
            ),
          ),
          DropdownLevel(items: levelsList, onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          }),
          Text("Valor seleccionado: $_selectedValue", style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}