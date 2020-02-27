import 'package:flutter/material.dart';

class ManagerHeader extends SliverPersistentHeaderDelegate {
  final String title;
  ManagerHeader(this.title);
  @override
  Widget build(BuildContext context, double offset, bool overlaps) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xffcccccc),
                    blurRadius: 4,
                    offset: Offset(0, 3))
              ]),
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(child: Icon(Icons.arrow_back)),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(title,
                    style: TextStyle(
                        fontFamily: "SFUIDisplay",
                        fontSize: 35,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        );
      },
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 70.0;
  double get minExtent => 70.0;
}
