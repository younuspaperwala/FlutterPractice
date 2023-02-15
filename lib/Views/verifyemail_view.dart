import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerfiyEmailView extends StatefulWidget {
  const VerfiyEmailView({super.key});

  @override
  State<VerfiyEmailView> createState() => _VerfiyEmailViewState();
}

class _VerfiyEmailViewState extends State<VerfiyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Email Verification")),
        body: Column(
          children: [
            const Text(
                "Your Email is not verified please check your email for verification."),
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text("Send email for verification"))
          ],
        ));
  }
}
