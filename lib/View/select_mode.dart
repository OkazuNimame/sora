import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sora/View/break_showlog.dart';
import 'package:sora/View/showLog.dart';
import 'package:sora/main.dart';

class SelectView extends StatefulWidget {
  @override
  _SelectViewState createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Select"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Sora",)));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Showlog showlog = Showlog();
                          showlog.openDialog(context: context);
                        },
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/class.json"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "授業登録↑",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "mincho"),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BreakShowlog()));
                         
                        },
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/game.json"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "休憩時間を登録↑",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "mincho"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
