import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:sqldatabasedemo/Country.dart';

import 'MySqlService.dart';

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final fetchedCountries = await MySQLService().fetchCountries();
      setState(() {
        countries = fetchedCountries!;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addCountry(String name) async {
    await MySQLService().addCountry(name);
    fetchCountries();
  }

  Future<void> updateCountry(int id, String name) async {
    await MySQLService().updateCountry(id, name);
    fetchCountries();
  }

  Future<void> deleteCountry(int id) async {
    await MySQLService().deleteCountry(id);
    fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return ListTile(
                  title: Text(country.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(country),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteCountry(country.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Country Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: addCountry,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Country country) {
    final controller = TextEditingController(text: country.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Country'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Country Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                updateCountry(country.id, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
