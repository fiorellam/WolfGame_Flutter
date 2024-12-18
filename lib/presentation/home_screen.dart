import 'package:flutter/material.dart';
import 'package:wolf_game/presentation/widgets/dropdown_level.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  String _selectedValue = "Principiante"; //Valor inicial
  List<String> levelsList = levels;

  //Función que será llamada cuando cambie el valor del dropdown
  void _handleDropdownLevelChange(String value){
    setState(() {
      _selectedValue = value; //Actualizamos el valor del dropdown
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio Juego Lobo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SearchBar(),

            // Usamos el DropdownWidget
            DropdownLevel(items: levelsList, onChanged: _handleDropdownLevelChange),
            const SizedBox(height: 20),
            Text("Valor seleccionado: $_selectedValue", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
