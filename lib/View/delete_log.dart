import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sora/Repo/RestTimeDatabase.dart';
import 'package:sora/Repo/break_database.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/View/error.dart';
import 'package:sora/View/fl_chart.dart';
import 'package:sora/View/study_page.dart';
import 'package:sora/View/subject_timelimit.dart';
import 'package:sora/main.dart';

class ShowlogD {
  void openDeleteDialog({
    required BuildContext context,
    required int id, // 削除するアイテムのIDを渡す
    required dynamic a
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '削除確認',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "mincho",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "本当に削除してもよろしいですか？",
                  style: TextStyle(
                    fontFamily: "mincho",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pop(context), // キャンセルボタン
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          'キャンセル',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        // 削除処理を実行
                        SoraDatabase soraDatabase = await SoraDatabase();
                        await soraDatabase.deleteSubject(id); // IDで削除
                        Navigator.pop(context); // ダイアログを閉じる
                        // 削除後の画面遷移（例えば、一覧画面やトップページなど）
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => a),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }


  
  Future<void> delete_log(BuildContext context,int subjectId,int id,SubjectTimelimit a)async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '削除確認',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "mincho",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "本当に削除してもよろしいですか？",
                  style: TextStyle(
                    fontFamily: "mincho",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pop(context), // キャンセルボタン
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          'キャンセル',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                       await SubjectDatabase.deleteTime(subjectId, id);
                        Navigator.pop(context); // ダイアログを閉じる
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => a));
                      //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => a));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

   void delete(BuildContext context,int id){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '削除確認',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "mincho",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "本当に削除してもよろしいですか？",
                  style: TextStyle(
                    fontFamily: "mincho",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => Navigator.pop(context), // キャンセルボタン
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          'キャンセル',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 5,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                       final BreakDatabase database = await BreakDatabase();

                       await database.deleteBreak(id);
                        Navigator.pop(context); // ダイアログを閉じる
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LineChartSample2()));
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
