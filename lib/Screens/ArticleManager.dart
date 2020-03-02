import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ArticleEditor.dart';
import 'package:atc_admin/Screens/CreateArticle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class ArticleManager extends StatefulWidget {
  final auth;
  ArticleManager(this.auth);
  @override
  _ArticleManagerState createState() => _ArticleManagerState(auth);
}

class _ArticleManagerState extends State<ArticleManager> {
  Auth auth;
  _ArticleManagerState(this.auth);
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  List<DocumentSnapshot> _articles;
  void fetchArticles() {
    auth.store
        .collection("article")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          snapshot.documents.sort(
              (a, b) => b.data["createdAt"].compareTo(a.data["createdAt"]));

          setState(() {
            _articles = snapshot.documents;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateArticle()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Articles",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "SFUIDisplay",
              fontSize: 32,
              fontWeight: FontWeight.w900),
        ),
        backgroundColor: Color(0xffffffff),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          _articles == null
              ? SliverFillRemaining(
                  child: JumpingDotsProgressIndicator(
                    color: Color(0xffe29464),
                    fontSize: 70.0,
                    dotSpacing: 7,
                    numberOfDots: 4,
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.only(bottom: 50),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    var article = _articles[index].data;
                    article["id"] = _articles[index].documentID;

                    return Card(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                                  child: Text(article["title"],
                                      style: TextStyle(
                                          fontFamily: "SFUIDisplay",
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold)),
                                ),
                                article["description"] == null || article["description"] == ""
                                    ? Text("No content yet",
                                        style: TextStyle(
                                          fontFamily: "SFUIDisplay",
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                        ))
                                    : Text(
                                        article["description"].length > 150 ? article["description"]
                                                .substring(0, 150) +
                                            "..." : article["description"],
                                        style: TextStyle(
                                          fontFamily: "SFUIDisplay",
                                          fontSize: 17,
                                        )),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: PopupMenuButton<ContextOption>(
                                  itemBuilder: (context) {
                                    return ([
                                      contextMenuItem(ContextOption.Edit,
                                          Icons.edit, "Edit"),
                                      contextMenuItem(ContextOption.Publish,
                                          Icons.cloud_upload, "Publish"),
                                      contextMenuItem(ContextOption.Stats,
                                          Icons.show_chart, "View stats"),
                                      contextMenuItem(ContextOption.Delete,
                                          Icons.delete, "Delete"),
                                    ]);
                                  },
                                  onSelected: (ContextOption value) {
                                    switch (value) {
                                      case ContextOption.Edit:
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    withFirebase(Consumer(
                                                        builder: (context,
                                                                Auth auth, _) =>
                                                            ArticleEditor(
                                                                article["id"],
                                                                auth)))));
                                        break;
                                      case ContextOption.Stats:
                                        break;
                                      case ContextOption.Delete:
                                        auth.store
                                            .collection("article")
                                            .document(article["id"])
                                            .delete();
                                        break;
                                      default:
                                        break;
                                    }
                                  },
                                ),
                              )),
                        ],
                      ),
                    ));
                  }, childCount: _articles.length, semanticIndexOffset: 1)),
                ),
        ],
      ),
    );
  }
}

PopupMenuItem<ContextOption> contextMenuItem(
        ContextOption value, IconData icon, String choice) =>
    PopupMenuItem<ContextOption>(
        value: value,
        child: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(choice),
            ),
          ],
        ));

enum ContextOption { Edit, Stats, Delete, Publish, Unpublish }
