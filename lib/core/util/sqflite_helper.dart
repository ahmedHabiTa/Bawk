import 'package:bawq/notes/domain/entity/get_note_response.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, text, placeDate, userId
  ];

  static const String id = '_id';
  static const String text = 'text';
  static const String placeDate = 'placeDate';
  static const String userId = 'userId';
}

class Note {
  final int? id;
  final String text;
  final String placeDate;
  final String userId;

  const Note({
    this.id,
    required this.text,
    required this.placeDate,
    required this.userId,
  });

  Note copy({
    int? id,
    String? text,
    String? placeDate,
    String? userId,
  }) =>
      Note(
        id: id ?? this.id,
        text: text ?? this.text,
        placeDate: placeDate ?? this.placeDate,
        userId: userId ?? this.userId,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        text: json[NoteFields.text] as String,
        placeDate: json[NoteFields.placeDate] as String,
        userId: json[NoteFields.userId] as String,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.text: text,
        NoteFields.placeDate: placeDate,
        NoteFields.userId: userId,
      };
}

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(dbPath + filePath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${NoteFields.id} $idType, 
  ${NoteFields.text} $textType,
  ${NoteFields.placeDate} $textType,
  ${NoteFields.userId} $textType
  )
''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
