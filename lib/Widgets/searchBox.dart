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
          Navigator.pushReplacement(context, route);
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0),
              width: MediaQuery.of(context).size.width,
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search, color: Colors.blueGrey)),
                Padding(
                    padding: EdgeInsets.only(left: 8.0), child: Text("search")),
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
