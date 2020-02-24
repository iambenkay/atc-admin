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
        resizeToAvoidBottomInset: true,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                  child: CloseButton(),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(25, 25, 0, 0))
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
            child: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Image.asset(
                            "Assets/hamb-menu.png",
                            height: 50,
                            width: 50,
                            color: Color(0xffe29464),
                          ),
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            _scaffold.currentState.openDrawer();
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: AssetImage("Assets/avatar.png"),
                            radius: 28,
                          ),
                        )
                      ],
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 10, 30),
                  child: Text(
                    "Goodday, Benjamin!",
                    style: TextStyle(
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  height: 150,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Manage Charmaine TV",
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
                  decoration: BoxDecoration(
                      color: Color(0xffbbbbbb),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Color(0xffbbbbbb),
                          style: BorderStyle.solid,
                          width: 1)),
                )
              ],
            )));
  }
}
