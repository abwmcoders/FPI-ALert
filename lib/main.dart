import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpi_alert/screens/auth/register.dart';
import 'package:fpi_alert/screens/report.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import './screens/home.dart';
import './screens/login.dart';
import './screens/contacts.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DarkThemeProvider>(
      create: (_) => themeChangeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            title: 'Alert App',
            home: StreamBuilder<User?>(
              // Initialize FlutterFire:
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context,  snapshot) {
                if (snapshot.hasError) {
                  var snackBar =
                      const SnackBar(content: Text('Something went wrong !!!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return RegisterUser();
                } 
                else if (snapshot.hasData) {
                  return Home();
                } 
else {
                  return RegisterUser();
                }
              },
            ),
            initialRoute: '/',
            routes: {
              '/home': (ctx) => Home(),
              '/contacts': (ctx) => Contacts(),
              'report': (ctx) => Report(),
            },
          );
        },
      ),
    );

    // ChangeNotifierProvider(
    //   create: (_) => themeChangeProvider,
    //   child: Consumer<DarkThemeProvider>(
    //     builder: (BuildContext context, value, Widget child) {
    //       return GetMaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: Styles.themeData(themeChangeProvider.darkTheme, context),
    //         title: 'College Companion',
    //         home: FutureBuilder(
    //           // Initialize FlutterFire:
    //           future: _initialization,
    //           builder: (context, snapshot) {
    //             // Check for errors
    //             if (snapshot.hasError) {
    //               return const Center(child: Text("Error"));
    //             }

    //             // Once complete, show your application
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               return Home(); //Login();
    //             }

    //             // Otherwise, show something whilst waiting for initialization to complete
    //             return const Center(child: CircularProgressIndicator());
    //           },
    //         ),
    //         initialRoute: '/',
    //         routes: {
    //           '/home': (ctx) => Home(),
    //           '/contacts': (ctx) => Contacts(),
    //         },
    //       );
    //     },
    //   ),
    // );
  
  }
}
