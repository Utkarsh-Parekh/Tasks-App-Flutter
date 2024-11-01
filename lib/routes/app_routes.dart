
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/home_page.dart';
import 'package:flutter_firebase/screens/password_recovery.dart';
import 'package:flutter_firebase/screens/signin_page.dart';
import 'package:flutter_firebase/screens/signup_page.dart';
import 'package:flutter_firebase/screens/splashscreen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {

  final GoRouter routes = GoRouter(
  initialLocation: '/splash',
    routes: [
      GoRoute(
        path: "/splash",
        name: "splash",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashScreen(),
          );
        },
      ),

      GoRoute(
        path: "/",
        name: "Home",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HomePage(),
          );
        },
      ),

      GoRoute(
        path: "/signIn",
        name: "signIn",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child:SignInPage(),
          );
        },
      ),

      GoRoute(
        path: "/signUp",
        name: "signUp",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SignupPage(),
          );
        },
      ),

      GoRoute(
        path: "/passwordrecovery",
        name: "passwordRecovery",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: PasswordRecovery(),
          );
        },
      )
    ],

  );

}

