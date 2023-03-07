import 'package:flutter/material.dart';
import 'package:remedypractice/constants/routes.dart';
import 'package:remedypractice/services/auth/auth_exceptions.dart';
import 'package:remedypractice/services/auth/auth_service.dart';
import 'package:remedypractice/utilities/errorDialog.dart';

// import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            //Textfield for email
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your new Email address"),
          ),
          TextField(
            //textfield for password
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: "Enter your new password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCreds = await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyemailroute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Please use a strong password",
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  "Email already in use",
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "Email is invalid",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Something went wrong please contact administrator",
                );
              }
            }, //button press is an async task
            child: const Text("Register Here"),
          ),
          TextButton(
              onPressed: () => {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginroute, (route) => false),
                  },
              child: const Text("Already Registered? Login Here!"))
        ],
      ),
    );
  }
}
