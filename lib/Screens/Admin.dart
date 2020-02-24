import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Charmaine",
            style: TextStyle(
                color: Colors.white, fontFamily: "SFUIDisplay", fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffe29464),
          leading: GestureDetector(
            child: Image.asset(
              "Assets/hamb-menu.png",
              height: 50,
              width: 50,
              color: Color(0xffffffff),
            ),
            onTap: () {
              _scaffold.currentState.openDrawer();
            },
          ),
        ),
        resizeToAvoidBottomInset: true,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                  child: CloseButton(),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0))
            ],
          ),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("Assets/admin-bg.png"),
              fit: BoxFit.cover,
            )),
            child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0x99ffffff),
                ),
                child: ListView(
                  children: <Widget>[
                    Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 3,
                        child: Container(
                            height: 220,
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "24th February",
                                          style: TextStyle(
                                              fontFamily: "SFUIDisplay",
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                AssetImage("Assets/avatar.png"),
                                            radius: 23,
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ]),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      EdgeInsets.only(left: 20, bottom: 20),
                                  child: Text(
                                    "Welcome, Benjamin!",
                                    style: TextStyle(
                                        fontFamily: 'SFUIDisplay',
                                        fontSize: 28),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                child: Icon(Icons.show_chart))),
                                        Expanded(
                                            child: Container(
                                                child: Icon(
                                                    Icons.panorama_fish_eye))),
                                        Expanded(
                                            child: Container(
                                                child:
                                                    Icon(Icons.all_inclusive))),
                                      ],
                                    )),
                              ],
                            ))),
                    Card(
                      color: Color(0xff446688),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Charmaine TV",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "SFUIDisplay",
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "50 Channels",
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
                    Card(
                      color: Color(0xff886644),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Charmaine Articles",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "SFUIDisplay",
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "50 Channels",
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
                    Card(
                      color: Color(0xff448866),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Charmaine Shop",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "SFUIDisplay",
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "50 Channels",
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
                    Card(
                      color: Color(0xff664488),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Charmaine Events",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "SFUIDisplay",
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "50 Channels",
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
                  ],
                ))));
  }
}
