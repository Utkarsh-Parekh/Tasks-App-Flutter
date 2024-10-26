import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firestore_services.dart';
import 'package:random_string/random_string.dart';

final FirestoreServices firestoreServices = FirestoreServices();
  TextEditingController controller = TextEditingController();
  TextEditingController priorityController = TextEditingController();


class CustomDialogBox{

  
 void  customToast(String text,Color backgroundColor,BuildContext context){
    final snackbar = SnackBar(
      content:  Row(
        children: [
          const Icon(Icons.done,color: Colors.white,),
          const SizedBox(width: 10,),
          Text(text,style: const TextStyle(fontSize: 18),)
        ]
        ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(50),
      elevation: 30,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

void openAddDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Add Tasks",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Task',
                  hintText: "Enter the Tasks"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: priorityController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Priority',
                  hintText: "Select the Priority"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                //Here todos : Collection name of Firebase,"notedata" : Doc name of collections
                String randomId = randomAlphaNumeric(5);
                Map<String, dynamic> todoentry = {
                  'task': controller.text,
                  'priority': priorityController.text,
                  'id': randomId
                };

               await FirestoreServices().addNote(todoentry, randomId).then(
                  (value) {
                    customToast("Task Added Succesfully",Colors.purple,context);
                  },
                );

                // clear the textcontroller
                controller.clear();
                priorityController.clear();

                //close the dialogBox
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
      ),
    );
  }
}

