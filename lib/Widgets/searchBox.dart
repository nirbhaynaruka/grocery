import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Store/cart.dart';
import 'package:provider/provider.dart';

import '../Store/Search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool logincheck = false;

  @override
  void initState() {
    checklogin();
    super.initState();
  }

  checklogin() async {
    if (await EcommerceApp.auth.currentUser() != null) {
      setState(() {
        logincheck = true;
      });
    } else {
      setState(() {
        logincheck = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Nature Coop Fresh",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: Icon(Icons.shopping_basket, color: Colors.white),
                    onPressed: () {
                      // checklogin();
                      if (logincheck) {
                        Route route =
                            MaterialPageRoute(builder: (c) => CartPage());
                        Navigator.push(context, route);
                      } else {
                        Route route = MaterialPageRoute(
                            builder: (_) => AuthenticScreen());
                        Navigator.push(context, route);
                      }
                    }),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 6.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              logincheck
                                  ? (EcommerceApp.sharedPreferences
                                              .getStringList(
                                                  EcommerceApp.userCartList)
                                              .length -
                                          1)
                                      .toString()
                                  : "0",
                              style: TextStyle(
                                color: Color(0xff94b941),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        body: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(builder: (c) => SearchProduct());
            Navigator.push(context, route);
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            // height: 40,
            // color: Color(0xff94b941),
            // alignment: Alignment.center,
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
        ),
      ),
    );
  }
}

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
