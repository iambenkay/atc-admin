import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ArticleEditor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateArticle extends StatefulWidget {
  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  TextEditingController _title;
  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: withFirebase(Consumer(
                    builder: (context, Auth auth, _) => FlatButton(
                          onPressed: _title.text.isEmpty
                              ? null
                              : () async {
                                  final id = await auth.store
                                      .collection("article")
                                      .add({
                                    "title": _title.text,
                                    "createdAt": DateTime.now(),
                                  }).then((ref) => ref.documentID);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ArticleEditor(id, auth) ));
                                },
                          textColor: Color(0xffe29464),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "CREATE",
                            style: GoogleFonts.lato(
                              fontSize: 20,
                            ),
                          ),
                        ))))
          ],
          leading: InkWell(
            child: Icon(Icons.close),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            child: Form(
                child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 10, 20),
              child: Text(
                "Create a new\nArticle",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                onChanged: (_) {
                  setState(() {});
                },
                maxLines: null,
                autocorrect: true,
                controller: _title,
                validator: (value) =>
                    (value.isEmpty) ? "Please enter title" : null,
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    labelText: 'Title',
                    labelStyle: GoogleFonts.lato(fontSize: 30)),
              ),
            ),
          ],
        ))));
  }
}
