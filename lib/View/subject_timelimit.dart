import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sora/Repo/RestTimeDatabase.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/View/analysis.dart';
import 'package:sora/View/delete_log.dart';
import 'package:sora/View/error.dart';

class SubjectTimelimit extends StatefulWidget {
  final int timilit;
  final int id;

SubjectTimelimit({required this.timilit,required this.id});

  @override
  State<SubjectTimelimit> createState() => _SubjectTimelimitState();
}

class _SubjectTimelimitState extends State<SubjectTimelimit> {
  List<BarChartGroupData> barGroups = [];
  List<int> ids = [];
  List<String> labels = [];
  int total = 0;
  int remainingPercentage = 0;
  int usedPercentage = 0;
  Timer? longPressTimer;
  bool isLongPressing = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    calculateTotalTime();
  }



  Future<void> calculateTotalTime() async {
    int totalTime = await SubjectDatabase.allTime(widget.id);
    setState(() {
      total = totalTime;
      remainingPercentage = (100 - (total / widget.timilit * 100)).toInt();
      usedPercentage = (total / widget.timilit * 100).toInt();
    });
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> newData = await SubjectDatabase.getRestTimes(widget.id);
    List<String> newLabels = [];
    List<BarChartGroupData> newBarGroups = [];
    List<int> newIds = [];

    for (int i = 0; i < newData.length; i++) {
      int time = newData[i]['minutes'] ?? 0;
      String date = newData[i]['timestamp'] ?? '';

      newIds.add(newData[i]['id']);
      newLabels.add(date);

      newBarGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: time.toDouble(),
              color: Colors.purple,
              width: 24,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    setState(() {
      barGroups = newBarGroups;
      ids = newIds;
      labels = newLabels;
    });
    print(barGroups);
  }

  void _startLongPressTimer(BuildContext context, int index) {
    isLongPressing = true;
    longPressTimer = Timer(const Duration(milliseconds: 800), () {
      if (isLongPressing) {
        _showDeleteDialog(index);
      }
    });
  }

  void _cancelLongPressTimer() {
    isLongPressing = false;
    longPressTimer?.cancel();
  }

  Future<void> _showDeleteDialog(int index) async {
    ShowlogD showlogD = ShowlogD();
    if (labels.isNotEmpty) {
      await showlogD.delete_log(context, widget.id, index, SubjectTimelimit(timilit: widget.timilit, id: widget.id));
      fetchData();
      calculateTotalTime();
    }
  }

  Future<void> _addRestTime() async {
    TextEditingController timeController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("休憩時間"),
        content: SingleChildScrollView(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: '休んだ時間',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
              onDateChanged: (date) => selectedDate = date,
            ),
          ],
        ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("キャンセル"),
          ),
          ElevatedButton(
            onPressed: () async {
              int time = int.tryParse(timeController.text) ?? 0;
              if (time > 0) {
                await SubjectDatabase.addRestTime(widget.id, time, selectedDate);
                fetchData();
                calculateTotalTime();
                Navigator.pop(context);
              } else {
                CustomErrorDialog2.showErrorDialog(context: context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: widget.timilit > total ?remainingPercentage.toDouble():usedPercentage.toDouble(),
              color:widget.timilit > total ? Colors.blue:Colors.red,
              title:widget.timilit > total ? "$remainingPercentage%":widget.timilit == total? "もう時間ないよ！":"もう超えているよ！",
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              value: widget.timilit > total ? usedPercentage.toDouble():0,
              color: Colors.red,
              title: widget.timilit > total ?"$usedPercentage%":"",
              titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 5,
      getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        int index = value.toInt();
        if (index < 0 || index >= labels.length) return const SizedBox();
        return Text(labels[index], style: const TextStyle(fontSize: 12));
      },
    ),
  ),
  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
),
barTouchData: BarTouchData(
  touchCallback: (p0, p1) {
    if(p1 != null && p1.spot != null && p0 is FlLongPressStart){
      final index = p1.spot!.touchedBarGroupIndex;
      print(index);
      _startLongPressTimer(context, ids[index]);
    }else if(p0 is FlLongPressEnd){
      _cancelLongPressTimer();
    }
  },
)
        ),
        
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Subject Time Limit"),
      backgroundColor: Colors.blueAccent,
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addRestTime,
      child: Lottie.asset("assets/add.json", width: 50, height: 50),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPieChart(),
            Text(
              "$total/${widget.timilit}時間",
              style: const TextStyle(fontSize: 27),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  TextEditingController controller = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("最大値変更"),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: '',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("キャンセル"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            int data = int.parse(controller.text);
                            if (data > 0) {
                              SoraDatabase soraDatabase = await SoraDatabase();
                              await soraDatabase.deleteColumnData(widget.id, data);

                              Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectTimelimit(timilit:data, id: widget.id)));
                              
                              
                            } else {
                              CustomErrorDialog2.showErrorDialog(context: context);
                            }
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "最大時間変更",
                  style: TextStyle(fontFamily: "mincho"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400, // 必要に応じて高さを調整
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
    ),
  );
}

}
