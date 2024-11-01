import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices{

  //Create
Future<void> addNote(Map<String,dynamic> todoList,String id) async{
    return await FirebaseFirestore.instance.collection('todos').doc(id).set(todoList);
  }

 
  //UPDATE
  Future<void> updateTask(String id,Map<String,dynamic> UpdateInfo) async{
    return await FirebaseFirestore.instance.collection('todos').doc(id).update(UpdateInfo);
  }


  //DELETE
  Future<void> deleteTask(String id) async{
    return await FirebaseFirestore.instance.collection('todos').doc(id).delete();
  }

}