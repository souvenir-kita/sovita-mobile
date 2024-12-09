import 'package:flutter/material.dart';

class FormTambahUlasan extends StatefulWidget {
  final String? initialUsername;
  final int? initialRating;
  final String? initialDescription;
  final String? initialDate;

  const FormTambahUlasan({
    Key? key,
    this.initialUsername,
    this.initialRating,
    this.initialDescription,
    this.initialDate,
  }) : super(key: key);

  @override
  State<FormTambahUlasan> createState() => _FormTambahUlasanPageState();
}

class _FormTambahUlasanPageState extends State<FormTambahUlasan> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  int? rating;
  String? description;

  @override
  void initState() {
    super.initState();
    username = widget.initialUsername;
    rating = widget.initialRating;
    description = widget.initialDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ulasan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(labelText: 'Username'),
                onSaved: (value) => username = value,
              ),
              DropdownButtonFormField<int>(
                value: rating,
                decoration: const InputDecoration(labelText: 'Rating'),
                items: List.generate(10, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  );
                }),
                onChanged: (value) => rating = value,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 5,
                onSaved: (value) => description = value,
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.save();
                  Navigator.pop(context, {
                    'username': username,
                    'rating': rating,
                    'description': description,
                    'date': widget.initialDate ?? DateTime.now().toString(),
                  });
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
