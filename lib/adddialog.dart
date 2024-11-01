import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/todos_provider.dart';
import 'package:flutter_firebase/services/firestore_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

final FirestoreServices firestoreServices = FirestoreServices();
  TextEditingController controller = TextEditingController();
  TextEditingController priorityController = TextEditingController();

TextEditingController UpdateTaskcontroller = TextEditingController();
TextEditingController UpdatepriorityController = TextEditingController();


class CustomDialogBox{

  //ADD TASK
 Future<void> openAddDialogBox(BuildContext context) async {
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (context) => Consumer<TodosProvider>(
       builder: (context, provider, child) => AlertDialog(
         title: Text(
           "Add Tasks",
           style: GoogleFonts.poppins(textStyle : const TextStyle(color: Colors.black, fontSize: 20)),
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(
               controller: controller,
               onChanged: (value) {
                 provider.checkTextPresent(value);
               },
               decoration: InputDecoration(
                   suffixIcon: provider.isTextPresent == true
                       ? const Icon(
                     Icons.done,
                     color: Colors.green,
                   )
                       : const Icon(
                     Icons.close_sharp,
                     color: Colors.red,
                   ),
                   border: const OutlineInputBorder(
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
                   labelText: 'Description',
                   hintText: "Add Description Here"),
             ),
             const SizedBox(
               height: 20,
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
                 'id': randomId,
                 'creator': FirebaseAuth.instance.currentUser!.uid
               };

               provider.isButtonActivated
                   ? await FirestoreServices()
                   .addNote(todoentry, randomId)
                   .then((value) {
                 DelightToastBar(
                   autoDismiss: true,
                   snackbarDuration: Durations.extralong3,
                   position: DelightSnackbarPosition.top,
                   builder: (context) {
                     return const ToastCard(
                       color: Colors.green,
                       leading: Icon(
                         Icons.done,
                         color: Colors.white,
                       ),
                       title: Text("Task Added Successfully"),
                     );
                   },
                 ).show(context);
               })
                   : DelightToastBar(
                 autoDismiss: true,
                 snackbarDuration: Durations.extralong3,
                 position: DelightSnackbarPosition.top,
                 builder: (context) {
                   return const ToastCard(
                     color: Colors.red,
                     leading: Icon(
                       Icons.done,
                       color: Colors.white,
                     ),
                     title: Text("Task Field should not be empty"),
                   );
                 },
               ).show(context);

               // clear the textcontroller

               // controller.clear();
               // priorityController.clear();

               UpdateTaskcontroller = controller;
               UpdatepriorityController = priorityController;
               provider.isButtonActivated = false;
               provider.isTextPresent = false;

               //close the dialogBox
               Navigator.pop(context);
             },
             style: provider.isButtonActivated
                 ? ElevatedButton.styleFrom(backgroundColor: Colors.purple)
                 : ElevatedButton.styleFrom(backgroundColor: Colors.grey),
             child: const Text(
               "Add",
               style: TextStyle(color: Colors.white, fontSize: 20),
             ),
           )
         ],
       ),
     ),
   );
 }

}

