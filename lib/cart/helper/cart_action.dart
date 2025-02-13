import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

void deleteCartProduct(CookieRequest request, String id, BuildContext context,
    Function setState) async {
  final endpoint =
      "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/cart/delete_cart_product_flutter/$id/";

  try {
    final response = await request.post(endpoint, {});

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      setState(() {}); // Refresh the cart screen after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response['error'] ?? "Failed to delete product.")),
      );
    }
  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Error: $e")),
    // );
    print(e);
  }
}

void updateAmount(CookieRequest request, String id, bool increment,
    BuildContext context, Function setState) async {
  final endpoint =
      "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/cart/${increment ? 'inc_amount' : 'dec_amount'}/$id/";

  try {
    final response = await request.post(endpoint, {});

    if (response['success'] == true) {
      print('success');
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update amount.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error jawi: $e")),
    );
  }
}

void editNote(CookieRequest request, String cartProductId, String currentNote,
    BuildContext context, Function setState) {
  final TextEditingController noteController =
      TextEditingController(text: currentNote);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(
          controller: noteController,
          maxLength: 144,
          decoration: const InputDecoration(
            hintText: "Enter new note",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without saving
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newNote = noteController.text.trim();

              if (newNote.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note cannot be empty")),
                );
                return;
              }

              try {
                final response = await request.postJson(
                  "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/cart/update_note/$cartProductId/",
                  jsonEncode(<String, String>{'note': newNote}),
                );

                if (response['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note updated successfully")),
                  );
                  Navigator.of(context).pop(); // Close dialog after saving
                  setState(() {}); // Refresh the cart view
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(response['error'] ?? "Failed to update note"),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}


