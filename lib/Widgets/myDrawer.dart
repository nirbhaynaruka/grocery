import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Address/defaultAddress.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/aboutus.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Orders/myOrders.dart';
import 'package:grocery/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyDrawer());
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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

  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 20.0),
            // height: MediaQuery.of(context).size.height,
            height: 100.0,
            decoration: new BoxDecoration(
              color: Color(0xff94b941),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  logincheck
                      ? "Welcome, "+EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userName)
                      : "Hello, User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontFamily: "Arial Bold",
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 12.0),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            height: MediaQuery.of(context).size.height - 150,
            decoration: new BoxDecoration(
              color: Color(0xfffffff8),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => StoreHome(),
    transitionDuration: Duration(seconds: 0),
  ),);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Color(0xfffffff8),
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    if (logincheck) {
                      Route route =
                          MaterialPageRoute(builder: (c) => MyOrders());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => MyOrders(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => AuthenticScreen(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Color(0xfffffff8),
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    if (logincheck) {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => CartPage(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => AuthenticScreen(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color:Color(0xfffffff8),
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => SearchProduct(),
    transitionDuration: Duration(seconds: 0),
  ),);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Color(0xfffffff8),
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    if (logincheck) {
                      Route route =
                          MaterialPageRoute(builder: (c) => DefultAddress());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => DefultAddress(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => AuthenticScreen(),
    transitionDuration: Duration(seconds: 0),
  ),);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Color(0xfffffff8),
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.perm_device_info_rounded,
                    color: Colors.black,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                     Route route =
                          MaterialPageRoute(builder: (c) => Aboutus());
                      Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => Aboutus(),
    transitionDuration: Duration(seconds: 0),
  ),);
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(left:10.0, right: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xff94b941),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      height: 60,
                      child: ListTile(
                        leading: Icon(
                          Icons.all_out,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        title: Text(
                          logincheck ? "Logout" : "Login / Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: "Arial Bold",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // checklogin();
                          if (logincheck) {
                            EcommerceApp.auth.signOut().then((c) {
                              Route route = MaterialPageRoute(
                                  builder: (c) => SplashScreen());
                              Navigator.pushReplacement(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => SplashScreen(),
    transitionDuration: Duration(seconds: 0),
  ),);
                            });
                          } else {
                            Route route = MaterialPageRoute(
                                builder: (_) => AuthenticScreen());
                            Navigator.push(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => AuthenticScreen(),
    transitionDuration: Duration(seconds: 0),
  ),);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
