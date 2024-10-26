import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/todos_provider.dart';
import 'package:flutter_firebase/services/firestore_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

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

  void customToast(String text, Color backgroundColor) {
    final snackbar = SnackBar(
      content: Row(children: [
        const Icon(
          Icons.done,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 18),
          ),
        )
      ]),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(50),
      elevation: 30,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  showAlertDialogBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
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
              )),
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future<void> openAddDialogBox() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<TodosProvider>(
        builder: (context, provider, child) => AlertDialog(
          title: const Text(
            "Add Tasks",
            style: TextStyle(color: Colors.black, fontSize: 20),
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
                  'creator': "UTKARSH"
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

                controller.clear();
                priorityController.clear();
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

  void openUpdateDialogBox(String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<TodosProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            title: const Text(
              "Update Tasks",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
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
                  ))
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
        centerTitle: true,
        title: const Text(
          "Todo List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple.shade300,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          openAddDialogBox();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: ((didpop) {
          if (didpop) {
            return;
          } else {
            showAlertDialogBox(context);
          }
        }),
        child: StreamBuilder(
          stream: note.where("creator", isEqualTo: "UTKARSH").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var todos = snapshot.data?.docs[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (Direction) {
                      if (Direction == DismissDirection.endToStart) {
                        FirestoreServices()
                            .deleteTask(todos['id']);
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
                        title: Text(
                          todos!['task'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          todos['priority'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        onTap: () {
                          // controller.text = todos['task'];
                          controller.text = snapshot.data?.docs[index]['task'];
                          priorityController.text = todos['priority'];
                          openUpdateDialogBox(todos['id']);
                        },
                        onLongPress: () {
                          FirestoreServices()
                              .deleteTask(todos['id']);
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
      ),
    );
  }
}
