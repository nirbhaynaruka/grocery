import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
          Navigator.push(context, route);
        },
        child: Container(
          // height: 40,
          // color: Color(0xff94b941),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 2.0, color: Color(0xff94b941)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 15,
                    color: Color(0xFFB7B7B7).withOpacity(.5),
                  ),
                ],
              ),
              // color: Colors.white,
              height: 50,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search, color: Colors.black)),
                Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Search Item...",
                      style: TextStyle(
                        fontFamily: "Arial Bold",
                        fontSize: 16,
                      ),
                    )),
              ]),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
