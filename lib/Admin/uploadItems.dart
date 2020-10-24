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
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();

  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shorttextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  List<String> categories = [
    'Beauty & Hygeine',
    'Beverages and Snacks',
    'Cleaning & Household',
    'Cooking Essentials',
    'Dairy Products',
    'Fruits & Vegetables',
    'Packaged Foods',
    'Miscellaneous'
  ]; // Option 2
  String _selectedcategory = "Select a Category";

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
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
        leading: IconButton(
            icon: Icon(
              Icons.border_color,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => AdminShiftOrders());
              Navigator.push(context, route);
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

  displayAdminUploadScreen() {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: clearFormInfo),
          title: Text("New product", style: TextStyle(color: Colors.white)),
          actions: [
            FlatButton(
                onPressed:
                    uploading ? null : () => uploadImageandSaveItemInfo(),
                child: Text("add",
                    style: TextStyle(
                      color: Colors.green,
                    ))),
          ]),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text("data"),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
                width: 250.0,
                child: TextField(
                  maxLength: 20,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  controller: _shorttextEditingController,
                  
                  decoration: InputDecoration(
                    hintText: "short",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                )),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
                width: 250.0,
                child: TextField(
                  maxLength: 20,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  controller: _titletextEditingController,
                  decoration: InputDecoration(
                    hintText: "title",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                )),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: DropdownButton(
              // value: _selectedcategory,
              items: categories.map((val) {
                return DropdownMenuItem(
                  child: Text(val),
                  value: val,
                );
              }).toList(),
              hint: Text("$_selectedcategory"), // Not necessary for Option 1
              onChanged: (val) {
                // setState(() {
                _selectedcategory = val;
                // });
                this.setState(() {});
              },
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  controller: _descriptiontextEditingController,
                  decoration: InputDecoration(
                    hintText: "description",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                )),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                  ),
                  controller: _pricetextEditingController,
                  decoration: InputDecoration(
                    hintText: "price",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                )),
          ),
          Divider(
            color: Colors.pink,
          )
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _selectedcategory = "Select a Category";
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _shorttextEditingController.clear();
      _titletextEditingController.clear();
    });
  }

  uploadImageandSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveiteminfo(imageDownloadUrl);
    saveiteminfoitems(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mfileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask =
        storageReference.child("product $productId.jpg").putFile(mfileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

 Future saveiteminfo(String downloadUrl) async {
    final itemStore = await Firestore.instance.collection("items");
    itemStore.document(productId).setData({
      "shortInfo": _shorttextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titletextEditingController.text.trim(),
      "catname": _selectedcategory,
    });
    final itemsRef = await Firestore.instance.collection("$_selectedcategory");
    itemsRef.document(productId).setData({
      "shortInfo": _shorttextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titletextEditingController.text.trim(),
      "catname": _selectedcategory,
    });
    setState(() {
      file = null;
      _selectedcategory = "Select a Category";
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _shorttextEditingController.clear();
      _titletextEditingController.clear();
    });
  }

  saveiteminfoitems(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo": _shorttextEditingController.text.trim(),
      "longDescription": _descriptiontextEditingController.text.trim(),
      "price": int.parse(_pricetextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titletextEditingController.text.trim(),
      "catname": _selectedcategory,
    });
    setState(() {
      file = null;
      _selectedcategory = "Select a Category";
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _shorttextEditingController.clear();
      _titletextEditingController.clear();
    });
  }
}
