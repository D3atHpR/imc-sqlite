import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  void _calculateAndSaveIMC() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    double imc = weight / (height * height);

    _saveData(imc);
  }

  Future<void> _saveData(double imc) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'imc_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE imcs(id INTEGER PRIMARY KEY, imc REAL)",
        );
      },
      version: 1,
    );

    await database.insert(
      'imcs',
      {'imc': imc},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IMC Calculator"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: weightController,
            decoration: const InputDecoration(labelText: "Weight (kg)"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: heightController,
            decoration: const InputDecoration(labelText: "Height (m)"),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: _calculateAndSaveIMC,
            child: const Text("Calculate"),
          ),
        ],
      ),
    );
  }
}
