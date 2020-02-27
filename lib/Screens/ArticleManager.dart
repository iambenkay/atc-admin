import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/widgets/appbar.dart';
import 'package:atc_admin/widgets/drawer.dart';
import 'package:atc_admin/widgets/manager_headers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class ArticleManager extends StatefulWidget {
  @override
  _ArticleManagerState createState() => _ArticleManagerState();
}

class _ArticleManagerState extends State<ArticleManager> {
  Auth auth;
  List<DocumentSnapshot> _articles;
  void fetchArticles() async {
    final _a = await auth.store
        .collection("article")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents);

    setState(() {
      _articles = _a;
    });
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<Auth>(context);
    fetchArticles();
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPersistentHeader(
              delegate: ManagerHeader("Articles"), pinned: true),
          _articles == null
              ? SliverFillRemaining(
                  child: JumpingDotsProgressIndicator(
                    color: Color(0xffe29464),
                    fontSize: 70.0,
                    dotSpacing: 7,
                    numberOfDots: 4,
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                  var article = _articles[index].data;

                  return Card(
                      child: Container(
                        child: Row(
                    children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[],
                          ),
                        )
                    ],
                  ),
                      ));
                  return Card(
                    child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        subtitle: Text(
                            article["description"].substring(0, 150) + "...",
                            style: TextStyle(
                              fontFamily: "SFUIDisplay",
                            )),
                        title: Text(article["title"],
                            style: TextStyle(
                                fontFamily: "SFUIDisplay",
                                fontSize: 30,
                                fontWeight: FontWeight.bold))),
                  );
                }, childCount: _articles.length, semanticIndexOffset: 1)),
        ],
      ),
    );
  }
}
