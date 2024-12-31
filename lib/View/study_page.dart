import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sora/Repo/sora_database.dart';
import 'package:sora/View/delete_log.dart';
import 'package:sora/View/subject_select.dart';

class StudyPage extends StatefulWidget{
  @override
  _StudyPage createState() => _StudyPage();
}

class _StudyPage extends State<StudyPage>{
  List<Map<String,dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    getData();
    print(items);
  }

  void getData()async{
    SoraDatabase soraDatabase = await SoraDatabase(); 
    var newData = await soraDatabase.getAllSubjects();


    setState(() {
      items = newData;
    });
    
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Subject"),
        backgroundColor: Colors.blue,
      ),

      body:  items.isNotEmpty?ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          String classS = item["Cbools"];
          String reportS = item["Rbools"];

          List<bool> classB = classS.split(',').map((e) => e == '1').toList();
          List<bool> reportB = reportS.split(',').map((e) => e == '1').toList();
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
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: SizedBox(
                height: 60,
                width: 60,
                child: Lottie.asset("assets/flutter_icon.json", repeat: true),
              ),
              title:classB.every((e) => e == true) && reportB.every((e) => e == true)?
              
               Row(
                children: [
                  Text(
                "${item["subject"]!}:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              AnimatedTextKit(animatedTexts:[
                WavyAnimatedText(" 完了！",textStyle: TextStyle(fontFamily: "mincho",fontSize: 20,color: Colors.red))
              ])
                ],
              ):
              Text(
                item["subject"]!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              subtitle: Text(
                "${item["class"]}コマ:${item["report"]}枚",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurpleAccent,
              ),
              onTap: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubjectSelect(subject: item["subject"], classCount: item["class"], reports: item["report"],id: item["id"],)));
              },
              onLongPress: () {

               ShowlogD showlogD = ShowlogD();

               showlogD.openDeleteDialog(context: context, id: item["id"],a: StudyPage());
               
              },
            ),
          );
        },
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/not.json"),
            SizedBox(height: 10,),
            Text("データがありません",style: TextStyle(fontFamily: "mincho",fontSize: 30),)
          ],
        ),
      )
    );
  }

}