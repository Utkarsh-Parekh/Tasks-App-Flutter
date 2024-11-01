import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/adddialog.dart';
import 'package:flutter_firebase/providers/todos_provider.dart';
import 'package:flutter_firebase/services/firestore_services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreServices firestoreServices = FirestoreServices();
  TextEditingController controller = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  //This is the collection name : "todos"
  final CollectionReference note =
      FirebaseFirestore.instance.collection("todos");

  showAlertDialogBox(BuildContext context) {
   AlertDialog alert =  AlertDialog(
      backgroundColor: Colors.purple.shade300,
      title: const Text("Confirmation"),
      content: const Text(
        "Would you like to close the App?",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white)),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(fontSize: 16, color: Colors.white),
              )),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white)),
          child: TextButton(
            onPressed: () {
              exit(0);
            },
            child: const Text(
              "Yes",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void openUpdateDialogBox(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<TodosProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            title: Text("Update Tasks",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.black, fontSize: 20),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      // suffixIcon: provider.isTextPresent == true ? Icon(Icons.done,color: Colors.green,) : Icon(Icons.close_sharp,color: Colors.red,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: 'Task',
                      hintText: "Update the Tasks"),
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
                      hintText: "Update the Description"),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  //Here todos : Collection name of Firebase,"notedata" : Doc name of collections
                  Map<String, dynamic> updateInfo = {
                    'task': controller.text,
                    'priority': priorityController.text,
                  };

                  controller.text.isNotEmpty
                      ? await FirestoreServices()
                          .updateTask(id, updateInfo)
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
                                title: Text("Task Updated Successfully"),
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
                              title: Text("Task Field Should not be Empty"),
                            );
                          },
                        ).show(context);

                  // clear the textcontroller
                  controller.clear();
                  priorityController.clear();

                  //close the dialogBox
                  Navigator.pop(context);
                },
                style: controller.text.isNotEmpty
                    ? ElevatedButton.styleFrom(backgroundColor: Colors.purple)
                    : ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Todo List",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white))),
          backgroundColor: Colors.purple.shade300,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.remove('email');
                FirebaseAuth.instance.signOut();
                context.pushNamed("signIn");
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            CustomDialogBox().openAddDialogBox(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: ((didpop) async {
            if (didpop) {
              return;
            } else {
              return showAlertDialogBox(context);
            }
          }),
          child: StreamBuilder(
            stream: note
                .where("creator",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.size == 0) {
                return Center(
                  child: Lottie.asset(
                    "lib/assets/no_notes.json",
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var todos = snapshot.data?.docs[index];
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (Direction) {
                        if (Direction == DismissDirection.endToStart) {
                          FirestoreServices().deleteTask(todos['id']);
                          DelightToastBar(
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
                                title: Text("Task Deleted Successfully"),
                              );
                            },
                          ).show(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.purple.shade100),
                        child: ListTile(
                          title: Text(todos!['task'],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )),
                          subtitle: Text(todos['priority'],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              )),
                          onTap: () {
                            // controller.text = todos['task'];
                            controller.text =
                                snapshot.data?.docs[index]['task'];
                            priorityController.text = todos['priority'];
                            openUpdateDialogBox(todos['id']);
                          },
                          onLongPress: () {
                            FirestoreServices().deleteTask(todos['id']);
                            DelightToastBar(
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
                                  title: Text("Task Deleted Successfully"),
                                );
                              },
                            ).show(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
