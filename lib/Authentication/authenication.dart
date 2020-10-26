import 'package:flutter/material.dart';
// import 'package:grocery/Authentication/loginWithPhone.dart';
import 'login.dart';
import 'register.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          bottom: TabBar(
            // unselectedLabelColor: Color(0xffb9d17f),
            labelStyle: TextStyle(
              fontFamily: "Arial Bold",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              // Tab(
              //   text: "Phone Login",
              // ),
              Tab(
                text: "Email Login",
              ),
              Tab(
                text: "Register",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfffffff8),
          ),
          child: TabBarView(
            children: [
              // LoginScreen(),
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
