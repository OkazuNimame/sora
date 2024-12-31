import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BreakDatabase {
  // SQLiteデータベースのインスタンス
  static Database? _database;

  // テーブル名
  static const String tableName = 'breaks';
  
  static String date = "date";
  static String id = "id";
  static String hours = "hours";
  // データベースの初期化
  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDatabase();
    return _database!;
  }

  // データベースの作成
  Future<Database> _initializeDatabase() async {
    // アプリのディレクトリを取得
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'breaks.db');

    // データベースの初期化とテーブル作成
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $date TEXT,
            $hours INTEGER
          )
        ''');
      },
    );
  }

  // 休んだ時間と日付をデータベースに挿入
  Future<int> insertBreak(String date, int hours) async {
    final db = await _db;
    final map = {"date": date, "hours": hours};
    return await db.insert(tableName, map);
  }

  // データベースから全ての休んだ時間を取得
  Future<List<Map<String, dynamic>>> getAllBreaks() async {
    final db = await _db;
    return await db.query(tableName);
  }

  // 特定の日付の休んだ時間を取得（オプション）
  Future<List<Map<String, dynamic>>> getBreakByDate(String date) async {
    final db = await _db;
    return await db.query(
      tableName,
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  Future<int> sumBreakHours() async {
    final db = await _db;
    
    // SQLクエリでSUM関数を使用して合計時間を取得
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(hours) AS total_hours FROM $tableName');
    
    // 結果が存在するか確認し、合計時間を返す
    if (result.isNotEmpty && result[0]['total_hours'] != null) {
      return result[0]['total_hours'] as int;
    }
    
    return 0; // 合計時間がない場合は0を返す
  }

  Future<Map<String, int>> getBreakTimesByDate() async {
    Database db = await _db;
  final result = await db.rawQuery('''
    SELECT date, SUM($hours) AS total_time
    FROM $tableName
    GROUP BY $date
  ''');
  
  // 結果をマップ形式に変換
  return {
    for (var row in result) row['date'] as String: row['total_time'] as int
  };
}


  // 特定のIDで休んだ時間を更新（オプション）
  Future<int> updateBreak(int id, String date, int hours) async {
    final db = await _db;
    return await db.update(
      tableName,
      {'date': date, 'hours': hours},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 特定のIDで休んだ時間を削除（オプション）
  Future<int> deleteBreak(int id) async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
