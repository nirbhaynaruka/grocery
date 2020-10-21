import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminShiftOrders.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  @override
  Widget build(BuildContext context) {
    return displayAdminHomeScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
            icon: Icon(
              Icons.border_color,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            }),
        actions: [
          FlatButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.pink),
              )),
        ],
      ),
      body: getAdminHomeScreen(),
    );
  }

  getAdminHomeScreen() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.amber,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () => takeImage(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child:
                    Text("Add New item", style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "item image",
              style: TextStyle(color: Colors.green),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "capture with camera",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: capturPhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "capture with gallery",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: capturPhotoWithGallery,
              ),
              SimpleDialogOption(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  capturPhotoWithCamera() async {
    Navigator.pop(context);

    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0);
    setState(() {
      file = imageFile;
    });
  }

  capturPhotoWithGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }
}
