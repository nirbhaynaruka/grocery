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
                  color: Color(0xff94b941),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Container(
               decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
              color: Colors.white,
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search, color: Colors.black)),
                Padding(
                    padding: EdgeInsets.only(left: 8.0), child: Text("search", style: TextStyle(color: Colors.black),)),
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
