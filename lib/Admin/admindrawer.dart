import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:grocery/Admin/adminShiftOrders.dart';
import 'package:grocery/Admin/allorders.dart';
import 'package:grocery/Config/config.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(AdminDrawer());
}

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  // bool logincheck = false;
  @override
  void initState() {
    // checklogin();
    super.initState();
  }

  // checklogin() async {
  //   if (await EcommerceApp.auth.currentUser() != null) {
  //     setState(() {
  //       logincheck = true;
  //     });
  //   } else {
  //     setState(() {
  //       logincheck = false;
  //     });
  //   }
  // }

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
                  // logincheck
                  //     ? "Welcome, "+EcommerceApp.sharedPreferences
                  //         .getString(EcommerceApp.userName)
                  //     : 
                      "Hello, Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
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
                      fontSize: 20.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                   
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
                    "Pending Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    Route route =
                  MaterialPageRoute(builder: (c) => AdminShiftOrders());
              Navigator.push(context, route);

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
                    "Delivered  Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {
                    Route route =
                  MaterialPageRoute(builder: (c) => Allorders());
              Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color:Color(0xfffffff8),
                  thickness: 6.0,
                ),
  //               ListTile(
  //                 leading: Icon(
  //                   Icons.search,
  //                   color: Colors.black,
  //                 ),
  //                 title: Text(
  //                   "Search",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20.0,
  //                     fontFamily: "Arial Bold",
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   Route route =
  //                       MaterialPageRoute(builder: (c) => SearchProduct());
  //                   Navigator.push(context, PageRouteBuilder(
  //   pageBuilder: (_, __, ___) => SearchProduct(),
  //   transitionDuration: Duration(seconds: 0),
  // ),);
  //                 },
  //               ),
                // Divider(
                //   height: 10.0,
                //   color: Color(0xfffffff8),
                //   thickness: 6.0,
                // ),
  //               ListTile(
  //                 leading: Icon(
  //                   Icons.add_location,
  //                   color: Colors.black,
  //                 ),
  //                 title: Text(
  //                   "Add New Address",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 20.0,
  //                     fontFamily: "Arial Bold",
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   if (logincheck) {
  //                     Route route =
  //                         MaterialPageRoute(builder: (c) => DefultAddress());
  //                     Navigator.push(context, PageRouteBuilder(
  //   pageBuilder: (_, __, ___) => DefultAddress(),
  //   transitionDuration: Duration(seconds: 0),
  // ),);
  //                   } else {
  //                     Route route =
  //                         MaterialPageRoute(builder: (_) => AuthenticScreen());
  //                     Navigator.push(context, PageRouteBuilder(
  //   pageBuilder: (_, __, ___) => AuthenticScreen(),
  //   transitionDuration: Duration(seconds: 0),
  // ),);
  //                   }
  //                 },
  //               ),
  //               Divider(
  //                 height: 10.0,
  //                 color: Color(0xfffffff8),
  //                 thickness: 6.0,
  //               ),
                ListTile(
                  leading: Icon(
                    Icons.perm_device_info_rounded,
                    color: Colors.black,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: "Arial Bold",
                    ),
                  ),
                  onTap: () {},
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
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: "Arial Bold",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // checklogin();
                       
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
