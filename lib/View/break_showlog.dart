import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sora/Repo/break_database.dart';
import 'package:sora/View/select_mode.dart';
import 'package:sora/main.dart';
import 'package:flutter/services.dart'; // 追加

class BreakShowlog extends StatefulWidget {
  @override
  _BreakShowlogState createState() => _BreakShowlogState();
}

class _BreakShowlogState extends State<BreakShowlog> {
  final TextEditingController hoursController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "休憩時間を入力",
          style: TextStyle(fontFamily: "mincho"),
        ),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffe4a972).withOpacity(0.6),
                const Color(0xff9941d8).withOpacity(0.6),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 真ん中に配置
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    DateFormat('yyyy/MM/dd').format(selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number, // 数字入力モードに設定
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // 整数のみを許可
                  ],
                  decoration: InputDecoration(
                    labelText: '休んだ時間（整数のみ）',
                    hintText: '例: 2 時間',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => SelectView()));
                      },
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        BreakDatabase breakDatabase = await BreakDatabase();
                        DateTime dateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                        String formattedDate = DateFormat('MM/dd').format(dateTime);
                        int hours = int.parse(hoursController.text);
                        breakDatabase.insertBreak(formattedDate, hours);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora",)));
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: title)))
                      },
                      child: const Text('保存'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class Clear extends StatefulWidget {
  @override
  _Clear createState() => _Clear();
}

class _Clear extends State<BreakShowlog> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "日付を選択",
          style: TextStyle(fontFamily: "mincho"),
        ),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffe4a972).withOpacity(0.6),
                const Color(0xff9941d8).withOpacity(0.6),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 真ん中に配置
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    DateFormat('yyyy/MM/dd').format(selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 日付表示ボタンのみ
                ElevatedButton(
                  onPressed: () {
                    // 選択した日付を処理するためのアクションを追加
                    print("選択された日付: ${DateFormat('yyyy/MM/dd').format(selectedDate)}");
                    
                  },
                  child: const Text('日付を確定'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

