import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/SignIn.dart';
import 'Auth/auth.dart';
import 'Screens/Admin.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: firebase,
      child: Consumer(builder: (context, Auth auth, _) {
        switch(auth.status){
          case Status.Unauthenticated:
          case Status.Authenticating:
            return SignIn();
          case Status.Authenticated:
          default:
            return Admin();

        }
      }),
    );
  }
}
