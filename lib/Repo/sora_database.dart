import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SoraDatabase {
  static final SoraDatabase _instance = SoraDatabase._internal();
  factory SoraDatabase() =>  _instance;

  static Database? _database;

  SoraDatabase._internal();

  final String table = "sora";
  final String columnId = "id";
  final String columnSubject = "subject";
  final String columnClass = "class";
  final String columnReport = "report";
  final String columnBools = "Cbools";
  final String columnBools2 = "Rbools";
  final String columnDateC = "DateC";
  final String columnDateR = "DateR";
  final String columnSubjects_timelimit = "timelimit";

  Future<Database> get database async{
    if(_database != null) return _database!;
     _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =  join(documentsDirectory.path, 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY ,
        $columnSubject TEXT NOT NULL,
        $columnClass INTEGER NOT NULL,
        $columnReport INTEGER NOT NULL,
        $columnBools TEXT,
        $columnBools2 TEXT,
        $columnDateC TEXT,
        $columnDateR TEXT,
        $columnSubjects_timelimit INTEGER NOT NULL
      )
    ''');
  }

Future<int> insertSubject(Map<String, dynamic> subject) async {
  final db = await database;
  try {
    return await db.insert(table, subject);
  } catch (e) {
    print("Insert failed: $e");
    rethrow;
  }
}

 chengCode(List<bool> ReportStates){
  
   String statesString = ReportStates.map((e) => e ? '1' : '0').join(',');

   return statesString;
}
String dateTimeListToString(List<DateTime?> list) {
  String dateCString = list.map((e) => e == null ? "null":"0").join(',');
  print(dateCString);
  return dateCString;
}
String dateTimeListToStringR(List<DateTime?> list){
  String dateRString = list.map((e) => e == null ? "null":"0").join(',');
  print(dateRString);
  return dateRString;
}

chengCode2(List<bool> classStates){
  String stateString = classStates.map((e) => e ? "1":"0").join(",");

  return stateString;
}


   Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final db = await database;
    List<Map<String,dynamic>> data = await db.query(table);
    print(data);
    return await db.query(table);
  }
  Future<int> updateSubject(int id, Map<String, dynamic> subject) async {
    final db = await database;
    return await db.update(
      table,
      subject,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
Future<void> saveClassState(List<bool> classStates,List<DateTime?> dateC, int id) async {
  final db = await database;
  
  // リストの状態を文字列に変換
  String statesString = classStates.map((e) => e ? '1' : '0').join(',');
  String date = dateC.map((e) {
  if (e == null) {
    return "null";
  } else {
    return DateFormat('yyyy/MM/dd').format(e); // '2024-12-06' のようにフォーマット
  }
}).join(",");

  print("保存されたデータは：" + date);
  try {
    // 指定された ID のレコードを更新
    await db.update(
      table,  // テーブル名
      {'id': id, 'Cbools': statesString,'$columnDateC':date},  // 更新するデータ
      where: 'id = ?',  // 指定された ID に基づいて更新
      whereArgs: [id],  // where 引数として id を渡す
      conflictAlgorithm: ConflictAlgorithm.replace,  // 衝突時の処理方法
    );
    print('State updated for id: $id');
  } catch (e) {
    print("Error saving state: $e");
    throw Exception("Failed to save state");
  }
}

Future<void> saveReportState(List<bool> ReportStates,List<DateTime?> dateR, int id) async {
  final db = await database;
  
  // リストの状態を文字列に変換
  String statesString = ReportStates.map((e) => e ? '1' : '0').join(',');
  String date = dateR.map((e) {
  if (e == null) {
    return "null";
  } else {
    return DateFormat('yyyy/MM/dd').format(e); // '2024-12-06' のようにフォーマット
  }
}).join(",");

  print("保存されたデータは：" + date);

  try {
    // 指定された ID のレコードを更新
    await db.update(
      table,  // テーブル名
      {'id': id, 'Rbools': statesString,'$columnDateR':date},  // 更新するデータ
      where: 'id = ?',  // 指定された ID に基づいて更新
      whereArgs: [id],  // where 引数として id を渡す  // 衝突時の処理方法
    );
    print('State updated for id: $id');
  } catch (e) {
    print("Error saving state: $e");
    throw Exception("Failed to save state");
  }
}
 Future<void> deleteColumnData(int id, int time) async {
    final db = await database;

    // 指定した列のデータをNULLに設定
    await db.update(
      "$table",  // テーブル名
      {"timelimit": time},  // 更新する列と値
      where: 'id = ?',  // 削除対象のID
      whereArgs: [id],  // 削除対象のIDを指定
    );
  }

Future<int> getRowCount() async {
  final db = await database;
  final result = await db.rawQuery('SELECT COUNT(*) AS count FROM $table');
  return Sqflite.firstIntValue(result) ?? 0;
}

Future<int> getKomaCount()async{
  final db = await database;
  final result = await db.rawQuery("SELECT SUM($columnClass) as total FROM $table");

  if(result.isNotEmpty && result.first["total"] != null){
    return result.first["total"] as int;
  }
  return 0;
}


  Future<List<bool>> getClassStates(int not,int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      String statesString = result.first[columnBools] as String;
      return statesString.split(',').map((e) => e == '1').toList();
    } else {
      List<bool> notData = List.filled(not, false);
      return notData;
    }
  }
Future<List<DateTime?>> getClassDate(int id) async {
  final db = await database;
  final result = await db.query(table, where: "id = ?", whereArgs: [id]);

  if (result.isNotEmpty) {
    // データベースから取得した日付データを確認
    String date = result.first[columnDateC] as String;
    print("データベースから取得した値: $date");

    // 不要な末尾のカンマを削除
    String cheng = date.replaceAll(RegExp(r',$'), '');
    List<String> c = cheng.split(",");
    print("分割後のリスト: $c");

    // 日付文字列を DateTime? に変換
    List<DateTime?> dateTimes = c.map((dateString) {
      try {
        if (dateString == "null" || dateString.trim().isEmpty) {
          return null; // "null" を DateTime 型の null に変換
        } else {
          return DateFormat('yyyy/MM/dd').parse(dateString); // 有効な文字列を DateTime に変換
        }
      } catch (e) {
        print("日付変換エラー: $e");
        return null; // エラーが発生した場合も null にする
      }
    }).toList();

    print("変換後の日付リスト: $dateTimes");
    return dateTimes;
  }

  // 結果が空の場合は空のリストを返す
  return [];
}

   Future<List<DateTime?>> getReportDate(int id) async {
  final db = await database;
  final result = await db.query(table, where: "id = ?", whereArgs: [id]);

  if (result.isNotEmpty) {
    // データベースから取得した日付データを確認
    String date = result.first[columnDateR] as String;
    print("データベースから取得した値: $date");

    // 不要な末尾のカンマを削除
    String cheng = date.replaceAll(RegExp(r',$'), '');
    List<String> c = cheng.split(",");
    print("分割後のリスト: $c");

    // 日付文字列を DateTime? に変換
    List<DateTime?> dateTimes = c.map((dateString) {
      try {
        if (dateString == "null" || dateString.trim().isEmpty) {
          return null; // "null" を DateTime 型の null に変換
        } else {
          return DateFormat('yyyy/MM/dd').parse(dateString); // 有効な文字列を DateTime に変換
        }
      } catch (e) {
        print("日付変換エラー: $e");
        return null; // エラーが発生した場合も null にする
      }
    }).toList();

    print("変換後の日付リスト: $dateTimes");
    return dateTimes;
  }

  // 結果が空の場合は空のリストを返す
  return [];
}
  


  Future<List<bool>> getReportStates(int not,int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      String statesString = result.first[columnBools2] as String;
      return statesString.split(',').map((e) => e == '1').toList();
    } else {
      List<bool> notData = List.filled(not, false);
      return notData;
    }
  }

  // データの削除
  Future<int> deleteSubject(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
  Future<Map<String, dynamic>?> getSubjectById(int id) async {
  final db = await database;
  final result = await db.query(
    table,
    where: '$columnId = ?',
    whereArgs: [id],
  );

  // 結果が存在する場合は最初の行を返し、存在しない場合はnullを返す
  if (result.isNotEmpty) {
    return result.first;
  } else {
    return null;
  }
}

}