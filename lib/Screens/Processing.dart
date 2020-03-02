import 'dart:async';

import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ArticleEditor.dart';
import 'package:flutter/material.dart';

class Processing extends StatefulWidget {
  final Auth auth;
  final Map<String, dynamic> data;
  Processing(this.auth, this.data);
  @override
  _ProcessingState createState() => _ProcessingState(auth, data);
}

class _ProcessingState extends State<Processing> {
  Auth auth;
  
  Map<String, dynamic> data;
  bool _saved = false;
  _ProcessingState(this.auth, this.data);
  @override
  void initState() {
    super.initState();
    save();
  }

  void save() async {
    data["id"] = await auth.store.collection("article").add({
      "title": data["title"],
      "createdAt": data["createdAt"],
    }).then((ref) => ref.documentID);
    setState(() {
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) {
      Timer(Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ArticleEditor(data["id"], auth)));
      });
    }
    return Scaffold(
      body: Center(
          child: !_saved
              ? CircularProgressIndicator()
              : Icon(
                  Icons.check_box,
                  size: 80,
                  color: Color(0xff008800),
                )),
    );
  }
}
