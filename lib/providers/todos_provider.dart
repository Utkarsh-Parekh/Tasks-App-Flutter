
import 'package:flutter/material.dart';

class TodosProvider extends ChangeNotifier{

   bool isButtonActivated = false;
   bool isTextPresent = false;

   bool isUpdateButtonActivated = false;
   bool isUpdateTextPresent = false;

  void checkTextPresent(String text){
    if(!text.isEmpty){
      isTextPresent = true;
      isButtonActivated =true;
      notifyListeners();
    }
    else{
      isTextPresent = false;
      isButtonActivated =false;
      notifyListeners();
    }
  }

  void checkUpdatinTextPresent(String updatedText){
    if(!updatedText.isEmpty){
      isUpdateTextPresent = true;
      isUpdateButtonActivated =true;
      notifyListeners();
    }
    else{
      isUpdateTextPresent = false;
      isUpdateButtonActivated =false;
      notifyListeners();
    }
  }



  

}