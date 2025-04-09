import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();

  Future<void> ajouterContact() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/contacts"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom": nomController.text,
          "email": emailController.text,
          "telephone": telController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Contact ajouté avec succès")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout")),
        );
      }
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    emailController.dispose();
    telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un contact")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: nomController,
              decoration: InputDecoration(labelText: "Nom"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),
            TextFormField(
              controller: telController,
              decoration: InputDecoration(labelText: "Téléphone"),
              validator: (value) => value!.isEmpty ? "Champ requis" : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ajouterContact,
              child: Text("Ajouter"),
            ),
          ]),
        ),
      ),
    );
  }
}
