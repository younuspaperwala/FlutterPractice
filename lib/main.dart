import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:remedypractice/Views/Register_View.dart';
import 'package:remedypractice/constants/routes.dart';
import 'package:remedypractice/services/auth/auth_service.dart';
import 'package:remedypractice/views/Login_View.dart';
// import 'dart:developer' as devtools show log;

import 'Views/notes/new_notes_view.dart';
import 'Views/notes/notes_view.dart';
import 'Views/verifyemail_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginroute: (context) => const LoginView(),
      registerroute: (context) => const RegisterView(),
      notesroute: (context) => const NotesViewState(),
      verifyemailroute: (context) => const VerfiyEmailView(),
      newNoteroute: (context) => const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                // if (user?.emailVerified ?? false) {
                if (user.isEmailVerified) {
                  return const NotesViewState();
                } else {
                  return const VerfiyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
