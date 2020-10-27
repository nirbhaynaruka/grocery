import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Widgets/customTextField.dart';
import 'package:grocery/DialogBox/errorDialog.dart';
import 'package:grocery/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:grocery/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _phoneTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // String userImageUrl = "";
  // File _imageFile;
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/icons/new_logo_white.jpg",
                height: 220.0,
                width: 220.0,
              ),
            ),
            // InkWell(
            //   onTap: () => _selectAndPickImage,
            //   child: CircleAvatar(
            //     radius: _screenWidth * 0.15,
            //     backgroundColor: Colors.white,
            //     backgroundImage:
            //         _imageFile == null ? null : FileImage(_imageFile),
            //     child: _imageFile == null
            //         ? Icon(
            //             Icons.add_photo_alternate,
            //             size: _screenWidth * 0.15,
            //             color: Colors.grey,
            //           )
            //         : null,
            //   ),
            // ),
            SizedBox(height: 8.0),
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _phoneTextEditingController,
                    data: Icons.phone,
                    hintText: "Mobile Number",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100.0,
              height: 40.0,
              child: RaisedButton(
                onPressed: () {
                  uploadandsaveimage();
                },
                elevation: 5.0,
                color: Color(0xff94b941),
                child: Text(
                  "Sign Up",
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
          ],
        ),
      ),
    );
  }

  // Future<void> _selectAndPickImage() async {
  //   _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  // }

  Future<void> uploadandsaveimage() async {
    // if (_imageFile == null) {
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return ErrorAlertDialog(
    //           message: "please select an image",
    //         );
    //       });
    // } else {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isEmpty
            ? uploadtostorage()
            : uploadtostorage()
        // : displayDialog("please fill up the complete form...")
        : displayDialog("password do not match");
    // }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadtostorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "äuthenticating please wait..",
          );
        });

    // String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(imageFileName);
    // StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    // StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    // await taskSnapshot.ref.getDownloadURL().then((urlImage) {
    //     userImageUrl = urlImage;
    //   });
    _registerUser();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
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
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushAndRemoveUntil(context, route, (route) => false).then((value) => setState(() {}));
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "phone": "+91" + _phoneTextEditingController.text,
      // "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString("email", fUser.email);
    await EcommerceApp.sharedPreferences
        .setString("name", _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences
        .setString("phone", "+91" + _phoneTextEditingController.text);
    // await EcommerceApp.sharedPreferences.setString("url", userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
