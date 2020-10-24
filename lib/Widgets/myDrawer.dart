import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Authentication/login.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Address/addAddress.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Orders/myOrders.dart';
import 'package:grocery/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyDrawer());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyDrawer(),
//     );
//   }
// }

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
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            // decoration: new BoxDecoration(
            //   gradient: new LinearGradient(
            //     colors: [Colors.pink, Colors.lightGreenAccent],
            //     begin: const FractionalOffset(0.0, 0.0),
            //     end: const FractionalOffset(1.0, 0.0),
            //     stops: [0.0, 1.0],
            //     tileMode: TileMode.clamp,
            //   ),
            // ),
            child: Column(
              children: [
                // Material(
                //   borderRadius: BorderRadius.all(Radius.circular(80.0)),
                //   elevation: 8.0,
                //   child: Container(
                //     height: 160.0,
                //     width: 160.0,
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         EcommerceApp.sharedPreferences
                //             .getString(EcommerceApp.userAvatarUrl),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 30.0),
                Text(
                  logincheck ? EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName
                      ) : "Hello User",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontFamily: "Signatra"),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.0),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            // decoration: new BoxDecoration(
            //   gradient: new LinearGradient(
            //     colors: [Colors.pink, Colors.lightGreenAccent],
            //     begin: const FractionalOffset(0.0, 0.0),
            //     end: const FractionalOffset(1.0, 0.0),
            //     stops: [0.0, 1.0],
            //     tileMode: TileMode.clamp,
            //   ),
            // ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if(logincheck){

                    Route route = MaterialPageRoute(builder: (c) => MyOrders());
                    Navigator.push(context, route);
                    }
                    else{
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if(logincheck){

                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                    }
                    else{
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if(logincheck){

                    Route route = MaterialPageRoute(builder: (c) => AddAddress());
                    Navigator.push(context, route);
                    }
                    else{
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.all_out,
                    color: Colors.white,
                  ),
                  title: Text(
                    logincheck
                        ? "LogOut"
                        : "LogIn/SignUp",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // checklogin();
                    if (logincheck) {
                      EcommerceApp.auth.signOut().then((c) {
                        Route route =
                            MaterialPageRoute(builder: (c) => SplashScreen());
                        Navigator.pushReplacement(context, route);
                      });
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (_) => AuthenticScreen());
                      Navigator.push(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
