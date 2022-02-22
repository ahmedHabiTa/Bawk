import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;

  static const String _tableName = 'notes';

  static Future<void> initDB() async {
    if (_db != null) {
      print('db not null');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'note.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, content STRING, placeDateTime STRING, userId STRING)');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(GetNotesResponse? getNotesResponse) async {
    return await _db!.insert(_tableName, getNotesResponse!.toJson());
  }

  static Future<List<Map<String, Object?>>> query(
      GetNotesResponse? getNotesResponse) async {
    return await _db!.query(
      _tableName,
    );
  }
}
