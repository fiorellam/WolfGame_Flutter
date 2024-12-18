import 'package:flutter/material.dart';
class SearchBar extends StatefulWidget {

  final List<String> items;
  final Function(List<String>) onFilter;
  //TODO: Cambiar <String> por el tipo de objeto ya sea Player o Personaje

  const SearchBar({
    super.key,
    required this.items,
    required this.onFilter
  });

  @override
  _SearchBarState createState() => _SearchBarState(); 
}

class _SearchBarState extends State<SearchBar>{
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearchResults);
  }

  //Método para filtrar los resultados según la busqueda
  void _filterSearchResults(){
    final query = _searchController.text.toLowerCase();
    final filteredItems = widget.items
    .where((item) => item.toLowerCase().contains(query))
    .toList();
    widget.onFilter(filteredItems); // Llamar al callback con los resultados filtrados
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        hintText: "Busca a n jugador",
        suffixIcon: const Icon(Icons.search),
        // suffixIconColor: Colors.pink
      ),
    );
  }
}

