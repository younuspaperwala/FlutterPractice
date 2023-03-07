import 'package:flutter/material.dart';
import 'package:remedypractice/constants/routes.dart';
import 'package:remedypractice/services/auth/auth_service.dart';

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
                  AuthService.firebase().sendEmailVerification();
                },
                child: const Text("Send email for verification")),
            TextButton(
                onPressed: () async {
                  AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginroute, (route) => false);
                },
                child: const Text("Logout"))
          ],
        ));
  }
}
