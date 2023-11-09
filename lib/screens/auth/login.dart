import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpi_alert/screens/auth/register.dart';

import '../home.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AutofillGroup(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
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
                          labelText: 'User Name',
                          hintText: 'abc@gmail.com'),
                      validator: (value) {
                        if (!RegExp(
                                "^[a-zA-Z0-9+_.-]+@gmail.com")
                            .hasMatch(value!)) {
                          return ("Please enter a valid email username ");
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
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shadowColor: Colors.black38,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterUser(),
                              ));
                        },
                        child: const Text(
                          " Register",
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //Utils.showSnackBar(e.message.toString(), Colors.red);
      var snackBar = SnackBar(content: Text(e.message!));
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
    //if mounted then pop
    // Navigator.of(context).pop();

    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        //add dashboard and pass user object
        builder: (context) => Home(),
      ),
    );
    //Utils.showSnackBar("User Authorized", Colors.green);
    // Navigator.of(context, rootNavigator: true).pop();
    var snackBar = SnackBar(content: Text('User Authorized'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
