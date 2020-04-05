import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ArticleManager.dart';
import 'package:atc_admin/Screens/TvManager.dart';
import 'package:atc_admin/services/asset-provider.dart';
import 'package:atc_admin/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import '../widgets/greetings_header.dart';

class Admin extends StatefulWidget {
  final auth;
  Admin(this.auth);
  @override
  _AdminState createState() => _AdminState(auth);
}

class _AdminState extends State<Admin> {
  Auth auth;
  _AdminState(this.auth);
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  var _channels, _articles, _shop, _events;

  void fetchCount() {
    auth.store
        .collection("charmainetv")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _channels = snapshot.documents.length;
      });
    });
    auth.store
        .collection("article")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        _articles = snapshot.documents.length;
      });
    });
    auth.store.collection("shop").snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        _shop = snapshot.documents.length;
      });
    });
    auth.store.collection("event").snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        _events = snapshot.documents.length;
      });
    });
  }

  void initState() {
    super.initState();
    fetchCount();
  }

  @override
  Widget build(BuildContext context) {
    var _ready = _articles == null ||
            _channels == null ||
            _shop == null ||
            _events == null
        ? false
        : true;
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Charmaine",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffe29464),
          leading: InkWell(
            onTap: () {
              _scaffold.currentState.openDrawer();
            },
            child: Image.asset(
              AssetProvider.hamb_menu,
              height: 50,
              width: 50,
              color: Color(0xffffffff),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        drawer: CustomDrawer(),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(AssetProvider.admin_bg),
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
                                item: "Charmaine TV",
                                details: "$_channels channels",
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          withFirebase(Consumer<Auth>(
                                            builder: (context, Auth auth, _) =>
                                                TvManager(auth),
                                          ))));
                                },
                              ),
                              AdminItem(
                                item: "Charmaine Articles",
                                details: "$_articles posts",
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => withFirebase(
                                          Consumer<Auth>(
                                              builder:
                                                  (context, Auth auth, _) =>
                                                      ArticleManager(auth)))));
                                },
                              ),
                              AdminItem(
                                item: "Charmaine Shop",
                                details: "$_shop products",
                              ),
                              AdminItem(
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
  const AdminItem({Key key, this.item, this.details, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Text(
                  details,
                  style: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
