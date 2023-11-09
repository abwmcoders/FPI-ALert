import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpi_alert/screens/auth/register.dart';
import 'package:fpi_alert/screens/home.dart';
import 'package:get/get.dart';

import '../signin.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? wd, ht;

  void signIn() async {
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (!result.isNotEmpty && !result[0].rawAddress.isNotEmpty) {
    //     Get.snackbar("", "",
    //         titleText: Row(
    //           children: [
    //             CircularProgressIndicator(
    //               valueColor: new AlwaysStoppedAnimation<Color>(
    //                   Theme.of(context).accentColor),
    //             ),
    //             const Text(
    //               '    Logging In.....',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ],
    //         ),
    //         messageText: const Text(
    //           "               Please wait...",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.green,
    //         duration: const Duration(days: 1));
        try {
          // signInWithGoogle(context).then((val) {
          //   if (val != "Signed In") {
          //     Get.back();
          //     Get.offNamed('/home');
          //   } else {
          //     Get.back();
          //     Get.snackbar("Unable to sign in now.", "Try Again Later.",
          //         snackPosition: SnackPosition.BOTTOM,
          //         backgroundColor: Theme.of(context).primaryColor,
          //         colorText: Colors.white,
          //         duration: const Duration(seconds: 2));
          //   }
          // });
        } catch (e) {
          Get.back();
        }
    //   }
    // } on SocketException catch (_) {
    //   Get.snackbar("No Internet Connection.", "Try Again Later.",
    //       snackPosition: SnackPosition.BOTTOM,
    //       backgroundColor: Colors.amber,
    //       duration: const Duration(seconds: 2));
    // }
  }

  // void alreadySignedIn() async {
  //   if (await googleSignIn.isSignedIn()) {
  //     signIn();
  //   }
  // }

  @override
  void initState() {
   // alreadySignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wd = MediaQuery.of(context).size.width;
    ht = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ht,
          width: wd,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("images/background.png"),fit: BoxFit.cover),
          ),
          child: Container(
            color: Colors.black38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: wd,
                  height: ht! * 0.27,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FPI Alert',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            'The best protection any student can have.....is courage.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: const BorderSide(
                                      color: Colors.black38, width: 0.5))),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser())),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/logo.png",
                                height: 35,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Continue To App',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
