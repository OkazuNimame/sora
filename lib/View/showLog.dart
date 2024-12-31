
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sora/Model/rogic.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/View/error.dart';
import 'package:sora/View/subject_select.dart';
import 'package:sora/View/subject_timelimit.dart';
import 'package:sora/main.dart';
import 'package:sora/View/analysis.dart';

class Showlog {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController classCountController = TextEditingController(); // 数字入力用のコントローラ
  final TextEditingController reportCountController = TextEditingController(); // 数字入力用のコントローラ
  final TextEditingController timelimitController = TextEditingController();

  void openDialog({
    required BuildContext context,
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
            child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    '投稿',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: "mincho",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "科目を登録",
                  style: TextStyle(
                    fontFamily: "mincho",
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: subjectController,
                    decoration: InputDecoration(
                      labelText: '科目名',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: classCountController,
                    keyboardType: TextInputType.number, // 数字キーボード
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 数字のみ入力可
                    decoration: InputDecoration(
                      labelText: '授業数',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: reportCountController,
                    keyboardType: TextInputType.number, // 数字キーボード
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 数字のみ入力可
                    decoration: InputDecoration(
                      labelText: 'レポート数',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: timelimitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: "上限の休暇時間",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),),
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
                      onPressed: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          'いいえ',
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
                        String subjectName = subjectController.text;
                        int classCount = int.tryParse(classCountController.text) ?? 0;
                        int reportCount = int.tryParse(reportCountController.text) ?? 0;
                        int timelimit = int.tryParse(timelimitController.text)?? 0;
                        Rogic rogic = Rogic();
                        rogic.sevedNumber(classCount, reportCount);
                        if(subjectName.isNotEmpty && classCount > 0 && reportCount > 0){
                          SoraDatabase soraDatabase = await SoraDatabase();
                          String s = soraDatabase.chengCode2(rogic.classColunt);
                          String r = soraDatabase.chengCode(rogic.reportColunt);
                          String dateC = soraDatabase.dateTimeListToString(rogic.dateClassColunt);
                          String dateR = soraDatabase.dateTimeListToStringR(rogic.dateReportColunt);
                          Map<String,dynamic> data = {
                            soraDatabase.columnSubject:subjectName,
                            soraDatabase.columnClass:classCount,
                            soraDatabase.columnReport:reportCount,
                            soraDatabase.columnBools:s,
                            soraDatabase.columnBools2:r,
                            soraDatabase.columnDateC:dateC,
                            soraDatabase.columnDateR:dateR,
                            soraDatabase.columnSubjects_timelimit:timelimit,
                          };
                          await soraDatabase.insertSubject(data);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora")), // 最初の画面
                                (Route<dynamic> route) => false, // すべてのルートを削除
                          );

                        }else{
                         CustomErrorDialog.showErrorDialog(context: context);
                        }
                         
                      },
                      
                  
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        child: Text(
                          'はい',
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
            )
          ),
        );
      },
    );
  }
}



