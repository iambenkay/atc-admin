import 'dart:async';

import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/ChannelManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class TvManager extends StatefulWidget {
  final Auth auth;
  TvManager(this.auth);
  @override
  _TvManagerState createState() => _TvManagerState();
}

class _TvManagerState extends State<TvManager> {
  bool _creating = false;
  TextEditingController _channelName = TextEditingController(text: "");
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> _channels;
  void fetchChannels() {
    subscription = widget.auth.store
        .collection("charmainetv")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.documents
          .sort((a, b) => b.data["createdAt"].compareTo(a.data["createdAt"]));

      setState(() {
        _channels = snapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
    _channelName.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: _creating ? Colors.red : null,
          onPressed: () {
            setState(() {
              _creating = !_creating;
              if (!_creating) {
                _channelName.text = "";
              }
            });
          },
          child: Icon(
            _creating ? Icons.close : Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Channels",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
            ),
          ),
          backgroundColor: Color(0xffffffff),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: InkWell(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: _creating
                  ? Card(
                      child: Container(
                      height: 70,
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  decoration:
                                      BoxDecoration(color: Color(0xff112233)),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 9,
                                              child: TextField(
                                                autocorrect: true,
                                                controller: _channelName,
                                                onChanged: (_) {
                                                  setState(() {});
                                                },
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(5),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                  hintText: "Channel name",
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: FlatButton(
                                                disabledTextColor:
                                                    Color(0xff888888),
                                                textColor: Colors.white,
                                                onPressed: _channelName.text ==
                                                        ""
                                                    ? null
                                                    : () async {
                                                        setState(() {
                                                          _creating =
                                                              !_creating;
                                                        });
                                                        await widget.auth.store
                                                            .collection(
                                                                "charmainetv")
                                                            .add({
                                                          "categoryName":
                                                              _channelName.text,
                                                          "createdAt":
                                                              DateTime.now()
                                                        });
                                                      },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text("ADD"),
                                                ),
                                              ))
                                        ],
                                      ),
                                    )),
                              ],
                            )),
                      ),
                    ))
                  : Container(),
            ),
            _channels == null
                ? SliverFillRemaining(
                    child: JumpingDotsProgressIndicator(
                      color: Color(0xffe29464),
                      fontSize: 70.0,
                      dotSpacing: 7,
                      numberOfDots: 4,
                    ),
                  )
                : _channels.length > 0
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        var channel = _channels[index].data;
                        channel["id"] = _channels[index].documentID;

                        return Card(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ChannelManager(widget.auth, channel)));
                          },
                          child: Container(
                            height: 100,
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: FutureBuilder(builder:
                                    (_, AsyncSnapshot<Widget> snapshot) {
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              snapshot.error == null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xff112233)),
                                            )
                                          : snapshot.data,
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                Color(0xee000000),
                                                Color(0x00999999)
                                              ])),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(channel["categoryName"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                  );
                                }, future: (() async {
                                  dynamic url =
                                      "https://source.unsplash.com/collection/209138/400x100?id=${channel['id']}";

                                  return Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                  );
                                })()),
                              ),
                            ),
                          ),
                        ));
                      }, childCount: _channels.length))
                    : SliverFillRemaining(
                        child: Center(
                          child: Text("No channels have been created",
                              style: TextStyle(
                                  color: Color(0xffaaaaaa), fontSize: 23)),
                        ),
                      ),
          ],
        ));
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

enum ContextOption { Delete }
