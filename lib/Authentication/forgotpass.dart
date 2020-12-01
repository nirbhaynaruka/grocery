import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<void> resetPassword(String email) async {
    try {
        await _auth.sendPasswordResetEmail(email: email).then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Check your email to reset password.");
    });
    } catch (e) {
      if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
      Fluttertoast.showToast(msg: "Email not found");

      } else {
      Fluttertoast.showToast(msg: "Some error occured.");
      }
      print(e);
    }
  
  }

  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            "Forgot Password",
            style: TextStyle(
              letterSpacing: 1.3,
              color: Colors.white,
              fontFamily: "Folks-Heavy",
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 30.0),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/icons/transparent_new_logo_white.png",
                    height: 220.0,
                    width: 220.0,
                  ),
                ),
                // SizedBox(height: 20.0),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: _emailTextEditingController,
                        data: Icons.email,
                        hintText: "Email",
                        isObsecure: false,
                      ),
                      // CustomTextField(
                      //   controller: _passwordTextEditingController,
                      //   data: Icons.person_pin,
                      //   hintText: "Password",
                      //   isObsecure: true,
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  // width: 100.0,
                  height: 40.0,
                  child: RaisedButton(
                    onPressed: () async {
                      _emailTextEditingController.text.isNotEmpty
                          ? resetPassword(_emailTextEditingController.text)
                          : error();
                    },
                    elevation: 5.0,
                    color: Color(0xff94b941),
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),

                Container(
                  height: 4.0,
                  width: _screenWidth * 0.5,
                  color: Colors.grey.withOpacity(0.5),
                ),
                // SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

error() {
  Fluttertoast.showToast(msg: "Invalid EmaiL Id.");
}
