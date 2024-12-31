import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Rogic extends ChangeNotifier{
    late List<bool> classColunt = [];
    late List<bool> reportColunt = [];
    late List<DateTime?> dateClassColunt = [];
    late List<DateTime?> dateReportColunt = [];



    void sevedNumber(int number,int report){
      classColunt = List.filled(number, false);
      reportColunt = List.filled(report, false);
      dateClassColunt = List.filled(number,null);
      dateReportColunt = List.filled(report, null);

      
      notifyListeners();
    }


    void selectNumber(int index,DateTime date){
      if(classColunt[index] == true ){
        classColunt[index] = false;
        dateClassColunt[index] = null;

        notifyListeners();
      }else{
       classColunt[index] = true;
       dateClassColunt[index] = date;
       notifyListeners();
      }
      print(classColunt);
    }
    

    void selectReport(int index,DateTime date){
      if(reportColunt[index] == true){
        reportColunt[index] = false;
        dateReportColunt[index] = null;
        notifyListeners();
      }else{
        reportColunt[index] = true;
        dateReportColunt[index] = date;
        notifyListeners();
      }
      print("reportColunt is :$reportColunt");
    }

     selectDate(int index){
      if(dateClassColunt[index] != null){
        String formattedDate = DateFormat('yyyy/MM/dd').format(dateClassColunt[index]!);
        return formattedDate;
      }else{
        return "null";
      }
      
    }
    selectDate2(int index){
      if(dateReportColunt[index] != null){
        String formattedDate = DateFormat("yyyy/MM/dd").format(dateReportColunt[index]!);
        return formattedDate;
      }else{
        return "null";
      }
    }

    
}