import 'dart:async';

import 'package:atc_admin/Auth/auth.dart';
import 'package:atc_admin/Screens/CreateChannel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ChannelManager extends StatefulWidget {
  final Auth auth;
  final Map<String, dynamic> data;
  ChannelManager(this.auth, this.data);
  @override
  _ChannelManagerState createState() => _ChannelManagerState();
}

class _ChannelManagerState extends State<ChannelManager> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> _videos = [];
  void fetchVideos() {
    subscription = widget.auth.store
        .collection("charmainetv/${widget.data['id']}/videos")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.documents
          .sort((a, b) => b.data["createdAt"].compareTo(a.data["createdAt"]));

      setState(() {
        _videos = snapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateChannel(widget.data["id"])));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 1,
          title: Text(
            widget.data["categoryName"],
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
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: _videos.length > 0
            ? CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  _videos == null
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
                            var channel = _videos[index].data;
                            channel["id"] = _videos[index].documentID;

                            return Card(
                                child: Container(
                              height: 250,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      constraints: BoxConstraints.expand(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(5)),
                                        child: FutureBuilder(builder: (_,
                                            AsyncSnapshot<Widget> snapshot) {
                                          return snapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : snapshot.data;
                                        }, future: (() async {
                                          dynamic url = channel['thumbnailUrl'];

                                          return Stack(
                                            children: <Widget>[
                                              Image.network(
                                                url,
                                                fit: BoxFit.cover,
                                              ),
                                              Center(
                                                  child: CircleAvatar(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.black,
                                                ),
                                                backgroundColor:
                                                    Color(0xaaaaaaaa),
                                                radius: 25,
                                              )),
                                            ],
                                            fit: StackFit.expand,
                                          );
                                        })()),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 0, 10, 20),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8.0, 0, 8.0),
                                            child: Text(channel["title"],
                                                style: TextStyle(
                                                  fontSize: 23,
                                                )),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child:
                                                PopupMenuButton<ContextOption>(
                                              itemBuilder: (context) {
                                                return ([
                                                  contextMenuItem(
                                                      ContextOption.Delete,
                                                      Icons.delete,
                                                      "Delete"),
                                                ]);
                                              },
                                              onSelected:
                                                  (ContextOption value) {
                                                switch (value) {
                                                  case ContextOption.Delete:
                                                    widget.auth.store
                                                        .collection(
                                                            "charmainetv/${widget.data['id']}/videos")
                                                        .document(channel["id"])
                                                        .delete();
                                                    break;
                                                }
                                              },
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                          },
                                  childCount: _videos.length,
                                  semanticIndexOffset: 1)),
                        ),
                ],
              )
            : Center(
                child: Text("No videos have been created yet",
                    style: TextStyle(color: Color(0xffaaaaaa), fontSize: 23)),
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
