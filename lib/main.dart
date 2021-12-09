import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_sharing_app/user_state.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('App is being initialized'),
                    //This happens when there is a successful connection
                  ),
                ),
              )
          );
        } else if(snapshot.hasError){
          //This is what happens when there is an error in connection
          return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has occurred'),
                  ),
                ),
              )
          );
        }
        //After either of the states is sorted, the user is directed to the user state.
            return MaterialApp(
              debugShowCheckedModeBanner: false,
                title: 'Job Application',
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.black,
                  primarySwatch: Colors.blue,
              ),
            home: UserState(),
      );
    });
  }
}