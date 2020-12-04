import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Store/cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Store/category.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(Edititems());
}

class Edititems extends StatefulWidget {
  @override
  _EdititemsState createState() => new _EdititemsState();
}

class _EdititemsState extends State<Edititems> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  Future<QuerySnapshot> docList;
  @override
  bool logincheck = false;

  SnackBar get snackBar => null;
  @override
  void initState() {
    checklogin();
    setState(() {});
    super.initState();
  }

  checklogin() async {
    if (await EcommerceApp.auth.currentUser() != null) {
      setState(() {
        logincheck = true;
      });
    } else {
      setState(() {
        logincheck = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
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
          // actions: [
          //   Stack(
          //     children: [
          //       IconButton(
          //           icon: Icon(Icons.shopping_basket, color: Colors.white),
          //           onPressed: () {
          //             // checklogin();
          //             if (logincheck) {
          //               Route route =
          //                   MaterialPageRoute(builder: (c) => CartPage());
          //               Navigator.push(context, route);
          //             } else {
          //               Route route = MaterialPageRoute(
          //                   builder: (_) => AuthenticScreen());
          //               Navigator.push(context, route);
          //             }
          //           }),
          //       Positioned(
          //         child: Stack(
          //           children: [
          //             Icon(
          //               Icons.brightness_1,
          //               size: 20.0,
          //               color: Colors.white,
          //             ),
          //             Positioned(
          //               top: 3.0,
          //               bottom: 4.0,
          //               left: 6.0,
          //               child: Consumer<CartItemCounter>(
          //                 builder: (context, counter, _) {
          //                   return Text(
          //                     logincheck
          //                         ? (EcommerceApp.sharedPreferences
          //                                     .getStringList(
          //                                         EcommerceApp.userCartList)
          //                                     .length -
          //                                 1)
          //                             .toString()
          //                         : "0",
          //                     style: TextStyle(
          //                       color: Color(0xff94b941),
          //                       fontSize: 12.0,
          //                       fontWeight: FontWeight.w500,
          //                     ),
          //                   );
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   )
          // ],
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(60.0, 60.0),
          ),
        ),
        // floatingActionButton: Transform.scale(
        //   scale: 1.2,
        //   child: FloatingActionButton(
        //     onPressed: () => searchWidget(),
        //     elevation: 5,
        //     backgroundColor: Color(0xff94b941),
        //     splashColor: Color(0xffdde8bd),
        //     child: Icon(Icons.search, size: 30),
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.documents[index].data);
                      String pid = snap.data.documents[index].documentID;
                      print(pid);
                      return sourceeditInfo(model, context, pid);
                    },
                  )
                : Center(child: Text("Search Your Product to Edit"));
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 2.0, color: Color(0xff94b941)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 15,
            color: Color(0xFFB7B7B7).withOpacity(.5),
          ),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _searchTextEditingController,
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(
                    hintText: "Search to Edit....",
                    hintStyle: TextStyle(
                      fontFamily: "Arial Bold",
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sourceeditInfo(ItemModel model, BuildContext context, String pid,
      {Color background, removeCartFunction}) {
    Size size;

    ///[.]
    TextEditingController _descriptiontextEditingController =
        TextEditingController();
    TextEditingController _pricetextEditingController = TextEditingController();
    TextEditingController _originalpricetextEditingController =
        TextEditingController();

    TextEditingController _titletextEditingController = TextEditingController();
    TextEditingController _shorttextEditingController = TextEditingController();
    String productId = DateTime.now().millisecondsSinceEpoch.toString();

    setSearchParam(String caseNumber) {
      List<String> caseSearchList = List();
      String temp = "";
      for (int i = 0; i < caseNumber.length; i++) {
        temp = temp + caseNumber[i];
        caseSearchList.add(temp);
      }
      return caseSearchList;
    }

    Future<void> update(short, long, original, price, title, catname) async {
      // setState(() {});
      print(short);
      final itemsRef =
          await EcommerceApp.firestore.collection("items").document(pid)
              // .collection(EcommerceApp.subCollectionAddress)
              // Firestore.instance.collection("items");
              // itemsRef.document( EcommerceApp.userCartList)
              .updateData({
        "shortInfo": short.text.trim(),
        "longDescription": long.text.trim(),
        "originalPrice": int.parse(original.text),
        "price": int.parse(price.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "title": title.text.trim(),
        "searchArray": setSearchParam(short.text.trim().toLowerCase()),
        // "catname": catname.trim(),
      });
      final itemsRef1 =
          await EcommerceApp.firestore.collection(catname).document(pid)
              // Firestore.instance.collection("$_selectedcategory");
              // itemsRef.document(EcommerceApp.userCartList)
              .updateData({
        "shortInfo": short.text.trim(),
        "longDescription": long.text.trim(),
        "originalPrice": int.parse(original.text),
        "price": int.parse(price.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "title": title.text.trim(),
        "searchArray": setSearchParam(short.text.trim().toLowerCase()),
        // "catname": catname.trim(),
      });
      setState(() {
        // _selectedcategory = "Select a Category";
        productId = DateTime.now().millisecondsSinceEpoch.toString();
        _descriptiontextEditingController.clear();

        _originalpricetextEditingController.clear();
        _pricetextEditingController.clear();
        _shorttextEditingController.clear();
        _titletextEditingController.clear();
        Navigator.pop(context);
      });
    }

    Future<bool> showReview(
        price, originalPrice, shortInfo, title, longDescription, catname) {
      return showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.red,
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back), onPressed: () {}),
                  title: Text("Edit product",
                      style: TextStyle(color: Colors.white)),
                  actions: [
                    FlatButton(
                        onPressed: () {
                         
                          _shorttextEditingController.text.isEmpty ||
                                  _descriptiontextEditingController
                                      .text.isEmpty ||
                                  _originalpricetextEditingController
                                      .text.isEmpty ||
                                  _pricetextEditingController.text.isEmpty ||
                                  _titletextEditingController.text.isEmpty
                              ? 
                             Fluttertoast.showToast( 
              msg: "Fill ALL the Details Again", 
              // backgroundColor: Colors.grey,
              // fontSize: 25,
              // gravity: ToastGravity.TOP,  
              textColor: Colors.black 
              )
    
                              : setState(() {
                                  update(
                                      _shorttextEditingController,
                                      _descriptiontextEditingController,
                                      _originalpricetextEditingController,
                                      _pricetextEditingController,
                                      _titletextEditingController,
                                      catname);
                                  Navigator.of(context).pop();
                                });
                        },
                        // uploading ? null : () => uploadImageandSaveItemInfo(),
                        child: Text("Update",
                            style: TextStyle(
                              color: Colors.green,
                            ))),
                  ]),
              body: ListView(
                children: [
                  Padding(padding: EdgeInsets.only(top: 12.0)),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
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
                            hintText: "ShortInfo - " + shortInfo,
                            hintStyle:
                                TextStyle(color: Colors.deepPurpleAccent),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  Divider(
                    color: Colors.pink,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
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
                            hintText: "Title - " + title,
                            hintStyle:
                                TextStyle(color: Colors.deepPurpleAccent),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  Divider(
                    color: Colors.pink,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
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
                            hintText: "LongDesc - " + longDescription,
                            hintStyle:
                                TextStyle(color: Colors.deepPurpleAccent),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  Divider(
                    color: Colors.pink,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Colors.pink,
                    ),
                    title: Container(
                        width: 250.0,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                          ),
                          controller: _originalpricetextEditingController,
                          decoration: InputDecoration(
                            hintText:
                                "OriginalPrice - " + originalPrice.toString(),
                            hintStyle:
                                TextStyle(color: Colors.deepPurpleAccent),
                            border: InputBorder.none,
                          ),
                        )),
                  ),
                  Divider(
                    color: Colors.pink,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
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
                            hintText: "FinalPrice - " + price.toString(),
                            hintStyle:
                                TextStyle(color: Colors.deepPurpleAccent),
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
          });
    }

    
    error() {
      Fluttertoast.showToast(msg: "Please fill all the Fields");
    }
    ///[.]
    // heightm = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        // Route route =
        //     MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
        // Navigator.push(context, route);
      },
      splashColor: Color(0xff94b941),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
              width: width,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      height: MediaQuery.of(context).size.height / 5,
                      child: Image.network(
                        model.thumbnailUrl,
                        width: MediaQuery.of(context).size.width * 0.33,
                        // height: 140.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  model.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Arial Bold",
                                    fontSize: 25.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  model.shortInfo,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Arial",
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  // Icon(Icons.curr),

                                  Text(
                                    '\u{20B9}${model.price}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '\u{20B9}${model.originalPrice}',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.delete_forever,
                                        size: 20.0,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await EcommerceApp.firestore
                                            .collection("items")
                                            .document(pid)
                                            .delete();
                                        await EcommerceApp.firestore
                                            .collection(model.catname)
                                            .document(pid)
                                            .delete();
                                        // deleteFireBaseStorageItem(model.thumbnailUrl);
                                        setState(() {});
                                      }),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20.0,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showReview(
                                          model.price,
                                          model.originalPrice,
                                          model.shortInfo,
                                          model.title,
                                          model.longDescription,
                                          model.catname);
                                      //                                   Route route =
                                      //     MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
                                      // Navigator.push(context, route);
                                    },
                                  ),

                                  // Center(
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       showReview(
                                  //           model.price,
                                  //           model.originalPrice,
                                  //           model.shortInfo,
                                  //           model.title,
                                  //           model.longDescription,
                                  //           model.catname);
                                  //       //                                   Route route =
                                  //       //     MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
                                  //       // Navigator.push(context, route);
                                  //     },
                                  //     child:
                                  //         Icon(Icons.delete_forever, size: 20.0,color: Colors.red,)),
                                  //     // Container(
                                  //     //   decoration: BoxDecoration(
                                  //     //       color: Color(0xff94b941),
                                  //     //       borderRadius: BorderRadius.all(
                                  //     //           Radius.circular(6))),
                                  //     //   //  color: Colors.green,
                                  //     //   width: MediaQuery.of(context).size.width *
                                  //     //       0.20,
                                  //     //   height: 50.0,
                                  //     //   child: Center(
                                  //     //     child: Text(
                                  //     //       "Edit",
                                  //     //       style: TextStyle(color: Colors.white),
                                  //     //     ),
                                  //     //   ),
                                  //     // ),

                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 5.0, color: Colors.grey),
        ],
      ),
    );
  }

  // static void deleteFireBaseStorageItem(fileUrl) {
  //   String filePath = fileUrl
  //                 .replaceAll(new
  //                 RegExp(r'https://firebasestorage.googleapis.com/v0/b/dial-in-2345.appspot.com/o/'), '');
  //   // filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

  //   // filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

  //   print(filePath);
  //   StorageReference storageReferance = FirebaseStorage.instance.ref();

  //   storageReferance
  //       .child("items/$filePath")
  //       .delete()
  //       .then((_) => print('Successfully deleted $filePath storage item'));
  // }

  Future startSearching(String query) async {
    docList = Firestore.instance
        .collection("items")
        .where("searchArray", arrayContains: query)
        .getDocuments();
  }
}
