import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditContactPage extends StatefulWidget {
  final Map contact;

  EditContactPage({required this.contact});

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomController;
  late TextEditingController emailController;
  late TextEditingController telController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.contact['nom']);
    emailController = TextEditingController(text: widget.contact['email']);
    telController = TextEditingController(text: widget.contact['telephone']);
  }

  Future<void> modifierContact() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:5000/contacts/${widget.contact['id']}"),
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
          SnackBar(content: Text("Contact modifié avec succès")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la modification")),
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
      appBar: AppBar(title: Text("Modifier le contact")),
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
              onPressed: modifierContact,
              child: Text("Enregistrer les modifications"),
            ),
          ]),
        ),
      ),
    );
  }
}

