import 'package:atc_admin/Auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (context, auth, _) => Drawer(
              child: ListView(
                children: <Widget>[
                  Container(
                      child: CloseButton(),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(15, 15, 0, 0)),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Sign out"),
                    contentPadding: EdgeInsets.all(20),
                    onTap: () async {
                      await auth.signOut();
                    },
                  ),
                ],
              ),
            ));
  }
}
