import 'package:flutter/material.dart';

PreferredSizeWidget CustomAppBar() => AppBar(
      elevation: 0,
      title: Text(
        "Charmaine",
        style: TextStyle(
            color: Colors.white, fontFamily: "SFUIDisplay", fontSize: 25),
      ),
      centerTitle: true,
      backgroundColor: Color(0xffe29464),
      leading: Image.asset(
        "Assets/hamb-menu.png",
        height: 50,
        width: 50,
        color: Color(0xffffffff),
      ),
    );
