import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';

import 'Country.dart';

class MySQLService {
  static final MySQLService _instance = MySQLService._internal();
  late MySQLConnection client;

  factory MySQLService() {
    return _instance;
  }

  MySQLService._internal();

  Future<void> init() async {
    final connection = await MySQLConnection.createConnection(
      host: 'your host url',
      port: your portNumber,
      userName: 'your user name',
      password: 'your password ',
      databaseName: 'your database name',
    );

    client = connection;
    await client.connect();
  }

  Future<List<Country>?> fetchCountries() async {
    try {
      final results = await client.execute('SELECT * FROM countries');
      log(results.rows.toList()[0].colAt(0).toString());
      return results.rows.map((row) {
        // Safely extract and convert values from the row
        final id = row.colAt(0);
        final name = row.colAt(1);

        // Ensure the values are of the correct type
        final countryId = id is int ? id : int.tryParse(id.toString()) ?? 0;
        final countryName = name is String ? name : name.toString();
        log(countryId.toString());

        return Country(
          id: countryId as int,
          name: countryName,
        );
      }).toList();
    } catch (e) {
      log("log1");
      log(e.toString());
      return [];
    }
  }

  Future<void> addCountry(String name) async {
    await client.execute('INSERT INTO countries (name) VALUES (:name)', {
      'name': name,
    });
  }

  Future<void> updateCountry(int id, String name) async {
    await client.execute('UPDATE countries SET name = :name WHERE id = :id', {
      'name': name,
      'id': id,
    });
  }

  Future<void> deleteCountry(int id) async {
    await client.execute(
      'DELETE FROM countries WHERE id = :id',
      {'id': id},
    );
  }
}
