import 'package:chatterbeings/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/signin_up_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
       MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Initialize FlutterFire:
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check for errors

        if (snapshot.hasData) {
          return ChatScreen();
        }else{
          return AuthScreen();
        }
        return const Center(
          child:  CircularProgressIndicator(),
        );


      },
    );
  }
}


