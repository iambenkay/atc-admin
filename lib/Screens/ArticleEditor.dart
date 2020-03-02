import 'dart:async';

import 'package:atc_admin/Auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ArticleEditor extends StatefulWidget {
  final String id;
  final Auth auth;
  ArticleEditor(this.id, this.auth);
  @override
  _ArticleEditorState createState() => _ArticleEditorState(this.id, this.auth);
}

class _ArticleEditorState extends State<ArticleEditor>
    with SingleTickerProviderStateMixin {
  Timer timer;
  final String id;
  bool _synced = true;
  final Auth auth;
  Map<String, dynamic> article;
  _ArticleEditorState(this.id, this.auth);
  final months = <String>[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  TextEditingController _description;
  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void fetchArticle() {
    auth.store
        .collection("article")
        .document(id)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        article = snapshot.data;
        _description.text = article["description"];
        _description.selection =
            TextSelection.collapsed(offset: _description.text.length);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchArticle();
    _description = TextEditingController(text: "")
      ..addListener(() {
        setState(() {
          _synced = _description.text == article["description"];
        });
      });
  }

  Future<bool> showConfirmExit(BuildContext context) async {
    bool exit = await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text(
                  "You have unsaved changes. Are you sure you want to exit?"),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      customBorder: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Yes"),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      customBorder: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("No"),
                      )),
                )
              ],
            ));
    return exit;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateCreated;
    if (article != null) {
      Timestamp ts = article["createdAt"];
      dateCreated =
          DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch);
    }
    var center = Center(
        child: JumpingDotsProgressIndicator(
      color: Color(0xffe29464),
      fontSize: 70.0,
      dotSpacing: 7,
      numberOfDots: 4,
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Editor", style: GoogleFonts.lato(fontSize: 25)),
        leading: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () async {
            if (_synced || await showConfirmExit(context))
              Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          _synced
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () async {
                        await auth.store
                            .collection("article")
                            .document(id)
                            .updateData({"description": _description.text});
                        setState(() {
                          _synced = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.check, color: Color(0xff008800)),
                      )),
                )
        ],
      ),
      body: article == null
          ? center
          : WillPopScope(
              onWillPop: () async {
                if(_synced) return Future.value(true);
                return Future.value(showConfirmExit(context));
              },
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(article["title"],
                            style: GoogleFonts.lato(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: Text(
                            "Created on ${months[dateCreated.month - 1]} ${dateCreated.day}, ${dateCreated.year}",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ))
                    ],
                  ),
                  TextField(
                    maxLines: null,
                    autocorrect: true,
                    style: GoogleFonts.lato(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Start writing...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: _description,
                    keyboardType: TextInputType.multiline,
                  )
                ],
              ),
            ),
    );
  }
}
