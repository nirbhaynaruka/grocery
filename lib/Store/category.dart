import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Counters/totalMoney.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Store/product_page.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery/Widgets/sourceInfo.dart';
import 'package:provider/provider.dart';
import 'package:grocery/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/item.dart';

double width;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(Category());
}

bool logincheck = false;

class Category extends StatefulWidget {
  final ItemModel itemModel;
  final String catname;
  Category({this.itemModel, this.catname});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  // bool logincheck = falsee;

  @override
  void initState() {
    checklogin();
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
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Color(0xfffffff8),
          appBar: AppBar(
            backgroundColor: Color(0xff94b941),
            title: Text(
              widget.catname,
              style: TextStyle(
                // fontSize: 25.0,
                // fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
                fontFamily: "Folks-Heavy",
              ),
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                        icon: Icon(Icons.shopping_basket, color: Colors.white),
                        onPressed: () {
                          checklogin();
                          if (logincheck) {
                            Route route =
                                MaterialPageRoute(builder: (c) => CartPage());
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => CartPage(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                            );
                          } else {
                            Route route = MaterialPageRoute(
                                builder: (_) => AuthenticScreen());
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => AuthenticScreen(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                            );
                          }
                        }),
                  ),
                  Positioned(
                    top: 5.0,
                    right: 8.0,
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        Positioned(
                          top: 3.0,
                          bottom: 4.0,
                          left: 6.0,
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, _) {
                              return Text(
                                logincheck
                                    ? (json
                                                .decode(EcommerceApp
                                                    .sharedPreferences
                                                    .getString(EcommerceApp
                                                        .userCartList))
                                                .length -
                                            1)
                                        .toString()
                                    : "0",
                                style: TextStyle(
                                  color: Color(0xff94b941),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          floatingActionButton: Transform.scale(
            scale: 1.1,
            child: FloatingActionButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => SearchProduct());
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => SearchProduct(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
              },
              elevation: 5,
              backgroundColor: Color(0xff94b941),
              splashColor: Color(0xffdde8bd),
              child: Icon(Icons.search, size: 30),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(widget.catname)
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? Center(
                      child: Container(),
                    )
                  : ListView.builder(
                      itemCount: dataSnapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        ItemModel model = ItemModel.fromJson(
                            dataSnapshot.data.documents[index].data);
                        return dataSnapshot
                                    .data.documents[index].data["subcatname"] ==
                                widget.itemModel.subcatname
                            ? SourceInfo(model: model, quantity: 1)
                            : Center(
                                child: Container(),
                              );
                      },
                    );
            },
          )),
    );
  }
}

// Widget sourceInfo(ItemModel model, BuildContext context,
//     {Color background, removeCartFunction, addQuantityFunction}) {
//   List<int> _quantity = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   int _quantityCounter = 1;
//   // int newPrice = model.

//   return InkWell(
//     onTap: () {
//       Route route =
//           MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (_, __, ___) => ProductPage(itemModel: model),
//           transitionDuration: Duration(seconds: 0),
//         ),
//       );
//     },
//     splashColor: Color(0xff94b941),
//     child: Container(
//       padding: const EdgeInsets.all(5.0),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(0.0),
//             child: Container(
//               // color: Color(0xffffffff),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 boxShadow: [
//                   BoxShadow(
//                     offset: Offset(0, 4),
//                     blurRadius: 15,
//                     color: Color(0xFFB7B7B7).withOpacity(.5),
//                   ),
//                 ],
//               ),
//               // height: MediaQuery.of(context).size.height / 6,
//               width: width,
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(2.0)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.2),
//                               spreadRadius: 2,
//                               blurRadius: 2,
//                               offset:
//                                   Offset(0, 3), // changes position of shadow
//                             ),
//                           ]),
//                       height: MediaQuery.of(context).size.height / 7,
//                       child: CachedNetworkImage(
//                         width: MediaQuery.of(context).size.width * 0.33,
//                         imageUrl: model.thumbnailUrl,
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 15.0),
//                           Container(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     model.title,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontFamily: "Arial Bold",
//                                       fontSize: 18.0,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 5.0),
//                           Container(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     model.shortInfo,
//                                     style: TextStyle(
//                                       color: Colors.black54,
//                                       fontFamily: "Arial",
//                                       fontSize: 15.0,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 5.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       '\u{20B9}${model.price}',
//                                       style: TextStyle(
//                                         fontSize: 16.0,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(width: 5.0),
//                                     Text(
//                                       '\u{20B9}${model.originalPrice}',
//                                       style: TextStyle(
//                                         fontSize: 12.0,
//                                         color: Colors.grey,
//                                         decoration: TextDecoration.lineThrough,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               removeCartFunction == null
//                                   ? Padding(
//                                       padding: EdgeInsets.only(top: 8.0),
//                                       child: Center(
//                                         child: InkWell(
//                                           onTap: () {
//                                             // print(model.productId.toString());
//                                             // if (logincheck) {
//                                             checkItemInCart(
//                                                 model.productId,
//                                                 1,
//                                                 context);
//                                             // } else {
//                                             //   Route route = MaterialPageRoute(
//                                             //       builder: (_) =>
//                                             //           AuthenticScreen());
//                                             //   Navigator.push(
//                                             //     context,
//                                             //     PageRouteBuilder(
//                                             //       pageBuilder: (_, __, ___) =>
//                                             //           AuthenticScreen(),
//                                             //       transitionDuration:
//                                             //           Duration(seconds: 0),
//                                             //     ),
//                                             //   );
//                                             // }
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 color: Color(0xff94b941),
//                                                 borderRadius: BorderRadius.all(
//                                                     Radius.circular(6))),
//                                             //  color: Colors.green,
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.15,
//                                             height: 30.0,
//                                             child: Center(
//                                               child: Text(
//                                                 "Add",
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   // IconButton(
//                                   //     icon: Icon(
//                                   //       Icons.add_shopping_cart,
//                                   //       color: Colors.pinkAccent,
//                                   //     ),
//                                   //     onPressed: () {
//                                   //       checkItemInCart(model.shortInfo, context);
//                                   //     })
//                                   //

