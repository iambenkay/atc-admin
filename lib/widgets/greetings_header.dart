import 'package:flutter/material.dart';

class GreetingsHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double offset, bool overlaps) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DateTime _dateTime = DateTime.now();
        final months = <String>[
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December"
        ];
        String _greetings = "Welcome, Benjamin!",
            _date = "${months[_dateTime.month - 1]}, ${_dateTime.day}";
        return Card(
            margin: EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: Container(
                height: constraints.maxHeight,
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              _date,
                              style: TextStyle(
                                  fontFamily: "SFUIDisplay",
                                  fontSize: 25,
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
                                radius: 20,
                              ),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ]),
                    Visibility(
                      visible: offset < 65,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          _greetings,
                          style: TextStyle(
                              fontFamily: 'SFUIDisplay', fontSize: 28),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: offset < 10,
                      child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child:
                                      Container(child: Icon(Icons.show_chart))),
                              Expanded(
                                  child: Container(
                                      child: Icon(Icons.panorama_fish_eye))),
                              Expanded(
                                  child: Container(
                                      child: Icon(Icons.all_inclusive))),
                            ],
                          )),
                    ),
                  ],
                )));
      },
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 220.0;
  double get minExtent => 100.0;
}
