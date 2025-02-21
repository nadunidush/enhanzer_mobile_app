import 'package:enhanzer_mobile_app/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static Database? _db;
  static final DatabaseServices instance = DatabaseServices._constructor();

  final String loginTableName = "login";
  final String _loginId = "Unique_Id";
  final String _username = "Company_Code";
  final String _password = "Pw";

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "enhanzer_db.db");
    final database = await openDatabase(
      version: 1,
      databasePath,
      onCreate: (db, version) {
        db.execute('''
         CREATE TABLE $loginTableName(
            $_loginId INTEGER PRIMARY KEY,
            $_username TEXT NOT NULL,
            $_password TEXT NOT NULL
         )
        ''');
      },
    );

    return database;
  }

  void addUser(String username, String pw) async {
    final db = await database;
    await db.insert(loginTableName, {_username: username, _password: pw});
  }

  Future<List<User>?> getUsers() async {
    final db = await database;
    final data = db.query(loginTableName);
    print(data);
  }
}
