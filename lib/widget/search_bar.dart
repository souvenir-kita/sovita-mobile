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
  String? _filter;
  String _order = 'asc';

  void _submitSearch() {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllProducts(
            filter: '$_filter:$_order',
          ),
        ),
      );
      return;
    }
    if (widget.fromAllProductScreen == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllProducts(
            search: searchQuery,
            filter: '$_filter:$_order',
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AllProducts(
            search: searchQuery,
            filter: '$_filter:$_order',
          ),
        ),
      );
    }
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pilih Filter dan Urutan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Filter Berdasarkan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                      ),
                      child: Column(
                        children: [
                          _buildFilterTile(
                            icon: Icons.attach_money,
                            title: 'Harga',
                            value: 'price',
                            currentFilter: _filter,
                            onTap: () => setState(() => _filter = 'price'),
                          ),
                          const Divider(height: 1),
                          _buildFilterTile(
                            icon: Icons.sort_by_alpha,
                            title: 'Alfabet',
                            value: 'alphabet',
                            currentFilter: _filter,
                            onTap: () => setState(() => _filter = 'alphabet'),
                          ),
                          const Divider(height: 1),
                          _buildFilterTile(
                            icon: Icons.access_time,
                            title: 'Waktu',
                            value: 'time',
                            currentFilter: _filter,
                            onTap: () => setState(() => _filter = 'time'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Urutkan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOrderButton(
                            title: 'Ascending',
                            icon: Icons.arrow_upward,
                            value: 'asc',
                            currentOrder: _order,
                            onTap: () => setState(() => _order = 'asc'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildOrderButton(
                            title: 'Descending',
                            icon: Icons.arrow_downward,
                            value: 'desc',
                            currentOrder: _order,
                            onTap: () => setState(() => _order = 'desc'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Batal',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Terapkan',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterTile({
    required IconData icon,
    required String title,
    required String value,
    required String? currentFilter,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentFilter;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              )
            : null,
        selected: isSelected,
        selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildOrderButton({
    required String title,
    required IconData icon,
    required String value,
    required String currentOrder,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentOrder;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _formKey,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari Produk',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16),
                  onFieldSubmitted: (_) => _submitSearch(),
                ),
              ),
              Container(
                height: 32,
                width: 1,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
                onPressed: _showFilterOptions,
                splashRadius: 24,
              ),
              IconButton(
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                onPressed: _submitSearch,
                splashRadius: 24,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}