import 'package:flutter/material.dart';
import 'package:sovita/display/screens/allproducts.dart';

class SearchBarForm extends StatefulWidget {
  final bool? fromAllProductScreen;
  const SearchBarForm({super.key, this.fromAllProductScreen});

  @override
  _SearchBarFormState createState() => _SearchBarFormState();
}

class _SearchBarFormState extends State<SearchBarForm> {
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitSearch() {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isEmpty) {
      return;
    }
    print(widget.fromAllProductScreen);
    if (widget.fromAllProductScreen == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AllProducts(search : searchQuery)));
    } else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProducts(search : searchQuery)));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari Produk',
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (_) {
                    String searchQuery = _searchController.text.trim();
                    if (searchQuery.isNotEmpty) {
                      _submitSearch();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  String searchQuery = _searchController.text.trim();
                  if (searchQuery.isNotEmpty) {
                    _submitSearch();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}