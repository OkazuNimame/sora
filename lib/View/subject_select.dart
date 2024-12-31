import 'package:flutter/material.dart';
import 'package:sora/View/grid.dart';

class SubjectSelect extends StatefulWidget{
  late String subject;
  late int classCount;
  late int reports;
  late int id;

  SubjectSelect({required this.subject,required this.classCount,required this.reports,required this.id});
  @override
  _Subject createState() => _Subject();
}

class _Subject extends State<SubjectSelect>{
  @override
  Widget build(BuildContext context) {
    Grid grid = Grid(classCount: widget.classCount, report: widget.reports,id: widget.id,);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subject}"),
        backgroundColor: Colors.blue,
      ),

      body:Center(
        child: grid,
      )
    );
  }

}