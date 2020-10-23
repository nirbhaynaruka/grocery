import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminLogin.dart';
import 'package:grocery/Admin/uploadItems.dart';
import 'package:grocery/Widgets/customTextField.dart';
import 'package:grocery/DialogBox/errorDialog.dart';
import 'package:grocery/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:grocery/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/login.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person_pin,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              width: 100.0,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  _emailTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please write Email and Password",
                            );
                          });
                },
                elevation: 5.0,
                color: Color(0xff94b941),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(height: 10.0),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: (Icon(
                Icons.nature_people,
                size: 30,
                color: Color(0xff94b941),
              )),
              label: Text(
                "I'm Admin",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff94b941),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait...",
          );
        });

    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        // Navigator.pop(context);

        Route route = MaterialPageRoute(
            builder: (c) =>
                // EcommerceApp.sharedPreferences
                //               .getString(EcommerceApp.userName) == "Sudhanshu" ? UploadPage() :
                StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences
          .setString("email", dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences
          .setString("name", dataSnapshot.data[EcommerceApp.userName]);
      // await EcommerceApp.sharedPreferences.setString("url", userImageUrl);
      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
