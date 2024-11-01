import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/providers/todos_provider.dart';
import 'package:flutter_firebase/routes/app_routes.dart';
import 'package:flutter_firebase/screens/home_page.dart';
import 'package:flutter_firebase/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ChangeNotifierProvider<TodosProvider>
  (
    create: (context) => TodosProvider(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
     debugShowCheckedModeBanner: false,
      routerConfig: AppRoutes().routes,
    );
  }
}
