import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_sharing_app/jobs/jobs_screen.dart';

import 'auth/login.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);
    //This indicates the user state. Shows if the user is either logged in already or not.
    // User logged in ==> home screen
    // User not logged in ==> login screen
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot){
        if(userSnapshot.data == null){
          print('user is not logged in yet');
          return const Login();
        }
        else if(userSnapshot.hasData) {
          print('user is already logged in');
          return const JobScreen();
        }
        else if(userSnapshot.hasError){
          return const Scaffold(
            body: Center(
              child: Text('An error has occurred'),
            ),
          );
        }
        else if(userSnapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text('Something went wrong'),
          ),
        );
      }
    );
  }
}
