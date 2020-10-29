import 'package:flutter/material.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/cart.dart';
import 'package:provider/provider.dart';

class SubCategoryPage extends StatefulWidget {
  final ItemModel itemModel;

  const SubCategoryPage({Key key, this.itemModel}) : super(key: key);

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
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
            widget.itemModel.catname,
            style: TextStyle(
              // fontSize: 25.0,
              // fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                      icon: Icon(Icons.shopping_basket, color: Colors.white),
                      onPressed: () {
                        checklogin();
                        if (logincheck) {
                          // Route route =
                          //     MaterialPageRoute(builder: (c) => CartPage());
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => CartPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        } else {
                          // Route route = MaterialPageRoute(
                          //     builder: (_) => AuthenticScreen());
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => AuthenticScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        }
                      }),
                ),
                Positioned(
                  top: 5.0,
                  right: 8.0,
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
        floatingActionButton: Transform.scale(
          scale: 1.1,
          child: FloatingActionButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SearchProduct());
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchProduct(),
                  transitionDuration: Duration(seconds: 0),
                ),
              );
            },
            elevation: 5,
            backgroundColor: Color(0xff94b941),
            splashColor: Color(0xffdde8bd),
            child: Icon(Icons.search, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
