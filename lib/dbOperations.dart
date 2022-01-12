//SANTAROSSA RICCARDO 5BIA 01/01/2022

// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Swimmer.dart';

class dbOperations {
  //Crea il database e la tabella nuotatori
  static void createDB() async {
    final database = openDatabase(
      //Localizza il Database
      join(await getDatabasesPath(), 'swimmersDB.db'),
      onCreate: (db, version) {
        //Esegue la query SQL per creare la tabella
        return db.execute(
          'CREATE TABLE swimmers(id_swimmer INTEGER PRYMARY KEY AUTO_INCREMENT, swimmer_name TEXT, age INTEGER, nation TEXT)',
        );
      },
      version: 1,
    );
  }

  //Funzione di inserimento dei record
  static Future<void> insertRecord(Swimmer swimmer) async {
    //Apre il database
    final database =
        openDatabase(join(await getDatabasesPath(), 'swimmersDB.db'));
    //Connette al database
    final data = await database;
    //Inserisce un record di tipo nuotatore nella tabella swimmers, rimpiazza eventuali doppioni
    await data.insert('swimmers', swimmer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Funzione che mostra i record della tabella
  static Future<List<Swimmer>> showRecords() async {
    //Apre il database
    final database =
        openDatabase(join(await getDatabasesPath(), 'swimmersDB.db'));
    //Connette al database
    final data = await database;

    //Viene creata una lista di tutti i record presenti nella tabella
    //data.query esegue una SELECT *
    final List<Map<String, dynamic>> record = await data.query('swimmers');

    //Ritorna la lista creata e associa ad ogni campo il rispettivo valore per poi stamparlo
    return List.generate(record.length, (index) {
      return Swimmer(
          id_swimmer: record[index]['id'],
          swimmer_name: record[index]['nome'],
          age: record[index]['eta'],
          nation: record[index]['nazionalita']);
    });
  }

  static void printData() async {
    print(await showRecords());
  }
}