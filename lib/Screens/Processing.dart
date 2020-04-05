import 'dart:async';

import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/services/asset-provider.dart';
import 'package:flutter/material.dart';

class Processing extends StatefulWidget {
  final Auth auth;
  final Future<Widget> Function() onSave;
  Processing(this.auth, this.onSave);
  @override
  _ProcessingState createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing> {
  bool _saved = false;
  Widget next;
  _ProcessingState();
  @override
  void initState() {
    super.initState();
    save();
  }

  void save() async {
    next = await widget.onSave();
    setState(() {
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) {
      Timer(Duration(seconds: 1), () {
        if (next != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => next));
        } else
          Navigator.of(context).pop();
      });
    }
    return WillPopScope(
      onWillPop: () {
        super.dispose();
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: !_saved
                  ? CircularProgressIndicator()
                  : Image.asset(
                      AssetProvider.success_check,
                      cacheHeight: 50,
                      cacheWidth: 50,
                      scale: 0.2,
                    ))),
    );
  }
}
