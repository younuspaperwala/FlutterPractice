import 'package:flutter/material.dart';
import 'package:remedypractice/constants/routes.dart';
import 'package:remedypractice/services/auth/auth_exceptions.dart';
import 'package:remedypractice/services/auth/auth_service.dart';
import 'package:remedypractice/utilities/errorDialog.dart';
import 'dart:developer' as devtools show log;

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
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
                final userCreds = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;

                if (user != null) {
                  if (user.isEmailVerified) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesroute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyemailroute,
                      (route) => false,
                    );
                  }
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "User Not Found",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Username or password is incorrect",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Something went wrong please contact administrator",
                );
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
