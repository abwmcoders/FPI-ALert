import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fpi_alert/screens/report.dart';
import 'package:fpi_alert/screens/user_model.dart';
//import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
//import 'package:hardware_buttons/hardware_buttons.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sms_maintained/sms.dart';
import 'package:telephony/telephony.dart';

import '../signin.dart';
import '../theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double? wd, ht;
  SharedPreferences? prefs;
  bool loc = true, hardware = false;
  int down = 0, up = 0;
  StreamSubscription? _volumeButtonSubscription;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getUser() async {
    print("Userinfo of this account");
    print("This User value ----> ${user!.email}");
    await firestore.collection("users").doc(user!.email).get().then((value) {
      print("User of this account");
      print("This User value data ----> ${value.data()}");
      if (mounted) {
        setState(() {
          UserObject userObject = UserObject.fromJson(value.data());
          userEmail = userObject.email;
          userName = userObject.name;
          uid = user!.uid;
          phone = "";
          userImageUrl = "";
          print("getting user object");
          print("getting user object ----> ${userObject.email}");
          print("getting user object ----> ${userObject.name}");
        });
      }
    });
  }

  void _enterNumber() {
    final _key = GlobalKey<FormState>();
    String? number;
    Alert(
      context: context,
      style: const AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
      ),
      title: "Contact number",
      desc: "Enter your mobile number to continue.",
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Contact Number can\'t be empty' : null,
                  onSaved: (value) => number = value!,
                  decoration: const InputDecoration(
                    hintText: 'Enter contact number...',
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      buttons: [
        DialogButton(
          color: Colors.green,
          child: const Text(
            "SAVE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              FirebaseFirestore.instance.collection('users').doc(uid).update(
                  {'phone': number}).then((value) => print("User Updated"));
              print('username : ' + userName!);
              print('email : ' + userEmail!);
              print('phone : ' + phone!);
              Get.back();
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _sendSMS() async {
    List<String> recipients = prefs!.getStringList('nums') ?? [];
    // List<String> recipients = ["08058481324", "08140994757"];

    print("Added number below");
    print("${prefs!.getStringList('nums')}");

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latlng =
        position.latitude.toString() + ',' + position.longitude.toString();
    // final coordinates = Coordinates(position.latitude, position.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = "Ilaro"; //addresses.first.addressLine;
    print('Local Address: $first');

    FirebaseFirestore.instance
        .collection('sos')
        .doc('${user!.uid} ${DateTime.now().toString()}')
        .set({
      'username': userName,
      'photoUrl': userImageUrl,
      'id': user!.uid,
      'email': userEmail,
      'phone': phone,
      'address': first,
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
      'time': DateTime.now(),
      'emergencyContacts': recipients
    });
    if (recipients.length == 0) {
      Get.snackbar('No phone numbers found! Only THE DSA will be notified.',
          'Please check Emergency contacts list.');
    } else {
      String messageBody = 'Help me! I am in trouble.';
      print("About to send message");
      print("About to send message -----> $messageBody");
      if (loc) {
        messageBody +=
            '\n\nMy current location is:\nhttps://www.google.com/maps/search/?api=1&query=$latlng';
      }

      // SmsSender sender = new SmsSender();
      //for (int i = 0; i < recipients.length; i++) {
      // SmsMessage message = new SmsMessage(recipients[i], messageBody);
      // message.onStateChanged.listen((state) {
      //   if (state == SmsMessageState.Sent) {
      //     print("SMS $i is sent!");
      //   } else if (state == SmsMessageState.Delivered) {
      //     print("SMS $i is delivered!");
      //     print(messageBody);
      //   }
      // });
      //sender.sendSms(message);
      recipients.add("09018202526");
      sendMessage(messageBody, recipients);
      // }
      Get.snackbar(
          'SOS sent!', 'All emergency contacts & THE DSA have been notified.');
    }
  }

  sendMessage(String messageBody, List<String> recipients) async {
    //List<TContact> contactList = await DatabaseHelper().getContactList();
    if (recipients.isEmpty) {
      Fluttertoast.showToast(msg: "no number exist please add a number");
    } else {
      for (var i = 0; i < recipients.length; i++) {
        Telephony.backgroundInstance
            .sendSms(to: recipients[i], message: messageBody)
            .then((value) {
          Fluttertoast.showToast(msg: "message send");
        });
      }
    }
  }

  void locationServices() async {
    await Geolocator.checkPermission().then((permission) async {
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        await Geolocator.requestPermission();
      }
    });
    await Geolocator.isLocationServiceEnabled().then((locationStatus) async {
      if (!locationStatus) {
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
      }
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loc = prefs!.getBool('loc') ?? true;
      hardware = prefs!.getBool('hardware') ?? false;
    });
  }

  @override
  void initState() {
    getUser();
//     _volu
//meButtonSubscription =
//         volumeButtonEvents.listen((VolumeButtonEvent event) {
//       print('zzzzzzzzzzzzzzzzzzzzzzzzzzz');
// //      if(hardware){
// //        if(event==VolumeButtonEvent.VOLUME_DOWN){
// //          print('Volume Down Button Detected');
// //          down++;
// //        }
// //        if(event==VolumeButtonEvent.VOLUME_UP){
// //          print('Volume Up Button Detected');
// //          up++;
// //        }
// //        if(down == 2 && up ==1){
// //          print('DETECTED HARDWARE BUTTON SEQUENCE');
// //          _sendSMS();
// //        }
// //      }
// //      if(event==VolumeButtonEvent.VOLUME_DOWN && down==1){
// //        Timer(Duration(seconds: 2), () async {
// //          down = 0;
// //          up = 0;
// //        });
// //      }
//     });

    RawKeyboard.instance.addListener((RawKeyEvent event) {
      print('hhhhhkhbkbkbkbkn');
      if (hardware) {
        if (event.runtimeType == RawKeyDownEvent &&
            event.physicalKey.debugName == 'Audio Volume Down') {
          print('Volume Down Button Detected');
          down++;
        }
        if (event.runtimeType == RawKeyDownEvent &&
            event.physicalKey.debugName == 'Audio Volume Up') {
          print('Volume Up Button Detected');
          up++;
        }
        if (event.runtimeType == RawKeyDownEvent && down == 2 && up == 1) {
          print('DETECTED HARDWARE BUTTON SEQUENCE');
          _sendSMS();
        }
      }
      if (event.runtimeType == RawKeyDownEvent &&
          event.physicalKey.debugName == 'Audio Volume Down' &&
          down == 1) {
        Timer(const Duration(seconds: 2), () async {
          down = 0;
          up = 0;
        });
      }
    });

    locationServices();

    Timer(const Duration(seconds: 2), () async {
      if (user!.phoneNumber == '') {
      } else {
        print('username : ' + user!.displayName!);
        print('email : ' + user!.email!);
        print('phone : ' + user!.phoneNumber!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    wd = MediaQuery.of(context).size.width;
    ht = MediaQuery.of(context).size.height;

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          //'😁 Hello ${userName.substring(0, userName.indexOf(' '))}',
          '😁 Hello ${userName}',
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 25,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              onTap: () => signOut(context),
              child: const Icon(
                Icons.logout,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              onTap: () => Get.toNamed('/contacts'),
              child: const Icon(
                Icons.contacts,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Send SOS signal to all Emergency Contacts\nPress\n👇',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            AvatarGlow(
              glowColor: Theme.of(context).hintColor,
              endRadius: wd! * 0.5,
              duration: const Duration(milliseconds: 1700),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: MaterialButton(
                elevation: 3,
                onPressed: () {
                  //_sendSMS();
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: Column(
                          children: [
                            OptionCard(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Report(),
                                  ),
                                );
                              },
                              title: "Report",
                            ),
                            OptionCard(
                              onTap: () {
                                _sendSMS();
                                Navigator.pop(context);
                              },
                              title: "Emergency",
                            ),
                            const SizedBox(height: 15),
                            OptionCard(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              title: "Cancel",
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                color: Theme.of(context).cardColor,
                textColor: Colors.white,
                child: Text(
                  'SOS',
                  style: TextStyle(fontSize: wd! * 0.2),
                ),
                padding: EdgeInsets.all(wd! * 0.2),
                shape: const CircleBorder(),
              ),
            ),
            SizedBox(
              width: wd! * 0.8,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: const FractionColumnWidth(0.7)},
                children: [
                  TableRow(children: [
                    const Text('Send Location Coordinates:'),
                    CupertinoSwitch(
                      activeColor: Theme.of(context).canvasColor,
                      value: loc,
                      onChanged: (val) async {
                        setState(() {
                          loc = val;
                        });
                        await prefs!.setBool('loc', loc);
                      },
                    ),
                  ]),
                  TableRow(children: [
                    const Text('Dark Mode'),
                    CupertinoSwitch(
                      activeColor: Theme.of(context).canvasColor,
                      value: themeChange.darkTheme,
                      onChanged: (isDarkMode) {
                        themeChange.darkTheme = isDarkMode;
                      },
                    ),
                  ]),
                  TableRow(children: [
                    const Text(
                        'Hardware Shortcut\nPress VOLUME DOWN twice & VOLUME UP once'),
                    CupertinoSwitch(
                      activeColor: Theme.of(context).canvasColor,
                      value: hardware,
                      onChanged: (val) async {
                        setState(() {
                          hardware = val;
                        });
                        await prefs!.setBool('hardware', hardware);
                      },
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // be sure to cancel on dispose
    _volumeButtonSubscription?.cancel();
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).highlightColor,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).dividerColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
