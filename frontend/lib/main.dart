import 'package:flutter/material.dart';
import 'pages/contact_list_page.dart';
import 'pages/add_contact_page.dart';
import 'pages/edit_contact_page.dart';

void main() {
  runApp(ContactApp());
}

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Contacts',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: Typography().black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ContactListPage(),
        '/add': (context) => AddContactPage(),
      },
    );
  }
}
