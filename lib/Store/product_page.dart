import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/category.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(ProductPage());
}

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;

  @override
  bool logincheck = false;
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
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            widget.itemModel.catname,
            style: TextStyle(
              // fontSize: 25.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
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
                        // checklogin();
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
                                  ? (EcommerceApp.sharedPreferences
                                              .getStringList(
                                                  EcommerceApp.userCartList)
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
        // drawer: MyDrawer(),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.network(
                    widget.itemModel.thumbnailUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // SizedBox(height: 10.0),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.itemModel.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Arial Bold",
                          fontSize: 23.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          '\u{20B9}${widget.itemModel.price.toString()}',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          '\u{20B9}${widget.itemModel.originalPrice.toString()}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.itemModel.longDescription,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Arial Bold",
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff94b941),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),

                  height: MediaQuery.of(context).size.height * 0.06,
                  // margin: EdgeInsets.all(20.0),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (logincheck) {
                          checkItemInCart(widget.itemModel.productId, widget.itemModel.quantity.toString(),  context);
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
                      },
                      child: Container(
                        // width: MediaQuery.of(context).size.width *0.6,
                        height: 40.0,
                        child: Center(
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Arial Bold",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ListView(
        //   children: [
        //     Container(
        //       // padding: EdgeInsets.all(8.0),
        //       // width: MediaQuery.of(context).size.width,
        //       color: Colors.red,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Container(
        //             child: Center(
        //               child: Image.network(
        //                 widget.itemModel.thumbnailUrl,
        //             height: MediaQuery.of(context).size.height / 4,
        //                 // height: MediaQuery.of(context).size.height * 0.5
        //               ),
        //             ),
        //           ),
        //           Container(
        //             padding: EdgeInsets.all(20.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   widget.itemModel.title,
        //                   style: boldTextStyle,
        //                 ),
        //                 SizedBox(
        //                   height: 10.0,
        //                 ),
        //                 Row(
        //                   children: [
        //                     Text(
        //                       "Rs" + widget.itemModel.price.toString(),
        //                       style: largeTextStyle,
        //                     ),
        //                     SizedBox(
        //                       width: 10.0,
        //                     ),
        //                     Text(
        //                       "Rs" + widget.itemModel.originalPrice.toString(),
        //                       style: TextStyle(
        //                         fontSize: 15.0,
        //                         color: Colors.grey,
        //                         decoration: TextDecoration.lineThrough,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 SizedBox(
        //                   height: 10.0,
        //                 ),
        //                 Text(
        //                   widget.itemModel.longDescription,
        //                   style: largeTextStyle,
        //                 ),
        //                 SizedBox(
        //                   height: 10.0,
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Padding(
        //             padding: EdgeInsets.only(top: 8.0),
        //             child: Center(
        //               child: InkWell(
        //                 onTap: () {
        //                   if (logincheck) {
        //                     checkItemInCart(
        //                         widget.itemModel.shortInfo, context);
        //                   } else {
        //                     Route route = MaterialPageRoute(
        //                         builder: (_) => AuthenticScreen());
        //                     Navigator.push(context, route);
        //                   }
        //                 },
        //                 child: Container(
        //                   width: MediaQuery.of(context).size.width - 40.0,
        //                   height: 50.0,
        //                   child: Center(
        //                     child: Text(
        //                       "Add to Cart",
        //                       style: TextStyle(color: Colors.white),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 30, fontFamily: "Arial Bold");
const largeTextStyle =
    TextStyle(fontWeight: FontWeight.w400, fontSize: 20, fontFamily: "Arial");
