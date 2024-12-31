import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sora/Repo/break_database.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/View/delete_log.dart';
import 'package:sora/View/showLog.dart';
import 'package:sora/View/subject_timelimit.dart';
import 'package:sqflite/sqflite.dart';

class Analysis extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Analysis();
  }
}

class _Analysis extends State<Analysis> {
 @override
  void initState() {
    super.initState();
    _loadValue();
    getData();
  }



  SnackBar snack =  SnackBar(
          content: Text(
            "設定時間を超えているよ！",
            style: TextStyle(fontFamily: "mincho"),
          ),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // メッセージが少し浮いた位置に表示される
        );
  int count = 0;
  Map<String, int> total_break = {};
  List<Map<String,dynamic>> data = [];
  int? _touchedIndex;
  int totalClassCount = 0;
  int totalBreakTime = 0;
  bool _snackBarShown = false;

  List<PieChartSectionData> createPieChartSections(Map<String, int> data) {
    if (data.isEmpty) {
      return [];
    }

    final total = data.values.reduce((a, b) => a + b);
    return data.entries.map((entry) {
      final percentage = entry.value / total * 100;
      return PieChartSectionData(
        color: Colors.primaries[data.keys.toList().indexOf(entry.key) %
            Colors.primaries.length],
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

int? storedValue;

  getData() async {
    SoraDatabase database = await SoraDatabase();
    BreakDatabase breakDatabase = await BreakDatabase();
    int newCount = await database.getRowCount();
    int newTotalCount = await database.getKomaCount();
    int newTotalBreak = await breakDatabase.sumBreakHours();
    Map<String, int> newTotal = await breakDatabase.getBreakTimesByDate();
    List<Map<String ,dynamic>> newData = await database.getAllSubjects();

    setState(() {
      count = newCount;
      total_break = newTotal;
      totalClassCount = newTotalCount;
      totalBreakTime = newTotalBreak;
      data = newData;
    });
    await _loadValue();

     if (storedValue != null &&
      storedValue! < totalBreakTime &&
      storedValue != 0) {
       // ウィジェットのフレーム描画後にスナックバーを表示
    WidgetsBinding.instance.addPostFrameCallback((_) {
       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('設定時間を超えています')),
                        );
    });
                        
    
  }
    print(count);
    print(total_break);
  }

  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      storedValue = prefs.getInt('savedInteger'); // "savedInteger"キーの値を取得
    });
    print(prefs.getInt("savedInteger"));
  }


  // 新しい値を保存または更新するメソッド
  Future<void> _saveValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('savedInteger', value); // "savedInteger"キーに値を保存
    setState(() {
      storedValue = value; // UIを更新
    });
  }

  // 保存された値を削除するメソッド
  Future<void> _deleteValue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedInteger'); // "savedInteger"キーを削除
    setState(() {
      storedValue = 0; // UIを更新
    });
  }
final TextEditingController controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final sections = createPieChartSections(total_break);

    return Scaffold(
      
      floatingActionButton: FloatingActionButton(onPressed: (){
showDialog(
  context: context,
   builder:(BuildContext context){
    return  AlertDialog(
          title: Text('整数を入力してください',style: TextStyle(fontFamily: "mincho"),),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '例: 42'),
          ),
actions: [
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // ボタン間にスペースを確保
    children: [
      // キャンセルボタン
     Expanded(child:  ElevatedButton(
        onPressed: () => Navigator.of(context).pop(), // キャンセルで閉じる
        child: Text('取り消し', style: TextStyle(fontSize: 13)),
      ),),
      // 削除ボタン
      ElevatedButton(
        onPressed: () {
          _deleteValue();
          controller.clear();
          Navigator.of(context).pop();
        },
        child: Text("削除"),
      ),
      // 保存ボタン
      Expanded(child: ElevatedButton(
        onPressed: () {
          final value = int.tryParse(controller.text); // 整数に変換
          if (value != null) {
            setState(() {
              storedValue = value;
            });
            if (storedValue == 0 || storedValue! > 0) {
              _saveValue(storedValue!);
            }
            Navigator.of(context).pop(value); // 入力値を返す
          }
        },
        child: Text('保存'),
      ),)
    ],
  ),
],
        );
   } );

      },child: Lottie.asset("assets/add.json"),),
      appBar: AppBar(
        title: Text(
          "分析   $totalBreakTime/$storedValue時間",
          style: TextStyle(fontFamily: "mincho"),
        ),
        backgroundColor: Colors.blue,
      ),
      body:SingleChildScrollView(
        child:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            data.isNotEmpty?ListView.builder(
               shrinkWrap: true, // 必要な高さだけを使う
                  physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context,index){
                final item = data[index];

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      )
                    ]
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: Icon(Icons.timeline),
                    ),
                    title: Text("${item["subject"]}",style: TextStyle(fontFamily: "mincho",fontSize: 20),),
                    subtitle: Text("${item["class"]}コマ:${item["report"]}枚",style: TextStyle(fontSize: 16,color: Colors.grey[700])),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurpleAccent,),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectTimelimit(timilit: item["timelimit"],id: item["id"],)));
                    },
                    onLongPress: (){
                      ShowlogD showlogD = ShowlogD();

                      showlogD.openDeleteDialog(context: context, id: item["id"], a: Analysis());
                    },
                  ),
                
                );
                
            }):Center(child: Text("教科が登録されていません",style: TextStyle(fontFamily: "mincho",fontSize: 25),),),
            SizedBox(
              height: 300,
              child: total_break.isNotEmpty
                  ? PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(
                          touchCallback: (p0, p1) {
                            setState(() {
                              if (p0.isInterestedForInteractions &&
                                  p1?.touchedSection != null) {
                                final index =
                                    p1!.touchedSection!.touchedSectionIndex;
                                if (index >= 0 && index < total_break.length) {
                                  _touchedIndex = index;
                                } else {
                                  _touchedIndex = null;
                                }
                              } else {
                                _touchedIndex = null;
                              }
                            });
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline,
                              size: 100, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          Text(
                            "円チャートのデータがありません",
                            style: TextStyle(
                              fontFamily: "mincho",
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            if (_touchedIndex != null &&
                _touchedIndex! >= 0 &&
                _touchedIndex! < total_break.length)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${total_break.keys.toList()[_touchedIndex!]}: '
                  '${total_break.values.toList()[_touchedIndex!]} 時間',
                  style: TextStyle(
                    fontFamily: "mincho",
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
          ],
        ),
      ),
      )
      
      
    );
  }

 
}

