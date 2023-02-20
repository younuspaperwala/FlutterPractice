// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remedypractice/constants/routes.dart';
import 'package:remedypractice/utilities/errorDialog.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            //Textfield for email
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your Username or Email"),
          ),
          TextField(
            //textfield for password
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCreds = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(userCreds.user?.email.toString() ??
                    "" + " is now logged in ");
                if (userCreds.user != null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesroute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  showErrorDialog(
                    context,
                    "User Not Found",
                  );
                } else if (e.code == "wrong-password") {
                  showErrorDialog(
                    context,
                    "Username or password is incorrect",
                  );
                } else {
                  showErrorDialog(
                    context,
                    "Something went wrong please contact administrator",
                  );
                }
                // devtools.log(e.code);
              } catch (e) {
                devtools.log(e.toString());
              }
            }, //button press is an async task
            child: const Text("Log in"),
          ),
          TextButton(
              onPressed: () => {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerroute, (route) => false),
                  },
              child: const Text("Not Registered yet? Register Here!"))
        ],
      ),
    );
  }
}
