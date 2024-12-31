import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sora/Model/rogic.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/main.dart';

class Grid extends StatefulWidget {
  final int classCount;
  final int report;
  final int id;  // IDを渡す

  Grid({required this.classCount, required this.report, required this.id});

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateR = DateTime.now();
  late Rogic rogic;
  late List<bool> data = []; // 非同期でデータを読み込むためのFuture
  late List<bool> data2 = [];
  bool check = false;
  String dates = "";

  @override
  void initState() {
    super.initState();
    rogic = Rogic();
    loadData();
    print(data);
  }

Future<void> _showCustomDatePicker(BuildContext context,int index) async {
  DateTime tempDate = selectedDate; // 一時的な選択された日付を保持

  bool isCancelled = false; // キャンセル判定用のフラグ

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('日付を選択'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // 高さを制限
              maxWidth: MediaQuery.of(context).size.width * 0.9,  // 幅を制限
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: tempDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                  onDateChanged: (date) {
                    tempDate = date;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              isCancelled = true; // キャンセルフラグを設定
              Navigator.of(context).pop(); // ダイアログを閉じる
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: ()async {
              isCancelled = false; // キャンセルフラグをリセット
              setState(() {
                //rogic.selectNumber(index,selectedDate); // 状態を更新
                selectedDate = tempDate;
                 rogic.selectNumber(index,tempDate); // 状態を更新
              });
              
              Navigator.of(context).pop(selectedDate); // 選択された日付を返す
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  ).then((result) {
    if (isCancelled) {
      // キャンセルボタンが押された場合の処理
      print("キャンセルが押されました");
      return;
    }

    if (result != null) {
      // OKボタンが押され、日付が選択された場合の処理
      setState(() {
        selectedDate = result;
      });
      print("OKが押され、選択された日付: $selectedDate");
    }
  });
}





Future<void> _selectDateR(BuildContext context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDateR,
    firstDate: DateTime(2020),
    lastDate: DateTime(2101),
  );

  // pickedDateがnullの場合は何もしない
  if (pickedDate == null) {
    return; // 何も更新せずに関数を終了
  }

  // pickedDateがnullでなく、選択された日付が変更されていれば更新
  if (pickedDate != selectedDateR) {
    setState(() {
      selectedDateR = pickedDate;
    });
  }

}

Future<void> _showDatePicker(BuildContext context,int index) async {
  DateTime tempDate = selectedDateR; // 一時的な選択された日付を保持

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('日付を選択',style: TextStyle(fontFamily: "mincho"),),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6, // 高さを制限
              maxWidth: MediaQuery.of(context).size.width * 0.9,  // 幅を制限
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: tempDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2101),
                  onDateChanged: (date) {
                    tempDate = date;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // キャンセルボタンのアクション
              print("キャンセルが押されました");
              Navigator.of(context).pop(); // ダイアログを閉じる
            },
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async{
              // OKボタンのアクション
              setState(() {
                selectedDateR = tempDate;
                rogic.selectReport(index,tempDate); // 状態を更新
              });
              print("OKが押され、選択された日付: $selectedDateR");
              Navigator.of(context).pop(); // ダイアログを閉じる
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}




  loadData()async{
    SoraDatabase soraDatabase = await SoraDatabase();

    
       List<bool> classData = await soraDatabase.getClassStates(widget.classCount,widget.id);
    List<bool> reportData = await soraDatabase.getReportStates(widget.report,widget.id);
    List<DateTime?> classDate = await soraDatabase.getClassDate(widget.id);
    List<DateTime?> reportDate = await soraDatabase.getReportDate(widget.id);
    
      setState(() {
        rogic.classColunt = classData;
        rogic.reportColunt = reportData;
        data = classData;
        data2 = reportData;
        rogic.dateClassColunt = classDate;
        rogic.dateReportColunt = reportDate;
        
       
      });
      print(classData);

     print("data is $data");
     print("data2 is $data2");
     print("date is :$classDate");
     print("date is :$reportDate");
  }

  // 戻るボタンが押されたときに状態をデータベースに保存する
 
  @override
  Widget build(BuildContext context) {
    return 
        // 戻るボタンが押されたときに呼び出される
       Scaffold(
        body: data.isNotEmpty && data2.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  
                  _buildClassList(),
                  SizedBox(height: 10),
                  
                  _buildReportList(),
                  SizedBox(height: 30,),
                  Center(
                    child: TextButton(onPressed: ()async{
                      SoraDatabase soraDatabase = await SoraDatabase();
                      print("ロジッククラスのデータ:${rogic.dateReportColunt}");
                      print("ロジッククラス：${rogic.dateClassColunt}");
                      soraDatabase.saveClassState(rogic.classColunt, rogic.dateClassColunt,widget.id);
                      soraDatabase.saveReportState(rogic.reportColunt,rogic.dateReportColunt, widget.id);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora",)));
                    }, child:Text("保存！",style: TextStyle(fontFamily: "mincho",fontSize: 35),),
                    ),
                  )
                ],
              )
            : Center(
                child: Text("not data"),
              ),
      );
  }

  // 授業コマ数のリストを表示する
  Widget _buildClassList() {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100, // 横スクロール時に高さを固定
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 横スクロールに設定
          itemCount: widget.classCount, // クラス数分のアイテムを表示
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()async {
                if(rogic.classColunt[index]){
                   setState(() {
                  if(rogic.dateClassColunt.isNotEmpty){
                    
                     dates = rogic.selectDate(index);
                     rogic.selectNumber(index, selectedDate);
                    print(rogic.dateClassColunt);
                  }
                  
                  // 状態を個別に反映
                  print('Tapped: Index $index, Class State: ${rogic.classColunt[index]}');
                });
                }else{
                   await _showCustomDatePicker(context,index);
                    setState(() {
                     
                  if(rogic.dateClassColunt.isNotEmpty){
                     dates = rogic.selectDate(index);
                    print(rogic.dateClassColunt);
                  }
                  
                  // 状態を個別に反映
                  print('Tapped: Index $index, Class State: ${rogic.classColunt[index]}');
                });
                }
              },
              child: Container(
                width: 100, // 各正方形の幅を指定
                height: 100, // 各正方形の高さを指定（幅と同じ）
                margin: EdgeInsets.symmetric(horizontal: 4.0), // 正方形間のスペース
                color: Colors.blueAccent, // 正方形の色
                child: data[index]
                    ?  Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Lottie.asset("assets/check.json"),
                        ),
                        SizedBox(height: 20,width: 80,child: Text("${rogic.selectDate(index)}"),)
                      ],
                    )
                    : Center(
                        child: Text(
                          '${index + 1}コマ',
                          style: TextStyle(color: Colors.white, fontFamily: "mincho"),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  // レポート数のリストを表示する
  Widget _buildReportList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100, // 横スクロール時に高さを固定
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 横スクロールに設定
          itemCount: widget.report, // レポート数分のアイテムを表示
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async{
              if(rogic.reportColunt[index]){
                   setState(() {
                  if(rogic.dateReportColunt.isNotEmpty){
                    
                     dates = rogic.selectDate2(index);
                     rogic.selectReport(index, selectedDateR);
                    print(rogic.dateClassColunt);
                  }
                  
                  // 状態を個別に反映
                  print('Tapped: Index $index, Class State: ${rogic.reportColunt[index]}');
                });
                }else{
                   print("dateReport is :${rogic.dateReportColunt}");
                   await _showDatePicker(context,index);
                    setState(() {
                  if(rogic.dateReportColunt.isNotEmpty){
                    
                     dates = rogic.selectDate2(index);
                    print("dateReport is :${rogic.dateReportColunt}");
                  }
                  
                  // 状態を個別に反映
                  print('Tapped: Index $index, Class State: ${rogic.reportColunt[index]}');
                });
                }
              },
              child: Container(
                width: 100, // 各正方形の幅を指定
                height: 100, // 各正方形の高さを指定（幅と同じ）
                margin: EdgeInsets.symmetric(horizontal: 4.0), // 正方形間のスペース
                color: Colors.greenAccent, // 正方形の色
                child: data2[index]?
                  Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Lottie.asset("assets/check.json"),
                        ),
                        SizedBox(height: 20,width: 80,child: Text("${rogic.selectDate2(index)}"),)
                      ],
                    )
                    : Center(
                        child: Text(
                          '${index + 1}枚目',
                          style: TextStyle(color: Colors.white, fontFamily: "mincho"),
                        ),
                      ),
                ),
            );
          },
        ),
      ),
    );
  }
}
