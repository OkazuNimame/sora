import 'package:flutter/material.dart';
import 'package:sora/Model/rogic.dart';

class Bools extends ChangeNotifier{
  Rogic rogic = Rogic();
  void selectNumber(int index){
      if(rogic.classColunt[index] == true){
        rogic.classColunt[index] = false;
        notifyListeners();
      }else{
       rogic.classColunt[index] = true;
       notifyListeners();
      }
      print(rogic.classColunt);
    }

    void selectReport(int index){
      if(rogic.reportColunt[index] == true){
        rogic.reportColunt[index] = false;
        notifyListeners();
      }else{
        rogic.reportColunt[index] = true;
        notifyListeners();
      }
      print(rogic.reportColunt);
    }
}