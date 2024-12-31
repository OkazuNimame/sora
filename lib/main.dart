
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sora/Model/rogic.dart';

import 'package:sora/View/select_mode.dart';
import 'package:sora/View/start.dart';
import 'package:sora/ViewModel/bools.dart';
import 'View/pageView.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Bools()),
        ChangeNotifierProvider(create: (_) => Rogic()),
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home:  Start(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
Pageviews pageView = Pageviews();
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectView()));
      },child: Lottie.asset("assets/add.json")),
      appBar: AppBar(
        
       backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.blue,
        child: pageView,
      ),
    );
  }
}
