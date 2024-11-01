import 'dart:io';

import 'package:flutter/material.dart';

class AlertDialogue{

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

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },);
  }
}