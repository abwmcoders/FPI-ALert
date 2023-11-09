import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import '../signin.dart';
import 'home.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController descriptionController = TextEditingController(text: "");
  getPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'REPORT',
          style: TextStyle(
            fontFamily: 'SAN',
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Iwitness",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Stolen Vehicle",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Gun Violence",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Drug Abuse",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Domestic Violence",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Rape",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Kidnap",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Robbery",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Vandalism",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Fire",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Accident",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Medical",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Riot",
            ),
            OptionCard(
              onTap: () {
                _showMyDialog(context, descriptionController);
              },
              title: "Child Abuse",
            ),
          ],
        ),
      ),
    );
  }

  SharedPreferences? prefs;

  void _sendSMS(String messageBody) async {
    List<String> recipients = prefs!.getStringList('nums') ?? [];
    //List<String> recipients = ["08058481324", "08140994757"];
    print("about to send message");
    print("Added number below");
    print("${prefs!.getStringList('nums')}");
    print("about to sendiiing message");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String latlng =
        position.latitude.toString() + ',' + position.longitude.toString();
    //final coordinates = new Coordinates(position.latitude, position.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = "Ilaro"; //addresses.first.addressLine;
    print('Local Address: $first');

    // FirebaseFirestore.instance
    //     .collection('sos')
    //     .doc('$uid ${DateTime.now().toString()}')
    //     .set({
    //   'username': userName,
    //   'photoUrl': userImageUrl,
    //   'id': uid,
    //   'email': userEmail,
    //   'phone': phone,
    //   'address': first,
    //   'latitude': position.latitude.toString(),
    //   'longitude': position.longitude.toString(),
    //   'time': DateTime.now(),
    //   'emergencyContacts': recipients,
    // });
    if (recipients.length == 0) {
      Get.snackbar('No phone numbers found! Only THE DSA will be notified.',
          'Please check Emergency contacts list.');
    } else {
      //String messageBody = 'Help me! I am in trouble.';
      print("About to send message");
      print("About to send message -----> $messageBody");
      messageBody +=
          '\n\nMy current location is:\nhttps://www.google.com/maps/search/?api=1&query=$latlng';

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
      print("about to send nw nw message");
      sendMessage(messageBody, recipients);
      print("about to senttttttt message");
      // }
      print("about to send message oyaaaa snack");
      Get.snackbar(
          'SOS sent!', 'All emergency contacts & THE DSA have been notified.');
      Get.offNamed('/home');
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

  Future<void> _showMyDialog(context, TextEditingController controller) async {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(
                  bottom: 50, left: 10, right: 10, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'DESCRIPTION OF\nEMERGENCY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        minLines:
                            6, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        maxLines: 8,
                        controller: controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                            )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.black,
                            )),
                            hintText:
                                "Please enter a detailed description of the situation..."),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      child: Text(
                        'Raise Emergency Alarm',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        if (controller.text != null && controller.text != "") {
                          _sendSMS(controller.text.toString());
                          Navigator.of(context).pop();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Please add description of the emergency !!!");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
}
