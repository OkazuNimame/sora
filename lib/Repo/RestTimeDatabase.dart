import 'package:intl/intl.dart';
import 'package:sora/Model/RestTime.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SubjectDatabase {
  static Future<Database> openDatabaseForSubject(int subjectId) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'subject_$subjectId.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE rest_times (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            minutes INTEGER NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> addRestTime(int subjectId, int minutes,DateTime date) async {
    final db = await openDatabaseForSubject(subjectId);
    String dates = DateFormat("yyyy/MM/dd").format(date);
    return await db.insert('rest_times', {
      'minutes': minutes,
      'timestamp': dates,
    });
  }
  static Future<int>  allTime(int subjectId)async{
    final db = await openDatabaseForSubject(subjectId);
    List<Map<String,dynamic>> alltimeData = await db.rawQuery('SELECT SUM(minutes) AS total_time FROM rest_times');
    // 結果が存在するか確認し、合計時間を返す
    if (alltimeData.isNotEmpty && alltimeData[0]['total_time'] != null) {
      return alltimeData[0]['total_time'] as int;
    }
    
    return 0; // 合計時間がない場合は0を返す
  }

  static Future<int> deleteTime(int subjectId,int id)async{
    final db = await openDatabaseForSubject(subjectId);

   return db.delete(
    "rest_times",
    where: "id = ?",
    whereArgs: [id],
    
   );
  }
  

  static Future<List<Map<String, dynamic>>> getRestTimes(int subjectId) async {
    final db = await openDatabaseForSubject(subjectId);
    return await db.query('rest_times');
  }

}