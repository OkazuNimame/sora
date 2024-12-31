import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sora/Repo/break_database.dart';
import 'package:sora/View/delete_log.dart';
import 'package:sora/main.dart';

class LineChartSample2 extends StatefulWidget {
  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<FlSpot> dataPoints = [];
  List<String> xLabels = [];
  List<BarChartGroupData> barGroups = [];
  List<int> id = [];
  
  FlSpot? selectedSpot; // 選択されたスポットを保存する変数

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    final BreakDatabase database = await BreakDatabase();
    final List<Map<String, dynamic>> results = await database.getAllBreaks();
     Timer? longPressTimer;
     bool isLongPressing = false;
     double chartWidth = 1.0;
     // グラフ全体の幅を計
        if(results.isNotEmpty){
          List<FlSpot> spots = [];
    List<String> labels = [];
    List<BarChartGroupData> newBarGroup = [];
    List<int> newid = [];
    for (int i = 0; i < results.length; i++) {
      double time = results[i]["hours"]?.toDouble() ?? 0;
      String date = results[i]['date'] ?? '';
      newid.add(results[i]["id"]);
      spots.add(FlSpot(i.toDouble(), time));
      newBarGroup.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: time,color: Colors.blue[800],width: 50,borderRadius: BorderRadius.zero,),
          
          ],
          
        )
      );
      labels.add(date);
    }

    setState(() {
      dataPoints = spots;
      xLabels = labels;
      barGroups = newBarGroup;
      id = newid;
    });
        }
    
  }

  Timer? longPressTimer;
     bool isLongPressing = false;

       void _startLongPressTimer(int index) {
    isLongPressing = true;
    longPressTimer = Timer(Duration(milliseconds: 800), () {
      if (isLongPressing) {
        _showDeleteDialog(id[index]);
      }
    });
  }

  void _cancelLongPressTimer() {
    isLongPressing = false;
    longPressTimer?.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212), // 背景を暗い色に
        primaryColor: Colors.blueGrey[900],
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[500], // AppBarの背景色
        ),
        textTheme: TextTheme(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey[400]),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Line Chart'), leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora",)));
        }, icon: Icon(Icons.arrow_back)),),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showSimpleDialog(context);
          setState(() {
            
          });
        },child: Icon(Icons.delete),),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: dataPoints.isNotEmpty ? dataPoints.length * 60 : 300,
              height: 450,
              child: GestureDetector(
                onTap: () {
                  // タップしたスポットに対して処理
                  if (selectedSpot != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('日付: ${xLabels[selectedSpot!.x.toInt()]}')),
                    );
                  }
                },
                child: LineChart(
                  LineChartData(
                    
                    minX: 0,
                    maxX: dataPoints.isNotEmpty ? dataPoints.length.toDouble() - 1 : 1,
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: AxisTitles(),
                      topTitles: AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < 0 || index >= xLabels.length) return Container();
                            return Text(
                              xLabels[index],
                              style: TextStyle(fontSize: 10, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataPoints,
                        isCurved: true,
                        color: Colors.lightBlueAccent,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true, // 内部のタッチ処理を無効化
                      touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                        if (response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          setState(() {
                            selectedSpot = response.lineBarSpots!.first;
                          });
                        } else if (event is FlPanEndEvent || event is FlLongPressEnd) {
                          setState(() {
                            selectedSpot = null; // タッチ解除で非表示にする
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    ShowlogD showlogD = ShowlogD();
    if (xLabels.isNotEmpty) {
      showlogD.delete(context, index);
    }
  }

  void _showSimpleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('削除ダイアログ',style: TextStyle(fontFamily: "mincho"),),
        content: Text('削除されたら自動的に更新されます',style: TextStyle(fontFamily: "mincho"),),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Container(
            height: 400,
            width: barGroups.isNotEmpty? barGroups.length  * 100:1 
            ,child:GestureDetector(
             
              child: BarChart(
              
              BarChartData(
                
                groupsSpace: 30,
                alignment: BarChartAlignment.start, // バー間隔を一定に設定
                barGroups: barGroups,
                
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(),style: TextStyle(fontSize: 12),);
                      },
                    )
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();

                        if(index < 0 || index >= xLabels.length)return Container();

                          return Text(
                            xLabels[index],style: TextStyle(fontSize: 12),
                          );
                        
                      },
                    )
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                )
                ,barTouchData: BarTouchData(
                  touchCallback: (p0, p1) {
                     if (p1 != null &&
                    p1.spot != null &&
                    p0 is FlLongPressStart) {
                  final index = p1.spot!.touchedBarGroupIndex;
                  print("タッチされた場所$index：データベースのid${id[index]}");
                  _startLongPressTimer(index);
                } else if (p0 is FlLongPressEnd) {
                  _cancelLongPressTimer();
                }
                  },
                  
                )
                ,
              ),
              
            ),
            )
             
             ),
              )
           
            ],
          ),
         

             
        ],
      );
    },
  );
}

}