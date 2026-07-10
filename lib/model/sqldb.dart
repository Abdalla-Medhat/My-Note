import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class Sqldb {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  /// Database initialization function
  Future<Database> initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "mynote.db");

    Database myDb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onUpgrade: _onUpgrade,
    );

    return myDb;
  }

  /// Create function, called one time when the database is created
  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute("""
      CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      image TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      is_logged_in INTEGER DEFAULT 0
      )
      """);

    batch.execute("""
      CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      note TEXT NOT NULL,
      user_id INTEGER NOT NULL,
      image TEXT,
      last_edit TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY(user_id) REFERENCES users(id)
      )
      """);

    await batch.commit();

    print("===>Database Created successfully...");
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("===>onUpgrade function called successfully...");
  }

  // CRUD functions

  /// Read function
  Future<List<Map<dynamic, dynamic>>> readData(
    String sql,
    List<Object?>? args,
  ) async {
    Database? myDb = await db;
    List<Map> response = await myDb!.rawQuery(sql, args);
    return response;
  }

  /// Insert function
  Future<int> insertData(String sql, List<Object?>? args) async {
    Database? myDb = await db;
    int response = await myDb!.rawInsert(sql, args);
    return response;
  }

  /// Update function
  Future<int> updateData(String sql, List<Object?>? args) async {
    Database? myDb = await db;
    int response = await myDb!.rawUpdate(sql, args);
    return response;
  }

  /// Delete function
  Future<int> deleteData(String sql, List<Object?>? args) async {
    Database? myDb = await db;
    int response = await myDb!.rawDelete(sql, args);
    return response;
  }

  /// Delete Database function
  Future<void> deleteDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "mynote.db");
    await deleteDatabase(path);
  }

  // Check if the user is logged in
  Future<bool> isLoggedin() async {
    Database? myDb = await db;
    List<Map> result = await myDb!.rawQuery(
      "SELECT * FROM users WHERE is_logged_in = 1",
    );
    return result.isNotEmpty;
  }
}
