import 'package:atc_admin/Auth/auth.dart';
import 'package:flutter/material.dart';

class Processing extends StatefulWidget {
  final Auth auth;
  Processing(this.auth);
  @override
  _ProcessingState createState() => _ProcessingState(auth);
}

class _ProcessingState extends State<Processing> {
  Auth auth;
  _ProcessingState(this.auth);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Icon(Icons.check_box, size: 80,),),
    );
  }
}