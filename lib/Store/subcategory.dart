import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery/Authentication/authenication.dart';
import 'package:grocery/Config/config.dart';
import 'package:grocery/Counters/cartitemcounter.dart';
import 'package:grocery/Models/item.dart';
import 'package:grocery/Store/Search.dart';
import 'package:grocery/Store/cart.dart';
import 'package:grocery/Store/category.dart';
import 'package:grocery/Widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

import 'category.dart';

class SubCategoryPage extends StatefulWidget {
  final ItemModel itemModel;

  const SubCategoryPage({Key key, this.itemModel}) : super(key: key);

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  bool logincheck = false;

  List<ItemModel> model = [
    ItemModel(
      catname: "Fruits & Vegetables",
      catthumbnail: "assets/images/FruitsandVegetables.png",
    ),
    ItemModel(
      catname: "Dairy Products",
      catthumbnail: "assets/images/DairyProducts.png",
    ),
    ItemModel(
      catname: "Cleaning & Household",
      catthumbnail: "assets/images/Cleaning_Household.png",
    ),
    ItemModel(
      catname: "Beauty & Hygeine",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
    ItemModel(
      catname: "Beverages and Snacks",
      catthumbnail: "assets/images/Beverage_Snacks.png",
    ),
    ItemModel(
      catname: "Cooking Essentials",
      catthumbnail: "assets/images/CookingEssentials.png",
    ),
    ItemModel(
      catname: "Miscellaneous",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
    ItemModel(
      catname: "Packaged Foods",
      catthumbnail: "assets/images/BeautyandHygeine.png",
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff94b941),
          title: Text(
            widget.itemModel.catname,
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
                          // Route route =
                          //     MaterialPageRoute(builder: (c) => CartPage());
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => CartPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        } else {
                          // Route route = MaterialPageRoute(
                          //     builder: (_) => AuthenticScreen());
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
        floatingActionButton: Transform.scale(
          scale: 1.1,
          child: FloatingActionButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SearchProduct());
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: 
           StreamBuilder<QuerySnapshot>(
            stream:Firestore.instance.collection("category").document(widget.itemModel.catname).collection("subcategory").snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? Center(
                      child: circularProgress(),
                    )
                  : ListView.builder(
                      itemCount: dataSnapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        ItemModel model = ItemModel.fromJson(
                            dataSnapshot.data.documents[index].data);
                        return subcategoryinfo(model,widget.itemModel.catname, context);
                      },
                    );
            },
        ),
      
        // StreamBuilder<QuerySnapshot>(
        //   stream: EcommerceApp.firestore
        //       .collection("category")
        //       .document(widget.itemModel.catname)
        //       .snapshots(),
        //   builder: (c, snapshot) {
        //     return snapshot.hasData
        //         ? ListView.builder(
        //             itemCount: snapshot.data.documents.length,
        //             itemBuilder: (c, index) {
        //               return FutureBuilder<QuerySnapshot>(
        //                 future: Firestore.instance
        //                     .collection(widget.itemModel.catname)
        //                     .where("subcategory",
        //                         whereIn: snapshot.data.documents[index]
        //                             .data[EcommerceApp.productID])
        //                     .getDocuments(),
        //                 builder: (c, snap) {
        //                   return snap.hasData
        //                       ? OrderCard(
        //                           itemCount: snap.data.documents.length,
        //                           data: snap.data.documents,
        //                           orderId:
        //                               snapshot.data.documents[index].documentID,
        //                         )
        //                       : Center(
        //                           child: circularProgress(),
        //                         );
        //                 },
        //               );
        //             },
        //           )
        //         : Center(
        //             child: circularProgress(),
        //           );
        //   },

          //  SingleChildScrollView(
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 10.0),
          //     child: Container(
          //       height: MediaQuery.of(context).size.height,
          //       child: GridView.count(
          //         physics: NeverScrollableScrollPhysics(),
          //         // shrinkWrap: true,
          //         // scrollDirection: Axis.vertical,
          //         crossAxisCount: 2,
          //         padding: EdgeInsets.all(10.0),
          //         childAspectRatio: 0.9,
          //         children: model.map((model) {
          //           return categoryinfo(model, context);
          //         }).toList(),
          //       ),
          //     ),
          //   ),
          // ),
        
      ),
    );
  }

  Widget subcategoryinfo(ItemModel model,String catname, BuildContext context,
      {Color: Colors.white}) {
    // String name = model.catname;
    return GestureDetector(
      onTap: () {
        Route route =
            MaterialPageRoute(builder: (c) => Category(itemModel: model));
        Navigator.push(
          context,
          PageRouteBuilder(
           pageBuilder: (_, __, ___) => Category(itemModel: model,catname: catname),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                model.subcatthumbnail,
                fit: BoxFit.cover,
                height: 120.0,
              ),
              SizedBox(height: 10.0),
              Text(
                model.subcatname,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Arial Bold",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
          //     InkWell(

          //     child: Text(model.catname),
          // ),
          ),
    );
  }
}
