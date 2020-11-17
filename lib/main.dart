import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
          title: 'Nature Coop Fresh',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    displaySplash();
    super.initState();
  }

  displaySplash() {
    Timer(Duration(seconds: 2), () async {
      Route route = MaterialPageRoute(builder: (_) => StoreHome());
      Navigator.pushReplacement(context, PageRouteBuilder(
    pageBuilder: (_, __, ___) => StoreHome(),
    transitionDuration: Duration(seconds: 0),
  ),).then((value) => setState(() {}));
      // if (await EcommerceApp.auth.currentUser() != null) {
      //   Route route = MaterialPageRoute(builder: (_) => StoreHome());
      //   Navigator.pushReplacement(context, route);
      // } else {
      //   Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
      //   Navigator.pushReplacement(context, route);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Color(0xfffffff8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "assets/icons/new_logo_white.jpg",
                  height: 220.0,
                  width: 220.0,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: SpinKitFadingCube(
                  color: Color(0xff6d882f),
                  size: 65.0,
                  duration: Duration(seconds: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
