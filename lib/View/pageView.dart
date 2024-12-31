import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sora/View/analysis.dart';
import 'package:sora/View/fl_chart.dart';
import 'package:sora/View/study_page.dart';

class Pageviews extends StatefulWidget {
  @override
  _PageView createState() => _PageView();
}

class _PageView extends State<Pageviews> {
  final List<dynamic> animatedTextKit = [
    AnimatedTextKit(animatedTexts: [
      WavyAnimatedText("お勉強！", textStyle: TextStyle(fontSize: 50, fontFamily: "mincho")),
    ]),
    AnimatedTextKit(animatedTexts: [
      
      WavyAnimatedText("分析！", textStyle: TextStyle(fontSize: 50, fontFamily: "mincho")),
    ]),
    TextLiquidFill(
      text: "休憩！",
      textStyle: TextStyle(fontSize: 50, fontFamily: "regler"),
      waveColor: Colors.blueAccent,
      boxBackgroundColor: Colors.white,
    ),
  ];

  final List<String> lottieAnimations = [
    'assets/aaa.json',
    'assets/bbb.json',
    'assets/ccc.json',
  ];

  final List<Color> backgroundColors = [
    Colors.lightBlue.shade100,
    Colors.lightGreen.shade100,
    Colors.pink.shade100,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Expanded(
          
          child: FractionallySizedBox(
            
            widthFactor: 1.0,
            child: PageView.builder(
              itemCount: animatedTextKit.length,
              itemBuilder: (context, index) {
                return Container(
                  color: backgroundColors[index], // 背景色を設定
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      animatedTextKit[index],
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          print(index);
                          if(index == 0){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => StudyPage()));
                          }else if(index == 1){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Analysis()));
                          }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LineChartSample2()));
                          }
                        },
                        child: Lottie.asset(
                        lottieAnimations[index],
                        width: 200,
                        height: 200,
                        repeat: true,
                      ),
                      )
                     
                    ],
                  ),
                );
              },
              controller: PageController(viewportFraction: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}
