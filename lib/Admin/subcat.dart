import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/Admin/adminShiftOrders.dart';
import 'package:grocery/Admin/admindrawer.dart';
import 'package:grocery/Admin/edititems.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:grocery/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Subcat extends StatefulWidget {
  @override
  _SubcatState createState() => _SubcatState();
}

class _SubcatState extends State<Subcat>
    with AutomaticKeepAliveClientMixin<Subcat> {
  bool get wantKeepAlive => true;
  File file;

  bool uploading = false;
  int _user = 0;
  var categories = <String>[
    'Fruits and Vegetables',
    'Household Supplies',
    'Personal Care',
    'Cooking Essentials',
    'Packaged Foods',
    'Baby Products',
    'Beverage',
    'Pet Care',
    'Dairy Products',
    'Bakery',
    'Plant Care'
  ]; // Option 2
  String _selectedcategory = "Select a Category";
  String _selectedsubcategory = "Select a SubCategory";
  static List<List<String>> subcategories = [
    ['Fresh Vegetables', 'Fresh Fruits'],
    ['Laundry Detergent', 'Household Cleaning', 'Hand Hygeinie & Masks','Kitchen Supplies','Tissues & more'],
    ['Bath & Body', 'Hair Care', 'Skin Care','Deodrant','Makeup & accessories'],
    ['Atta & Flour', 'Rice', 'Salt, Spices & Sugar','Oils & Ghee','Dals & Pulses','Others'],
    ['Dry Fruits', 'Biscuits & Snacks', 'Breakfast Food','Beverages','Noodles & Pasta','Spread & Ketchup','Chocolates & Cake','Others'],
    ['Baby Bath & Body', 'Baby Food', 'Diapers & Wipes'],
    ['Tea', 'Coffee', 'Health Drinks','Soft Drinks','Juices'],
    ['Pet food', 'Pet supplement', 'Pet toy & Accessories'],
    ['Milk','Paneer','Buttermilk','Curd'],
    ['Bread','Rusk','Paaw'],
    ['']
  ];

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return WillPopScope(
      onWillPop: () async => false,
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
        ),
        body: getAdminHomeScreen(),
      ),
    );
  }

  getAdminHomeScreen() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () => takeImage(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child:
                    Text("Add Categories Images", style: TextStyle(color: Colors.white)),
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
              "Item image",
              style: TextStyle(color: Colors.green),
            ),
            children: [
         
              SimpleDialogOption(
                child: Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: capturPhotoWithGallery,
              ),
            ],
          );
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
                child: Text("Add",
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
                _user = categories.indexOf(val);

                // });
                this.setState(() {});
              },
            ),
          ),
          Divider(
            color: Colors.pink,
          ),

          ///[for sub category]

          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: DropdownButton(
              // value: _selectedcategory,
              items: subcategories[_user].map((subval) {
                return DropdownMenuItem(
                  child: Text(subval),
                  value: subval,
                );
              }).toList(),
              hint: Text("$_selectedsubcategory"),
              onChanged: (subval) {
                // setState(() {
                _selectedsubcategory = subval;
                // });
                this.setState(() {});
              },
            ),
          ),

          ///[for sub category]

          Divider(
            color: Colors.pink,
          ),
        
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _user = 0;
      _selectedcategory = "Select a Category";
      _selectedsubcategory = "Select a SubCategory";

    });
  }

  uploadImageandSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveiteminfo(imageDownloadUrl);
    // saveiteminfoitems(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mfileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("category");
    StorageUploadTask uploadTask =
        storageReference.child("$_selectedcategory $_selectedsubcategory.jpg").putFile(mfileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future saveiteminfo(String downloadUrl) async {
    final itemStore = await Firestore.instance.collection("category").document(_selectedcategory).collection("subcategory");
    itemStore.document(_selectedsubcategory).setData({
      "subcatthumbnail": downloadUrl,
      "catname": _selectedcategory,
      "subcatname": _selectedsubcategory
    });
    setState(() {
      file = null;
      _selectedcategory = "Select a Category";
      _selectedsubcategory = "Select a SubCategory";
      uploading = false;
    });
  }
}
