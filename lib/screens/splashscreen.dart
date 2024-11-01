import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/screens/home_page.dart';
import 'package:flutter_firebase/screens/signin_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

   String? userEmail;

  @override
  void initState(){
    getUserLoggedIn().whenComplete(() async{
      userEmail == null ?
      Timer(const Duration(seconds: 5),(){
        context.pushNamed('signIn');
      }) : Timer(const Duration(seconds: 5),(){
        context.pushNamed('Home');
      });
    },);
    super.initState();
  }

  Future getUserLoggedIn() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var userLoggedIn = preferences.getString("email");
    setState(() {
      userEmail = userLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Lottie.asset("lib/assets/animation-logo.json",width: 300,height: 300),),
            const SizedBox(height: 30,),
            Text("Daily Task",style: GoogleFonts.poppins(fontSize: 30,color: Colors.purple))
          ],
        )
      ),
    );
  }
}