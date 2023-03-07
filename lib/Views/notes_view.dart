import 'package:flutter/material.dart';
import 'package:remedypractice/enums/menus_action.dart';
import 'package:remedypractice/services/auth/auth_service.dart';

import '../constants/routes.dart';

class NotesViewState extends StatefulWidget {
  const NotesViewState({super.key});

  @override
  State<NotesViewState> createState() => _NotesViewStateState();
}

class _NotesViewStateState extends State<NotesViewState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginroute, (_) => false);
                }
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              )
            ];
          })
        ],
      ),
      body: const Text("You're verified"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text("Are you sure you want to logout"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out")),
          ],
        );
      }).then((value) => value ?? false);
}
