import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_contact_page.dart';
import 'edit_contact_page.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List contacts = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:5000/contacts"));
    if (response.statusCode == 200) {
      setState(() {
        contacts = json.decode(response.body);
      });
    }
  }

  Future<void> deleteContact(int id) async {
    final response = await http.delete(Uri.parse("http://10.0.2.2:5000/contacts/$id"));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact supprimé")));
      fetchContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des contacts"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchContacts,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final c = contacts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text("${c['nom']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📧 ${c['email']}"),
                  Text("📞 ${c['telephone']}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditContactPage(contact: c),
                        ),
                      ).then((_) => fetchContacts());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteContact(c['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactPage()),
          ).then((_) => fetchContacts());
        },
        child: Icon(Icons.add),
        tooltip: "Ajouter un contact",
      ),
    );
  }
}
