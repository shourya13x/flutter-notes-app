// Importing necessary packages for SQLite database and file path handling.
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

// Singleton class to manage the SQLite database.
class NotesDatabase {
  // Static instance of the NotesDatabase class.
  static final NotesDatabase instance = NotesDatabase._init();

  // Private constructor to enforce singleton pattern.
  NotesDatabase._init();

  // Private variable to store the database instance.
  static sqflite.Database? _database;

  // Getter to retrieve the database instance, initializing it if necessary.
  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db'); // Initialize the database.
    return _database!;
  }

  // Function to initialize the database with the given file path.
  Future<sqflite.Database> _initDB(String filePath) async {
    final dbPath = await sqflite.getDatabasesPath(); // Get the database path.
    final path = join(dbPath, filePath); // Combine path and file name.
    return await sqflite.openDatabase(
      path,
      version: 1, // Database version.
      onCreate: _createDB, // Callback to create the database schema.
    );
  }

  // Function to create the database schema (e.g., the `notes` table).
  Future _createDB(sqflite.Database db, int version) async {
    await db.execute('''
     CREATE TABLE notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    date TEXT NOT NULL,
    color INTEGER NOT NULL
)
    ''');
  }

  // Function to add a new note to the database.
  Future<int> addNote(
    String title,
    String description,
    String date,
    int color,
  ) async {
    final db = await instance.database; // Get the database instance.
    return await db.insert('notes', {
      'title': title,
      'description': description,
      'date': date,
      'color': color,
    }); // Insert the note into the `notes` table.
  }

  // Function to retrieve all notes from the database, ordered by date in descending order.
  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await instance.database; // Get the database instance.
    return await db.query(
      'notes',
      orderBy: 'date DESC',
    ); // Query the `notes` table.
  }

  // Function to update an existing note in the database.
  Future<int> updateNote(
    String title,
    String description,
    String date,
    int color,
    int id,
  ) async {
    final db = await instance.database; // Get the database instance.
    return await db.update(
      'notes',
      {
        'title': title,
        'description': description,
        'date': date,
        'color': color,
      },
      where: 'id=?', // Specify the note to update by its ID.
      whereArgs: [id],
    );
  }

  // Function to delete a note from the database by its ID.
  Future<int> deleteNote(int id) async {
    final db = await instance.database; // Get the database instance.
    return await db.delete(
      'notes',
      where: 'id=?', // Specify the note to delete by its ID.
      whereArgs: [id],
    );
  }
}