//                                   : Container(
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             alignment: Alignment.topLeft,
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 5.0, vertical: 0.0),
//                                             margin: EdgeInsets.symmetric(
//                                                 horizontal: 0.0, vertical: 5.0),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(5.0)),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   offset: Offset(0, 4),
//                                                   blurRadius: 15,
//                                                   color: Color(0xFFB7B7B7)
//                                                       .withOpacity(.5),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "Qty: ",
//                                                   style: TextStyle(
//                                                     fontFamily: "Arial Bold",
//                                                     fontSize: 16,
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                                 DropdownButton(
//                                                   underline: Container(),
//                                                   isExpanded: false,
//                                                   // value: _selectedcategory,
//                                                   items: _quantity.map((val) {
//                                                     return DropdownMenuItem(
//                                                       child:
//                                                           Text(val.toString()),
//                                                       value: val,
//                                                     );
//                                                   }).toList(),
//                                                   hint: Text(
//                                                     "$_quantityCounter",
//                                                     style: TextStyle(
//                                                       fontFamily: "Arial Bold",
//                                                       fontSize: 16,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ), // Not necessary for Option 1
//                                                   // onChanged: (val) {
//                                                   //   // setState(() {
//                                                   //   _selectedPinCode = val;
//                                                   //   _user = _selectedPinCodecat
//                                                   //       .indexOf(val);
//                                                   //   cCity.text =
//                                                   //       _selectedCitycat[_user]
//                                                   //           .single;
//                                                   //   // });
//                                                   //   this.setState(() {});
//                                                   // },
//                                                   onChanged: (val) {
//                                                     _quantityCounter = val;
//                                                     print(model.title);
//                                                     print(val);
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           IconButton(
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 color: Color(0xff94b941),
//                                               ),
//                                               onPressed: () {
//                                                 removeCartFunction();
//                                               }),
//                                         ],
//                                       ),
//                                     ),
//                               // : IconButton(
//                               //             icon: Icon(
//                               //               Icons.delete,
//                               //               color: Color(0xff94b941),
//                               //             ),
//                               //             onPressed: () {
//                               //               removeCartFunction();
//                               //             }),
//                             ],
//                           ),
//                           // Divider(height: 5.0, color: Colors.black),

//                           // Flexible(
//                           //   child: Container(),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Divider(height: 5.0, color: Colors.grey),
//         ],
//       ),
//     ),
//   );
// }

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * 0.34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Image.network(
          imgPath,
          height: 150.0,
          width: width * 0.34,
          fit: BoxFit.fill,
        )),
  );
}

void checkItemInCart(String productID, int quantity, BuildContext context) {
  Map<String, dynamic> decodedMap = json.decode(
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList));
  decodedMap.containsKey(productID)
      ? Fluttertoast.showToast(msg: "Item is Already in the Cart!")
      : addItemToCart(productID, quantity, context);
}

addItemToCart(String productID, int quantity, BuildContext context)  {
  String tempCartList =
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList);
  Map<String, dynamic> decodedMap = json.decode(tempCartList);
  decodedMap[productID] = quantity;

   EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
    EcommerceApp.userCartList: decodedMap,
  }).then((v) {
    quantity == 1
        ? Fluttertoast.showToast(msg: "Item Added to Cart Successfully.")
        : Fluttertoast.showToast(msg: "Item Quantity Changed.");

    EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userCartList, json.encode(decodedMap));
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
     Navigator
                                                            .pushReplacement(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder:
                                                                (_, __, ___) =>
                                                                    CartPage(),
                                                            transitionDuration:
                                                                Duration(
                                                                    seconds: 0),
                                                          ),
                                                        );
  });
}
