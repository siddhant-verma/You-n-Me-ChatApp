import 'dart:developer';
import 'dart:io';
import 'package:demoo/helper/dialogs.dart';
import 'package:demoo/main.dart';
import 'package:demoo/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

//handle google login button click
  handleGoogleBtnClick() {
    // show progress bar
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async {
      // for hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        log('\nuser: ${user.user}');
        log('\nuserAdditionalInfo: ${user.additionalUserInfo}');
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          await APIs.createUser().then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen())));
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n signInWithGoogle: $e');
      Dialogs.showSnackbar(
          context, 'Something went Wrong (Check your Internet Connection !)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    // mq = MediaQuery.of(context).size;
    return Scaffold(
      // app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome to You n Me'),
      ),
      //body
      body: Stack(children: [
        //app logo
        AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            child: Image.asset('images/message.png')),

        //google Login button
        Positioned(
            bottom: mq.height * .16,
            left: mq.width * .1,
            width: mq.width * .8,
            height: mq.height * .04,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    shape: StadiumBorder(),
                    elevation: 2),
                onPressed: () {
                  handleGoogleBtnClick();
                },
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * .03,
                ),
                label: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ]),
                )))
      ]),
    );
  }
}
