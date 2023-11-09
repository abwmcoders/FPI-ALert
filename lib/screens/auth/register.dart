import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'login.dart';


class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController matric = TextEditingController();

class _RegisterUserState extends State<RegisterUser> {
  bool _showPassword = false;
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: AutofillGroup(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Image.asset(
                    'images/logo.png',
                  ),
                ),
                Text(
                  "Create an account",
                  style: TextStyle(
                      color: Colors.green.shade500,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: name,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full Name',
                        hintText: 'abcdef'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter your name");
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: matric,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Matric Number',
                        hintText: 'H/CS/22/7890'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter your matric number");
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autofocus: true,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                        hintText: 'abc@gmail.com',
                        ),
                    validator: (value) {
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@gmail.com")
                          .hasMatch(value!)) {
                        return ("Please Enter an email username and append with\n@gmail.com.fpimemo.edu.mk format");
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: pass,
                    autofocus: true,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.security),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _showPassword ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                    ),
                    validator: (value) => value != null && value.length < 6
                        ? "Enter atleast 6 characters"
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signIn,
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shadowColor: Colors.black38,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: isLoading ? const CircularProgressIndicator() : const SizedBox(),
      ),
    );

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      var snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context, rootNavigator: true).pop();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(email.text.trim())
        .set({
      "email": email.text.trim(),
      "pass": pass.text.trim(),
      "username": name.text.trim().substring(0, email.text.trim().indexOf('@')),
      "Matric": matric.text.trim(),
      "token": "",
      "account_type": "Student",
    });
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        //add dashboard and pass user object
        builder: (context) => Home(),
      ),
    );
    var snackBar =
        const SnackBar(content: Text("Account created successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
