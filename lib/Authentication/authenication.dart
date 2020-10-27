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
              letterSpacing: 1.3,
            color: Colors.white,
            fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            // unselectedLabelColor: Color(0xffb9d17f),
            labelStyle: TextStyle(
              fontFamily: "Folks-Heavy",
              letterSpacing: 1.3,
              fontSize: 16,
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
