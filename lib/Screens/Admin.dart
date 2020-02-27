import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ArticleManager.dart';
import 'package:atc_admin/widgets/appbar.dart';
import 'package:atc_admin/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import '../widgets/greetings_header.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  var _channels, _articles, _shop, _events, _ready = false;
  Auth auth;

  void fetchCount() async {
    int _c = await auth.store
        .collection("charmainetv")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.length);
    int _a = await auth.store
        .collection("article")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.length);
    int _s = await auth.store
        .collection("shop")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.length);
    int _e = await auth.store
        .collection("event")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.length);

    setState(() {
      _channels = _c;
      _articles = _a;
      _shop = _s;
      _events = _e;
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<Auth>(context);
    fetchCount();
    return Scaffold(
        key: _scaffold,
        appBar: CustomAppBar(),
        resizeToAvoidBottomInset: true,
        drawer: CustomDrawer(),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("Assets/admin-bg.png"),
              fit: BoxFit.cover,
            )),
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0x99ffffff),
              ),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: GreetingsHeader(),
                  ),
                  !_ready
                      ? SliverFillRemaining(
                          child: JumpingDotsProgressIndicator(
                            color: Color(0xffe29464),
                            fontSize: 70.0,
                            dotSpacing: 7,
                            numberOfDots: 4,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              AdminItem(
                                color: 0xff446688,
                                item: "Charmaine TV",
                                details: "$_channels channels",
                                onTap: () {
                                  print("Pressed");
                                },
                              ),
                              AdminItem(
                                color: 0xff886644,
                                item: "Charmaine Articles",
                                details: "$_articles posts",
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          withFirebase(ArticleManager())));
                                },
                              ),
                              AdminItem(
                                color: 0xff664488,
                                item: "Charmaine Shop",
                                details: "$_shop products",
                              ),
                              AdminItem(
                                color: 0xff448866,
                                item: "Charmaine Events",
                                details: "$_events events",
                              ),
                            ],
                          ),
                        )
                ],
              ),
            )));
  }
}

class AdminItem extends StatelessWidget {
  final String item, details;
  final Function onTap;
  final int color;
  const AdminItem({Key key, this.item, this.details, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          child: Padding(
            padding: EdgeInsets.only(right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(item,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "SFUIDisplay",
                        fontWeight: FontWeight.bold)),
                Text(
                  details,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "SFUIDisplay"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
