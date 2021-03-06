import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/uploadItems.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Widgets/customTextField.dart';
import 'package:grocery/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xfffffff8),
          ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/icons/transparent_new_logo_white.png",
                height: 220.0,
                width: 220.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Text(
                "Only Admins",
                style: TextStyle(
                  color: Color(0xff94b941),
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Arial Bold",
                ),
              ),
            ),
            SizedBox(height: 15),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data: Icons.person,
                    hintText: "Admin-ID",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: _screenWidth* 0.40,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  _adminIDTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginAdmin()
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
                  "Login Admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 4.0,
              width: _screenWidth * 0.5,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(height: 10.0),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: (Icon(
                Icons.nature_people,
                color: Color(0xff94b941),
                size: 25,
              )),
              label: Text(
                "I'm not Admin",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xff94b941),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data["id"] != _adminIDTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your ID is not Correct...!"),
          ));
        } else if (result.data["password"] !=
            _passwordTextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your password is incorrect...!"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Dear Admin," + result.data["name"]),
          ));

          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
